type dbindex = int
type name = string

type cty
  = IntT
  | BoolT
  | CharT
  | CArr of cty * cty
  | DataTy of name 

type var 
  = Global of name
  | Local of dbindex

type cexpr
  = CInt of int
  | CChar of char
  | CBool of bool
  | Clos of name * dbindex list * cexpr * cty
  | CApp of cexpr * cexpr * cty
  | Var of var * cty