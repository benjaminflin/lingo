type cindex = int 
type cname = string

type cty
  = CIntT
  | CBoolT
  | CharT
  | CDataTy of cname 
  | CClosT of cname 

type cexpr
  = CInt of int
  | CChar of char 
  | CBool of bool 
  | CApp of cexpr * cexpr * cty
  | CClos of cname * cexpr list * cty
  | CArg of cindex * cty 
  | CIf  of cexpr * cexpr * cexpr * cty
  | CConstruction of cname * cexpr list * cty
  | CCase of cexpr * ccase_alt list
and ccase_alt 
  = CDestructor of cname * cty list * cexpr * cty
  | CWildcard of cexpr * cty

type ccons = cname * cty list
type cglobaldef = cname * cty list * cexpr * cty
type cdataty = cname * ccons list
type cclosuredef = cname * cty list  

type program = {
  globals : cglobaldef list;
  closures : cclosuredef list;
  datatys : cdataty list;
  main : cexpr;
}

(*
let prog : program = {
  datatys = [
    "List_Int", ["Cons", [CIntT, CDataTy "List_Int"]; "Nothing", [] ] 
  ],
  closures = [
    "f", [IntT];
    "foldl1", [IntT];
  ]
  globals = [
    "foldl", 
      [CClosT "f"], 
      CClos ("foldl1", [CArg 0]),
      CClosT "foldl1";
    "foldl1", 
      [CClosT "f"; CInt], 
      CClos ("foldl2", [CArg 0, CArg 1]),
      CClosT "foldl2";
    "foldl2", [CClosT "f"; CInt; CDataTy "List_Int"], 
      CCase (CArg 2, [
      CDestructor ("Nil", [], CArg 1); 
      CDestructor ("Cons", [IntT; CDataTy "List_Int"], 
        CApp(
          CApp(
            CApp(
              CClos("foldl", []), CArg 0
            ), 
          CApp(
            CApp(CArg 0, CArg 1)
          , CArg 3)
          ), CArg 4))])
    ]
  main = 
  CApp(CApp(CApp(CClos "foldl", CClos "f"), CInt 0), 
  CConstruction ("Cons", [CInt 0, CConstruction ("Cons", [CInt 1, CConstruction "Nil" []])]))
}
*) 