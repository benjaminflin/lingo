open Monad

module StringMap = Map.Make (String)

type name = string

type mult = One | Unr
type base_t = IntT | BoolT
type ty 
  = BaseT of base_t 
  | LamT of (mult * ty * ty)
  | Forall of (name * ty)

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
  | If of (expr * expr * expr) 

type env = ty StringMap.t
type usage = mult StringMap.t 
type constr = (mult * mult)
module Check = RWS (struct type t = env end) (UnitMonoid) (struct type t = usage * constr list end)

