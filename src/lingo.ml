open Lib

let src1 = "
data PartyAnimal {a} |p| where
  Cow     : a -p> PartyAnimal;
  Giraffe : a -p> PartyAnimal;
  Hyenas  : a ->  PartyAnimal;
  Donkies : a ->  PartyAnimal;
"
let src2 = "let compose {a b c} |p q| f g x : @a @b @c #p #q (b -q> c) -> (a -p> b) -> a -p*q> c = f (g x);"

let src3 = "let x : Int -> Int = (\\(x : Int) -> x + 1);"

let src4 = "let x : Foo = (/t -> id {t}) {Int};"

let src5 = "let x : Foo = (|p -> (/t -> id {t} |p|));"
let src6 = "let x : Int = -6;"

let src7 = "
  let x : Maybe {Maybe {Int}} |One| = case (Just (Just 4)) of
    Just a -> Just a;
    Nothing -> Just 0;
  ;"

let src8 = "let x = \'\n\'"

let _ = 
  print_endline (
    Prettyprinter.pretty_print (
      let lexbuf = Lexing.from_string src8
      in Parse.Parser.defs Parse.Scanner.tokenize lexbuf
  ))

