module Tc = Core.Typecheck
type binop = Tc.binop
type unop = Tc.unop
type global = string
type dbindex = int
type num_abstr = int

type mty = 
  | IntT 
  | CharT
  | BoolT
  | DataTy of global 
  | TVar of dbindex 
  | BoxT
  | Arr of mty * mty

type mexpr
  = Lam     of mexpr * mty * mty
  | Case    of mexpr * mty * case_alt list * mty
  | DbIndex of dbindex * mty 
  | Global  of global * mty 
  | Binop   of binop * mty
  | Unop    of unop * mty
  | Let     of mexpr * mty * mexpr * mty 
  | App     of mexpr * mty * mexpr * mty * mty
  | Construction 
            of global * mty
  | Box     of mexpr * mty 
  | Unbox   of mexpr * mty 
  | If      of mexpr * mexpr * mexpr * mty 
  | Int     of int
  | Char    of char
  | Bool    of bool
and case_alt 
  = Destructor of global * num_abstr * mexpr * mty  
  | Wildcard   of mexpr * mty

type cons_def = global * mty list 
type data_def = global * cons_def list

type program = {
  main : mexpr;
  letdefs : (global * mty * mexpr) list;
  datadefs: data_def list;
  decls: (global * mty) list;
}
