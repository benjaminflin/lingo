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


let rec convert_sexpr = function
| S.Lam (sexpr, in_sty, _) ->
  let out_ty, expr = convert_sexpr sexpr in
  let in_ty = convert_sty in_sty in
  Arr (in_ty, out_ty), Lam (expr, in_ty, out_ty)

| S.TLam (sexpr, _) ->
  convert_sexpr (S.shift 0 (-1) sexpr)

| S.Case (sscrut, _, ca_list, _) ->
  let scrut_ty, scrut = convert_sexpr sscrut in
  let calt_res = List.map convert_calt ca_list in
  let res_ty = fst @@ List.hd calt_res in
  res_ty, Case (scrut, scrut_ty, List.map snd calt_res, res_ty)

| S.DbIndex (idx, sty) -> 
  convert_sty sty, DbIndex (idx, convert_sty sty)
| S.Global (global, sty) -> 
  convert_sty sty, Global (global, convert_sty sty)
| S.Binop (op, sty) -> 
  convert_sty sty, Binop (op, convert_sty sty)
| S.Unop (op, sty) -> 
  convert_sty sty, Unop (op, convert_sty sty)
| S.Let (sexpr1, _, sexpr2, _) ->
  let ty1, expr1 = convert_sexpr sexpr1 in
  let ty2, expr2 = convert_sexpr sexpr2 in
  ty2, Let (expr1, ty1, expr2, ty2)

| S.App (sexpr1, _, sexpr2, _, out_ty) ->
  let ty1, expr1 = convert_sexpr sexpr1 in
  let ty2, expr2 = convert_sexpr sexpr2 in
  let out_ty = convert_sty out_ty in
  (match ty1 with
  | Arr (_, _) ->
      out_ty, App (expr1, ty1, expr2, ty2, out_ty)
  | _ -> raise MonoError
  )
| S.TApp (sexpr, _, _) ->
  convert_sexpr sexpr
| S.Construction (global, sty) ->
  convert_sty sty, Construction (global, convert_sty sty) 
| S.If (sexpr1, sexpr2, sexpr3, _) ->
  let _, expr1 = convert_sexpr sexpr1 in
  let ty2, expr2 = convert_sexpr sexpr2 in
  let _,   expr3 = convert_sexpr sexpr3 in
  ty2, If(expr1, expr2, expr3, ty2)
| S.Int i -> IntT, Int i
| S.Bool b -> BoolT, Bool b
| S.Char c -> CharT, Char c

and convert_calt = function
| S.Destructor (name, num_abstr, sexpr, _) ->
  let ty, expr = convert_sexpr sexpr in
  ty, Destructor (name, num_abstr, expr, ty) 

| S.Wildcard (sexpr, _) ->
  let ty, expr = convert_sexpr sexpr in
  ty, Wildcard (expr, ty) 
  let rec pick_tys ty1 ty2 = (match ty1, ty2 with
  | BoxT, _ -> BoxT
  | _, BoxT -> BoxT
  | Arr (in_ty, out_ty), Arr (in_ty', out_ty') -> 
    Arr (pick_tys in_ty in_ty', pick_tys out_ty out_ty')
  | _ -> ty1)
let fix prog = 
  let rec fix tys = function
  | Lam (expr, in_ty, _) ->
    let out_ty, expr = fix tys expr in 
    Arr (in_ty, out_ty), Lam (expr, in_ty, out_ty)
  | Case (scrut, _, ca_list, _) ->
    let scrut_ty, scrut = fix tys scrut in 
    let calt_res = List.map (fix_calt tys) ca_list in
    let res_ty = fst @@ List.hd calt_res in
    res_ty, Case (scrut, scrut_ty, List.map snd calt_res, res_ty) 
  | DbIndex (idx, ty) -> 
    (match List.nth_opt tys idx with
    | Some ty -> ty, DbIndex (idx, ty)
    | None -> ty, DbIndex (idx, ty))
  | Global (global, ty) -> 
    let ty' = List.assoc global (List.map (fun (name,ty,_) -> (name,ty)) prog.letdefs) in
    let out_ty = pick_tys ty ty' in
    out_ty, Global (global, out_ty)
  | Binop (op, ty) -> 
    ty, Binop (op, ty)
  | Unop (op, ty) -> 
    ty, Unop (op, ty)
  | Let (expr1, _, expr2, _) ->
    let ty1, expr1 = fix tys expr1 in
    let ty2, expr2 = fix tys expr2 in
    ty2, Let (expr1, ty1, expr2, ty2)
  | App (expr1, _, expr2, _, out_ty') ->
    let ty1, expr1 = fix tys expr1 in
    let in_ty', expr2 = fix tys expr2 in
    (match ty1 with
    | Arr (in_ty, out_ty) -> 
      (match (out_ty, out_ty') with
      | (BoxT, _) -> 
        (match (in_ty, in_ty') with
        | (BoxT, _) -> out_ty', Unbox ((App (expr1, ty1, Box (expr2, in_ty'), BoxT, out_ty)), out_ty')
        | _ -> out_ty', Unbox ((App (expr1, ty1, expr2, in_ty, out_ty)), out_ty'))
      | _ -> 
        (match (in_ty, in_ty') with
        | (BoxT, _) -> out_ty, (App (expr1, ty1, Box (expr2, in_ty'), BoxT, out_ty))
        | _ -> out_ty, (App (expr1, ty1, expr2, in_ty', out_ty))))
    | _ -> raise NotImplemented
    )
  | Construction (global, ty) ->
    ty, Construction (global, ty)
  | If (expr1, expr2, expr3, _) ->
    let _, expr1 = fix tys expr1 in
    let out_ty, expr2 = fix tys expr2 in
    let _, expr3 = fix tys expr3 in
    out_ty, If (expr1, expr2, expr3, out_ty)
  | Int i -> IntT, Int i
  | Char c -> CharT, Char c
  | Bool b -> BoolT, Bool b
  | _ -> raise MonoError
  and fix_calt tys = function
  | Destructor (global, num_abstr, expr, ty') ->
    let all_cons = List.concat (List.map snd prog.datadefs) in
    let tys' = List.assoc global all_cons in
    let ty, expr = fix (tys' @ tys) expr in
    (match (ty, ty') with
    | (BoxT, BoxT) -> ty, Destructor (global, num_abstr, expr, ty)
    | (BoxT, _) -> ty, Destructor (global, num_abstr, Unbox (expr, ty'), ty)
    | (_, _) -> ty, Destructor (global, num_abstr, expr, ty)
    )
  | Wildcard (expr, _) ->
    let ty, expr = fix tys expr in
    ty, Wildcard (expr, ty)
  in fix []


let convert_prog sprog = 
  let initial_sprog = { 
    letdefs = []; 
    main = Global ("unit", DataTy "Unit");
    datadefs = [];
    decls = [];
  } in
  let to_prog mprog = function
  | S.LetDef (global, _, sexpr) -> 
    if global = "main" then 
      {mprog with main = snd @@ convert_sexpr sexpr} 
    else 
      let ty, expr = convert_sexpr sexpr in
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
  let prog = List.fold_left to_prog initial_sprog sprog in
  { prog with letdefs = 
    (List.map (fun (n,_,e) -> 
      let ty, e = fix prog e in n,ty,e) prog.letdefs);
    main = snd @@ fix prog prog.main }

