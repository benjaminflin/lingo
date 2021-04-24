open Parse
module Tc = Typecheck

exception NotImplemented
exception UnboundVariable of string
exception ExpectedArrow of Ast.ty 
exception TypeInWrongPlace of Ast.ty
exception MultInWrongPlace of Ast.mult
exception ImpredicativeType 

let index_of y xs = 
  let rec index_of' y i = function
  | []      -> raise Not_found 
  | (x::xs) -> if x = y then i else index_of' y (i + 1) xs
  in
  index_of' y 0 xs

let rec convert_mult dbmap = function
| Ast.One -> Tc.One
| Ast.Unr -> Tc.Unr
| Ast.MTimes (a, b) -> Tc.MTimes (convert_mult dbmap a, convert_mult dbmap b)
| Ast.MVar name -> 
  try 
    Tc.MVar (index_of name dbmap)
with Not_found -> raise (UnboundVariable name)

let tname_to_ty params = function
| "Int" -> Tc.BaseT Tc.IntT 
| "Bool" -> Tc.BaseT Tc.BoolT 
| "Char" -> Tc.BaseT Tc.CharT 
| x -> Tc.DataTy (x, params)

let rec convert_ty dbmap ty =
  let rec convert_ty' dbmap params = function
  | Ast.TName name -> tname_to_ty params name
  | Ast.TVar name -> (
    try 
      Tc.TVar (index_of name dbmap)
    with Not_found -> raise (UnboundVariable name)
    )

  | Ast.Arr (mult, in_ty, out_ty) -> 
    Tc.Arr ( convert_mult dbmap mult, 
            convert_ty' dbmap params in_ty, 
            convert_ty' dbmap params out_ty 
          ) 

  | Ast.Inst (to_inst, with_ty) -> 
    convert_ty' dbmap ((Type (convert_ty dbmap with_ty))::params) to_inst

  | Ast.InstM (to_inst, with_mult) -> 
    convert_ty' dbmap ((Mult (convert_mult dbmap with_mult))::params) to_inst

  | Ast.Forall (name, ty) -> 
    Tc.Forall (convert_ty' (name::dbmap) params ty) 

  | Ast.ForallM (name, ty) -> 
    Tc.ForallM (convert_ty' (name::dbmap) params ty) 
  in
  convert_ty' dbmap [] ty 

let convert_binop = function
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

let convert_unop = function
| Ast.Not -> Tc.Not
| Ast.Neg -> Tc.Neg

let rec convert_check_expr dbmap = function
| Ast.Lam (name, cexpr) -> Tc.Lam (convert_check_expr (name::dbmap) cexpr)  
| Ast.Case (iexpr, ca_list) -> 
  Tc.Case ( convert_infer_expr dbmap iexpr, 
            List.map (convert_case_alt dbmap) ca_list
          )
| Ast.Infer iexpr       -> Tc.Infer (convert_infer_expr dbmap iexpr)

and convert_infer_expr dbmap = function
| Ast.Var name -> (
  try 
    Tc.DbIndex (index_of name dbmap)
  with Not_found -> Tc.Global name
  )
| Ast.Binop binop -> 
  Tc.Binop (convert_binop binop)

| Ast.Unop unop -> 
  Tc.Unop (convert_unop unop)

| Ast.Let (name, mult, ty, cexpr, iexpr) -> 
  Tc.Let ( convert_mult [] mult, 
           convert_ty [] ty, 
           convert_check_expr (name::dbmap) cexpr, 
           convert_infer_expr (name::dbmap) iexpr
         )

| Ast.App (iexpr, Ast.Infer (Ast.Type ty)) ->
  Tc.TApp (convert_infer_expr dbmap iexpr, convert_ty dbmap ty)

| Ast.App (iexpr, Ast.Infer (Ast.Mult mult)) ->
  Tc.MApp (convert_infer_expr dbmap iexpr, convert_mult dbmap mult)

| Ast.App (iexpr, cexpr) ->
  Tc.App (convert_infer_expr dbmap iexpr, convert_check_expr dbmap cexpr)

| Ast.Type ty -> raise (TypeInWrongPlace ty)

| Ast.Mult mult -> raise (MultInWrongPlace mult)

| Ast.Construction name -> Tc.Construction name



| Ast.Ann (cexpr, ty) -> 
  Tc.Ann (convert_check_expr dbmap cexpr, convert_ty [] ty)

| Ast.If (iexpr, iexpr_a, iexpr_b) -> 
  Tc.If ( convert_infer_expr dbmap iexpr, 
          convert_infer_expr dbmap iexpr_a, 
          convert_infer_expr dbmap iexpr_b
        ) 

| Ast.Int i -> Tc.Int i

| Ast.Char c -> Tc.Char c

| Ast.Bool b -> Tc.Bool b

and convert_case_alt dbmap = function
| Ast.Destructor (name, name_list, iexpr) -> 
  Tc.Destructor ( name, 
                  List.length name_list, 
                  convert_infer_expr ((List.rev name_list) @ dbmap) iexpr
                ) 

| Ast.Wildcard (iexpr) -> 
  Tc.Wildcard (convert_infer_expr dbmap iexpr) 

let rec name_list_to_lam dbmap cexpr = function
| [] -> convert_check_expr dbmap cexpr 
| x::xs -> Tc.Lam (name_list_to_lam (x::dbmap) cexpr xs)

let convert_data_param = function
| Ast.MultParam _ -> Tc.MultParam
| Ast.TypeParam _ -> Tc.TypeParam

let data_param_name = function
| Ast.MultParam name -> name
| Ast.TypeParam name -> name 

let rec convert_cons_params dbmap = function
| Ast.Arr (mult, in_ty, out_ty) -> 
  (convert_mult dbmap mult, convert_ty dbmap in_ty) :: convert_cons_params dbmap out_ty
| _ -> [] 

let convert_cons_ty_params dbmap ty = 
  let rec ty_params' = function
  | Ast.Inst (to_inst, ty) -> 
    Tc.Type (convert_ty dbmap ty) :: ty_params' to_inst
  | Ast.InstM (to_inst, mult) -> 
    Tc.Mult (convert_mult dbmap mult) :: ty_params' to_inst
  | Ast.Forall _  -> raise ImpredicativeType
  | Ast.ForallM _ -> raise ImpredicativeType
  | _ -> []
  in
  let rec ty_params = function
  | Ast.Arr (_, _, out_ty) -> ty_params out_ty
  | Forall _  -> raise ImpredicativeType
  | ForallM _ -> raise ImpredicativeType
  | ty -> ty_params' ty
  in
  List.rev (ty_params ty)


let convert_cons_def dbmap (Ast.Cons (name, ty))
  = (name, convert_cons_params dbmap ty, convert_cons_ty_params dbmap ty) 

let convert_def = function
  | Ast.LetDef (name, args, ty, cexpr) -> 
    Tc.LetDef (name, convert_ty [] ty, name_list_to_lam [] cexpr args)
  | Ast.DataDef (name, dp_list, cd_list) -> 
    Tc.DataDef ( name,
                List.map convert_data_param dp_list,
                let dbmap = List.rev (List.map data_param_name dp_list) in
                List.map (convert_cons_def dbmap) cd_list
               ) 
  | Ast.LetDecl (name, ty) -> Tc.LetDecl (name, convert_ty [] ty)  
let convert = List.map convert_def
