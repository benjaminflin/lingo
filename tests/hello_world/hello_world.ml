open Printf

let src_file = "./tests/hello_world/hello_world.lingo"
let out_file = "./tests/hello_world/hello_world.s"
let out_exec = "./tests/hello_world/hello_world"
let lib_file = "./tests/hello_world/lib.c"

let string_of_file file = 
  let ic = open_in file in
  let str = really_input_string ic (in_channel_length ic) in
  close_in ic;
  str

let llmodule_string src_file =
  let src = string_of_file src_file
  in
  let ast =
    let lexbuf = Lexing.from_string src in 
    Parse.Parser.program Parse.Scanner.tokenize lexbuf 
  in
  let core_ast = Core.Conversion.convert ast 
  in
  Llvm.string_of_llmodule (Codegen.translate core_ast)


let rec read_input_string ic = 
  let str = input_line ic in
  str ^ "\n" ^ (try read_input_string ic with _ -> "")

let test () =
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
  let output = input_char ic in
  close_in ic; 
  try 
    assert (output = '0');
    print_endline "hello_world: Passing;"
  with _ -> 
    print_endline @@ "hello_world failure: " ^ "expected (output = 0) got (" ^ String.make 1 output ^ "= 0)"
