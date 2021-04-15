%{ 
open Ast 
%}

%token COLON SEMICOLON WILDCARD BACKSLASH LPAREN RPAREN UNIT BACKTICK DOT
%token PLUS DASH STAR SLASH ASSIGN EQ NEQ LT LEQ GT GEQ OR AND NOT
%token IF THEN ELSE LET IN OF DATA CASE WHERE FORALL FORALLM
%token UNR ONE

%token <int>    LITERAL
%token <bool>   BOOL 
%token <string> UID LID
%token <char>   CHAR

%token  EOF

%left   OR
%left   AND
%left   EQ NEQ
%left   LT GT LEQ GEQ
%left   PLUS DASH
%left   STAR SLASH
%right  NOT

%start  program
%type   <Ast.program> program

%%

program:
| def { [$1] }
| def program { $1::$2 }

def:
| let_def { $1 }
| data_def { $1 }
| let_decl { $1 } 

let_decl: 
| LID COLON ty SEMICOLON          { LetDecl($1, $3) }

data_def:
| DATA UID data_param_list WHERE cons_list { DataDef($2, $3, $5) }
| DATA UID WHERE cons_list                 { DataDef($2, [], $4) }

data_param_list:
| data_param { [$1] }
| data_param data_param_list { $1::$2 }
 
data_param:
| FORALL LID    { TypeParam($2) }
| LID           { TypeParam($1) }
| FORALLM LID   { MultParam($2) }

cons_list:
|                { [] }
| cons cons_list { $1::$2 }

cons:
| UID COLON ty SEMICOLON { Cons($1, $3) }

let_def:
| LID COLON ty ASSIGN check_expr SEMICOLON           { LetDef($1, [], $3, $5) }
| LID name_list COLON ty ASSIGN check_expr SEMICOLON { LetDef($1, $2, $4, $6) }

lambda:
| BACKSLASH LID DOT check_expr                { Lam($2, $4) } 
| LPAREN lambda RPAREN                        { $2 } 

check_expr:
| lambda                                            { $1 } 
| CASE infer_expr OF case_alts                      { Case($2, $4) }
| infer_expr                                        { Infer($1) }

infer_expr:
| IF infer_expr THEN infer_expr ELSE infer_expr     { If($2, $4, $6) } 
| LPAREN check_expr COLON ty RPAREN                 { Ann($2, $4) }
| NOT infer_expr                                    { App(Unop(Not), Infer($2)) }
| DASH infer_expr %prec NOT                         { App(Unop(Neg), Infer($2)) }
| app_term                                          { $1 }
| let_expr                                          { $1 }
| bin_operation                                     { $1 } 
| app_term lambda                                   { App($1, $2) }
| app_term BACKTICK LID BACKTICK app_term           { App(App(Var($3), Infer($1)), Infer($5)) }

let_expr:
| LET mult LID COLON ty ASSIGN check_expr IN infer_expr                { Let($3, $2, $5, $7, $9) }
| LET LID COLON ty ASSIGN check_expr IN infer_expr                     { Let($2, Unr, $4, $6, $8) }

app_term:
| atomic_term                                       { $1 }
| app_term atomic_term                              { App($1, Infer($2)) }

atomic_term:
| LPAREN infer_expr RPAREN      { $2 }
| UNIT                          { Construction("unit") } 
| LID                           { Var($1) }
| UID                           { Construction($1) }
| LITERAL                       { Int($1) }
| BOOL                          { Bool($1) }
| CHAR                          { Char($1) }
| FORALL atomic_ty              { Type($2) } 
| FORALLM atomic_mult           { Mult($2) }

case_alts:
| case_alt           { [$1] }
| case_alt case_alts  { $1::$2 }

case_alt:
| UID name_list DASH GT infer_expr SEMICOLON   { Destructor($1, $2, $5) }
| UID DASH GT infer_expr SEMICOLON             { Destructor($1, [], $4) }
| WILDCARD DASH GT infer_expr SEMICOLON        { Wildcard($4) }

bin_operation:
| bterm PLUS bterm      { App(App(Binop(Plus), Infer($1)), Infer($3)) }
| bterm DASH bterm      { App(App(Binop(Minus), Infer($1)), Infer($3)) }
| bterm SLASH bterm     { App(App(Binop(Divide), Infer($1)), Infer($3)) }
| bterm STAR bterm      { App(App(Binop(Times), Infer($1)), Infer($3)) }
| bterm OR bterm        { App(App(Binop(Or), Infer($1)), Infer($3)) }
| bterm AND bterm       { App(App(Binop(And), Infer($1)), Infer($3)) }
| bterm EQ bterm        { App(App(Binop(Eq), Infer($1)), Infer($3)) }
| bterm NEQ bterm       { App(App(Binop(Neq), Infer($1)), Infer($3)) }
| bterm LEQ bterm       { App(App(Binop(Leq), Infer($1)), Infer($3)) }
| bterm GT bterm        { App(App(Binop(Gt), Infer($1)), Infer($3)) }
| bterm GEQ bterm       { App(App(Binop(Geq), Infer($1)), Infer($3)) }


bterm:
| app_term           { $1 }
| bin_operation      { $1 }

ty:
| FORALL LID ty      { Forall($2, $3) }
| FORALLM LID ty     { ForallM($2, $3) }
| mapp_ty arrow ty   { Arr($2, $1, $3) }
| mapp_ty            { $1 }

mapp_ty:
| mapp_ty FORALLM mult { InstM($1, $3) }
| mapp_ty FORALL atomic_ty { Inst($1, $3) }
| app_ty { $1 }

app_ty:
| app_ty atomic_ty    { Inst($1, $2) }
| atomic_ty           { $1 }

atomic_ty:
| UNIT { TName "Unit" }
| LID { TVar $1 }
| UID { TName $1 }
| LPAREN ty RPAREN  { $2 }

arrow:
| DASH GT { Unr }
| DASH STAR { One } 
| DASH mult GT { $2 } 

mult:
| atomic_mult STAR atomic_mult  { MTimes($1, $3) }
| atomic_mult                   { $1 }

atomic_mult:
| LPAREN mult RPAREN { $2 }
| LID { MVar($1) }
| UNR { Unr } 
| ONE { One } 

name_list:
| LID { [$1] } 
| LID name_list { $1::$2 } 
