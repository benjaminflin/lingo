(* open Monad *)
module StringMap = Map.Make (String)

type mult 
  = One 
  | Unr 
  | MVar of string
  | MTimes of mult * mult

type name = string

type base_t = BoolT | CharT | IntT

type ty
  = BaseT of base_t 
  | DataTy of name
  | TVar of name
  | Arr of mult * ty * ty
  | Inst of ty * ty
  | InstM of ty * mult
  | Forall of name * ty
  | ForallM of name * ty

type binop 
  = Lt | Gt | Leq | Geq | Neq | Eq | Plus | Minus | Divide | Times | And | Or

type unop = Not | Neg

type check_expr
  = Lam of name * check_expr
  | Infer of infer_expr
and infer_expr 
  = Var of name
  | Binop of binop
  | Unop of unop
  | Let of name * mult * ty * check_expr * infer_expr
  | App of infer_expr * check_expr
  | MApp of infer_expr * mult
  | TApp of infer_expr * ty
  | Construction of name
  | Case of infer_expr * case_alt list
  | If of infer_expr * infer_expr * infer_expr
  | Ann of check_expr * ty
  | Lit of int
  | Char of char
  | Bool of bool
and case_alt 
  = Destructor of name * name list * infer_expr
  | Wildcard of infer_expr

type cons_def
  = Cons of name * ty 

type data_param
  = MultParam of name
  | TypeParam of name

type def 
  = LetDef of name * ty * check_expr
  | DataDef of name * data_param list * cons_def list

type program = def list

type mult_constraint = LE of mult * mult

exception TypeMismatch of ty * ty
exception ExpectedAbs of ty
exception NotImplemented 

let cond c e = if c then () else raise e

let lookup = List.assoc
let remove = List.remove_assoc 

let scale_usage mult = List.map (fun (x, m) -> (x, MTimes (mult, m)))

let rec union_with f l = function
| [] -> []  
| (x, v1)::xs -> 
  (match List.assoc_opt x l with
  | Some v2 -> (x, f v1 v2)::(union_with f (remove x l) xs)
  | None -> (x, v1)::(union_with f l xs)) 

let add_usage x y = union_with (fun _ _ -> Unr) x y

let rec subst_mult_mult subst mult = match (subst, mult) with
  | (a, b), (MVar c) -> if a = c then b else (MVar c)
  | x, MTimes (a, b) -> MTimes ((subst_mult_mult x a), (subst_mult_mult x b))
  | _, m -> m 
let rec subst_mult_ty subst ty = match (subst, ty) with
  | x, Arr (m, t, t') -> Arr ((subst_mult_mult x m), (subst_mult_ty x t), (subst_mult_ty x t'))
  | x, ForallM (p, t) -> ForallM (p, subst_mult_ty x t)
  | x, Forall (p, t) -> Forall (p, subst_mult_ty x t)
  | _, t -> t

let subst_mult_constr subst (LE (m, m')) = LE (subst_mult_mult subst m, subst_mult_mult subst m')
let subst_mult_constr_list subst = List.map (subst_mult_constr subst)

let rec subst_ty_ty subst ty = match (subst, ty) with
  | (x, t), (TVar y) -> if x = y then t else (TVar y)
  | s, Arr (m, t, t') -> Arr (m, subst_ty_ty s t, subst_ty_ty s t')
  | s, Forall (x, t) -> Forall (x, subst_ty_ty s t)
  | s, ForallM (x, t)-> ForallM (x, subst_ty_ty s t)
  | _, t -> t


let rec check env ty constr = function
| Lam (name, check_expr) -> 
  (match ty with
    | Arr (expected_mult, in_ty, out_ty) -> 
      let usage_env, constr = check ((name, in_ty)::env) out_ty constr check_expr in
      let actual_mult = try lookup name usage_env with | Not_found -> Unr in
      remove name usage_env, (LE (actual_mult, expected_mult))::constr
    | Forall  (_, ty') -> check env ty' constr check_expr 
    | ForallM (_, ty') -> check env ty' constr check_expr
    | t -> raise (ExpectedAbs t))
| Infer infer_expr -> 
  let ty', usage_env, constr = infer env constr infer_expr in
  cond (ty = ty') (TypeMismatch (ty, ty')); (* TODO: equality up to alpha equivalence *) 
  usage_env, constr
and infer env constr = function
| Var name -> lookup name env, [(name, One)], constr
| Binop binop -> 
  (match binop with
    | And | Or -> Arr (One, BaseT BoolT, Arr (One, BaseT BoolT, BaseT BoolT)), [], constr
    | _ -> Arr (One, BaseT IntT, Arr (One, BaseT IntT, BaseT IntT)), [], constr)
| Unop unop -> (match unop with
  | Not -> Arr (One, BaseT BoolT, BaseT BoolT), [], constr
  | Neg -> Arr (One, BaseT IntT, BaseT IntT), [], constr
 )
| Let (name, mult, ty, check_expr, infer_expr) -> 
  let u_env1, constr = check ((name, ty)::env) ty constr check_expr in
  let ty', u_env2, constr = infer ((name, ty)::env) constr infer_expr in
  ty', add_usage (remove name u_env1) (scale_usage mult (remove name u_env2)), constr
| App (infer_expr, check_expr) ->
  let ty, u_env1, constr = infer env constr infer_expr in
    (match ty with
    | Arr (mult, in_ty, out_ty) -> 
      let u_env2, constr = check env in_ty constr check_expr in
      out_ty, add_usage u_env1 (scale_usage mult u_env2), constr
    | t -> raise @@ ExpectedAbs t)
| MApp (infer_expr, mult) ->
  let lhs_ty, u_env, constr = infer env constr infer_expr in
    (match lhs_ty with
    | ForallM (name, ty) -> subst_mult_ty (name, mult) ty, u_env, constr 
    | t -> raise @@ ExpectedAbs t) 
| TApp (infer_expr, ty) ->
  let lhs_ty, u_env, constr = infer env constr infer_expr in
    (match lhs_ty with
    | Forall (name, ty') -> subst_ty_ty (name, ty) ty', u_env, constr 
    | t -> raise @@ ExpectedAbs t) 
| Lit _ -> BaseT IntT, [], constr
| Char _ -> BaseT CharT, [], constr
| Bool _ -> BaseT BoolT, [], constr
| _ -> raise NotImplemented