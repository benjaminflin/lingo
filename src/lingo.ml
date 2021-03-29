 

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
      Ord e f ->  
        (case f x y of 
          LT -> true; 
          _ -> false;
        : Bool)
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

foo : Int -> Maybe Int #One  
    = \\x. Just @Int #One x;  

foo' m
  : Maybe Int #One -> Int
  = case m of 
    Just i -> i;
  ; 

"

let src5 = "
data Foo a where 
  Foo1 : Int -> Foo Int;
  Foo2 : Char -> Foo Char;

extract a f : @a Foo a -> a 
= case f of
  Foo1 t -> t;
  Foo2 c -> c;
  ;
"



let ast =
  let lexbuf = Lexing.from_string src4 in
  Parse.Parser.program Parse.Scanner.tokenize lexbuf


let core_ast =
  Core.Conversion.convert ast

let _ = 
  ignore (Core.Typecheck.check_prog core_ast)



let _ = print_string "typechecked successfully\n"
