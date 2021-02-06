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
  | ForallM of (name * mult)

type base_e 
  = IntE of int
  | BoolE of bool

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
exception NotInScope of name
exception NotAFunction of expr
exception Mismatch of (ty * ty)

type env = ty StringMap.t
type usage = mult StringMap.t 
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

let add = M.union (fun _ _ _ -> Some Unr)
let mult m = M.map (fun a -> Times (m, a))

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
  | _ -> raise NotImplemented

    