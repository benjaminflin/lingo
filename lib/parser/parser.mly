%{ open Ast %}

%token VBAR COLON COMMA WILDCARD BACKSLASH LPAREN RPAREN LBRACE RBRACE 
%token PLUS DASH STAR SLASH ASSIGN EQ NEQ LT 
%token LEQ GT GEQ IF THEN ELSE LET IN OF DATA CASE WHERE 

%token <int> LITERAL
%token <bool> BOOL MULT
%token <string> UID LID

%token EOF

%left PLUS MINUS
%left TIMES DIVIDE

%start expr
%type <Ast.expr> expr

%%

expr:
  expr PLUS   expr { Binop($1, Add, $3) }
| expr DASH   expr { Binop($1, Sub, $3) }
| expr TIMES  expr { Binop($1, Mul, $3) }
| expr SLASH  expr { Binop($1, Div, $3) }
| LITERAL          { Lit($1) }
