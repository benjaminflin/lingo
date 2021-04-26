(* Authors: Ben, Jay *)
type global       = string
type dbindex      = int
type num_abstr    = int
type constr_index = int
type uniq_varname = int

type mult 
  = One 
  | Unr 
  | MVar of dbindex
  | MTimes of mult * mult

type kind
  = KType
  | KMult
  | KUnknown of uniq_varname 
  | KArr of kind * kind

type base_ty = BoolT | CharT | IntT

type ty
  = BaseT of base_ty
  | DataTy of global * param list
  | TVar of dbindex
  | Arr of mult * ty * ty
  | Forall of ty
  | ForallM of ty
and param 
  = Mult of mult  
  | Type of ty
type binop 
  = Lt | Gt | Leq | Geq | Neq | Eq | Plus | Minus | Divide | Times | And | Or

type unop = Not | Neg

type check_expr
  = Lam of check_expr
  | Case of infer_expr * case_alt list
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
  | If of infer_expr * infer_expr * infer_expr
  | Ann of check_expr * ty
  | Int of int
  | Char of char
  | Bool of bool
and case_alt 
  = Destructor of global * num_abstr * infer_expr
  | Wildcard of infer_expr

type cons_def = global * (mult * ty) list * param list

type data_param
  = MultParam 
  | TypeParam 

type data_def = global * data_param list * cons_def list

type def 
  = LetDef of global * ty * check_expr
  | DataDef of data_def
  | LetDecl of global * ty

type env =
  {
    local_env  : ty list;
    global_env : (global * ty) list;
    kind_env   : (global * kind) list;
    data_env   : data_def list;
    lam_count   : int;
  }

type program = def list

module Sast = struct 
  module Syntax = struct
    type sty = 
    | BaseT of base_ty
    | DataSty of global * sty list
    | TVar of dbindex 
    | Arr of sty * sty
    | Forall of sty

    type ast
    = Lam     of ast * sty * sty
    | TLam    of ast * sty
    | Case    of ast * sty * case_alt list * sty
    | DbIndex of dbindex * sty 
    | Global  of global * sty 
    | Binop   of binop * sty
    | Unop    of unop * sty
    | Let     of ast * sty * ast * sty 
    | App     of ast * sty * ast * sty * sty 
    | TApp    of ast * sty * sty
    | Construction 
              of global * sty
    | If      of ast * ast * ast * sty 
    | Int     of int
    | Char    of char
    | Bool    of bool
    and case_alt 
    = Destructor of global * num_abstr * ast * sty  
    | Wildcard   of ast * sty

    type cons_def = global * sty list 
    type data_def = global * num_abstr * cons_def list

    type def 
    = LetDef of global * sty * ast
    | DataDef of data_def
    | LetDecl of global * sty

    type program = def list
  end
  module S = Syntax


  let rec shift_sty cutoff amount = function
  | S.DataSty (global, stys) -> S.DataSty (global, List.map (shift_sty cutoff amount) stys)
  | S.TVar n -> S.TVar(if n < cutoff then n else n + amount)
  | S.Arr (in_sty, out_sty) -> S.Arr (shift_sty cutoff amount in_sty, shift_sty cutoff amount out_sty)
  | S.Forall ty -> S.Forall (shift_sty (cutoff + 1) amount ty)
  | t -> t
  and shift cutoff amount = function
  | S.Lam (ast, sty1, sty2) -> S.Lam (shift (cutoff + 1) amount ast, shift_sty cutoff amount sty1, shift_sty cutoff amount sty2)
  | S.Case (ast, sty, calts, sty2) -> S.Case (shift cutoff amount ast, shift_sty cutoff amount sty, List.map (shift_case_alt cutoff amount) calts, shift_sty cutoff amount sty2)
  | S.DbIndex (n, ty) -> S.DbIndex ((if n < cutoff then n else n + amount), (shift_sty cutoff amount ty))
  | S.Global (name, sty) -> S.Global(name, shift_sty cutoff amount sty)
  | S.Binop (binop, sty) -> S.Binop (binop, shift_sty cutoff amount sty) 
  | S.Unop (unop, sty) -> S.Unop (unop, shift_sty cutoff amount sty)
  | S.Let (in_ast, in_sty, out_ast, out_sty) -> 
      (match in_sty with
      | S.Arr (_, _) -> 
        S.Let (
                shift (cutoff + 1) amount in_ast, 
                shift_sty cutoff amount in_sty, 
                shift (cutoff + 1) amount out_ast,
                shift_sty (cutoff + 1) amount out_sty
              )
      | _ -> S.Let (
                shift (cutoff + 1) amount in_ast, 
                shift_sty cutoff amount in_sty, 
                shift (cutoff) amount out_ast,
                shift_sty (cutoff + 1) amount out_sty
      )) 
  | S.TApp (ast, app_sty, out_sty) -> S.TApp(shift cutoff amount ast, shift_sty cutoff amount app_sty, shift_sty cutoff amount out_sty)
  | S.Construction (name, sty) -> S.Construction (name, shift_sty cutoff amount sty)
  | S.If(ast1, ast2, ast3, sty) -> S.If(shift cutoff amount ast1, shift cutoff amount ast2, shift cutoff amount ast3, shift_sty cutoff amount sty)
  | t -> t
  and shift_case_alt cutoff amount = function
  | S.Destructor(name, num_abstr, ast, sty) -> S.Destructor(name, num_abstr, shift (cutoff + num_abstr) amount ast, shift_sty (cutoff + num_abstr) amount sty)
  | S.Wildcard(ast, sty) -> S.Wildcard(shift cutoff amount ast, shift_sty cutoff amount sty)

  let ty_to_sty ty = 
    let rec tts cutoff = function
    | BaseT base_ty -> S.BaseT base_ty 
    | DataTy (name, param_list) -> S.DataSty (name, List.concat @@ List.map (param_to_ty cutoff) param_list)   
    | TVar dbindex -> S.TVar dbindex
    | Arr (_, in_ty, out_ty) -> S.Arr (tts cutoff in_ty, tts cutoff out_ty)
    | Forall ty -> S.Forall (tts (cutoff + 1) ty)
    | ForallM ty -> shift_sty cutoff (-1) (tts cutoff ty)
    and param_to_ty cutoff = function
    | Type ty -> [tts cutoff ty]
    | _ -> [] 
    in tts 0 ty

  let convert_ty_param = function
  | Type t -> [ty_to_sty t] 
  | _ -> []
  let convert_cons_def ty_params (global, params, _) =
    let rec convert_params cutoff params = function
    | (TypeParam)::xs ->  convert_params (cutoff + 1) params xs
    | _::xs -> convert_params cutoff (List.map (shift_sty cutoff (-1)) params) xs
    | [] -> params
    in
    let sparams = List.map ty_to_sty (List.map snd params) in
    global, convert_params 0 sparams ty_params
  let convert_data_def (name, params, cd_list) = 
    let rec num_ty_params = function
    | (TypeParam)::xs -> 1 + num_ty_params xs 
    | _::xs -> num_ty_params xs
    | [] -> 0 in
    name, num_ty_params params, List.map (convert_cons_def params) cd_list
  include S
end

exception NotImplemented 
exception ExpectedAbs of ty
exception ExpectedArr of ty
exception ExpectedForall of ty
exception ExpectedForallM of ty
exception TypeMismatch of ty * ty
exception MultMismatch of mult * mult
exception VarNotFound of global
exception UnknownConstructor of global
exception ExpectedDataTy of ty
exception ArgumentLengthMismatch of num_abstr * num_abstr
exception CaseResultMismatch of ty
exception ParamMismatch of param * param
exception InternalTypechekerError

let rec string_of_mult = function 
| One -> "One"
| Unr -> "Unr"
| MTimes (a, b) -> string_of_mult a ^ "*" ^ string_of_mult b
| MVar a -> "#" ^ string_of_int a

let rec string_of_ty = function
| BaseT (IntT) -> "Int" 
| BaseT (BoolT) ->"Bool" 
| BaseT (CharT) -> "Char" 
| DataTy (ty, params) -> ty ^ " " ^ List.fold_left (fun s p -> s ^ " " ^ string_of_param p) "" params
| TVar t -> "#" ^ string_of_int t 
| Arr (m, s, t) -> "(" ^ string_of_ty s ^ " -" ^ string_of_mult m ^ "> " ^ string_of_ty t ^ ")"
| Forall (t) -> "@ (" ^ string_of_ty t ^ ")"
| ForallM (t) -> "# (" ^ string_of_ty t ^ ")"
and string_of_param = function
| Type ty -> string_of_ty ty
| Mult mult -> string_of_mult mult


let string_of_uenv = 
  List.fold_left (fun s (i, m) -> s ^ string_of_int i ^ ": " ^ string_of_mult m ^ "\n") "" 

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

  | DataTy (_, _) -> 
    (* TODO: Infer kinds of params from use in each constructor *)
    KType, IntMap.empty, i   

  | TVar idx -> (
    try 
      List.nth env.kind_env idx, IntMap.empty, i
    with _ -> raise (UnknownTypeParam idx)
  )

  | Arr (_, from_ty, to_ty) -> 
    let k1, s1, i = infer_kind env i from_ty in
    let k2, s2, i = infer_kind (apply_subst_env s1 env) i to_ty in 
    KArr (KArr (k1, KMult), k2), s2, i

  | Forall ty -> 
    let k, s, i' = infer_kind { env with kind_env = (KUnknown i)::env.kind_env } (i + 1) ty in
    (KArr (apply_subst s (KUnknown i), k)), s, i'

  | ForallM ty -> 
    let k, s, i = infer_kind { env with kind_env = KMult::env.kind_env } i ty in
    (KArr (KMult, k)), s, i
  and kind_param env i = function
  | Type ty -> infer_kind env i ty
  | Mult _ -> KMult, IntMap.empty, i
end

let cond c e = if c then () else raise e

let rec extract_data_env = function
| (LetDef _)::defs -> extract_data_env defs
| (DataDef data_def)::defs -> data_def :: extract_data_env defs
| _::defs -> extract_data_env defs
| _ -> []

let rec extract_global_env = function
| (LetDef (global, ty, _))::defs -> (global,ty) :: extract_global_env defs
| (DataDef _)::defs -> extract_global_env defs
| (LetDecl (global, ty))::defs -> (global, ty) :: extract_global_env defs
| _ -> []

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
  let rec cons_ty' name ty_params = function
  | ((mult, in_ty)::xs) -> Arr (mult, in_ty, cons_ty' name ty_params xs)
  | [] -> DataTy (name, ty_params)
  in
  let cons_ty name params ty_params = add_abs (cons_ty' name ty_params params)
  in
  let cd_list = 
    List.concat (List.map (
      fun (dname,dp_list,cd_list) -> 
        List.map (fun 
          (cname, params, ty_params) -> 
            (cname, cons_ty dname params ty_params dp_list)) cd_list
    ) data_env)
  in 
  try List.assoc name cd_list with _ -> raise (UnknownConstructor name)

let rec dec_uenv = function
| (i, mult)::env -> if i = 0 then dec_uenv env else (i-1, mult)::dec_uenv env
| [] -> []

let scale_usage mult = List.map (fun (x, m) -> (x, MTimes (mult, m)))

let rec union_with f l = function
| [] -> l  
| (x, v1)::xs -> 
  (match List.assoc_opt x l with
  | Some v2 -> (x, f v1 v2)::(union_with f (List.remove_assoc x l) xs)
  | None -> (x, v1)::(union_with f l xs)) 

let simp = 
  let rec simp' = function
  | MTimes (a, One)  -> simp' a
  | MTimes (One, a)  -> simp' a
  | MTimes (Unr, _)  -> Unr
  | MTimes (_, Unr)  -> Unr
  | a -> a 
  in
  let rec simp = function
  | MTimes (a, b)    -> simp' (MTimes (simp a, simp b))
  | a                -> simp' a
  in simp

let add_usage x y = union_with (fun _ _ -> Unr) x y
let multiply_usage x y = union_with (fun a b -> MTimes (a, b)) x y


let rec shift_mult cutoff amount = function
| MTimes (a, b) -> MTimes (shift_mult cutoff amount a, shift_mult cutoff amount b)  
| MVar n -> MVar (if n < cutoff then n else n + amount)
| m -> m 
let rec shift_ty cutoff amount = function
| Arr (mult, in_ty, out_ty) -> 
  Arr ( shift_mult cutoff amount mult, 
        shift_ty cutoff amount in_ty,
        shift_ty cutoff amount out_ty
      )
| Forall ty -> Forall (shift_ty (cutoff + 1) amount ty)
| ForallM ty -> ForallM (shift_ty (cutoff + 1) amount ty)
| TVar n -> TVar (if n < cutoff then n else n + amount)
| DataTy (name, params) -> DataTy (name, List.map (shift_param cutoff amount) params) 
| t -> t 
and shift_param cutoff amount = function
| Type ty -> Type (shift_ty cutoff amount ty)
| Mult mult -> Mult (shift_mult cutoff amount mult)

let rec subst_mult_mult subst mult = match (subst, mult) with
| (i, m), MVar j -> if i = j then m else MVar j
| s, MTimes (a, b) -> MTimes (subst_mult_mult s a, subst_mult_mult s b)
| _, m -> m 

let rec subst_mult_ty subst ty = match (subst, ty) with
| s, Arr (m, t, t') -> Arr (subst_mult_mult s m, subst_mult_ty s t, subst_mult_ty s t')
| (i, m), Forall t -> Forall (subst_mult_ty (i+1, shift_mult 0 1 m) t) 
| (i, m), ForallM t -> ForallM (subst_mult_ty (i+1, shift_mult 0 1 m) t) 
| s, DataTy (name, params) -> DataTy (name, List.map (subst_mult_param s) params)
| _, t -> t
and subst_mult_param s = function
| Type ty -> Type (subst_mult_ty s ty)
| Mult mult -> Mult (subst_mult_mult s mult)

let rec subst_ty_ty subst ty = match (subst, ty) with
| (i, t), TVar j -> if i = j then t else TVar j
| s, Arr (m, t, t') -> Arr (m, subst_ty_ty s t, subst_ty_ty s t') 
| (i, t), Forall t' -> Forall (subst_ty_ty (i+1, shift_ty 0 1 t) t')
| (i, t), ForallM t' -> ForallM (subst_ty_ty (i+1, shift_ty 0 1 t) t')
| s, DataTy (name, params) -> DataTy (name, List.map (subst_ty_param s) params)
| _, t -> t
and subst_ty_param s = function
| Type ty -> Type (subst_ty_ty s ty)
| m -> m

let subst_param_ty (i, p) ty = match p with 
| Type ty'-> subst_ty_ty (i, ty') ty
| Mult mult -> subst_mult_ty (i, mult) ty   
let subst_param_mult (i, p) mult = match p with
| Mult mult' -> subst_mult_mult (i, mult') mult   
| _ -> mult 
let subst_param_list_ty substs ty = 
  List.fold_left (fun ty s -> subst_param_ty s ty) ty substs
let subst_param_list_mult substs mult = 
  List.fold_left (fun mult s -> subst_param_mult s mult) mult substs

let lookup_constructor_def name { data_env; _ } = 
  let cd_aggregate_list = 
    List.concat (List.map (
      fun (_,_,cd_list) -> List.map 
        (fun (name, params, ty_params) -> name, (params, ty_params)) cd_list
    ) data_env)
  in 
  try List.assoc name cd_aggregate_list with _ -> raise (UnknownConstructor name)

let rec unify_left ty ty' = match (ty, ty') with
| Arr (m, in_ty, out_ty), Arr (m', in_ty', out_ty') ->
  let s_in = unify_left in_ty in_ty' in
  let s_out = unify_left out_ty out_ty' in
  cond (m = m') (MultMismatch (m, m'));
  union_with (fun t t' -> 
    cond (t = t') (TypeMismatch (t, t')); t'
  ) s_in s_out
| DataTy (name, params), DataTy (name', params') ->
  cond (name = name') (TypeMismatch (ty, ty'));
  let unify_param (p, p') = (match (p, p') with
  | Type t, Type t' -> unify_left t t'
  | Mult m, Mult m' -> cond (m = m') (MultMismatch (m, m')); [] 
  | _, _ -> raise @@ ParamMismatch (p, p'))
  in
  let unify_params s p = (unify_param p) @ s
  in
  List.fold_left unify_params [] (List.combine params params')
| TVar n, _ -> [n, ty']
| _, TVar _ -> raise @@ TypeMismatch (ty, ty')
| _ -> cond (ty = ty') (TypeMismatch (ty, ty')); []

module S = Sast

let rec is_polymorphic = function
| One -> false
| Unr -> false
| MVar _ -> true 
| MTimes (a, b) -> is_polymorphic a || is_polymorphic b

let check_constraint actual_mult expected_mult = 
  let rec leq a b = match (a, b) with
  | MTimes (MTimes (a, b), c), MTimes (MTimes (a', b'), c') -> assoc_leq a b c a' b' c' 
  | MTimes (a,  MTimes (b, c)), MTimes (MTimes (a', b'), c') -> assoc_leq a b c a' b' c' 
  | MTimes (MTimes (a, b), c), MTimes (a',  MTimes (b', c')) -> assoc_leq a b c a' b' c' 
  | MTimes (a,  MTimes (b, c)), MTimes (a',  MTimes (b', c')) -> assoc_leq a b c a' b' c' 
  | MTimes (((MVar _) as a), ((MVar _) as b)), MTimes (((MVar _) as a'), ((MVar _) as b')) -> (leq a a' && leq b b') || (leq a b' && leq b a')
  | MTimes (a, b), ((MVar _) as c) -> (leq a c && leq b c)  
  | a, MTimes (b, MTimes (c, d)) -> leq a (MTimes (b, c)) || leq a (MTimes (b, d)) || leq a (MTimes (c, d)) 
  | a, MTimes (MTimes (b, c), d) -> leq a (MTimes (b, c)) || leq a (MTimes (b, d)) || leq a (MTimes (c, d))
  | a, MTimes (b, c) -> leq a b || leq a c
  | (MVar a, MVar b) -> a = b 
  | (_, Unr) -> true 
  | (Unr, _) -> false
  | (One, One) -> true 
  | (One, _) -> true
  | (_, One) -> false
  and assoc_leq a b c a' b' c' = 
    (leq a a' && leq b b' && leq c c') ||
    (leq a a' && leq b c' && leq c b') ||
    (leq a b' && leq b c' && leq c a') ||
    (leq a b' && leq b a' && leq c c') ||
    (leq a c' && leq b b' && leq c a') ||
    (leq a c' && leq b a' && leq c b') 
  in
  let a, b = simp actual_mult, simp expected_mult in
  if leq a b then
    ()
  else
    raise @@ MultMismatch (a, b)

let rec check env ty = function
| Lam cexpr -> 
  (match ty with
    | Arr (expected_mult, in_ty, out_ty) ->
      let env = { env with lam_count = env.lam_count + 1 } in 
      let uenv, sexpr
        = check (extend_env in_ty env) out_ty cexpr 
      in
      let actual_mult = lookup_uenv 0 uenv in
      check_constraint actual_mult expected_mult;
      dec_uenv uenv, S.Lam (sexpr, S.ty_to_sty in_ty, S.ty_to_sty out_ty)   
    | Forall (ty') -> 
      let uenv, sexpr = check env ty' cexpr in
      dec_uenv uenv, S.TLam (sexpr, S.ty_to_sty ty)
    | ForallM (ty') -> 
      let uenv, sexpr = check env ty' cexpr in
      dec_uenv uenv, S.shift 0 (-1) sexpr
    | ty -> raise @@ ExpectedAbs ty
  )
| Case (iexpr, calts) -> 
  let ty_scrut, uenv,  sscrut = infer env iexpr in
  let infer_calt = function
    | Destructor (name, len, rhs) -> (
      let range n = List.init n (fun x -> x) in
      (* Get parameters and type paramaters from constructor *)
      let calt_params, _ 
        = lookup_constructor_def name env in         
      let scrut_ty_params = (match ty_scrut with 
      | DataTy (_, params) -> params
      | _ -> raise @@ ExpectedDataTy ty_scrut)
      in
      (* Refine type of parameters according to the scrutinee *)
      let calt_params 
        = List.map (
            fun (m, t) -> 
              let substs = List.combine (range (List.length scrut_ty_params)) (List.rev scrut_ty_params)
              in
              subst_param_list_mult substs m, 
              subst_param_list_ty substs t) (List.rev calt_params)
      in

      (* Infer type of rhs given the params introduced by the case alt *)
      let mults = List.map fst calt_params in
      let types = List.map snd calt_params in
      let actual_ty, uenv, srhs 
        = infer ({ env with local_env = types @ env.local_env }) rhs 
      in
      (* Check to make sure that the number of arguments 
         bound matches the number of arguments given in 
         the definition of the constructor *)
      cond (len = List.length types) (ArgumentLengthMismatch (len, List.length types));
      (* Unify expected type with actual (GADT) *)
      let substs = unify_left ty actual_ty in  
      let subst_list_ty_ty s t = List.fold_left (fun t s -> subst_ty_ty s t) t s
      in
      let expected_ty 
        = subst_list_ty_ty substs ty in
      (* Check equality of rhs to the expected type *)
      cond (expected_ty = actual_ty) (TypeMismatch (expected_ty, actual_ty));
      (* Check multiplicity constraints based on usage env in rhs of case alt *)
      let check_constr (idx, expected_mult) =
        let actual_mult = lookup_uenv idx uenv in
        check_constraint actual_mult expected_mult
      in
      List.iter check_constr (List.combine (range len) mults);
      (* Remove all bound variables in usage environment *)
      let uenv = List.fold_left (fun u _ -> dec_uenv u) uenv (range len) in
      uenv, S.Destructor (name, len, srhs, S.ty_to_sty actual_ty)
    ) 
    | Wildcard rhs -> 
      let uenv, srhs = check env ty (Infer rhs) in
      uenv, S.Wildcard (srhs, S.ty_to_sty ty)
  in 
  (* Add up all constraints and usage environments from each case alt *)
  let rhs_res = List.map infer_calt calts in
  let uenv_rhs = List.concat (List.map fst rhs_res) in
  let scalts = List.map snd rhs_res in
  add_usage uenv uenv_rhs, S.Case (sscrut, S.ty_to_sty ty_scrut, scalts, S.ty_to_sty ty)
| Infer iexpr -> 
  let ty', uenv, sexpr 
    = infer env iexpr 
  in
  cond (ty = ty') (TypeMismatch (ty, ty'));
  uenv, sexpr
and infer env = function
| DbIndex idx -> let ty = List.nth env.local_env idx in
  ty, [(idx, One)], S.DbIndex (idx, S.ty_to_sty ty)

| Global global -> 
  (
    try
      let ty = List.assoc global env.global_env in
      ty, [], S.Global (global, S.ty_to_sty ty)
    with _ -> raise (VarNotFound global)
  )

| Binop binop ->
  (match binop with
  | And | Or -> 
    let ty = Arr (One, BaseT BoolT, Arr (One, BaseT BoolT, BaseT BoolT)) in
    ty, [], S.Binop (binop, S.ty_to_sty ty)
  | Plus | Minus | Times | Divide ->
    let ty = Arr (One, BaseT IntT, Arr (One, BaseT IntT, BaseT IntT)) in
    ty, [], S.Binop (binop, S.ty_to_sty ty)
  | _ -> 
    let ty = Arr (One, BaseT IntT, Arr (One, BaseT IntT, BaseT BoolT)) in
    ty, [], S.Binop (binop, S.ty_to_sty ty))
| Unop unop -> 
  (match unop with
  | Not -> 
    let ty = Arr (One, BaseT BoolT, BaseT BoolT) in
    ty, [], S.Unop (unop, S.ty_to_sty ty)  
  | Neg -> 
    let ty = Arr (One, BaseT IntT, BaseT IntT) in
    ty , [], S.Unop (unop, S.ty_to_sty ty))

| Let (mult, ty, cexpr, iexpr) ->
  (match ty with
  | Arr (_, _, _) ->
    let uenv1, sexpr1
      = check (extend_env ty env) ty cexpr
    in
    let ty', uenv2, sexpr2
      = infer (extend_env ty env) iexpr
    in
    let actual_mult = lookup_uenv 0 uenv2 in
    check_constraint actual_mult mult;
    ty', add_usage (dec_uenv uenv2) (scale_usage mult (dec_uenv uenv1)), S.Let (sexpr1, S.ty_to_sty ty, sexpr2, S.ty_to_sty ty')
  | _ -> 
    let uenv1, sexpr1
      = check env ty cexpr
    in
    let ty', uenv2, sexpr2
      = infer (extend_env ty env) iexpr
    in
    let actual_mult = lookup_uenv 0 uenv2 in
    check_constraint actual_mult mult;
    ty', add_usage (dec_uenv uenv2) (scale_usage mult uenv1), S.Let (sexpr1, S.ty_to_sty ty, sexpr2, S.ty_to_sty ty')
  )

| App (iexpr, cexpr) ->
  let ty, uenv1, sexpr1 = infer env iexpr in 
  (match ty with
  | Arr (mult, in_ty, out_ty) ->
    let uenv2, sexpr2 = check env in_ty cexpr in
    out_ty, add_usage uenv1 (scale_usage mult uenv2), S.App (sexpr1, S.ty_to_sty ty, sexpr2, S.ty_to_sty in_ty, S.ty_to_sty out_ty)
  | t -> raise @@ ExpectedArr t)

| MApp (iexpr, mult) ->
  let lhs_ty, uenv, sexpr1 = infer env iexpr in
  let mult = shift_mult 0 (-env.lam_count) mult in
  (match lhs_ty with
  | ForallM ty ->  
    shift_ty 0 (-1) (subst_mult_ty (0, shift_mult 0 1 mult) ty), uenv, sexpr1
  | t -> raise @@ ExpectedForallM t)

| TApp (iexpr, ty) ->
  let lhs_ty, uenv, sexpr = infer env iexpr in
  let ty = shift_ty 0 (-env.lam_count) ty in
  (match lhs_ty with
  | Forall ty' -> 
    let out_ty = shift_ty 0 (-1) (subst_ty_ty (0, shift_ty 0 1 ty) ty') in
    out_ty, uenv, S.TApp (sexpr, S.ty_to_sty ty, S.ty_to_sty out_ty)  
  | t -> raise @@ ExpectedForall t)

| Construction name -> 
  let ty = lookup_constructor name env in
  ty, [], S.Construction (name, S.ty_to_sty ty)

| If (iexpr_0, iexpr_1, iexpr_2) ->
  let ty, uenv, sexpr0 = infer env iexpr_0 in
  cond (ty = BaseT BoolT) (TypeMismatch (ty, (BaseT BoolT)));
  let ty1, uenv1, sexpr1 = infer env iexpr_1 in
  let ty2, uenv2, sexpr2 = infer env iexpr_2 in
  cond (ty1 = ty2) (TypeMismatch (ty1, ty2));
  ty1, add_usage uenv (multiply_usage uenv1 uenv2), S.If (sexpr0, sexpr1, sexpr2, (S.ty_to_sty ty1))

| Ann (cexpr, ty) ->
  let uenv, sexpr = check env ty cexpr in
  ty, uenv, sexpr 

| Int i -> BaseT IntT, [], S.Int i

| Char c -> BaseT CharT, [], S.Char c

| Bool b -> BaseT BoolT, [], S.Bool b


let check_def env = function
| LetDef (name, ty, cexpr) -> 
  let _ = KindChecker.infer_kind (env_to_kenv env) 0 ty in
  let _, sexpr = check env ty cexpr in
  S.LetDef (name, S.ty_to_sty ty, sexpr)
| DataDef dd -> S.DataDef (S.convert_data_def dd)
| LetDecl (name, ty) -> S.LetDecl (name, S.ty_to_sty ty)
let check_prog prog =
  try  
    let data_env = extract_data_env prog in
    let global_env = extract_global_env prog in
    let env = { local_env = []; 
                global_env = global_env; 
                data_env = data_env;
                kind_env = []; 
                lam_count = 0;
              } in
    List.map (check_def env) prog 
  with 
  | MultMismatch (a, b) as self -> 
    Printf.eprintf "%s\n" ("Multiplicity Mismatch: " ^ string_of_mult a ^ " > " ^ string_of_mult b);
    raise self
  | TypeMismatch (a, b) as self ->
    Printf.eprintf "%s\n" ("Type Mismatch: " ^ string_of_ty a ^ " /= " ^ string_of_ty b);
    raise self