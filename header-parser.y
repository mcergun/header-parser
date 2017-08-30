%{

#include <stdio.h>
#include <stdlib.h>
#include <iostream>

int yylex();
int yyparse();
void yyerror(const char * s);

%}

%union
{
	long long ival;
	double fval;
	char * sval;
}

%token INCL_KEYW DEF_KEYW IFDEF_KEYW
%token HASHTAG LEFT_BRKT RIGHT_BRKT QUOTE

%token <ival> INT
%token <fval> FLOAT
%token <sval> STR

%%

include_dirs: include_dirs include_dir
	| include_dir
	;

include_dir: INCL_KEYW include_addr_local
	| INCL_KEYW include_addr_global
	| INCL_KEYW include_addr_local useless_strings
	| INCL_KEYW include_addr_global useless_strings
	;
include_addr_local: QUOTE STR QUOTE { std::cout << "include_addr_local " << $2 << std::endl; }
	;
include_addr_global: LEFT_BRKT STR RIGHT_BRKT { std::cout << "include_addr_global " << $2 << std::endl; }
	;
useless_strings: useless_strings useless_string
	| useless_string
		{ std::cout << "useless_strings" << std::endl; }
	;
useless_string: STR
	| QUOTE
	| LEFT_BRKT
	| RIGHT_BRKT
	| LEFT_BRKT
	;

%%

void yyerror(const char *s)
{
	std::cout << "parse error" << s;
	return;
}