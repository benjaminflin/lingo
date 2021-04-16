module M = Mono.Mast
open Cast
exception NotImplemented
exception ClosureError
type partial_prog = {
  globals: cglobaldef list;
}
module Tc = Core.Typecheck
let (<<<) f g x = f (g x)

module SM = Map.Make (String)
let vars = ref SM.empty  
let unique_name name = 
  match SM.find_opt name !vars with
  | Some i -> vars := SM.add name (i+1) !vars; name ^ string_of_int i  
  | None -> vars := SM.add name 1 !vars; name
let convert_mty = function
| M.IntT -> CIntT 
| M.CharT -> CharT
| M.BoolT -> CBoolT
| M.DataTy name -> CDataTy name
| M.BoxT -> BoxT
| M.Arr _ -> CClosT 
| _ -> raise ClosureError 
let rec free_vars cutoff = function
  | M.Lam (mexpr, _, _) -> free_vars (cutoff + 1) mexpr
  | M.Case (mexpr, _, calt_list, _) -> 
    free_vars cutoff mexpr 
      @ List.concat (List.map (free_vars_calt cutoff) calt_list)
  | M.DbIndex (idx, mty) -> if idx > cutoff then [idx, convert_mty mty] else []
  | M.Let (mexpr1, _, mexpr2, _) ->
    free_vars (cutoff + 1) mexpr1 @
    free_vars (cutoff + 1) mexpr2
  | M.App (mexpr1, _, mexpr2, _, _) ->
    free_vars cutoff mexpr1 @ free_vars cutoff mexpr2
  | M.Box (mexpr, _) -> free_vars cutoff mexpr 
  | M.Unbox (mexpr, _) -> free_vars cutoff mexpr 
  | M.If (mexpr1, mexpr2, mexpr3, _) -> 
    free_vars cutoff mexpr1 
    @ free_vars cutoff mexpr2
    @ free_vars cutoff mexpr3
  | _ -> []
  and free_vars_calt cutoff = function
  | M.Destructor (_, num_abstr, mexpr, _) -> free_vars (cutoff + num_abstr) mexpr
  | M.Wildcard (mexpr, _) -> free_vars cutoff mexpr  

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

let globals = ref []
let convert_mexpr name (prog : M.program) expr = 
 let rec convert_mexpr = function
  | M.Lam (mexpr, _in_mty, out_mty) -> 
    let name = unique_name name in
    let expr = convert_mexpr mexpr in
    let fvs = free_vars 0 mexpr in
    let args = List.map (fun (i,t) -> CArg (i - 1, t)) @@ fvs in
    let fv_tys = List.map snd fvs in 
    let global = name, List.length fvs + 1, expr, convert_mty out_mty in
    globals := global::!globals; 
    CClos (name, args, fv_tys)
  | M.Case (mscrut, scrut_mty, ca_list, out_mty) -> 
    let scrut = convert_mexpr mscrut in
    let ca_list = List.map convert_calt ca_list in
    CCase (scrut, convert_mty scrut_mty, ca_list, convert_mty out_mty) 
  | M.DbIndex (idx, ty) -> CArg (idx, convert_mty ty)
  | M.Global (name, _) -> CClos (name, [], [])
  | M.App (mexpr1, mty1, mexpr2, mty2, out_mty) -> 
    let expr1 = convert_mexpr mexpr1 in
    let expr2 = convert_mexpr mexpr2 in
    CApp (expr1, convert_mty mty1, expr2, convert_mty mty2, convert_mty out_mty)
  | M.Box (mexpr, mty) -> Box (convert_mexpr mexpr, convert_mty mty) 
  | M.Unbox (mexpr, mty) -> Unbox (convert_mexpr mexpr, convert_mty mty) 
  | M.Int i -> CInt i
  | M.Bool i -> CBool i
  | M.Char i -> CChar i
  | M.Construction (cname, _mty) -> 
    let cons_tys = List.map convert_mty 
      @@ List.assoc cname @@ List.concat (List.map snd prog.datadefs) in
    let dty = CDataTy (fst @@ List.find (fun (_, d) -> List.mem cname (List.map fst d)) prog.datadefs) in
    let globals' = List.map (fun (name,tyl,expr,ty) -> name, (tyl, expr, ty)) !globals in 
    List.iter print_endline @@ List.map fst globals';
    print_endline cname;  
    (match List.assoc_opt cname globals' with
    | Some _ -> CClos (cname, [], [])
    | None -> 
      (* I don't know if I could make this more inefficient if I tried *)
      let names = List.init (List.length cons_tys) (fun _ -> unique_name cname) in
      let add_global i name =
        let args = List.init (i+1) (fun k -> CArg (k, List.nth cons_tys k)) in
        let arg_tys = (List.init (i+1) (fun k -> List.nth cons_tys k)) in

        let expr, ty = 
          if i < List.length names - 1 then
            CClos (List.nth names (i + 1), args, (List.tl arg_tys)), CClosT
          else
            CConstruction (cname, args, dty), dty   
        in
        globals := (name, List.length arg_tys, expr, ty)::!globals;
      in
      List.iteri add_global names;
      CClos (cname, [], [])
      )
  | M.Binop (binop, _ty) -> 
    CClos ("__prim__" ^ string_of_binop binop , [], [])
  | M.Unop (unop, _ty) ->
    CClos ("__prim__" ^ string_of_unop unop, [], [])
  | M.If (mexpr1, mexpr2, mexpr3, out_mty) ->
    let expr1 = convert_mexpr mexpr1 in
    let expr2 = convert_mexpr mexpr2 in
    let expr3 = convert_mexpr mexpr3 in
    CIf (expr1, expr2, expr3, convert_mty out_mty)
  | M.Let (_mexpr1, _mty1, _mexpr2, _mty2) -> raise NotImplemented
  and convert_calt = function
  | M.Destructor (name, num_abstr, mexpr, mty) ->
    let expr = convert_mexpr mexpr in
    CDestructor (name, num_abstr, expr, convert_mty mty)
  | M.Wildcard (mexpr, mty) ->
    let expr = convert_mexpr mexpr in
    CWildcard (expr, convert_mty mty)
  in convert_mexpr expr


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
    globals := clos1::clos2::!globals;
  in
  let gen_unop unop (in_ty, out_ty) =   
    let name = string_of_unop unop in
    let clos = "__prim__" ^ name, 1, CCall ("__prim__unop__" ^ name, [CArg (0, in_ty), in_ty]), out_ty in
    decls := ("__prim__unop__" ^ name, ([in_ty], out_ty))::!decls;
    globals := clos::!globals;
  in
  List.iter2 gen_binop binops binop_tys;
  List.iter2 gen_unop unops unop_tys;
  !decls



let rec convert_decl = function
| M.Arr (in_mty, out_mty) -> 
  let tys, out_ty = convert_decl out_mty in
  (convert_mty in_mty :: tys), out_ty
| mty -> [], convert_mty mty
let convert_prog ({ main; letdefs; decls; datadefs } as prog: M.program) = 
  let expr = convert_mexpr "__main__" prog main in
  List.iter (fun (name, _, mexpr) -> ignore (convert_mexpr name prog mexpr)) letdefs;
  let decls = List.map (fun (name, ty) -> name, convert_decl ty) decls in
  let datatys = List.map (
    fun (dname, cs) -> dname, List.map (
      fun (cname, tys) -> cname, List.map convert_mty tys) cs) datadefs
  in
  let decls = (gen_ops ()) @ decls in
  let ret = { globals = !globals; main = expr; datatys = datatys; decls = decls } in
  globals := [];
  vars := SM.empty;
  ret
