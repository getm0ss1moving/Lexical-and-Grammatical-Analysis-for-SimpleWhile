
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     NUM = 258,
     IDENT = 259,
     REQUIRE = 260,
     ENSURE = 261,
     INV = 262,
     WHILE = 263,
     IF = 264,
     ELSE = 265,
     SKIP = 266,
     TRUE = 267,
     FALSE = 268,
     FORALL = 269,
     EXISTS = 270,
     PLUS = 271,
     MINUS = 272,
     MUL = 273,
     LT = 274,
     GT = 275,
     LE = 276,
     GE = 277,
     EQ = 278,
     NE = 279,
     AND = 280,
     OR = 281,
     IMPLY = 282,
     IFF = 283,
     NOT = 284,
     ASSIGN = 285,
     SEMI = 286,
     LPAREN = 287,
     RPAREN = 288,
     LBRACE = 289,
     RBRACE = 290
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 16 "parser.y"

    int num;
    char *str;
    struct expr_int *expr_int_val;
    struct expr_bool *expr_bool_val;
    struct cmd *cmd_val;
    struct full_annotated_cmd *program_val;



/* Line 1676 of yacc.c  */
#line 98 "parser.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


