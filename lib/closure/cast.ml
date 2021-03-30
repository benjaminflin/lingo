type cindex = int 
type cname = string

type cty
  = CIntT
  | CBoolT
  | CharT
  | CArr of cty * cty
  | CDataTy of cname 

type cexpr
  = CInt of int
  | CChar of char 
  | CBool of bool 
  | CApp of cexpr * cexpr * cty
  | CClos of cname * cexpr list * cty
  | CArg of cindex * cty 
  | CIf  of cexpr * cexpr * cexpr * cty
  | CConstruction of cname * cexpr list * cty
  | CCase of ccase_alt list
and ccase_alt 
  = CDestructor of cname * cexpr * cty
  | CWildcard of cexpr * cty

type ccons = cty list
type cglobaldef = cname * cty list * cexpr * cty
type cdataty = cname * ccons list

type program = {
  globals : cglobaldef list;
  datatys : cdataty list;
  main : cexpr;
}
