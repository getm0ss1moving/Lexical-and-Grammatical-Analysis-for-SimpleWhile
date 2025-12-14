%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "lang.h"

extern int yylex();
extern int line_num;
extern FILE *yyin;

void yyerror(const char *s);

struct full_annotated_cmd *parsed_program = NULL;
%}

%union {
    int num;
    char *str;
    struct expr_int *expr_int_val;
    struct expr_bool *expr_bool_val;
    struct cmd *cmd_val;
    struct full_annotated_cmd *program_val;
}

%token <num> NUM
%token <str> IDENT
%token REQUIRE ENSURE INV WHILE IF ELSE SKIP TRUE FALSE FORALL EXISTS
%token PLUS MINUS MUL
%token LT GT LE GE EQ NE
%token AND OR IMPLY IFF NOT
%token ASSIGN SEMI LPAREN RPAREN LBRACE RBRACE

%type <expr_int_val> expr_int term factor
%type <expr_bool_val> expr_bool atomic_bool quant_bool
%type <cmd_val> cmd simple_cmd
%type <program_val> program

%right FORALL EXISTS
%left IFF
%left IMPLY
%left OR
%left AND
%right NOT
%left LT GT LE GE EQ NE
%left PLUS MINUS
%left MUL

%%

program:
    REQUIRE expr_bool ENSURE expr_bool cmd {
        $$ = (struct full_annotated_cmd *)malloc(sizeof(struct full_annotated_cmd));
        if ($$ == NULL) {
            fprintf(stderr, "Memory allocation failed\n");
            exit(1);
        }
        $$->require = $2;
        $$->ensure = $4;
        $$->c = *$5;
        parsed_program = $$;
        printf("Successfully parsed annotated SimpleWhile program\n");
    }
    ;

cmd:
    simple_cmd {
        $$ = $1;
    }
    | cmd SEMI cmd {
        $$ = TSeq($1, $3);
    }
    ;

simple_cmd:
    IDENT ASSIGN expr_int {
        $$ = TAsgn($1, $3);
    }
    | SKIP {
        $$ = TSkip();
    }
    | IF LPAREN expr_bool RPAREN LBRACE cmd RBRACE ELSE LBRACE cmd RBRACE {
        $$ = TIf($3, $6, $10);
    }
    | INV expr_bool WHILE LPAREN expr_bool RPAREN LBRACE cmd RBRACE {
        $$ = TWhile($2, $5, $8);
    }
    | LBRACE cmd RBRACE {
        $$ = $2;
    }
    ;

expr_int:
    term {
        $$ = $1;
    }
    | expr_int PLUS term {
        $$ = TBinOp(T_PLUS, $1, $3);
    }
    | expr_int MINUS term {
        $$ = TBinOp(T_MINUS, $1, $3);
    }
    ;

term:
    factor {
        $$ = $1;
    }
    | term MUL factor {
        $$ = TBinOp(T_MUL, $1, $3);
    }
    ;

factor:
    NUM {
        $$ = TConst($1);
    }
    | IDENT {
        $$ = TVar($1);
    }
    | LPAREN expr_int RPAREN {
        $$ = $2;
    }
    ;

expr_bool:
    atomic_bool {
        $$ = $1;
    }
    | quant_bool {
        $$ = $1;
    }
    | expr_bool AND expr_bool {
        $$ = TPropBinOp(T_AND, $1, $3);
    }
    | expr_bool OR expr_bool {
        $$ = TPropBinOp(T_OR, $1, $3);
    }
    | expr_bool IMPLY expr_bool {
        $$ = TPropBinOp(T_IMPLY, $1, $3);
    }
    | expr_bool IFF expr_bool {
        $$ = TPropBinOp(T_IFF, $1, $3);
    }
    | NOT expr_bool {
        $$ = TPropUnOp(T_NOT, $2);
    }
    | LPAREN expr_bool RPAREN {
        $$ = $2;
    }
    ;

atomic_bool:
    TRUE {
        $$ = TTrue();
    }
    | FALSE {
        $$ = TFalse();
    }
    | expr_int LT expr_int {
        $$ = TCmp(T_LT, $1, $3);
    }
    | expr_int GT expr_int {
        $$ = TCmp(T_GT, $1, $3);
    }
    | expr_int LE expr_int {
        $$ = TCmp(T_LE, $1, $3);
    }
    | expr_int GE expr_int {
        $$ = TCmp(T_GE, $1, $3);
    }
    | expr_int EQ expr_int {
        $$ = TCmp(T_EQ, $1, $3);
    }
    | expr_int NE expr_int {
        $$ = TCmp(T_NE, $1, $3);
    }
    ;

quant_bool:
    FORALL IDENT expr_bool {
        $$ = TQuant(T_FORALL, $2, $3);
    }
    | EXISTS IDENT expr_bool {
        $$ = TQuant(T_EXISTS, $2, $3);
    }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Parse error at line %d: %s\n", line_num, s);
}
