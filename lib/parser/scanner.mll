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
| '|'                                   { VBAR }
| "()"                                  { UNIT }
| ':'                                   { COLON }
| ';'                                   { SEMICOLON }
| '_'                                   { WILDCARD }
| '\\'                                  { BACKSLASH }
| '('                                   { LPAREN }
| ')'                                   { RPAREN }
| '@'                                   { FORALL }
| '#'                                   { FORALLM }
| '{'                                   { LBRACE }
| '}'                                   { RBRACE }
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
| "Unr"                                 { MULT(true) }
| "One"                                 { MULT(false) }
| digits as lxm                         { LITERAL(int_of_string lxm) }
| lchar+ (digit | lchar | uchar)* ('\'')? as lxm    
                                        { LID(lxm) }
| uchar+ (digit | lchar | uchar)* ('\'')? as lxm    
                                        { UID(lxm) }
| '\'' ((lchar | uchar) as lxm) '\''    { CHAR(lxm) }
| eof                                   { EOF }
| _ as char { raise (Failure("illegal character " ^ Char.escaped char ))}

and comment = parse
  "*)"  { tokenize lexbuf }
| _     { comment lexbuf }
