
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
  | Forall of (name * ty)
  | ForallM of (name * ty)


type binop 
  = Lt | Gt | Le | Ge | Ne | Eq | Plus | Minus | Divide | Times | And | Or

type unop = Not | Neg

type param 
  = MParam of name
  | TParam of name
  | Param of name



type expr
  = Var of name
  | Op of expr * binop * expr
  | Let of (name * param list * mult * ty * expr * expr)
  | App of (expr * expr) 
  | Lam of (name * mult * ty * expr)
  | MLam of (name * expr) 
  | MApp of (expr * mult)
  | TLam of (name * expr)
  | Unop of (unop * expr)
  | TApp of (expr * ty)
  | Construction of (name)
  | If of (expr * expr * expr) 
  | Case of (expr * casealt list)
  | Lit of int
  | Char of char
  | Bool of bool
and casealt 
  = Destructor of (name * name list * expr)
  | Wildcard of expr

type consdef
  = Cons of name * ty 

type datadef
  = DataType of name * param list * consdef list


type def 
  = Def of name * ty * expr
  | DataDef of datadef


type defs = def list