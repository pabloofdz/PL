%{
#include <stdlib.h>
#include "proyecto.tab.h"
%}
%option yylineno

numopcion      [0-9]+
fichero        [/a-zA-Z0-9_-]+\.txt
texto          \"[^\"]+\"
textotitulo    \-[^\-]+\-
delim          [ \t\n]
ws             {delim}+
%%
{ws}           { /* ignorar espacio en blanco */ }
"historia"     {return HISTORIA;}
"titulo"       {return TITULO;}
"capitulo"     {return CAPITULO;}
"eleccion"     {return ELECCION;}
"opcion"       {return OPCION;}
"fin"          {return FIN;}
{numopcion}    {yylval.valInt=atoi(yytext); return NUM;}
{fichero}      {yylval.valString=strdup(yytext); return FICHERO;}
{textotitulo}  {yylval.valString=strdup(yytext); return TEXTOTITULO;}
{texto}        {yylval.valString=strdup(yytext); return TEXTO;}
.              { /* ignorar el resto */ }
%%
