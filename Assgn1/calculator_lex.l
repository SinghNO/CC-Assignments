%{
       #include<math.h>
       #include"y.tab.h"
%}
%%

[0-9]+|[0-9]*\.[0-9]+ {
                       yylval.p = atof(yytext);
                       return num;		//return on digit occurence
                       }

sin return SIN;     //sine function to yacc
cos return COS;	    //cosine function to yacc
tan return TAN;	    //tangent function to yacc
log return LOG;	    //logarithm function to yacc
sqrt return SQRT;   //square root function to yacc
pow return POW;     //power function to yacc
[\t];
\n      return 0;
.       return yytext[0];


%%
