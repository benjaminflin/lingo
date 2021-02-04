open Lib

let () = 
  let res = Math.add 2 3 in
  let sub = Math.sub res 2 in
  print_endline (string_of_int sub)

