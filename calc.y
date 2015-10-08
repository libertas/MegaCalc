%{
    #include <stdio.h>
%}
%union {
    int int_value;
    double double_value;
}
%token <double_value> DOUBLE_LITERAL
%token ADD SUB MUL DIV CR LB M RB
%type <double_value> expL expH expPri
%%
all:
    line |
    all line;
line:
    expL CR
    {
        printf("%lf\n", $1);
    }
expL:
    expH |
    expL ADD expH
    {
        $$ = $1 + $3;
    } |
    expL SUB expH
    {
        $$ = $1 - $3;
    };

expH:
    expPri |
    expH MUL expPri
    {
        $$ = $1 * $3;
    } |
    expH DIV expPri
    {
        $$ = $1 / $3;
    };
expPri:
    DOUBLE_LITERAL |
    ADD DOUBLE_LITERAL
    {
        $$ = $2;
    } |
    SUB DOUBLE_LITERAL
    {
        $$ = -1 * $2;
    } |
    LB expL RB
    {
        $$ = $2;
    } |
    expL M expL
    {
        double r = 1, tmp = $3;
        if(tmp == 0)
            $$ = r;
        else if(tmp >0)
            while(tmp)
            {
                tmp--;
                r *= $1;
            }
        else if(tmp < 0)
            while(tmp)
            {
                tmp++;
                r /= $1;
            }
        $$ = r;
    };
%%
int yyerror(char const *str)
{
    extern char *yytext;
    printf("Parser error near %s\n", yytext);
    return 0;
}
int main(void)
{
    extern int yyparse(void);
    extern FILE *yyin;
    yyin = stdin;
    if(yyparse())
    {
        return 1;
    }
    return 0;
}
