(* Authors: Sophia *)
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