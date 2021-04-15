type arglen = int
type cindex = int 
type cname = string

type cty
  = CIntT
  | CBoolT
  | CharT
  | CDataTy of cname 
  | CClosT
  | BoxT

type cexpr
  = CInt of int
  | CChar of char 
  | CBool of bool 
  | CApp of cexpr * cty * cexpr * cty * cty
  | CClos of cname * cexpr list * cty list
  | CCall of cname * (cexpr * cty) list 
  | Box of cexpr * cty
  | Unbox of cexpr * cty
  | CArg of cindex * cty 
  | CIf  of cexpr * cexpr * cexpr * cty
  | CConstruction of cname * cexpr list * cty
  | CCase of cexpr * cty * ccase_alt list * cty
and ccase_alt 
  = CDestructor of cname * arglen * cexpr * cty
  | CWildcard of cexpr * cty

type ccons = cname * cty list
type cglobaldef = cname * arglen * cexpr * cty
type cdataty = cname * ccons list
type cclosuredef = cname * cty list  

type program = {
  globals : cglobaldef list;
  datatys : cdataty list;
  decls : (cname * (cty list * cty)) list; 
  main : cexpr;
}

(*
let prog : program = {
  datatys = [
    "List_Int", ["Cons", [CIntT, CDataTy "List_Int"]; "Nothing", [] ] 
  ],
  closures = [
    "f", [IntT]; // points at f (we didnt write it below)
    // get arbitrary name F_Clos code ptr to f and args IntT
    "foldl1", [IntT];
  ]
  globals = [
    "foldl", 
      [CClosT "f"], // Apply can take in more than a closure
      CClos ("foldl1", [CArg 0]), // return this as a closure (struct Clos_foldl1) {...}
      CClosT "foldl1";
      struct Clos_Foldl1 foldl(Clos_F) {
        return (struct Clos_foldl1) {
          code_ptr = foldl1,
          arg0 = C arg0
        }
      }
    "foldl1", 
      [CClosT "f"; CInt], 
      CClos ("foldl2", [CArg 0, CArg 1]), struct { code_ptr = foldl2, arg0 = CArg 0, arg1 = Carg 1}
      CClosT "foldl2"; // return type
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

@a @b (a -> a) -> (b -> b) -> int
(BoxT -> BoxT) -> (BoxT -> BoxT) -> Int

foo : (@a a -> a) -> (Int, Char)
foo = \f. (f @Int 0, f @Char 'a') 


BoxT -> BoxT -> Tuple
foo : (BoxT -> BoxT) -> Tuple 
foo = \f. (f (Box 0), f (Box 'a'))

foo : (BoxT -> BoxT) -> (BoxT, BoxT) 
foo = \f. (f (MkBox 0), f (MkBox 'a'))

main : 
Unbox (case (foo id) of
  Tuple a b -> a (* Box 0 *), Int)


*)
(*

foo a b = a + b
main = (foo 10) 20


{
  datatys = []
  globals = [
    // Fn Name, Arg Types, returned closure (which we need to build), return type, 
    ("foo", [CIntT], CClos ("foo1", [CArg (0, CIntT)]), CClosT "foo1");
    ("foo1", [CIntT; CIntT], CApp (CClos ("prim_add" Add CArg (0, CIntT), CArg (1, CInt)), CIntT)
  ] 
  closures = [
    "foo", [];        // points at foo with 0 arguments
    "foo1", [CIntT]   // points at foo1 with 1 argument of type CIntT
  ]
  main =
    CApp(
      CApp(
        CClos ("foo", [], CClosT "foo1"),  // lhs (closure)
        CClosT "foo",// type of lhs (type of closure)
        CInt 10,     // rhs (argument to apply)
        CIntT,       // type of rhs (type of argument to Apply)
        ClosT "foo1" // type of result of apply 
      ), // lhs
      CClosT "foo1", // type of lhs
      CInt 20,       // rhs 
      CIntT,         // type of rhs
      CIntT          // type of result of apply
    );
}
*)