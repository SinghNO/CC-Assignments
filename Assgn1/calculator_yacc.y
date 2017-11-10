%{
       #include<stdio.h>
       #include<math.h>
%}

%union //define a symbol p which is the number input by the user
{ double p;}
%token<p>num
%token SIN COS TAN LOG SQRT POW

/* left precedence rules */
 
%left '+','-'			//lowest precedence
%left '*','/'			//highest precedence
%nonassoc uminus		//no associativity
%type<p>exp			//non terminal

%%

/* for printing the answer */

ss: exp {printf("\n= %g\n",$1);}

/* rules */
exp :   exp'+'exp      { $$=$1+$3; }
       |exp'-'exp      { $$=$1-$3; }
       |exp'*'exp      { $$=$1*$3; }
       |exp'/'exp      {
                               if($3==0)
                               {
                                       printf("Divide By Zero");
                                       exit(0);
                               }
                               else $$=$1/$3;
                       }
       |'-'exp         {$$=-$2;}
       |'('exp')'      {$$=$2;}
       |SIN'('exp')'   {$$=sin($3);}
       |COS'('exp')'   {$$=cos($3);}
       |TAN'('exp')'   {$$=tan($3);}
       |LOG'('exp')'   {$$=log($3);}
       |SQRT'('exp')'  {$$=sqrt($3);}
       |POW'('exp','exp')'  {$$=pow($3,$5);}
       |num;
%%

/* extern FILE *yyin; */
main()
{
       do
       {
               yyparse();	/* repeatedly tries to parse the sentence until the i/p runs out */
       }while(1);

}

yyerror(s)			/* used to print the error message when there is an error in parsing */

char *s;
{
       printf("ERROR\n");
}

