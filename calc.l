%{
    #include "y.tab.h"
    #include <stdio.h>

    int yywrap(void)
    {
        return 1;
    }
%}

%%
"+"    return ADD;
"-"    return SUB;
"*"    return MUL;
"/"    return DIV;
"("    return LB;
")"    return RB;
"\n"   return CR;
([1-9][0-9]*)|0|([0-9]+\.[0-9]*) {
    double tmp;
    sscanf(yytext, "%lf", &tmp);
    yylval.double_value = tmp;
    return DOUBLE_LITERAL;
}
. {
    fprintf(stderr, "Lexical Error!\n");
}
%%