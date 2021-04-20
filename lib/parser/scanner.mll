(* Ocamllex Scannner *)

{ open Parser }
let digit = ['0'-'9']
let digits = digit+
let lchar = ['a'-'z']
let uchar = ['A'-'Z']

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
| '\'' ("\\0") '\'' 
                                        { CHAR(char_of_int 0) }
| '\'' ((digit | lchar | uchar) as lxm) '\''   
                                        { CHAR(lxm) }
| lchar+ (digit | lchar | uchar | '_')* ('\'')* as lxm    
                                        { LID(lxm) }
| uchar+ (digit | lchar | uchar | '_')* ('\'')* as lxm    
                                        { UID(lxm) }
| eof                                   { EOF }
| _ as char { raise (Failure("illegal character " ^ Char.escaped char ))}

and comment = parse
  "*)"  { tokenize lexbuf }
| _     { comment lexbuf }