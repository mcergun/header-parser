%{

#include "header-parser.tab.h"
#include <iostream>

%}

%option noyywrap

%%
[ \t\r\n]	;
\/\/.*	;	// line comment
\/\*(.|\r|\r\n|\n)*\*\/	;	// block comment
\<	{ return LEFT_BRKT; }
\>	{ return RIGHT_BRKT; }
\"	{ return QUOTE; }
\#include	{ return INCL_KEYW; }
[a-zA-Z0-9./\\:]+	{ yylval.sval = _strdup(yytext); return STR;}
.	;

%%