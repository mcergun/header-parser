%{

#include "header-parser.tab.h"
#include <iostream>

#define PRINT_DEBUG 1

void BEGIN_STATE(int state);
void END_STATE();

int old_state = 0;	// hope that's INITIAL...
int cur_state = 0;

void BEGIN_STATE(int state)
{ 
	old_state = cur_state; 
	cur_state = (state); 
	BEGIN(cur_state); 
	std::cout << "state now at " << cur_state << ", while old one is " << old_state << std::endl;
}

void END_STATE() 
{
	cur_state = old_state;
	BEGIN(old_state);
	old_state = old_state ? 0 : old_state; // system shouldnt go deeper than 2 stack of states
	std::cout << "state now at " << cur_state << std::endl;
}

void debug_print(const char *str)
{
#if PRINT_DEBUG
	std::cout << "\t" << str << std::endl;
#endif
}

%}

%option noyywrap

%x BLK_COMMENT
%x QUOTED_STR
%x BRKTED_STR

%%
[ \t\r\n]								;
\/\/.*									{ debug_print("LINE_COMMENT"); }	// line comment
\"\"(.*?|\r|\r\n|\n)\"\"				{ debug_print("QUOTED_STR"); yylval.sval = _strdup(yytext); return QUOTED_STR; }	// block comment

\/\*									{ debug_print("BLK_START"); BEGIN_STATE(BLK_COMMENT); }
<BLK_COMMENT>\*\/						{ debug_print("BLK_END"); END_STATE(); std::cout << "BLK_COMMENT" << std::endl; }
<BLK_COMMENT>[^\*\/]*					;

\"										{ debug_print("QT_START"); BEGIN_STATE(QUOTED_STR); }
<QUOTED_STR>\"							{ debug_print("QT_END"); END_STATE(); std::cout << "QUOTED_STR " << yylval.sval << std::endl; return QUOTED_STR; }
<QUOTED_STR>[^"]*						{ debug_print("QT_MID"); yylval.sval = _strdup(yytext); };

\<										{ debug_print("BRKT_START"); BEGIN_STATE(BRKTED_STR); }
<BRKTED_STR>\>							{ debug_print("BRKT_END"); END_STATE(); std::cout << "BRKTED_STR " << yylval.sval << std::endl; return BRKTED_STR; }
<BRKTED_STR>[\r\n]						{ debug_print("BRKT_END"); END_STATE(); }
<BRKTED_STR>[\*\/]						{ debug_print("COMMENT_IN_BRKT"); BEGIN_STATE(BLK_COMMENT); }
<BRKTED_STR>[^\>^(\r|\n|\r\n)^\*\/]*	{ debug_print("BRKT_MID"); yylval.sval = _strdup(yytext); };

\#include								{ debug_print("INCL_KEYW"); return INCL_KEYW; }
[a-zA-Z0-9./\\:\-\_]+					{ debug_print("STR"); yylval.sval = _strdup(yytext); return STR; }
.	;

%%