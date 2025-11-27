#include <stdio.h>
#include <stdlib.h>
#include "lang.h"

extern int yyparse();
extern FILE *yyin;
extern struct full_annotated_cmd *parsed_program;

void print_expr_int(struct expr_int *e, int indent);
void print_expr_bool(struct expr_bool *e, int indent);
void print_cmd(struct cmd *c, int indent);
void print_indent(int indent);

void print_indent(int indent) {
    for (int i = 0; i < indent; i++) {
        printf("  ");
    }
}

void print_expr_int(struct expr_int *e, int indent) {
    if (e == NULL) {
        printf("NULL");
        return;
    }

    switch (e->t) {
        case T_CONST:
            printf("%u", e->d.CONST.value);
            break;
        case T_VAR:
            printf("%s", e->d.VAR.name);
            break;
        case T_BINOP:
            printf("(");
            print_expr_int(e->d.BINOP.left, 0);
            switch (e->d.BINOP.op) {
                case T_PLUS: printf(" + "); break;
                case T_MINUS: printf(" - "); break;
                case T_MUL: printf(" * "); break;
            }
            print_expr_int(e->d.BINOP.right, 0);
            printf(")");
            break;
    }
}

void print_expr_bool(struct expr_bool *e, int indent) {
    if (e == NULL) {
        printf("NULL");
        return;
    }

    switch (e->t) {
        case T_TRUE:
            printf("true");
            break;
        case T_FALSE:
            printf("false");
            break;
        case T_CMP:
            printf("(");
            print_expr_int(e->d.CMP.left, 0);
            switch (e->d.CMP.op) {
                case T_LT: printf(" < "); break;
                case T_GT: printf(" > "); break;
                case T_LE: printf(" <= "); break;
                case T_GE: printf(" >= "); break;
                case T_EQ: printf(" == "); break;
                case T_NE: printf(" != "); break;
            }
            print_expr_int(e->d.CMP.right, 0);
            printf(")");
            break;
        case T_PROP_BINOP:
            printf("(");
            print_expr_bool(e->d.PROP_BINOP.left, 0);
            switch (e->d.PROP_BINOP.op) {
                case T_AND: printf(" && "); break;
                case T_OR: printf(" || "); break;
                case T_IMPLY: printf(" => "); break;
                case T_IFF: printf(" <=> "); break;
            }
            print_expr_bool(e->d.PROP_BINOP.right, 0);
            printf(")");
            break;
        case T_PROP_UNOP:
            printf("!");
            print_expr_bool(e->d.PROP_UNOP.arg, 0);
            break;
        case T_QUANT:
            switch (e->d.QUANT.op) {
                case T_FORALL: printf("forall "); break;
                case T_EXISTS: printf("exists "); break;
            }
            printf("%s (", e->d.QUANT.name);
            print_expr_bool(e->d.QUANT.arg, 0);
            printf(")");
            break;
    }
}

void print_cmd(struct cmd *c, int indent) {
    if (c == NULL) {
        printf("NULL");
        return;
    }

    switch (c->t) {
        case T_ASGN:
            print_indent(indent);
            printf("%s = ", c->d.ASGN.left);
            print_expr_int(c->d.ASGN.right, 0);
            printf(";\n");
            break;
        case T_SKIP:
            print_indent(indent);
            printf("skip;\n");
            break;
        case T_SEQ:
            print_cmd(c->d.SEQ.left, indent);
            print_cmd(c->d.SEQ.right, indent);
            break;
        case T_IF:
            print_indent(indent);
            printf("if (");
            print_expr_bool(c->d.IF.cond, 0);
            printf(") {\n");
            print_cmd(c->d.IF.left, indent + 1);
            print_indent(indent);
            printf("} else {\n");
            print_cmd(c->d.IF.right, indent + 1);
            print_indent(indent);
            printf("}\n");
            break;
        case T_WHILE:
            print_indent(indent);
            printf("inv ");
            print_expr_bool(c->d.WHILE.inv, 0);
            printf("\n");
            print_indent(indent);
            printf("while (");
            print_expr_bool(c->d.WHILE.cond, 0);
            printf(") {\n");
            print_cmd(c->d.WHILE.body, indent + 1);
            print_indent(indent);
            printf("}\n");
            break;
    }
}

int main(int argc, char **argv) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            fprintf(stderr, "Error: Cannot open file %s\n", argv[1]);
            return 1;
        }
        printf("Parsing file: %s\n", argv[1]);
    } else {
        printf("Reading from stdin (Ctrl+D or Ctrl+Z to end input):\n");
        yyin = stdin;
    }

    int result = yyparse();

    if (result == 0 && parsed_program != NULL) {
        printf("\n=== Parsed Program AST ===\n\n");
        printf("REQUIRE: ");
        print_expr_bool(parsed_program->require, 0);
        printf("\n\nENSURE: ");
        print_expr_bool(parsed_program->ensure, 0);
        printf("\n\nCOMMAND:\n");
        print_cmd(&parsed_program->c, 0);
        printf("\n=== End of AST ===\n");
    } else if (result != 0) {
        fprintf(stderr, "Parsing failed with error code %d\n", result);
        return 1;
    }

    if (argc > 1) {
        fclose(yyin);
    }

    return 0;
}
