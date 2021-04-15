type mult 
  = One 
  | Unr 
  | MVar of string
  | MTimes of mult * mult

type name = string

type ty
  = TVar of name
  | TName of name
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
  | Case of infer_expr * case_alt list
  | Infer of infer_expr
and infer_expr 
  = Var of name
  | Binop of binop
  | Unop of unop
  | Let of name * mult * ty * check_expr * infer_expr
  | Type of ty
  | Mult of mult
  | App of infer_expr * check_expr
  | Construction of name
  | If of infer_expr * infer_expr * infer_expr
  | Ann of check_expr * ty
  | Int of int
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
  | LetDecl of name * ty 

type program = def list
