let src_file = Sys.argv.(1)

let string_of_file file = 
  let ic = open_in file in
  let str = really_input_string ic (in_channel_length ic) in
  close_in ic;
  str

let llmodule_string src_file =
  let src = string_of_file src_file in
  let prog = let lexbuf = Lexing.from_string src in Parse.Parser.program Parse.Scanner.tokenize lexbuf 
  in 
  let sast = let core_ast = Core.Conversion.convert prog in Core.Typecheck.check_prog core_ast 
  in 
  let mast = Mono.Conversion.convert_prog sast in 
  let cast = Closure.Conversion.convert_prog mast in 
  Llvm.string_of_llmodule @@ Codegen.translate cast

let _ = print_endline @@ llmodule_string src_file

(* 
let src = "main : () = printInt 0;"

let ast =
  let lexbuf = Lexing.from_string src in 
  Parse.Parser.program Parse.Scanner.tokenize lexbuf 

let core_ast = Core.Conversion.convert ast

let _ =
  print_string @@ Llvm.string_of_llmodule (Codegen.translate core_ast) *)


(* let src1 = "main : () = ();"

let src2 = "
data Ordering where
  LT : Ordering;
  GT : Ordering;
  EQ : Ordering; 

data Eq a where
  Eq : (a -> a -> Bool) -> Eq a;

data Ord a where
  Ord : Eq a -> (a -> a -> Ordering) -> Ord a;

lessThan t o x y : @a Ord a -> a -> a -> Bool 
  = case o of
    Ord e f -> case f x y of 
      LT -> true; _  -> false;
    ;
; 
"

let src3 = "
data NonEmpty where
data Empty where

data List a b where
  Nil   : List a Empty;
  Cons  : a -> List a b -> List a NonEmpty; 

l : List Int Empty = Nil @Int @Empty;
l2 : List Int NonEmpty = Cons @Int @Empty 0 l; 
l3 : List Int NonEmpty = Cons @Int @NonEmpty 1 l2; 

head a l
  : @a List a NonEmpty -> a
  = case l of
    Cons x l' -> x;
;

headWithDefault a b d l 
  : @a @b a -> List a b -> a
  = case l of
    Cons x l' -> x;
    Nil -> d;
;

foo : Int = headWithDefault @Int @Empty (-1) l;
bar : Int = head @Int l2;
"

let src4 = "
data Maybe a #p where
  Just    : a -p> Maybe a #p; 
  Nothing : Maybe a #p;

foo : Int -* Maybe Int #One  
    = \\x. Just @Int #One x;

(* Doesn't work yet but should *)
 
foo' m
  : Maybe Int #Unr -* Int
  = case m of 
    Just i -> i;
  ; 

"

let ast =
  let lexbuf = Lexing.from_string src4 in
  Parse.Parser.program Parse.Scanner.tokenize lexbuf


let core_ast =
  Core.Conversion.convert ast

let _ = 
  Core.Typecheck.check_prog core_ast


let _ = print_string "typechecked successfully\n" *)
