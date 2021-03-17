
(* TODO: 
  - Produce an annotated ast (this should be done after type checking??)
*)

type global       = string
type dbindex      = int
type num_abstr    = int
type constr_index = int

type mult 
  = One 
  | Unr 
  | MVar of dbindex
  | MTimes of mult * mult

type kind
  = KType
  | KMult
  | KUnknown of constr_index 
  | KArr of kind * kind

type base_ty = BoolT | CharT | IntT

type ty
  = BaseT of base_ty
  | DataTy of global
  | TVar of dbindex
  | Arr of mult * ty * ty
  | Inst of ty * ty
  | InstM of ty * mult
  | Forall of ty
  | ForallM of ty

type binop 
  = Lt | Gt | Leq | Geq | Neq | Eq | Plus | Minus | Divide | Times | And | Or

type unop = Not | Neg

type check_expr
  = Lam of check_expr
  | Infer of infer_expr
and infer_expr 
  = DbIndex of dbindex
  | Global of global
  | Binop of binop
  | Unop of unop
  | Let of mult * ty * check_expr * infer_expr
  | App of infer_expr * check_expr
  | MApp of infer_expr * mult
  | TApp of infer_expr * ty
  | Construction of global
  | Case of infer_expr * case_alt list
  | If of infer_expr * infer_expr * infer_expr
  | Ann of check_expr * ty
  | Int of int
  | Char of char
  | Bool of bool
and case_alt 
  = Destructor of global * num_abstr * infer_expr
  | Wildcard of infer_expr

type cons_def
  = Cons of global * ty 

type data_param
  = MultParam 
  | TypeParam 

type data_def = global * data_param list * cons_def list

type def 
  = LetDef of global * ty * check_expr
  | DataDef of data_def

type env =
  {
    local_env  : ty list;
    global_env : (global * ty) list;
    kind_env   : (global * kind) list;
    data_env   : data_def list;
  }

type program = def list

type mult_constraint = LE of mult * mult

exception NotImplemented 
exception UnsatisfiableConstraint of mult * mult 
exception ExpectedAbs of ty
exception ExpectedArr of ty
exception ExpectedForall of ty
exception ExpectedForallM of ty
exception TypeMismatch of ty * ty
exception VarNotFound of global
exception UnknownConstructor of global
exception ArgumentLengthMismatch of num_abstr * num_abstr
exception CaseResultMismatch of ty


module KindChecker = struct 

  exception UnknownDataType of global
  exception UnknownTypeParam of dbindex
  exception OccursCheck of constr_index * kind
  exception UnificationError of kind * kind

  let lookup_data_def name dd_list = 
    let finder name_to_find (name, _, _) = 
      name_to_find = name 
    in
    (try
      List.find (finder name) dd_list
      with Not_found -> raise (UnknownDataType name))


  type kenv =
  {
    kind_env   : kind list;
    data_env   : data_def list;
  }

  module IntMap = Map.Make (Int)

  let rec apply_subst s = function
  | KUnknown i -> 
    (match (IntMap.find_opt i s) with
    | Some k -> k
    | None -> KUnknown i)
  | KArr (k1, k2) -> KArr (apply_subst s k1, apply_subst s k2)
  | k -> k

  let apply_subst_env s env = { env with kind_env = List.map (apply_subst s) env.kind_env }
  let compose_subst s1 s2 = IntMap.union (fun _ x _ -> Some x) (IntMap.map (apply_subst s1) s2) s1

  let rec unify_kind k1 k2 = 
    let rec fvs = function
    | KUnknown i -> [i]  
    | KArr (k1, k2) -> fvs k1 @ fvs k2
    | _ -> []
    in
    let occurs_check i k = 
      match List.find_opt (fun x -> x = i) (fvs k) with
      | Some _ -> raise (OccursCheck (i, k))
      | None -> ()
    in 
    let bind i k = 
      if (KUnknown i) = k then IntMap.empty else
      (occurs_check i k; IntMap.singleton i k)
    in 
    match (k1, k2) with
  | KUnknown i, k -> bind i k
  | k, KUnknown i -> bind i k
  | KArr (k1, k2), KArr (k3, k4) -> 
    let s1 = unify_kind k1 k3 in
    let s2 = unify_kind (apply_subst s1 k2) (apply_subst s1 k4) in
    compose_subst s2 s1 
  | k1, k2 -> if k1 = k2 then IntMap.empty else raise (UnificationError (k1, k2))

  let rec infer_kind env i = function
  | BaseT _ -> KType, IntMap.empty, i

  | DataTy name -> 
    let _, dp_list, _ = lookup_data_def name env.data_env in
    let rec data_param_list_kind = function
    | (MultParam::xs) -> KArr (KMult, data_param_list_kind xs) 
    | (TypeParam::xs) -> KArr (KType, data_param_list_kind xs) 
    | [] -> KType
    in
    data_param_list_kind dp_list, IntMap.empty, i

  | TVar idx -> (
    try 
      List.nth env.kind_env idx, IntMap.empty, i
    with _ -> raise (UnknownTypeParam idx)
  )

  | Arr (_, from_ty, to_ty) -> 
    let k1, s1, i = infer_kind env i from_ty in
    let k2, s2, i = infer_kind (apply_subst_env s1 env) i to_ty in 
    KArr (KArr (k1, KMult), k2), s2, i

  | Inst (to_inst, with_ty) -> 
    let k1, s1, i = infer_kind env i to_inst in
    let k2, s2, i = infer_kind (apply_subst_env s1 env) i with_ty in
    let v = unify_kind (apply_subst s2 k1) (KArr (k2, KUnknown i)) in
    let s = compose_subst v (compose_subst s2 s1) in
    let k = apply_subst v (KUnknown i) in
    k, s, i + 1

  | InstM (to_inst, _) -> 
    let k1, s1, i = infer_kind env i to_inst in
    let v = unify_kind (apply_subst s1 k1) (KArr (KMult, KUnknown i)) in
    apply_subst v (KUnknown i), compose_subst v s1, i + 1

  | Forall ty -> 
    let k, s, i' = infer_kind { env with kind_env = (KUnknown i)::env.kind_env } (i + 1) ty in
    (KArr (apply_subst s (KUnknown i), k)), s, i'

  | ForallM ty -> 
    let k, s, i = infer_kind { env with kind_env = KMult::env.kind_env } i ty in
    (KArr (KMult, k)), s, i

end

let cond c e = if c then () else raise e

let rec extract_data_env = function
| (LetDef _)::defs -> extract_data_env defs
| (DataDef data_def)::defs -> data_def :: extract_data_env defs
| [] -> []

let rec extract_global_env = function
| (LetDef (global, ty, _))::defs -> (global,ty) :: extract_global_env defs
| (DataDef _)::defs -> extract_global_env defs
| [] -> []

let rec make_kind_env = function
| (LetDef _)::defs -> make_kind_env defs 
| (DataDef ((global, _, _) as data_def))::defs ->
  let kenv : KindChecker.kenv 
      = { kind_env = [];
          data_env =  [data_def];
        } 
  in 
  let kind, _, _ = 
    KindChecker.infer_kind kenv 0 (DataTy global)
  in
  (global, kind) :: make_kind_env defs
| [] -> []

let env_to_kenv env : KindChecker.kenv = { kind_env = []; data_env = env.data_env; }
let extend_env ty env = { env with local_env = ty :: env.local_env }

let rec lookup_uenv i = function
| (j, mult)::env -> if i = j then mult else lookup_uenv i env 
| [] -> Unr 

let lookup_constructor name { data_env; _ } =
  let rec add_abs c = function
  | TypeParam::xs -> Forall (add_abs c xs) 
  | MultParam::xs -> ForallM (add_abs c xs) 
  | [] -> c
  in
  let cd_list = 
    List.concat_map (
      fun (_,dp_list,cd_list) -> 
        List.map (fun (Cons (n, t)) -> (n, add_abs t dp_list)) cd_list
    ) data_env 
  in 
  try List.assoc name cd_list with _ -> raise (UnknownConstructor name)
  
let rec dec_uenv = function
| (i, mult)::env -> if i = 0 then dec_uenv env else (i-1, mult)::dec_uenv env
| [] -> []

let scale_usage mult = List.map (fun (x, m) -> (x, MTimes (mult, m)))

let rec union_with f l = function
| [] -> []  
| (x, v1)::xs -> 
  (match List.assoc_opt x l with
  | Some v2 -> (x, f v1 v2)::(union_with f (List.remove_assoc x l) xs)
  | None -> (x, v1)::(union_with f l xs)) 

let rec simp = function
  | MTimes (a, One)  -> a
  | MTimes (One, a)  -> a
  | MTimes (Unr, _)  -> Unr
  | MTimes (_, Unr)  -> Unr
  | MTimes (a, b)    -> MTimes (simp a, simp b)
  | a                -> a

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
  | (i, m), (MVar j) -> if i = j then m else (MVar j)
  | s, MTimes (a, b) -> MTimes (subst_mult_mult s a, subst_mult_mult s b)
  | _, m -> m 

let rec subst_mult_ty subst ty = match (subst, ty) with
  | s, Arr (m, t, t') -> Arr (subst_mult_mult s m, subst_mult_ty s t, subst_mult_ty s t')
  | (i, t), Forall t' -> Forall (subst_mult_ty (i+1, t) t') 
  | (i, t), ForallM t' -> ForallM (subst_mult_ty (i+1, t) t') 
  | s, Inst (t, t') -> Inst (subst_mult_ty s t, subst_mult_ty s t')
  | s, InstM (t, m) -> InstM (subst_mult_ty s t, subst_mult_mult s m)
  | _, t -> t

let rec subst_ty_ty subst ty = match (subst, ty) with
  | (i, t), (TVar j) -> if i = j then t else (TVar j)
  | s, Arr (m, t, t') -> Arr (m, subst_ty_ty s t, subst_ty_ty s t') 
  | (i, t), Forall t' -> Forall (subst_ty_ty (i+1, t) t')
  | (i, t), ForallM t' -> ForallM (subst_ty_ty (i+1, t) t')
  | s, Inst(t, t') -> Inst (subst_ty_ty s t, subst_ty_ty s t')
  | s, InstM (t, m) -> InstM (subst_ty_ty s t, m) 
  | _, t -> t

let subst_mult_constr subst (LE (m, m')) = LE (subst_mult_mult subst m, subst_mult_mult subst m')
let subst_mult_constr_list subst = List.map (subst_mult_constr subst)
let subst_mult_list_mult subst_list mult = List.fold_left (fun m subst -> subst_mult_mult subst m) mult subst_list

let rec check env ty constr = function
| Lam cexpr -> 
  (match ty with
    | Arr (expected_mult, in_ty, out_ty) ->
      let uenv, constr 
        = check (extend_env in_ty env) out_ty constr cexpr 
      in
      let actual_mult = lookup_uenv 0 uenv in
      dec_uenv uenv, reduce_constraints @@ (LE (simp expected_mult, simp actual_mult))::constr  
    | Forall (ty') -> check env ty' constr cexpr
    | ForallM (ty') -> check env ty' constr cexpr
    | ty -> raise @@ ExpectedAbs ty
  )

| Infer iexpr -> 
  let ty', uenv, constr 
    = infer env constr iexpr 
  in
  cond (ty = ty') (TypeMismatch (ty, ty'));
  uenv, constr
and infer env constr = function
| DbIndex idx -> 
  List.nth env.local_env idx, [], constr

| Global global -> 
  (try List.assoc global env.global_env, [], constr with _ -> raise (VarNotFound global))

| Binop binop ->
  (match binop with
  | And | Or -> Arr (One, BaseT BoolT, Arr (One, BaseT BoolT, BaseT BoolT)), [], constr
  | _ -> Arr (One, BaseT IntT, Arr (One, BaseT IntT, BaseT IntT)), [], constr)

| Unop unop -> 
  (match unop with
  | Not -> Arr (One, BaseT BoolT, BaseT BoolT), [], constr
  | Neg -> Arr (One, BaseT IntT, BaseT IntT), [], constr)

| Let (mult, ty, cexpr, iexpr) ->
  let uenv1, constr 
    = check (extend_env ty env) ty constr cexpr
  in
  let ty', uenv2, constr
    = infer (extend_env ty env) constr iexpr
  in
  ty', add_usage (dec_uenv uenv1) (scale_usage mult (dec_uenv uenv2)), constr

| App (iexpr, cexpr) ->
  let ty, uenv1, constr = infer env constr iexpr in 
  (match ty with
  | Arr (mult, in_ty, out_ty) ->
    let uenv2, constr = check env in_ty constr cexpr in
    out_ty, add_usage uenv1 (scale_usage mult uenv2), constr
  | t -> raise @@ ExpectedArr t)

| MApp (iexpr, mult) ->
  let lhs_ty, uenv, constr = infer env constr iexpr in
  (match lhs_ty with
  | ForallM ty ->  
    subst_mult_ty (0, mult) ty, uenv, reduce_constraints @@ subst_mult_constr_list (0, mult) constr 
  | t -> raise @@ ExpectedForallM t)

| TApp (iexpr, ty) ->
  let lhs_ty, uenv, constr = infer env constr iexpr in
  (match lhs_ty with
  | Forall ty' -> subst_ty_ty (0, ty) ty', uenv, constr
  | t -> raise @@ ExpectedForall t)

| Construction name -> lookup_constructor name env, [], constr    

| If (iexpr_0, iexpr_1, iexpr_2) ->
  let ty, uenv, constr = infer env constr iexpr_0 in
  cond (ty = BaseT BoolT) (TypeMismatch (ty, (BaseT BoolT)));
  let ty1, uenv1, constr = infer env constr iexpr_1 in
  let ty2, uenv2, constr = infer env constr iexpr_2 in
  cond (ty1 = ty2) (TypeMismatch (ty1, ty2));
  ty1, add_usage uenv (multiply_usage uenv1 uenv2), constr

| Ann (cexpr, ty) ->
  let uenv, constr = check env ty constr cexpr in
  ty, uenv, constr 

| Case (iexpr, calts) -> 
  let ty_scrut, uenv, constr = infer env constr iexpr in
  let infer_calt = function
    | Destructor (name, len, rhs) -> (
      let rec cons_mults = function
      | Arr (m, _, to_ty) -> m :: cons_mults to_ty 
      | Forall (ty) -> cons_mults ty
      | ForallM (ty) -> cons_mults ty
      | _ -> []
      in
      let rec cons_mult_intros = function
      | Forall ty -> cons_mult_intros ty
      | ForallM ty -> 1 + (cons_mult_intros ty)
      | _ -> 0
      in
      let rec cons_types = function
      | Arr (_, from_ty, to_ty) -> from_ty :: cons_types to_ty 
      | Forall ty -> cons_types ty
      | ForallM ty -> cons_types ty
      | _ -> []
      in
      let rec case_scrut_mults = function
      | InstM (to_inst, mult) -> mult :: case_scrut_mults to_inst
      | Inst (to_inst, _) -> case_scrut_mults to_inst
      | _ -> []
      in
      let range n = List.init n (fun x -> x + 1)
      in
      let cons_ty     = lookup_constructor name env in         
      let cons_mults  = cons_mults cons_ty in 
      let scrut_mults = case_scrut_mults ty_scrut in 
      let mult_intros = cons_mult_intros cons_ty in
      let types       = cons_types cons_ty in
      let ty, uenv, constr = infer ({ env with local_env = types @ env.local_env }) constr rhs in
      let gen_constraint (idx, expected_mult) =
        let actual_mult = lookup_uenv idx uenv in
        let substs = List.combine (range mult_intros) scrut_mults in
        LE (actual_mult, subst_mult_list_mult substs expected_mult) 
      in
      let constr' = List.map gen_constraint (List.combine (range len) cons_mults) in
      let uenv = List.fold_left (fun u _ -> dec_uenv u) uenv (range len) in
      cond (len = List.length types) (ArgumentLengthMismatch (len, List.length types));
      ty, uenv, (constr' @ constr)
    ) 
    | Wildcard rhs -> infer env constr rhs
  in 
  let rhs_res = List.map infer_calt calts in
  let constr = List.concat (List.map (fun (_, _, c) -> c) rhs_res) in
  let uenv_rhs = List.concat (List.map (fun (_, u, _) -> u) rhs_res) in
  let rhs_tys = List.map (fun (t, _, _) -> t) rhs_res in
  let rhs_ty, _, _ = List.hd rhs_res in
  let all_same = List.for_all (fun t -> t = rhs_ty) rhs_tys in
  cond (all_same) (CaseResultMismatch rhs_ty);
  rhs_ty, add_usage uenv uenv_rhs, constr

| Int (_) -> BaseT IntT, [], constr

| Char (_) -> BaseT CharT, [], constr

| Bool (_) -> BaseT BoolT, [], constr


let check_def env = function
| LetDef (_, ty, cexpr) -> 
  let _ = KindChecker.infer_kind (env_to_kenv env) 0 ty in
  ignore (check env ty [] cexpr)
| _ -> () 

let check_prog prog = 
  let data_env = extract_data_env prog in
  let global_env = extract_global_env prog in
  let kind_env = make_kind_env prog in
  let env = { local_env = []; 
              global_env = global_env; 
              data_env = data_env;
              kind_env = kind_env; 
            } in
  List.iter (check_def env) prog 

