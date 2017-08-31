%{

#include "header-parser.tab.h"
#include <iostream>

#define PRINT_DEBUG 0

void debug_print(const char *str)
{
#if PRINT_DEBUG
	std::cout << str << std::endl;
#endif
}

%}

%option noyywrap

%%
[ \t\r\n]	;
\/\/.*						{ debug_print("LINE_COMMENT"); }	// line comment
\"\"(.*?|\r|\r\n|\n)\"\"	{ debug_print("QUOTED_STR"); yylval.sval = _strdup(yytext); return QUOTED_STR;}		// block comment
\/\*(.*?|\r|\r\n|\n)*\*\/	{ debug_print("BLOCK_COMMENT"); }	// block comment
\<							{ debug_print("LEFT_BRKT"); return LEFT_BRKT; }
\>							{ debug_print("RIGHT_BRKT"); return RIGHT_BRKT; }
\"							{ debug_print("QUOTE"); return QUOTE; }
\#include					{ debug_print("INCL_KEYW"); return INCL_KEYW; }
[a-zA-Z0-9./\\:\-\_]+		{ debug_print("STR"); yylval.sval = _strdup(yytext); return STR;}
.	;

%%