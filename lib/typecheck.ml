open Monad
module StringMap = Map.Make (String)

type name = string

type mult 
  = One 
  | Unr
  | MVar of name 
  | Plus of (mult * mult)
  | Times of (mult * mult)

type base_t = IntT | BoolT
type ty
  = BaseT of base_t 
  | TVar of name
  | LamT of (mult * ty * ty)
  | Forall of (name * ty)
  | ForallM of (name * ty)

type base_e 
  = IntE of int
  | BoolE of bool
  | CharE of char
type expr  
  = BaseE of base_e
  | Var of name
  | Lam of (name * mult * ty * expr)
  | App of (expr * expr) 
  | MLam of (name * expr) 
  | MApp of (expr * mult) 
  | TLam of (name * expr)
  | TApp of (expr * ty)
  | Construction of (name * expr list)
  | Let of (name * mult * ty * expr * expr)
  | Letrec of ((name * mult * ty * expr) list * expr) 
  | Case of (expr * case_alt list)
  | If of (expr * expr * expr) 
and case_alt 
  = Constructor of (name list * expr)
  | Wildcard of expr

exception NotImplemented 
exception NotAMLam of ty
exception NotInScope of name
exception NotAFunction of expr
exception Mismatch of (ty * ty)

type env    = ty StringMap.t
type usage  = mult StringMap.t 
type constr = LE of (mult * mult)

module Check = RWS (struct type t = env end) (UnitMonoid) (struct type t = constr list end)
module M = StringMap
open Check
let (let*) = bind
let (&) m m' = bind m (fun _ -> m')

let add_constr c = 
  let* cs = get in 
  put (c::cs)

let lookup_var x =
  let* map = ask in 
  match M.find_opt x map with
    | Some ty -> pure (ty, M.singleton x One)
    | _ -> raise (NotInScope x)

let simp = function
  | Plus _          -> Unr
  | Times (a, One)  -> a
  | Times (One, a)  -> a
  | Times (Unr, _)  -> Unr
  | Times (_, Unr)  -> Unr
  | a               -> a
let add a b = 
  let f _ a b = Some (Plus (a, b)) in
  M.map (simp) (M.union f a b)
let mult m a = M.map (simp) (M.map (fun a -> Times (m, a)) a)

let rec subst_mult_mult subst mult = match (subst, mult) with
  | (MVar a, b), (MVar c) -> if a == c then b else (MVar c)
  | x, Times (a, b)       -> Times ((subst_mult_mult x a), (subst_mult_mult x b))
  | x, Plus (a, b)        -> Plus ((subst_mult_mult x a), (subst_mult_mult x b))
  | _, m                  -> m 
let rec subst_mult_ty subst ty = match (subst, ty) with
  | x, LamT (m, t, t') -> LamT ((subst_mult_mult x m), (subst_mult_ty x t), (subst_mult_ty x t'))
  | x, ForallM (p, t)  -> ForallM (p, subst_mult_ty x t)
  | x, Forall (p, t)   -> Forall (p, subst_mult_ty x t)
  | _, t                -> t

let subst_mult_constr subst (LE (m, m')) = LE (subst_mult_mult subst m, subst_mult_mult subst m')
let subst_mult_constr_list subst = List.map (subst_mult_constr subst)

(* let reduce_constraints = raise NotImplemented  *)
let reduce_constraints = ()
(* let reduce_constraints = 
  let* a = get & *)


let rec check expr = 
  match expr with
  | BaseE (IntE _) -> 
    pure (BaseT IntT, M.empty) 

  | BaseE (BoolE _) -> 
    pure (BaseT BoolT, M.empty)

  | (Var x) -> lookup_var x
   
  | (Lam (x, m, t, e)) ->
    let* (t', u) = local (M.add x t) (check e) in
    let m' = (match M.find_opt x u with 
      | Some u -> u
      | None -> Unr) in 
    add_constr (LE (m', m)) &
    pure (LamT (m, t, t'), M.remove x u)
  
  | App (e1, e2) -> 
    let* (t1, u1) = check e1 in
    let* (t2, u2) = check e2 in
    (match t1 with
      | LamT (p, a, b) -> 
        if a == t2 then 
          pure (b, add u1 (mult p u2))
        else
          raise (Mismatch (t2, a))
      | _ -> raise (NotAFunction e1))
  | MLam (x, e) -> 
    (* Maybe TODO: subtract any existing p from env *)
    let* (t, u) = check e in
    pure (ForallM (x, t), u)
  | MApp (e, p) -> 
    let* (t', u) = check e in
    (match t' with 
      | Forall(q, t) ->
          modify (subst_mult_constr_list (MVar q, p)) &
          (* reduce_constraints & *)
          pure (subst_mult_ty (MVar q, p) t, u)
      | _ -> raise (NotAMLam t')
    )
  | If (_, _, _) -> raise NotImplemented
  | _ -> raise NotImplemented

(* 
let _ =
  let lexbuf = Lexing.from_channel stdin in
  let expr = Parser.expr Scanner.tokenize lexbuf in
  let result = eval expr in
  print_endline (string_of_int result) *)
