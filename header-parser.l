%{

#include "header-parser.tab.h"

%}

%option noyywrap

%%

[#a-zA-Z0-9]+	;
\<	{ return LEFT_BRKT; }
\>	{ return RIGHT_BRKT; }
\"	{ return QUOTE; }
\#include[\ \t]+	{ return INCL_KEYW; }
\/\/.*	;	// line comment
\/\*(.|\r|\r\n|\n)*\*\/	;	// block comment

%%