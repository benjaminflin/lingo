open Lib
open Monad

module TestRWS = RWS (struct type t = int end) (UnitMonoid) (struct type t = int end)

open TestRWS
let (let*) = bind 
let rws_test = 
  let* a = ask in
  let* _ = put (a + 2) in
  pure (a + 1)

let rws_result = let (_,a,_) = run_rws rws_test 0 0 in a

let () = 
  print_endline (string_of_int rws_result)

