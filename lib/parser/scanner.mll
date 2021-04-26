(* 
Authors: Ben, Sophia, Jay
Ocamllex Scanner *)

{ open Parser }
let digit = ['0'-'9']
let digits = digit+
let lchar = ['a'-'z']
let uchar = ['A'-'Z']
let schar = [ ^ '"' ]
let cchar = [ ^ '\'' ]

rule tokenize = parse
  [' ' '\t' '\r' '\n']                  { tokenize lexbuf }
| "(*"                                  { comment lexbuf }
| "!="                                  { NEQ }
| "<="                                  { LEQ }
| '<'                                   { LT }
| ">="                                  { GEQ }
| '>'                                   { GT }
| "=="                                  { EQ }
| '='                                   { ASSIGN }
| "||"                                  { OR }
| "&&"                                  { AND }
| "!"                                   { NOT }
| "()"                                  { UNIT }
| ':'                                   { COLON }
| ';'                                   { SEMICOLON }
| '_'                                   { WILDCARD }
| '\\'                                  { BACKSLASH }
| '`'                                   { BACKTICK }
| '.'                                   { DOT }
| '('                                   { LPAREN }
| ')'                                   { RPAREN }
| '@'                                   { FORALL }
| '#'                                   { FORALLM }
| '+'                                   { PLUS }
| '-'                                   { DASH }
| '*'                                   { STAR }
| '/'                                   { SLASH }
| "if"                                  { IF }
| "then"                                { THEN }
| "else"                                { ELSE }
| "let"                                 { LET }
| "in"                                  { IN }
| "of"                                  { OF }
| "data"                                { DATA }
| "case"                                { CASE }
| "where"                               { WHERE }
| "true"                                { BOOL(true) }
| "false"                               { BOOL(false) }
| "Unr"                                 { UNR }
| "One"                                 { ONE }
| digits as lxm                         { LITERAL(int_of_string lxm) }
| '"' ((schar*) as lxm) '"'             { STRING (lxm) } 
| '\'' (cchar as lxm) '\'' 
                                        { CHAR(lxm) }
| '\'' ((cchar*) as lxm) '\''           { CHAR(String.get (Scanf.unescaped lxm) 0) }
| lchar+ (digit | lchar | uchar | '_')* ('\'')* as lxm    
                                        { LID(String.map (fun x -> if x = '\'' then '-' else x) lxm) }
| uchar+ (digit | lchar | uchar | '_')* ('\'')* as lxm    
                                        { UID(String.map (fun x -> if x = '\'' then '-' else x) lxm) }
| eof                                   { EOF }
| _ as char { raise (Failure("illegal character " ^ Char.escaped char ))}

and comment = parse
  "*)"  { tokenize lexbuf }
| _     { comment lexbuf }