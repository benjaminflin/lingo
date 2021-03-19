(* open Parse.Ast

let rec concat_with_space : name list -> name = (function
| [s] -> s
| (s::ss) -> s ^ " " ^ (concat_with_space ss)
| [] -> "")

let rec concat_with t = (function
| (s::ss) -> s ^ t ^ (concat_with t ss)
| [] -> "")

let extract_param_name = function
| MParam namelist -> "|" ^ concat_with_space namelist ^ "|"
| TParam namelist -> "{" ^ concat_with_space namelist ^ "}"
| Param namelist -> concat_with_space namelist

let rec pretty_print_paramlist = function
| [p] -> extract_param_name p 
| (p::ps) -> extract_param_name p ^ " " ^ pretty_print_paramlist ps
| [] -> "" 

let rec pretty_print_mult = function
| MVar name -> name
| Unr -> "Unr"
| One -> "One"
| Times(m1, m2) -> pretty_print_mult m1 ^ "*" ^  pretty_print_mult m2
 
let pretty_print_arrow m =
  if m == One then 
    "-*" 
  else if m == Unr then 
    "->" 
  else "-" ^ pretty_print_mult m ^ ">"

let rec pretty_print_ty = function
| TVar name -> name
| TName name -> name
| LamT (m, t1, t2) -> "(" ^ pretty_print_ty t1 ^ " " ^ pretty_print_arrow m ^ " " ^ pretty_print_ty t2 ^ ")"
| ForallM (name, t) -> "#" ^ name ^ " " ^ pretty_print_ty t
| Forall (name, t) -> "@" ^ name ^ " " ^ pretty_print_ty t
| Inst  (t, tlist) -> 
  pretty_print_ty t 
  ^ " {" 
  ^ concat_with_space (List.map (pretty_print_ty) tlist) ^ "} "
| InstM (t, mlist) -> 
  pretty_print_ty t 
  ^ " |"
  ^ concat_with_space (List.map (pretty_print_mult) mlist) 
  ^ "| "

let pretty_print_consdef (Cons (name, ty)) = name ^ " : " ^ pretty_print_ty ty ^ ";"

let pretty_print_consdeflist l = concat_with "\n  " (List.map (pretty_print_consdef) l)  

let pretty_print_datadef (DataType (name, paramlist, consdeflist)) = "data "
    ^ name ^ " " 
    ^ pretty_print_paramlist paramlist ^ " where\n  "
    ^ pretty_print_consdeflist consdeflist


let pretty_print_binop = function
| Lt -> "<"
| Gt -> ">"
| Le -> "<=" 
| Ge -> ">="
| Ne -> "!="
| Eq -> "=="
| Plus -> "+"
| Minus -> "-"
| Divide -> "/"
| Times -> "*"
| And -> "&&"
| Or -> "||"

let pretty_print_unop = function
| Neg -> "-"
| Not -> "!"

let rec pretty_print_expr = function
| Var(name) -> name
| Op(e1, bop, e2) -> 
    pretty_print_expr e1 
    ^ pretty_print_binop bop 
    ^ pretty_print_expr e2
| Let(name, pl, m, t, e1, e2) -> 
    "let " 
    ^ name ^ " " 
    ^ pretty_print_paramlist pl ^ " : " 
    ^ pretty_print_mult m ^ " " 
    ^ pretty_print_ty t ^ " = " 
    ^ pretty_print_expr e1 ^ " in "
    ^ pretty_print_expr e2
| App(e1, e2) -> 
    "(" ^ pretty_print_expr e1 ^ " "
    ^ pretty_print_expr e2 ^ ")"
| Lam(name, m, t, e) -> 
    "\\(" 
    ^ name ^ " : "
    ^ pretty_print_ty t ^ ") " 
    ^ pretty_print_arrow m ^ " "
    ^ pretty_print_expr e
| MLam(name, e) ->
    "|" ^ name ^ " -> " 
    ^ pretty_print_expr e
| MApp(e, ml) -> 
    "(" ^ pretty_print_expr e ^ " |"
    ^ concat_with_space (List.map (pretty_print_mult) ml) ^ "|)"
| TLam(name, e) -> 
    "/" ^ name ^  " -> "
    ^ pretty_print_expr e
| TApp(e, tl) ->
    "(" ^ pretty_print_expr e ^ " {"
    ^ concat_with_space (List.map (pretty_print_ty) tl) ^ "})"
| Unop(unop, e) -> 
    "(" ^ pretty_print_unop unop
    ^ pretty_print_expr e ^ ")" 
| Construction(name) ->
    name
| If(e1, e2, e3) -> 
    "if " ^ pretty_print_expr e1 ^ " then "
    ^ pretty_print_expr e2 ^ " else "  
    ^ pretty_print_expr e3
| Case(e, casealt) ->
    "case " ^ pretty_print_expr e ^ " of\n"
    ^ concat_with_space (List.map (pretty_print_case) casealt)
| Lit(i) -> string_of_int i 
| Char(c) -> String.make 1 c 
| Bool(b) -> string_of_bool b 
and pretty_print_case = function
| Destructor(name, nl, e) -> 
    name ^ " "
    ^ concat_with_space nl ^ " -> "
    ^ pretty_print_expr e ^ ";\n"
| Wildcard(e) -> 
    "_ -> " ^ pretty_print_expr e ^ ";\n"

let pretty_print_letstmt (name, paramlist, ty, expr) = 
  "let "
  ^ name ^ " "
  ^ pretty_print_paramlist paramlist ^ " : " 
  ^ pretty_print_ty ty ^ " = " 
  ^ pretty_print_expr expr ^ ";"

let pretty_print_def = function
| DataDef(d) -> pretty_print_datadef d ^ "\n"
| Def(n,p,t,e) -> pretty_print_letstmt (n,p,t,e) ^ "\n"

let pretty_print defs 
  = concat_with "\n" (List.map (pretty_print_def) defs) *)