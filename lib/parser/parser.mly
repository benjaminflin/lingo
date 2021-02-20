%{ 
open Ast 
%}

%token VBAR COLON COMMA WILDCARD BACKSLASH LPAREN RPAREN LBRACE RBRACE 
%token PLUS DASH STAR SLASH ASSIGN EQ NEQ LT 
%token LEQ GT GEQ IF THEN ELSE LET IN OF DATA CASE WHERE 

%token <int> LITERAL
%token <bool> BOOL MULT
%token <string> UID LID

%token EOF

%left PLUS DASH
%left STAR SLASH

%nonassoc LET LPAREN BACKSLASH VBAR IF LITERAL BOOL LID
%nonassoc APP

%start ty
%type <Ast.ty> ty

%%

// expr:
// // | LPAREN expr RPAREN { $2 }
// // | LET LID COLON mult ty ASSIGN expr IN expr { Let($2, $4, $5, $7, $9) }
// // | LET LID COLON ty ASSIGN expr IN expr { Let($2, Unr, $4, $6, $8) }
// | BACKSLASH LID COLON ty arrow expr { Lam($2, $5, $4, $6) }
// // | VBAR LID DASH GT expr { MLam($2, $5) }
// // | expr VBAR mult VBAR { MApp($1, $3) }
// // | SLASH LID DASH GT expr { TLam($2, $5) }
// // | expr LBRACE ty RBRACE { TApp($1, $3) }
// // | IF expr THEN expr ELSE expr { If($2, $4, $6) }
// | expr expr %prec APP { App($1, $2) }
// // | binop { $1 }
// | LITERAL { Lit($1) }
// | BOOL { Bool($1) }
// | LID { Var($1) }

arrow:
| DASH GT { Unr }
| DASH STAR { One } 
| DASH mult GT { $2 } 

mult:
| LID { MVar($1) }
| MULT { if ($1) then Unr else One }
| mult STAR mult { Times($1, $3) }

ty:
| LPAREN ty RPAREN { $2 }
| ty arrow ty_r { LamT($2, $1, $3) }
| LID { TVar $1 }
| UID { TName $1 }

ty_r:
| LPAREN ty_r RPAREN { $2 }
| LID { TVar $1 }
| UID { TName $1 }

// binop:
// | expr PLUS expr { Op($1, Plus, $3) }
// | expr DASH expr { Op($1, Minus, $3) }
// | expr SLASH expr { Op($1, Divide, $3) }
// | expr STAR expr { Op($1, Times, $3) }