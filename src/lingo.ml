
let src = "main : () = printInt 0;"

let ast =
  let lexbuf = Lexing.from_string src in 
  Parse.Parser.program Parse.Scanner.tokenize lexbuf 

let core_ast = Core.Conversion.convert ast

let _ =
  print_string @@ Llvm.string_of_llmodule (Codegen.translate core_ast)
