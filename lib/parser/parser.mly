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

data_def:
| DATA UID data_param_list WHERE cons_list { DataDef($2, $3, $5) }
| DATA UID WHERE cons_list                 { DataDef($2, [], $4) }

data_param_list:
| data_param { [$1] }
| data_param data_param_list { $1::$2 }
 
data_param:
| FORALL LID    { TypeParam($2) }
| FORALLM LID   { MultParam($2) }

cons_list:
| cons          { [$1] }
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
| lambda        { $1 } 
| infer_expr    { Infer($1) }

infer_expr:
| IF infer_expr THEN infer_expr ELSE infer_expr     { If($2, $4, $6) } 
| LPAREN check_expr COLON ty RPAREN                 { Ann($2, $4) }
| CASE infer_expr OF case_alts                      { Case($2, $4) }
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
| UNIT                          { Var("unit") } 
| LID                           { Var($1) }
| UID                           { Construction($1) }
| LITERAL                       { Lit($1) }
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
| app_ty arrow ty    { Arr($2, $1, $3) }
| app_ty             { $1 }
| mapp_ty            { $1 }

mapp_ty:
| mapp_ty FORALLM mult { InstM($1, $3) }
| app_ty FORALLM mult { InstM($1, $3) }

app_ty:
| atomic_ty app_ty    { Inst($1, $2) }
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

// Top Level Bindings and Data Declerations
// defs:
// | def { [$1] }
// | def defs { $1::$2 }

// def:
// | letstmt                                           { $1 }
// | datadef                                           { DataDef($1) }

// letstmt:
// | LET LID COLON ty ASSIGN expr SEMICOLON                { Def($2, [], $4, $6) } 
// | LET LID COLON mult ty ASSIGN expr SEMICOLON           { Def($2, [], $5, $7) }
// | LET LID params COLON mult ty ASSIGN expr SEMICOLON    { Def($2, $3, $6, $8) }
// | LET LID params COLON ty ASSIGN expr SEMICOLON         { Def($2, $3, $5, $7) }

// datadef:
// | DATA UID params WHERE conslist { DataType($2, $3, $5) }

// conslist:
// | cons          { [$1] }
// | cons conslist { $1::$2 }

// cons:
// | UID COLON ty SEMICOLON { Cons($1, $3) }

// // Expressions and Let Expressions

// expr:
// | BACKSLASH LPAREN LID COLON ty RPAREN arrow expr   { Lam($3, $7, $5, $8)}
// | SLASH LID DASH GT expr                            { TLam($2, $5) }
// | VBAR LID DASH GT expr                             { MLam($2, $5) }
// | IF expr THEN expr ELSE expr                       { If($2, $4, $6) } 
// | CASE expr OF casealts                             { Case($2, $4) }
// | NOT expr                                          { Unop(Not, $2) }
// | DASH expr %prec NOT                               { Unop(Neg, $2) }
// | binop                                             { $1 }
// | appterm                                           { $1 }
// | letexpr                                           { $1 }

// letexpr:
// | LET LID COLON mult ty ASSIGN expr IN expr         { Let($2, [], $4, $5, $7, $9) }
// | LET LID params COLON mult ty ASSIGN expr IN expr  { Let($2, $3, $5, $6, $8, $10) }
// | LET LID params COLON ty ASSIGN expr IN expr       { Let($2, $3, Unr, $5, $7, $9) }
// | LET LID COLON ty ASSIGN expr IN expr              { Let($2, [], Unr, $4, $6, $8) }

// // Case Statements

// casealts:
// | casealt           { [$1] }
// | casealt casealts  { $1::$2 }

// casealt:
// | UID lids DASH GT expr SEMICOLON   { Destructor($1, $2, $5) }
// | UID DASH GT expr SEMICOLON        { Destructor($1, [], $4) }
// | WILDCARD DASH GT expr SEMICOLON   { Wildcard($4) }

// // Lowercase ID list 

// lids:
// | LID               { [$1] }
// | LID lids          { $1::$2 }

// params:
// | param                 { [$1] }
// | param params          { $1::$2 }

// param:
// | LBRACE lids RBRACE     { TParam($2) }
// | VBAR lids VBAR         { MParam($2) }
// | LID                    { Param([$1]) }

// appterm:
// | atomicterm                { $1 }
// | appterm atomicterm        { App($1, $2) }
// | appterm VBAR multlist VBAR    { MApp($1, $3) }
// | appterm LBRACE tylist RBRACE  { TApp($1, $3) }

// atomicterm:
// | LPAREN expr RPAREN    { $2 }
// | UNIT                  { Var("unit") }
// | LID                   { Var($1) }
// | UID                   { Construction($1) }
// | LITERAL               { Lit($1) }
// | BOOL                  { Bool($1) }
// | CHAR                  { Char($1) }

// arrow:
// | DASH GT           { Unr }
// | DASH STAR         { One } 
// | DASH mult GT      { $2 } 

// // Multiplicites

// multlist:
// | mult { [$1] }
// | mult multlist { $1::$2 }

// mult:
// | LID               { MVar($1) }
// | MULT              { if ($1) then Unr else One }
// | mult STAR mult    { Times($1, $3) }

// // Types
// tylist:
// | ty { [$1] }
// | ty tylist { $1::$2 }


// ty:
// | FORALL LID ty             { Forall($2, $3)    }
// | FORALLM LID ty            { ForallM($2, $3)   }
// | appty arrow ty            { LamT($2, $1, $3)  }
// | appty                     { $1                }

// appty:
// | appty LBRACE tylist RBRACE   { Inst($1, $3)      }
// | appty VBAR multlist VBAR     { InstM($1, $3)     }
// | atomicty { $1 }

// // Atomic IDs

// atomicty:
// | UNIT              { TName "Unit"      }
// | LID               { TVar $1           }
// | UID               { TName $1          }
// | LPAREN ty RPAREN  { $2                }

// // Binary Operations

// binop:
// | bterm PLUS bterm  { Op($1, Plus, $3)  }
// | bterm DASH bterm  { Op($1, Minus, $3) }
// | bterm SLASH bterm { Op($1, Divide, $3)}
// | bterm STAR bterm  { Op($1, Times, $3) }
// | bterm OR bterm    { Op($1, Or, $3)    }
// | bterm AND bterm   { Op($1, And, $3)   }
// | bterm EQ bterm    { Op($1, Eq, $3)    }
// | bterm NEQ bterm   { Op($1, Ne, $3)    }
// | bterm LEQ bterm   { Op($1, Le, $3)    }
// | bterm GT bterm    { Op($1, Gt, $3)    }
// | bterm GEQ bterm   { Op($1, Ge, $3)    }

// bterm:
// | appterm           { $1 }
// | binop             { $1 }

// let compose {a b c} |p q| f g x : @a @b @c #p #q (b -p> c) -> (a -q> b) -> a -p*q> c = f (g x);
// let compose : Foo = compose {Int Int Int} |One One|
// let src = "let x : Bool = 1 == (\(x : Bool) -> true) 10;"