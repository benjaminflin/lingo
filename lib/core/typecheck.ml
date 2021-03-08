(* open Monad *)
module StringMap = Map.Make (String)

type mult 
  = One 
  | Unr 
  | MVar of string
  | Times of mult * mult

type name = string

type base_t = BoolT | CharT | IntT

type ty
  = BaseT of base_t 
  | DataTy of name
  | TVar of name
  | Arr of mult * ty * ty
  | Inst of ty * ty
  | InstM of ty * mult
  | Forall of name * ty
  | ForallM of name * ty

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
  | Let of name * mult * infer_expr * infer_expr
  | App of infer_expr * check_expr
  | MApp of infer_expr * mult
  | TApp of infer_expr * ty
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
  = LetDef of name * ty * check_expr
  | DataDef of name * data_param list * cons_def list

type program = def list