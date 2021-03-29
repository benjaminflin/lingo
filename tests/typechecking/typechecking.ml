let src_files = 
  [ "./tests/typechecking/ord.lingo"
  ; "./tests/typechecking/gadt_eq.lingo" 
  ; "./tests/typechecking/gadt_list.lingo"
  ; "./tests/typechecking/maybe.lingo"
  ]

let string_of_file file = 
  let ic = open_in file in
  let str = really_input_string ic (in_channel_length ic) in
  close_in ic;
  str


let test () =
  let srcs = List.map string_of_file src_files in
  let ast src =
    let lexbuf = Lexing.from_string src in
    let ast' = Parse.Parser.program Parse.Scanner.tokenize lexbuf in 
    Core.Conversion.convert ast'
  in
  let asts = List.map ast srcs in
  let test_each (src_file, prog) = 
    let paths = String.split_on_char '/' src_file in
    let src_file = List.nth paths ((List.length paths) - 1) in
    try
      ignore (Core.Typecheck.check_prog prog);
      print_endline @@ src_file ^ ": Passing;"
    with 
      exn -> 
        print_endline @@ src_file ^ ": Failed ->\n\t" ^ Printexc.to_string exn ^ ";";
  in
  List.iter test_each (List.combine src_files asts) 