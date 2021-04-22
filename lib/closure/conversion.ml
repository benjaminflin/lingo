module M = Mono.Mast

open Cast
exception NotImplemented
exception ClosureError
type partial_prog = {
  funs: fundef list;
}
module Tc = Core.Typecheck
let (<<<) f g x = f (g x)

let string_of_ty = function
| CIntT -> "Int"
| CBoolT -> "Bool"
| CharT -> "Char"
| CDataTy cname -> cname
| CClosT -> "Clos"
| BoxT -> "Box"

module SM = Map.Make (String)
let vars = ref SM.empty  
let unique_name name = 
  match SM.find_opt name !vars with
  | Some i -> vars := SM.add name (Random.int64 (Int64.max_int)) !vars; name ^ Int64.to_string i  
  | None -> vars := SM.add name (Random.int64 (Int64.max_int)) !vars; name
let convert_mty = function
| M.IntT -> CIntT 
| M.CharT -> CharT
| M.BoolT -> CBoolT
| M.DataTy name -> CDataTy name
| M.BoxT -> BoxT
| M.Arr _ -> CClosT 
| _ -> raise ClosureError 

let beta_reduce mexpr1 mexpr2 = 
  let rec shift cutoff amount = function
  | M.Lam (mexpr, in_mty, out_mty) -> 
    M.Lam (shift (cutoff + 1) amount mexpr, in_mty, out_mty)  
  | M.DbIndex(idx, ty) as self -> if idx < cutoff then self else M.DbIndex(idx - amount, ty)
  | M.Case (mscrut, mty, mcalts, out_mty) -> 
    M.Case (shift cutoff amount mscrut, mty, List.map (shift_case amount cutoff) mcalts, out_mty)
  | M.Let (mexpr1, mty1, mexpr2, mty2) -> 
    M.Let (shift (cutoff + 1) amount mexpr1, mty1, shift (cutoff + 1) amount mexpr2, mty2) 
  | M.Box (mexpr, mty) -> 
    M.Box (shift cutoff amount mexpr, mty) 
  | M.Unbox (mexpr, mty) ->  
    M.Unbox (shift cutoff amount mexpr, mty)  
  | M.If (mexpr1, mexpr2, mexpr3, mty) ->
    M.If (shift cutoff amount mexpr1, shift cutoff amount mexpr2, shift cutoff amount mexpr3, mty)
  | M.App (mexpr1, mty1, mexpr2, mty2, out_mty) ->
    M.App (shift cutoff amount mexpr1, mty1, shift cutoff amount mexpr2, mty2, out_mty)
  | a -> a 
  and shift_case cutoff amount = function
  | M.Destructor (name, num_abstr, mexpr, out_mty) ->
    M.Destructor (name, num_abstr, shift (cutoff + num_abstr) amount mexpr, out_mty)
  | M.Wildcard (mexpr, ty) ->
    M.Wildcard (shift cutoff amount mexpr, ty)
  in 
  let rec subst expr idx = function
  | M.Lam (mexpr, in_mty, out_mty) -> 
    M.Lam (subst (shift 0 1 expr) (idx + 1) mexpr, in_mty, out_mty)  
  | M.DbIndex(i, _) as self -> if i == idx then expr else self 
  | M.Case (mscrut, mty, mcalts, out_mty) -> 
    M.Case (subst expr idx mscrut, mty, List.map (subst_case expr idx) mcalts, out_mty)
  | M.Let (mexpr1, mty1, mexpr2, mty2) -> 
    M.Let (subst (shift 0 1 expr) (idx + 1) mexpr1, mty1, subst (shift 0 1 expr) (idx + 1) mexpr2, mty2) 
  | M.Box (mexpr, mty) -> 
    M.Box (subst expr idx mexpr, mty) 
  | M.Unbox (mexpr, mty) ->  
    M.Unbox (subst expr idx mexpr, mty)  
  | M.If (mexpr1, mexpr2, mexpr3, mty) ->
    M.If (subst expr idx mexpr1, subst expr idx mexpr2, subst expr idx mexpr3, mty)
  | M.App (mexpr1, mty1, mexpr2, mty2, out_mty) ->
    M.App (subst expr idx mexpr1, mty1, subst expr idx mexpr2, mty2, out_mty)
  | a -> a 
  and subst_case expr idx = function
  | M.Destructor (name, num_abstr, mexpr, out_mty) ->
    M.Destructor (name, num_abstr, subst (shift 0 num_abstr expr) (idx + num_abstr) mexpr, out_mty)
  | M.Wildcard (mexpr, ty) ->
    M.Wildcard (subst expr idx mexpr, ty)
  in
  shift 0 (-1) (subst (shift 0 1 mexpr2) 0 mexpr1)



module T = struct 
  type t = (cindex * cty) 
  let compare : t -> t -> int = fun x y -> compare (fst x) (fst y)
end   
module S = Set.Make (T) 
let free_vars =
  let dec_by c = 
    S.filter_map (fun (idx,ty) -> if idx - c < 0 then None else Some (idx-c, ty))
  in
  let rec free_vars = function
    | M.Lam (mexpr, _, _) -> dec_by 1 @@ free_vars mexpr
    | M.Case (mexpr, _, calt_list, _) -> 
      S.union (free_vars mexpr)
        @@ List.fold_left S.union S.empty (List.map free_vars_calt calt_list)
    | M.DbIndex (idx, mty) -> S.singleton (idx, convert_mty mty)
    | M.Let (mexpr1, _, mexpr2, _) ->
      S.union (free_vars mexpr1) (dec_by 1 @@ free_vars mexpr2)
    | M.App (mexpr1, _, mexpr2, _, _) ->
      S.union (free_vars mexpr1) (free_vars mexpr2)
    | M.Box (mexpr, _) -> free_vars mexpr 
    | M.Unbox (mexpr, _) -> free_vars mexpr 
    | M.If (mexpr1, mexpr2, mexpr3, _) -> 
      S.union (S.union (free_vars mexpr1)
      (free_vars mexpr2)) @@ free_vars mexpr3
    | _ -> S.empty 
    and free_vars_calt = function
    | M.Destructor (_, num_abstr, mexpr, _) -> 
      dec_by num_abstr @@ free_vars mexpr
    | M.Wildcard (mexpr, _) -> free_vars mexpr  
  in S.elements <<< free_vars 

let string_of_binop = function
| Tc.Plus -> "plus" 
| Tc.Minus -> "minus" 
| Tc.Times -> "times" 
| Tc.Divide -> "divide"
| Tc.Geq -> "geq"
| Tc.Gt -> "gt"
| Tc.Eq -> "eq"
| Tc.Leq -> "leq" 
| Tc.Lt -> "lt"
| Tc.Neq -> "neq"
| Tc.And -> "and"
| Tc.Or -> "or"
let string_of_unop = function
| Tc.Not -> "not"
| Tc.Neg -> "neg"

let funs = ref []
let convert_mexpr name (prog : M.program) expr = 
 let rec convert = function
  | M.Lam (mexpr, _in_mty, out_mty) as self -> 
    let name = unique_name ("fn_" ^ name) in
    let expr = convert mexpr in
    let fvs = free_vars self in
    let args = List.map (fun (i,t) -> CArg (i, t)) @@ fvs in
    let fv_tys = List.map snd fvs in 
    let global = name, List.length fvs + 1, expr, convert_mty out_mty in
    funs := global::!funs; 
    CClos (name, args, fv_tys)
  | M.Case (mscrut, scrut_mty, ca_list, out_mty) -> 
    let scrut = convert mscrut in
    let ca_list = List.map convert_calt ca_list in
    CCase (scrut, convert_mty scrut_mty, ca_list, convert_mty out_mty) 
  | M.DbIndex (idx, ty) -> CArg (idx, convert_mty ty)
  | M.Global (name, mty) -> ( 
    let ty = convert_mty mty in
    match List.assoc_opt name prog.decls with
    | Some _ -> CClos ("__" ^ name ^ "__", [], []) 
    | None -> CApp (CClos (name, [], []), CClosT, CInt 0, CIntT, ty))
  | M.App (mexpr1, mty1, mexpr2, mty2, out_mty) -> 
    let expr1 = convert mexpr1 in
    let expr2 = convert mexpr2 in
    CApp (expr1, convert_mty mty1, expr2, convert_mty mty2, convert_mty out_mty)
  | M.Box (mexpr, mty) -> Box (convert mexpr, convert_mty mty) 
  | M.Unbox (mexpr, mty) -> Unbox (convert mexpr, convert_mty mty) 
  | M.Int i -> CInt i
  | M.Bool i -> CBool i
  | M.Char i -> CChar i
  | M.Construction (cname, _mty) -> ( 

    let cons_tys = List.map convert_mty 
      @@ List.assoc cname @@ List.concat (List.map snd prog.datadefs) in
    let dty = CDataTy (fst @@ List.find (fun (_, d) -> List.mem cname (List.map fst d)) prog.datadefs) in
    let funs' = List.map (fun (name,tyl,expr,ty) -> name, (tyl, expr, ty)) !funs in 

    (match List.assoc_opt cname funs' with
    | Some _ -> CClos (cname, [], [])
    | None -> 
      let mk_globals =  
        let rec mk i arg_tys = function
        | [] -> 
          let args = List.rev @@ List.mapi (fun i ty -> CArg (i, ty)) arg_tys in
          CConstruction (cname, args, dty), dty 
        | (ty::tys) -> 
          let uname = unique_name cname in 
          let expr, out_ty = mk (i+1) (ty::arg_tys) tys in
          let len = List.length (ty::tys) in
          funs := (uname, len, expr, out_ty)::!funs;
          CClos (uname, List.mapi (fun i ty -> CArg (i, ty)) arg_tys, arg_tys), CClosT
        in  
        fst <<< mk 0 []
      in
      mk_globals cons_tys
  ))
  | M.Binop (binop, _ty) -> 
    CClos ("__prim__" ^ string_of_binop binop , [], [])
  | M.Unop (unop, _ty) ->
    CClos ("__prim__" ^ string_of_unop unop, [], [])
  | M.If (mexpr1, mexpr2, mexpr3, out_mty) ->
    let expr1 = convert mexpr1 in
    let expr2 = convert mexpr2 in
    let expr3 = convert mexpr3 in
    CIf (expr1, expr2, expr3, convert_mty out_mty)
  | M.Let (mexpr1, mty1, mexpr2, mty2) ->
    (* let x = e in y ~> (\x. y) e *)
    (* let f x = e in y ~> (\f. y) (\f. \x. e) *) 
    let name1 = unique_name name in 
    let name2 = unique_name name in 
    let mexpr1 = beta_reduce mexpr1 (M.Global (name1, mty1)) in
    let expr2 = convert mexpr2 in
    let expr1 = (match mty1 with
    | M.Arr (_, _) -> 
      let fvs = free_vars mexpr1 in
      let expr1 = convert mexpr1 in
      let args = List.map (fun (i,t) -> CArg (i, t)) @@ fvs in
      let fv_tys = List.map snd fvs in 
      let fn = name, List.length fvs + 1, expr1, CClosT in
      funs := fn::!funs; 
      CApp (CClos (name1, args, fv_tys), CClosT, CInt 0, CIntT, CClosT) 
    | _ -> convert mexpr1) in
    let fvs = free_vars @@ M.Lam (mexpr2, mty1, mty2) in
    let args = List.map (fun (i,t) -> CArg (i, t)) @@ fvs in
    let fv_tys = List.map snd fvs in 
    let ty2 = convert_mty mty2 in 
    let fn = name2, List.length fvs + 1, expr2, ty2 in
    funs := fn::!funs;
    CApp (CClos (name2, args, fv_tys), CClosT, expr1, convert_mty mty1, ty2)
  and convert_calt = function
  | M.Destructor (name, num_abstr, mexpr, mty) ->
    let expr = convert mexpr in
    CDestructor (name, num_abstr, expr, convert_mty mty)
  | M.Wildcard (mexpr, mty) ->
    let expr = convert mexpr in
    CWildcard (expr, convert_mty mty)
  in convert expr


let gen_ops () = 
  let decls = ref [] in
  let binops = [
    Tc.Plus
  ; Tc.Minus 
  ; Tc.Times 
  ; Tc.Divide 
  ; Tc.Geq 
  ; Tc.Gt 
  ; Tc.Eq 
  ; Tc.Leq 
  ; Tc.Lt 
  ; Tc.Neq 
  ; Tc.And 
  ; Tc.Or ]
  in
  let unops = [ Tc.Neg; Tc.Not ] in
  let unop_tys = [ CIntT, CIntT; CBoolT, CBoolT ] in
  let binop_tys = [
    CIntT, CIntT
  ; CIntT, CIntT
  ; CIntT, CIntT 
  ; CIntT, CIntT 
  ; CIntT, CBoolT 
  ; CIntT, CBoolT 
  ; CIntT, CBoolT 
  ; CIntT, CBoolT 
  ; CIntT, CBoolT 
  ; CIntT, CBoolT 
  ; CBoolT, CBoolT 
  ; CBoolT, CBoolT 
  ] in
  let gen_binop binop (in_ty, out_ty) =
    let name = string_of_binop binop in
    let clos1 = "__prim__" ^ name, 1, CClos ("__prim__" ^ name ^ "1", [CArg (0, in_ty)], [in_ty]), CClosT in
    let clos2 = "__prim__" ^ name ^ "1", 2, CCall ("__prim__binop__" ^ name, [CArg (1, in_ty), in_ty; CArg (0, in_ty), in_ty]), out_ty in
    decls := ("__prim__binop__" ^ name, ([in_ty; in_ty], out_ty))::!decls;
    funs := clos1::clos2::!funs;
  in
  let gen_unop unop (in_ty, out_ty) =   
    let name = string_of_unop unop in
    let clos = "__prim__" ^ name, 1, CCall ("__prim__unop__" ^ name, [CArg (0, in_ty), in_ty]), out_ty in
    decls := ("__prim__unop__" ^ name, ([in_ty], out_ty))::!decls;
    funs := clos::!funs;
  in
  List.iter2 gen_binop binops binop_tys;
  List.iter2 gen_unop unops unop_tys;
  !decls


let rec convert_decl = function
| M.Arr (in_mty, out_mty) -> 
  let tys, out_ty = convert_decl out_mty in
  (convert_mty in_mty :: tys), out_ty
| mty -> [], convert_mty mty

let decl_globals decls = 
  let mk_globals (name, (ty_list, out_ty)) =
    let pname = "__" ^ name ^ "__" in 
    let rec mk i arg_tys = function
    | [] -> 
      CCall (name, List.rev @@ List.mapi (fun i ty -> CArg (i, ty), ty) arg_tys), out_ty 
    | (ty::tys) -> 
      let uname = unique_name pname in 
      let expr, out_ty = mk (i+1) (ty::arg_tys) tys in
      let len = List.length (ty::tys) in
      funs := (uname, len, expr, out_ty)::!funs;
      CClos (uname, List.mapi (fun i ty -> CArg (i, ty)) arg_tys, arg_tys), CClosT
    in  
    ignore @@ mk 0 [] ty_list   
  in
  List.iter mk_globals decls

let convert_prog ({ main; letdefs; decls; datadefs } as prog: M.program) = 
  let expr = convert_mexpr "__main__" prog main in
  let globals = List.map (fun (name, mty, mexpr) -> name, (convert_mexpr name prog mexpr, convert_mty mty)) letdefs in
  List.iter (fun (name, (expr, ty)) -> funs := (name, 1, expr, ty)::!funs) globals;  
  let decls = List.map (fun (name, ty) -> name, convert_decl ty) decls in
  decl_globals decls;
  let datatys = List.map (
    fun (dname, cs) -> dname, List.map (
      fun (cname, tys) -> cname, List.map convert_mty tys) cs) datadefs
  in
  let decls = (gen_ops ()) @ decls in
  let ret = { funs = !funs; main = expr; datatys = datatys; decls = decls } in
  funs := [];
  vars := SM.empty;
  ret
