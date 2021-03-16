module StringMap = Map.Make (String)

(* TODO: 
  - Convert all abstractions to debrujin indices (automatic alpha equivalence)
  - Produce an annotated ast (this should be done after type checking??)
  - Extend environment with kinds  
  *)

type global    = string
type dbindex   = int
type num_abstr = int

type mult 
  = One 
  | Unr 
  | MVar of dbindex
  | MTimes of mult * mult

type kind
  = KType
  | KMult
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