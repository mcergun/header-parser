%{

#include "header-parser.tab.h"
#include <iostream>

static const int DEBUG = 1;

void BEGIN_STATE(int state);
void END_STATE();

int old_state = 0;        // hope that's INITIAL...
int cur_state = 0;
int line_num = 1;

// TODO: actually return token here, it is removed for testing without bison
#define RETURN_TOKEN(token) \
{\
        if(DEBUG) { \
                printf("%s ", #token); \
        } \
}

// TODO: actually return token here, it is removed for testing without bison
#define RETURN_STR_TOKEN(token) \
{\
        if(DEBUG) { \
                printf("%s ", #token); \
        } \
        strncpy(yylval.sval, yytext, 256); \
        yylval.sval[255] = '\0'; \
}

void BEGIN_STATE(int state)
{ 
        old_state = cur_state; 
        cur_state = (state); 
        BEGIN(cur_state); 
        if(DEBUG)
                std::cout << "state now at " << cur_state << ", while old one is " << old_state << std::endl;
}

void END_STATE() 
{
        cur_state = old_state;
        BEGIN(old_state);
        old_state = old_state ? 0 : old_state; // system shouldnt go deeper than 2 stack of states
        if(DEBUG)
                std::cout << "state now at " << cur_state << std::endl;
}

using namespace std;

%}

%option noyywrap

%x ST_BLK_CMT
%x ST_QUO_STR

%%
[ \t]                                           ;
[\r\n]                                          { cout << " L" << line_num << endl; line_num++; }
\/\*                                            { BEGIN_STATE(ST_BLK_CMT); }
<ST_BLK_CMT>\*\/                                { END_STATE(); }
<ST_BLK_CMT>[\r\n]                              { cout << " L" << line_num << endl; line_num++; }
<ST_BLK_CMT>[^\*\/\r\n]*                        ;
\"                                              { BEGIN_STATE(ST_QUO_STR); RETURN_TOKEN(SYM_QUO); }
<ST_QUO_STR>\"                                  { END_STATE(); RETURN_TOKEN(SYM_QUO); }
<ST_QUO_STR>[\r\n]                              { cout << " L" << line_num << endl; line_num++; }
<ST_QUO_STR>[a-zA-Z0-9_]+                       { RETURN_STR_TOKEN(STR_IDE); }
<ST_QUO_STR>[a-zA-Z0-9_\/\\\.]+                 { RETURN_STR_TOKEN(STR_FIL); }
<ST_QUO_STR>[^\"\r\n]*                          { RETURN_STR_TOKEN(STR_LIT); }
.                                               ;

%%

int main()
{
        FILE *input = fopen("c:/Users/mert/Documents/GitHub/header-parser/t.txt", "r");
        yyin = input;

        yylex();

        cin.get();
}