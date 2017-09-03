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

include_dir: INCL_KEYW QUOTED_STR
	| INCL_KEYW BRKTED_STR
	| INCL_KEYW QUOTED_STR useless_strings
	| INCL_KEYW BRKTED_STR useless_strings
		{ std::cout << "include_dir" << std::endl; }
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
	| error
		{ std::cout << "useless_string" << std::endl; }
	;

%%

void yyerror(const char *s)
{
	std::cout << "parse error:\r\n\t" << s << std::endl;
	return;
}