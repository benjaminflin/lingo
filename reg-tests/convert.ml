open Printf

let src = Sys.argv.(1)
let src_file =  "./reg-tests/" ^ src ^ ".lingo"
let out_file = src_file ^ ".s"
let out_exec = "./reg-tests/" ^ src
let lib_file = "./reg-tests/lib.c"
let actual_out = "./reg-tests/" ^ src ^ ".a.out"


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
  Llvm.string_of_llmodule @@ Codegen._translate cast



let rec read_input_string ic = 
  let str = input_line ic in
  str ^ "\n" ^ (try read_input_string ic with _ -> "")

let test =
  let (ic, oc) = Unix.open_process "llc" in
  fprintf oc "%s" (llmodule_string src_file);
  close_out oc;
  let asm = read_input_string ic in
  close_in ic;
  let oc = open_out out_file in
  fprintf oc "%s" asm;
  close_out oc;
  let _ = Sys.command @@ "cc " ^ out_file ^ " " ^ lib_file ^ " -o " ^ out_exec in
  let ic = Unix.open_process_in out_exec in 
  let output = input_line ic in
  close_in ic; 
  
  let oc = open_out actual_out in (* create or truncate file, return channel *)
    Printf.fprintf oc "%s\n" output; (* write something *)   
    close_out oc;    


