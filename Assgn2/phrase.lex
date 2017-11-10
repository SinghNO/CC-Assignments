%{
#include <stdio.h>
%}

%%

[\t ]+                   /* ignore whitespace */ ;

is |
am |
are |
were |
was |
be |
being |
doing |
been |
do |
give |
check |
does |
did  |
will |
would |
should |
can  |
could |
has  |
have |
had |
go        { printf("%s: is a verb\n", yytext); }

Snehal |
Tiwari |
COEP |
coep |
college |
compiler |
Computer |
Engineering |
Engineer |
Pune |
year |
course |
test |
boy |
girl |
input |
output |
assignment { printf("%s: is a noun\n", yytext); }

I |
He |
She |
They |
It |
Those |
me |
Me |
Their {printf("%s : is a pronoun\n", yytext); }

[0-9]+ { printf("Syntax Error", yytext); }
[@|$|#|%|^|&|*|(|)|]+ { printf("Syntax Error", yytext); }
[a-zA-Z]+ { printf("%s: is neither a noun nor a verb\n", yytext); }

.|\n      { ECHO; /* normal default anyway */ }
%%

main()
{
      yylex();
}
yywrap()
{
  return(1);
}
yyerror(s)
char *s;
{
  fprintf(stderr, "%s\n",s);
}
