type mult 
  = One 
  | Unr 
  | MVar of string
  | Times of mult * mult

type name = string

type ty
  = TVar of name
  | TName of name
  | Arr of (mult * ty * ty)
  | Inst of (ty * ty)
  | InstM of (ty * mult)
  | Forall of (name * ty)
  | ForallM of (name * ty)

type binop 
  = Lt | Gt | Leq | Geq | Neq | Eq | Plus | Minus | Divide | Times | And | Or

type unop = Not | Neg

type check_expr
  = Lam of name * mult * check_expr
  | Infer of infer_expr
and infer_expr 
  = Var of name
  | Binop of binop
  | Unop of unop
  | Let of name * name list * mult * infer_expr * infer_expr
  | Type of ty
  | Mult of mult
  | App of infer_expr * check_expr
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
  = LetDef of name * name list * ty * check_expr
  | DataDef of name * data_param list * cons_def list

type program = def list



(* type mult 
  = One 
  | Unr 
  | MVar of string
  | Times of mult * mult

type name = string

type ty
  = TVar of name
  | TName of name
  | LamT of (mult * ty * ty)
  | Inst of (ty * ty list)
  | InstM of (ty * mult list)
  | Forall of (name * ty)
  | ForallM of (name * ty)

type binop 
  = Lt | Gt | Le | Ge | Ne | Eq | Plus | Minus | Divide | Times | And | Or

type unop = Not | Neg

type param 
  = MParam of name list
  | TParam of name list
  | Param of name list

type expr
  = Var of name
  | Op of expr * binop * expr
  | Let of (name * param list * mult * ty * expr * expr)
  | App of (expr * expr) 
  | Lam of (name * mult * ty * expr)
  | MLam of (name * expr) 
  | MApp of (expr * mult list)
  | TLam of (name * expr)
  | TApp of (expr * ty list)
  | Unop of (unop * expr)
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
  = Def of name * param list * ty * expr
  | DataDef of datadef

type defs = def list *)


