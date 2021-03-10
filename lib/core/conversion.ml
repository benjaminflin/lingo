open Parse
module Tc = Typecheck

exception ExpectedArrow of Ast.ty 
exception TypeInWrongPlace of Ast.ty
exception MultInWrongPlace of Ast.mult

let rec mult_to_mult = function
| Ast.One -> Tc.One
| Ast.Unr -> Tc.Unr
| Ast.MTimes (a, b) -> Tc.MTimes (mult_to_mult a, mult_to_mult b)
| Ast.MVar a -> Tc.MVar a

let tname_to_ty = function
| "Int" -> Tc.BaseT Tc.IntT 
| "Bool" -> Tc.BaseT Tc.BoolT 
| "Char" -> Tc.BaseT Tc.CharT 
| x -> Tc.DataTy x 

let rec ty_to_ty = function
| Ast.TName name -> tname_to_ty name 
| Ast.TVar name -> Tc.TVar name 
| Ast.Arr (m, s, t) -> Tc.Arr (mult_to_mult m, ty_to_ty s, ty_to_ty t) 
| Ast.Inst (s, t) -> Tc.Inst (ty_to_ty s, ty_to_ty t) 
| Ast.InstM (t, m) -> Tc.InstM (ty_to_ty t, mult_to_mult m) 
| Ast.Forall (x, t) -> Tc.Forall (x, ty_to_ty t) 
| Ast.ForallM (x, t) -> Tc.ForallM (x, ty_to_ty t) 

let arr_get_mult = function
| Ast.Arr (m, _, _) -> mult_to_mult m
| Ast.Forall _ -> Unr 
| Ast.ForallM _ -> Unr 
| t -> raise (ExpectedArrow t)

let arr_get_rhs = function
| Ast.Arr (_, _, t) -> t
| Ast.Forall (_, t) -> t
| Ast.ForallM (_, t) -> t 
| t -> raise (ExpectedArrow t)

let rec name_list_to_lam check_expr ty = function
| [] -> check_expr 
| x::xs -> Tc.Lam (x, name_list_to_lam check_expr (arr_get_rhs ty) xs)

let rec name_list_to_lam_unr check_expr = function
| [] -> check_expr 
| x::xs -> Tc.Lam (x, name_list_to_lam_unr check_expr xs)

let binop_to_binop = function
| Ast.Leq -> Tc.Leq
| Ast.Geq -> Tc.Leq
| Ast.Neq -> Tc.Neq
| Ast.Eq -> Tc.Eq
| Ast.Lt -> Tc.Lt
| Ast.Gt -> Tc.Gt
| Ast.And -> Tc.And
| Ast.Or -> Tc.Or
| Ast.Times -> Tc.Times
| Ast.Divide -> Tc.Divide
| Ast.Plus -> Tc.Plus
| Ast.Minus -> Tc.Minus

let unop_to_unop = function
| Ast.Not -> Tc.Not
| Ast.Neg -> Tc.Neg

let rec check_expr_to_check_expr = function
| Ast.Lam (name, check_expr) -> Tc.Lam (name, check_expr_to_check_expr check_expr)  
| Ast.Infer infer_expr -> Tc.Infer (infer_expr_to_infer_expr infer_expr)
and infer_expr_to_infer_expr = function
| Ast.Var name -> 
  Tc.Var name
| Ast.Binop binop -> 
  Tc.Binop (binop_to_binop binop)
| Ast.Unop unop -> 
  Tc.Unop (unop_to_unop unop)
| Ast.Let (name, mult, ty, check_expr, infer_expr) -> 
  Tc.Let (name, mult_to_mult mult, ty_to_ty ty, check_expr_to_check_expr check_expr, infer_expr_to_infer_expr infer_expr)
| Ast.App (infer_expr, Ast.Infer (Ast.Type ty)) ->
  Tc.TApp (infer_expr_to_infer_expr infer_expr, ty_to_ty ty)
| Ast.App (infer_expr, Ast.Infer (Ast.Mult mult)) ->
  Tc.MApp (infer_expr_to_infer_expr infer_expr, mult_to_mult mult)
| Ast.App (infer_expr, check_expr) ->
  Tc.App (infer_expr_to_infer_expr infer_expr, check_expr_to_check_expr check_expr)
| Ast.Type ty -> raise (TypeInWrongPlace ty)
| Ast.Mult mult -> raise (MultInWrongPlace mult)
| Ast.Construction name -> Tc.Construction name
| Ast.Case (infer_expr, case_alt_list) -> Tc.Case (infer_expr_to_infer_expr infer_expr, List.map case_alt_to_case_alt case_alt_list)
| Ast.Ann (check_expr, ty) -> Tc.Ann (check_expr_to_check_expr check_expr, ty_to_ty ty)
| Ast.If (infer_expr, infer_expr_a, infer_expr_b) -> 
  Tc.If (infer_expr_to_infer_expr infer_expr, infer_expr_to_infer_expr infer_expr_a, infer_expr_to_infer_expr infer_expr_b) 
| Ast.Lit i -> Tc.Lit i
| Ast.Char c -> Tc.Char c
| Ast.Bool b -> Tc.Bool b
and case_alt_to_case_alt = function
| Ast.Destructor (name, name_list, infer_expr) -> Tc.Destructor (name, name_list, infer_expr_to_infer_expr infer_expr) 
| Ast.Wildcard (infer_expr) -> Tc.Wildcard (infer_expr_to_infer_expr infer_expr) 

let data_param_to_data_param = function
| Ast.MultParam name -> Tc.MultParam name
| Ast.TypeParam name -> Tc.TypeParam name

let cons_def_to_cons_def (Ast.Cons (name, ty)) = Tc.Cons (name, ty_to_ty ty)

let convert_def = function
  | Ast.LetDef (name, name_list, ty, check_expr) -> 
    Tc.LetDef (name, ty_to_ty ty, name_list_to_lam (check_expr_to_check_expr check_expr) ty name_list)
  | Ast.DataDef (name, data_param_list, cons_def_list) -> Tc.DataDef (name, List.map data_param_to_data_param data_param_list, List.map cons_def_to_cons_def cons_def_list)
let convert = List.map convert_def
