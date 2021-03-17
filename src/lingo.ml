let src1 = "main : () = ();"

let src2 = "
data Empty where

data NonEmpty where

data List a b where
  Nil : List a Empty;
  Cons : @c a -> List a c -> List a NonEmpty; 

l : List Int Empty = Nil @Int @Empty;
l2 : List Int NonEmpty = Cons @Int @NonEmpty @Empty 0 l;

"

let ast =
  let lexbuf = Lexing.from_string src2 in
  Parse.Parser.program Parse.Scanner.tokenize lexbuf


let core_ast =
  Core.Conversion.convert ast

let _ = 
  Core.Typecheck.check_prog core_ast


let _ = print_string "typechecked successfully\n"