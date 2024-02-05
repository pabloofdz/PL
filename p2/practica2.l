%{
#include <stdlib.h>
#include "practica2.tab.h"
%}
%option yylineno

id            [A-ZÁÉÍÓÚÑa-záéíóúñ0-9\-_]+
version       "version"=\"[0-9]+\.[0-9]+\"
encoding      "encoding"=\"{id}\"
header1       "<?xml"{delim}+{version}{delim}+{encoding}{delim}*\?\>
header2       "<?xml"{delim}+{encoding}{delim}+{version}{delim}*\?\>
header        {header1}|{header2}
wrongheader   \<\?"xml"\>*([^\?\>]|[^\?]\>|\?[^\>])*\?*\?\>
comment1      "<!--"\-?([^\-\-]|[^\-]\-)*"-->"
comment2      "<!--"([^\-\-]|\-[^\-])*\-?"-->"
comment       {comment1}|{comment2}
wrongcomment  "<!--"\>*([^\-\-\>]|[^\-]\-\>|\-[^\-]\>|\-\-[^\>])*\-*"-->"
starttag      "<"{id}">"
emptytag      "<"{id}"/>"
endtag        "</"{id}">"
entity        "&amp;"|"&lt;"|"&gt;"|"&apos;"|"&quot;"
text          [^&\<]*{entity}*[^&\<]*
content       {text}*
delim         [ \t\n]
ws            {delim}+
%%
{ws}            { /* ignore white space */ }
{header}        {yylval.valString=strdup(yytext); return HEADER;}
{wrongheader}   {yylval.valString=strdup(yytext); return WRONGHEADER;}
{comment}       {yylval.valString=strdup(yytext); return COMMENT;}
{wrongcomment}  {yylval.valString=strdup(yytext); return WRONGCOMMENT;}
{starttag}      {yylval.valString=strdup(yytext); return STARTTAG;}
{emptytag}      {yylval.valString=strdup(yytext); return EMPTYTAG;}
{endtag}        {yylval.valString=strdup(yytext); return ENDTAG;}
{content}       {yylval.valString=strdup(yytext); return CONTENT;}
<<EOF>>         {static int once = 0; return (once = !once) ? ENDOFFILE : 0;}//En Flex, cuando se alcanza el final del archivo, la función de análisis devuelve 0. Es por esto que únicamente se devuelve el token la primera vez que se encuentra eof y después se devolverá 0. Evitando errores de sintaxis cuando la sintaxis xml es correcta.
.               {yylval.valString=strdup(yytext); return WRONGTEXT;}
%%
