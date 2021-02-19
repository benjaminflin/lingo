
type mult 
  = One 
  | Unr 
  | MVar of string
  | Times of mult * mult

type name = string


type ty
  = TVar of name
  | TName of name
  | LamT of (mult * ty * ty)

type binop 
  = Lt | Gt | Le | Ge | Ne | Eq | Plus | Minus | Divide | Times

type expr
  = Var of name
  | Op of expr * binop * expr
  | Let of (name * mult * ty * expr * expr)
  | App of (expr * expr) 
  | Lam of (name * mult * ty * expr)
  | MLam of (name * expr) 
  | MApp of (expr * mult)
  | TLam of (name * expr)
  | TApp of (expr * ty)
  | If of (expr * expr * expr) 
  | Lit of int
  | Bool of bool
