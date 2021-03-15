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
exception ExpectedAbsApp of ty
exception ExpectedAbsMApp of ty
exception ExpectedAbsTApp of ty
exception NotImplemented 
exception UnsatisfiableConstraint of mult * mult 
exception CaseResultMismatch of ty  

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

let simp = function
  | MTimes (a, One)  -> a
  | MTimes (One, a)  -> a
  | MTimes (Unr, _)  -> Unr
  | MTimes (_, Unr)  -> Unr
  | a               -> a

let add_usage x y = union_with (fun _ _ -> Unr) x y
let multiply_usage x y = union_with (fun a b -> MTimes (a, b)) x y

let reduce_constraints cs = 
  let reduce cs = function
    | LE (Unr, One) -> raise (UnsatisfiableConstraint (Unr, One))
    | LE (One, Unr) -> cs
    | LE (Unr, Unr) -> cs
    | LE (One, One) -> cs
    | c             -> (c :: cs)
  in 
  List.fold_left reduce [] cs

let rec subst_mult_mult subst mult = match (subst, mult) with
  | (a, b), (MVar c) -> if a = c then b else (MVar c)
  | s, MTimes (a, b) -> MTimes ((subst_mult_mult s a), (subst_mult_mult s b))
  | _, m -> m 
let rec subst_mult_ty subst ty = match (subst, ty) with
  | (x, _) as s, ForallM (p, t) -> if x = p then ForallM (p, t) else ForallM (p, subst_mult_ty s t)
  | s, Arr (m, t, t') -> Arr (subst_mult_mult s m, subst_mult_ty s t, subst_mult_ty s t')
  | s, Forall (p, t) -> Forall (p, subst_mult_ty s t)
  | s, Inst (t, t') -> Inst (subst_mult_ty s t, subst_mult_ty s t')
  | s, InstM (t, m) -> InstM (subst_mult_ty s t, subst_mult_mult s m)
  | _, t -> t

let subst_mult_constr subst (LE (m, m')) = LE (subst_mult_mult subst m, subst_mult_mult subst m')
let subst_mult_constr_list subst = List.map (subst_mult_constr subst)

let subst_mult_list_mult subst_list mult = List.fold_left (fun m subst -> subst_mult_mult subst m) mult subst_list

let rec subst_ty_ty subst ty = match (subst, ty) with
  | (x, t), (TVar y) -> if x = y then t else (TVar y)
  | s, Arr (m, t, t') -> Arr (m, subst_ty_ty s t, subst_ty_ty s t')
  | (x, _) as s, Forall (y, t) -> if x = y then Forall (y, t) else Forall (y, subst_ty_ty s t)
  | s, ForallM (x, t) -> ForallM (x, subst_ty_ty s t)
  | s, Inst (t, t') -> Inst (subst_ty_ty s t, subst_ty_ty s t')
  | s, InstM (t, m) -> InstM (subst_ty_ty s t, m) 
  | _, t -> t

let rec case_mults = function
| Arr (m, _, to_ty) -> m :: case_mults to_ty 
| Forall (_, ty) -> case_mults ty
| ForallM (_, ty) -> case_mults ty
| _ -> []

let rec case_types = function
| Arr (_, from_ty, to_ty) -> from_ty :: case_types to_ty 
| Forall (_, ty) -> case_types ty
| ForallM (_, ty) -> case_types ty
| _ -> []

let rec case_mult_intros = function
| Forall (_, ty) -> case_mult_intros ty
| ForallM (name, ty) -> name :: (case_mult_intros ty)
| _ -> []

let rec case_scrut_mults = function
| InstM (to_inst, mult) -> mult :: case_scrut_mults to_inst
| Inst (to_inst, _) -> case_scrut_mults to_inst
| _ -> []

let rec check env ty constr = function
| Lam (name, check_expr) -> 
  (match ty with
    | Arr (expected_mult, in_ty, out_ty) -> 
      let usage_env, constr = check ((name, in_ty)::env) out_ty constr check_expr in
      let actual_mult = try lookup name usage_env with | Not_found -> Unr in
      remove name usage_env, reduce_constraints @@ (LE (actual_mult, expected_mult))::constr
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
    | t -> raise @@ ExpectedAbsApp t)
| MApp (infer_expr, mult) ->
  let lhs_ty, u_env, constr = infer env constr infer_expr in
    (match lhs_ty with
    | ForallM (name, ty) -> subst_mult_ty (name, mult) ty, u_env, reduce_constraints @@ subst_mult_constr_list (name, mult) constr
    | t -> raise @@ ExpectedAbsMApp t) 
| TApp (infer_expr, ty) ->
  let lhs_ty, u_env, constr = infer env constr infer_expr in
    (match lhs_ty with
    | Forall (name, ty') -> subst_ty_ty (name, ty) ty', u_env, constr 
    | t -> raise @@ ExpectedAbsTApp t) 
| Construction name -> lookup name env, [], constr
| If (infer_expr, infer_expr_a, infer_expr_b) ->
  let ty, u_env, constr = infer env constr infer_expr in
  cond (ty = BaseT IntT) (TypeMismatch (ty, (BaseT IntT)));
  let ty_a, u_env_a, constr = infer env constr infer_expr_a in
  let ty_b, u_env_b, constr = infer env constr infer_expr_b in
  cond (ty_a = ty_b) (TypeMismatch (ty_a, ty_b));
  ty_a, add_usage u_env (multiply_usage u_env_a u_env_b), constr
| Ann (check_expr, ty) -> 
  let u_env, constr = check env ty constr check_expr in
  ty, u_env, constr
| Case (infer_expr, case_alts) ->
  let ty_scrut, u_env, constr = infer env constr infer_expr in
  let infer_case_alt = function
  | Destructor (name, varnames, rhs) -> (
    let data_ty     = lookup name env in 
    let var_mults   = case_mults data_ty in
    let mult_intros = case_mult_intros data_ty in 
    let scrut_mults = case_scrut_mults ty_scrut in
    let types       = case_types data_ty in  
    let intros      = List.combine varnames types in
    let ty, u_env, constr = infer (intros @ env) constr rhs in
    let gen_constraint (name, expected_mult) = 
      let actual_mult = try lookup name u_env with Not_found -> Unr in 
      let substs = List.combine mult_intros scrut_mults in
      LE (actual_mult, subst_mult_list_mult substs expected_mult) in
    let constr' = List.map gen_constraint (List.combine varnames var_mults) in
    let u_env = List.fold_left (fun u n -> remove n u) u_env varnames in
    ty, u_env, (constr' @ constr) 
    )
  | Wildcard rhs -> infer env constr rhs 
  in
  let rhs_res = List.map infer_case_alt case_alts in
  let constr = List.concat (List.map (fun (_, _, c) -> c) rhs_res) in
  let u_env_rhs = List.concat (List.map (fun (_, u, _) -> u) rhs_res) in
  let rhs_tys = List.map (fun (t, _, _) -> t) rhs_res in
  let rhs_ty, _, _ = List.hd rhs_res in
  let all_same = List.for_all (fun t -> t = rhs_ty) rhs_tys in (* TODO: α equiv *)
  cond (all_same) (CaseResultMismatch rhs_ty);
  rhs_ty, add_usage u_env u_env_rhs, constr 
| Lit _ -> BaseT IntT, [], constr
| Char _ -> BaseT CharT, [], constr
| Bool _ -> BaseT BoolT, [], constr

let rec abstr t = function
| (MultParam x)::xs -> ForallM (x, abstr t xs)
| (TypeParam x)::xs -> Forall (x, abstr t xs)
| [] -> t

let rec app_params t = function
| (MultParam x)::xs -> InstM (app_params t xs, MVar x)
| (TypeParam x)::xs -> Inst (app_params t xs, TVar x)
| [] -> t

let rec data_res_ty dpl = function 
| Forall (x, ty) -> Forall (x, data_res_ty dpl ty)
| ForallM (x, ty) -> ForallM (x, data_res_ty dpl ty)
| Arr (m, from_ty, ty) -> Arr (m, from_ty, data_res_ty dpl ty)
| ty -> app_params ty dpl

let def_to_env = function
| DataDef(_, dpl, cdl) -> List.map (fun (Cons (name, ty)) -> (name, abstr (data_res_ty (List.rev dpl) ty) dpl)) cdl
| LetDef(name, ty, _) -> [(name, ty)]
let check_prog prog = 
  let unit_ty = ("unit", DataTy "Unit") in
  let env = unit_ty :: List.concat_map def_to_env prog in
  let check_def = function
  | LetDef (_, ty, check_expr) -> ignore (check env ty [] check_expr)
  | _ -> ()
  in
  List.iter check_def prog