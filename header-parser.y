%{

#include <stdio.h>
#include <stdlib.h>
#include <iostream>

int yylex();
int yyparse();
void yyerror(const char * s);

%}

%error-verbose

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
%token <sval> QUOTED_STR
%token <sval> BRKTED_STR

%%

file: line
	| file line
	;

line: include_dir
	| useless_strings
	;

include_dir: INCL_KEYW address
	| INCL_KEYW address useless_strings
		{ std::cout << "include_dir" << std::endl; }
	;
address: BRKTED_STR
	| QUOTED_STR
		{ std::cout << "address " << $1 << std::endl; }
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
	std::cout << "parse error:\r\n\t" << s << std::endl;
	return;
}