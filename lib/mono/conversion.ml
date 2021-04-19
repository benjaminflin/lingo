module Sast = Core.Typecheck.Sast
module C = Core.Typecheck
module S = Sast

open Mast 
exception NotImplemented
exception MonoError


let rec convert_sty = function
| S.BaseT C.BoolT -> BoolT
| S.BaseT C.IntT -> IntT
| S.BaseT C.CharT -> CharT
| S.DataSty (global, _) -> DataTy global
| S.TVar _ -> BoxT
| Forall sty -> convert_sty sty
| S.Arr (in_sty, out_sty) -> Arr (convert_sty in_sty, convert_sty out_sty) 

let rec string_of_ty = function
| IntT -> "Int"
| CharT -> "Char"
| BoolT -> "Bool"
| DataTy name -> name
| TVar dbindex -> "#" ^ string_of_int dbindex
| BoxT -> "Box"
| Arr (in_ty, out_ty) -> string_of_ty in_ty ^ " -> " ^ string_of_ty out_ty 

let reconcile expr exp_ty gen_ty = 
  match (exp_ty, gen_ty) with
  | (BoxT, BoxT) ->  BoxT, expr
  | (_, BoxT) -> exp_ty, Unbox (expr, exp_ty)
  | (BoxT, _) -> exp_ty, Box (expr, gen_ty)
  | _ -> gen_ty, expr


let convert_sexpr datadefs = 
  let rec convert_sexpr tys = function
  | S.Lam (sexpr, in_sty, out_sty) ->
    let gen_out_ty, expr = convert_sexpr tys sexpr in
    let in_ty = convert_sty in_sty in
    let exp_out_ty = convert_sty out_sty in
    let out_ty, expr = reconcile expr exp_out_ty gen_out_ty in
    Arr (in_ty, out_ty), Lam (expr, in_ty, out_ty)

  | S.TLam (sexpr, sty) ->
    let exp_ty = convert_sty sty in
    let gen_ty, expr = convert_sexpr tys (S.shift 0 (-1) sexpr) in
    reconcile expr exp_ty gen_ty

  | S.Case (sscrut, scrut_sty, ca_list, out_sty) ->
    let exp_scrut_ty = convert_sty scrut_sty in
    let gen_scrut_ty, scrut = convert_sexpr tys sscrut in
    let scrut_ty, scrut = reconcile scrut exp_scrut_ty gen_scrut_ty in
    let out_ty, calts = List.fold_left_map (convert_calt tys) (convert_sty out_sty) ca_list in
    out_ty, Case (scrut, scrut_ty, calts, out_ty)

  | S.DbIndex (idx, sty) -> 
    (match List.nth_opt tys idx with
    | Some ty -> 
      reconcile (DbIndex (idx, ty)) (convert_sty sty) ty
    | None -> convert_sty sty, DbIndex (idx, convert_sty sty))
  | S.Global (global, sty) -> 
    convert_sty sty, Global (global, convert_sty sty)
  | S.Binop (op, sty) -> 
    convert_sty sty, Binop (op, convert_sty sty)
  | S.Unop (op, sty) -> 
    convert_sty sty, Unop (op, convert_sty sty)
  | S.Let (sexpr1, _, sexpr2, _) ->
    let ty1, expr1 = convert_sexpr tys sexpr1 in
    let ty2, expr2 = convert_sexpr tys sexpr2 in
    ty2, Let (expr1, ty1, expr2, ty2)

  | S.App (sexpr1, _, sexpr2, in_sty, out_sty) ->
    let gen_arr_ty, expr1 = convert_sexpr tys sexpr1 in
    let _, expr2 = convert_sexpr tys sexpr2 in
    let exp_in_ty = convert_sty in_sty in
    let exp_out_ty = convert_sty out_sty in
    (match gen_arr_ty with
    | Arr (gen_in_ty, gen_out_ty) ->
        let ty2, expr2 = reconcile expr2 gen_in_ty exp_in_ty in 
        reconcile (App (expr1, gen_arr_ty, expr2, ty2, exp_out_ty)) exp_out_ty gen_out_ty
    | _ -> raise MonoError
    )
  | S.TApp (sexpr, _, sty) ->
    let exp_ty = convert_sty sty in
    let gen_ty, expr = convert_sexpr tys sexpr in
    reconcile expr exp_ty gen_ty  
  | S.Construction (global, sty) ->
    convert_sty sty, Construction (global, convert_sty sty) 
  | S.If (sexpr1, sexpr2, sexpr3, out_sty) ->
    let exp_out_ty = convert_sty out_sty in
    let ty1, expr1 = convert_sexpr tys sexpr1 in
    let _, expr1 = reconcile expr1 BoolT ty1 in
    let ty2, expr2 = convert_sexpr tys sexpr2 in
    let ty2, expr2 = reconcile expr2 exp_out_ty ty2 in
    let ty3, expr3 = convert_sexpr tys sexpr3 in
    let out_ty, expr3 = reconcile expr3 ty2 ty3 in
    out_ty, If(expr1, expr2, expr3, exp_out_ty)
  | S.Int i -> IntT, Int i
  | S.Bool b -> BoolT, Bool b
  | S.Char c -> CharT, Char c
  and convert_calt tys exp_ty = function
  | S.Destructor (name, num_abstr, sexpr, _) ->
    let all_cons = List.concat (List.map snd datadefs) in
    let tys' = List.assoc name all_cons in
    let gen_ty, expr = convert_sexpr (tys' @ tys) sexpr in
    let ty, expr = reconcile expr exp_ty gen_ty in 
    ty, Destructor (name, num_abstr, expr, ty) 

  | S.Wildcard (sexpr, _) ->
    let gen_ty, expr = convert_sexpr tys sexpr in
    let ty, expr = reconcile expr exp_ty gen_ty in 
    ty, Wildcard (expr, ty) 
  in convert_sexpr []

let convert_prog sprog = 
  let initial_sprog = { 
    letdefs = []; 
    main = Int 0;
    datadefs = [];
    decls = [];
  } in
  let rec datadefs = function
  | (S.DataDef (global, _, cd_list))::xs ->
      let datadef = 
        global, List.map (fun (name, l) -> name, List.map convert_sty l) cd_list 
      in datadef :: datadefs xs
  | _::xs -> datadefs xs
  | [] -> []
  in
  let datadefs = datadefs sprog in
  let to_prog mprog = function
  | S.LetDef (global, _, sexpr) -> 
    if global = "main" then 
      {mprog with main = snd @@ convert_sexpr datadefs sexpr} 
    else 
      let ty, expr = convert_sexpr datadefs sexpr in
      {mprog with letdefs = ((global, ty, expr)) :: mprog.letdefs }
  | S.DataDef (global, _, cd_list) ->
    let datadef = 
      global, List.map (fun (name, l) -> name, List.map convert_sty l) cd_list 
    in
    {mprog with datadefs = datadef::mprog.datadefs } 
  | S.LetDecl (global, sty) ->
    let decl = (global, convert_sty sty) in
    { mprog with decls = decl::mprog.decls }
  in
  List.fold_left to_prog initial_sprog sprog
