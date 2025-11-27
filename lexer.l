%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "lang.h"
#include "parser.tab.h"

int line_num = 1;
%}

%option noyywrap

%%

"require"       { return REQUIRE; }
"ensure"        { return ENSURE; }
"inv"           { return INV; }
"while"         { return WHILE; }
"if"            { return IF; }
"else"          { return ELSE; }
"skip"          { return SKIP; }
"true"          { return TRUE; }
"false"         { return FALSE; }
"forall"        { return FORALL; }
"exists"        { return EXISTS; }

[a-zA-Z_][a-zA-Z0-9_]*  {
    yylval.str = strdup(yytext);
    return IDENT;
}

[0-9]+          {
    yylval.num = atoi(yytext);
    return NUM;
}

"+"             { return PLUS; }
"-"             { return MINUS; }
"*"             { return MUL; }

"<="            { return LE; }
">="            { return GE; }
"<"             { return LT; }
">"             { return GT; }
"=="            { return EQ; }
"!="            { return NE; }

"&&"            { return AND; }
"||"            { return OR; }
"=>"            { return IMPLY; }
"<=>"           { return IFF; }
"!"             { return NOT; }

"="             { return ASSIGN; }
";"             { return SEMI; }
"("             { return LPAREN; }
")"             { return RPAREN; }
"{"             { return LBRACE; }
"}"             { return RBRACE; }

[ \t\r]+        { /* ignore whitespace and carriage returns */ }
\n              { line_num++; }
"//".*          { /* ignore single-line comments */ }
"/*"([^*]|\*+[^*/])*\*+"/"  {
    /* ignore multi-line comments */
    for (int i = 0; i < yyleng; i++) {
        if (yytext[i] == '\n') line_num++;
    }
}

.               {
    fprintf(stderr, "Unknown character: %s at line %d\n", yytext, line_num);
    return yytext[0];
}

%%
