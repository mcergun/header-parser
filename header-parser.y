%{

#include <stdio.h>
#include <stdlib.h>
#include <iostream>

int yylex();
int yyparse();
FILE * yyin;
void yyerror(const char * s);

%}

%union
{
	long long ival;
	double fval;
	char * sval;
}

%token INCL_KEYW DEF_KEYW IFDEF_KEYW
%token LEFT_BRKT RIGHT_BRKT QUOTE

%token <ival> INT
%token <fval> FLOAT
%token <sval> STR

%%

include_dir: INCL_KEYW include_addr_local
	| INCL_KEYW include_addr_global
	;
include_addr_local: QUOTE STR QUOTE { std::cout << "include " << $2 << std::endl; }
	;
include_addr_global: LEFT_BRKT STR RIGHT_BRKT { std::cout << "include " << $2 << std::endl; }
	;

%%

void yyerror(const char *s)
{
	std::cout << "parse error" << s;
	exit(-1);
}