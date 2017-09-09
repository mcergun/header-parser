%{

#include <stdio.h>
#include <stdlib.h>
#include <iostream>

int yylex();
int yyparse();
void yyerror(const char * s);

extern int line_num;

%}

%error-verbose

%union
{
        long long ival;
        double fval;
        char sval[256];
}

%token SYM_QUO SYM_LTN SYM_GTN SYM_PRL SYM_PRR SYM_CRL SYM_CRR
%token SYM_ADD SYM_MIN SYM_MUL SYM_DIV SYM_ESC

%token KW_INCL KW_DEFN KW_IFDF KW_ELIF KW_ENDF KW_ELSE KW_IFST

%token <ival> INT
%token <fval> FLOAT
%token <sval> STR_IDE
%token <sval> STR_FIL
%token <sval> STR_LIT

%%

file: line
        | file line
        ;

line: useless_strings
        ;
useless_strings: useless_strings useless_string
        | useless_string
                { std::cout << "useless_strings" << std::endl; }
        ;
useless_string:
        | error
                { std::cout << "useless_string" << std::endl; }
        ;

%%

void yyerror(const char *s)
{
        std::cout << "parse error:\r\n\t L" << line_num << " " << s << std::endl;
        return;
}