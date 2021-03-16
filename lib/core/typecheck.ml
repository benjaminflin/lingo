
(* TODO: 
  - Produce an annotated ast (this should be done after type checking??)
  - Extend environment with kinds  
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
  | k1, k2 -> raise (UnificationError (k1, k2))


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