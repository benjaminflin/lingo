let src1 = "main : () = ();"

let src2 = "
data Foo a #p where
  Foo1 : a -* Foo;
  Foo2 : a -p> Foo;

foo1 : Int -* Foo Int #Unr = \\x. Foo1 @Int #Unr x;
foo1 : Char -* Foo Char #One = \\x. Foo1 @Char #One x;
"

let ast =
  let lexbuf = Lexing.from_string src2 in
  Parse.Parser.program Parse.Scanner.tokenize lexbuf

let core_ast =
  Core.Conversion.convert ast

let _ =
  Core.Typecheck.check_prog core_ast