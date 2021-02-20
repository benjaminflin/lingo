%{ 
open Ast 
%}

%token VBAR COLON SEMICOLON WILDCARD BACKSLASH LPAREN RPAREN LBRACE RBRACE UNIT
%token PLUS DASH STAR SLASH ASSIGN EQ NEQ LT LEQ GT GEQ OR AND NOT
%token IF THEN ELSE LET IN OF DATA CASE WHERE FORALL FORALLM

%token <int> LITERAL
%token <bool> BOOL MULT
%token <string> UID LID
%token <char> CHAR

%token EOF

%left OR
%left AND
%left EQ NEQ
%left LT GT LEQ GEQ
%left PLUS DASH
%left STAR SLASH
%right NOT

%start defs
%type <Ast.defs> defs

%%

defs:
| def { [$1] }
| def defs { $1::$2 }

def:
| LET LID COLON ty ASSIGN expr { Def($2, $4, $6) } 
| datadef { DataDef($1) }

datadef:
| DATA UID params WHERE conslist { DataType($2, $3, $5) }

conslist:
| cons { [$1] }
| cons conslist { $1::$2 }

cons:
| UID COLON ty SEMICOLON { Cons($1, $3) }

expr:
| BACKSLASH LPAREN LID COLON ty RPAREN arrow expr   { Lam($3, $7, $5, $8)}
| SLASH LID DASH GT expr                            { TLam($2, $5) }
| VBAR LID DASH GT expr                             { MLam($2, $5) }
| LET LID COLON mult ty ASSIGN expr IN expr         { Let($2, [], $4, $5, $7, $9) }
| LET LID params COLON mult ty ASSIGN expr IN expr  { Let($2, $3, $5, $6, $8, $10) }
| LET LID params COLON ty ASSIGN expr IN expr       { Let($2, $3, Unr, $5, $7, $9) }
| LET LID COLON ty ASSIGN expr IN expr              { Let($2, [], Unr, $4, $6, $8) }
| IF expr THEN expr ELSE expr                       { If($2, $4, $6) } 
| CASE expr OF casealts                             { Case($2, $4) }
| NOT expr                                          { Unop(Not, $2) }
| DASH expr %prec NOT                               { Unop(Neg, $2) }
| binop                                             { $1 }
| appterm                                           { $1 }

casealts:
| casealt { [$1] }
| casealt casealts { $1::$2 }

casealt:
| UID caseparams DASH GT expr SEMICOLON  { Constructor($1, $2, $5) }
| WILDCARD DASH GT expr SEMICOLON        { Wildcard($4) }

caseparams:
| LID { [$1] }
| LID caseparams { $1::$2 }


params:
| param { [$1] }
| param params { $1::$2 }

param:
| LBRACE LID RBRACE { TParam($2) }
| VBAR LID VBAR { MParam($2) }
| LID { Param($1) }

appterm:
| atomicterm                { $1 }
| appterm atomicterm        { App($1, $2) }
| appterm VBAR mult VBAR    { MApp($1, $3) }
| appterm LBRACE ty RBRACE  { TApp($1, $3) }

atomicterm:
| LPAREN expr RPAREN    { $2 }
| LID                   { Var($1) }
| LITERAL               { Lit($1) }
| BOOL                  { Bool($1) }
| CHAR                  { Char($1) }

arrow:
| DASH GT           { Unr }
| DASH STAR         { One } 
| DASH mult GT      { $2 } 

mult:
| LID               { MVar($1) }
| MULT              { if ($1) then Unr else One }
| mult STAR mult    { Times($1, $3) }

ty:
| LPAREN ty RPAREN  { $2 }
| UNIT { TName "Unit" }
| FORALL LID ty { Forall($2, $3) }
| FORALLM LID ty { ForallM($2, $3) }
| atomicty arrow ty { LamT($2, $1, $3) }
| LID               { TVar $1 }
| UID               { TName $1 }

atomicty:
| LID               { TVar $1 }
| UID               { TName $1 }

binop:
| bterm PLUS bterm  { Op($1, Plus, $3) }
| bterm DASH bterm  { Op($1, Minus, $3) }
| bterm SLASH bterm { Op($1, Divide, $3) }
| bterm STAR bterm  { Op($1, Times, $3) }
| bterm OR bterm  { Op($1, Times, $3) }
| bterm AND bterm  { Op($1, Times, $3) }
| bterm EQ bterm  { Op($1, Times, $3) }
| bterm NEQ bterm  { Op($1, Times, $3) }
| bterm LEQ bterm  { Op($1, Times, $3) }
| bterm GT bterm  { Op($1, Times, $3) }
| bterm GEQ bterm  { Op($1, Times, $3) }

bterm:
| appterm           { $1 }
| binop             { $1 }