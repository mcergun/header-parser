#include <iostream>
#include "header-parser.tab.h"

extern FILE *yyin;

int main(int argc, char **argv)
{
	if (argc != 2)
	{
		std::cout << "need at least 1 parameter" << std::endl;
		return -1;
	}

	FILE *input = fopen(argv[1], "r");
	if (input == NULL)
	{
		std::cout << "error opening " << argv[1] << std::endl;
	}

	yyin = input;

	do
	{
		yyparse();
	} while (!feof(yyin));

	return 0;
}