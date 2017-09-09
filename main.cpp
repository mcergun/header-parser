#include <iostream>
#include "header-parser.tab.h"

extern FILE *yyin;

int mainn(int argc, char **argv)
{
        FILE *input = fopen("c:/Users/mert/Documents/GitHub/header-parser/t.txt", "r");
        if (input == NULL)
        {
                std::cout << "error opening " << argv[1] << std::endl;
        }

        yyin = input;

        do
        {
                yyparse();
        } while (!feof(yyin));

        std::cin.get();

        return 0;
}