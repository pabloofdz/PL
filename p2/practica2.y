%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int yylex(void);
void yyerror (char const *);
extern int yylineno;
char* tagError(char*, char*);
void compareTags(char*, char*);
%}
%union{
  char* valString;
}
%token <valString> HEADER
%token <valString> WRONGHEADER
%token <valString> WRONGTEXT
%token <valString> COMMENT
%token <valString> WRONGCOMMENT
%token <valString> STARTTAG
%token <valString> EMPTYTAG
%token <valString> ENDTAG
%token <valString> CONTENT
%token <valString> WRONGCONTENT
%token ENDOFFILE

%start S
%%
S : HEADER tags ENDOFFILE  {printf("Sintaxis XML correcta.\n");}
  | WRONGHEADER            {yyerror("Cabecera incorrecta."); yyclearin;}
  | tags                   {fprintf (stderr, "Sintaxis XML incorrecta. Se ha encontrado un error en la línea %i: %s\n", 1, "Cabecera no encontrada"); exit(0); yyclearin;}
;

tags: startoutcontent STARTTAG content ENDTAG outcontent           {compareTags($2, $4);}
    | startoutcontent STARTTAG ENDTAG outcontent                   {compareTags($2, $3);}
    | startoutcontent EMPTYTAG outcontent
    | startoutcontent STARTTAG content ENDTAG outcontent STARTTAG  {compareTags($2, $4); yyerror("No existe elemento raíz."); yyclearin;}
    | startoutcontent STARTTAG ENDTAG outcontent STARTTAG          {compareTags($2, $3); yyerror("No existe elemento raíz."); yyclearin;}
    | startoutcontent EMPTYTAG outcontent STARTTAG                 {yyerror("No existe elemento raíz."); yyclearin;}
    | startoutcontent STARTTAG content ENDTAG outcontent EMPTYTAG  {compareTags($2, $4); yyerror("No existe elemento raíz."); yyclearin;}
    | startoutcontent STARTTAG ENDTAG outcontent EMPTYTAG          {compareTags($2, $3); yyerror("No existe elemento raíz."); yyclearin;}
    | startoutcontent EMPTYTAG outcontent EMPTYTAG                 {yyerror("No existe elemento raíz."); yyclearin;}
    | startoutcontent STARTTAG content                             {yyerror("Falta tag de cierre"); yyclearin;}
    | startoutcontent STARTTAG                                     {yyerror("Falta tag de cierre"); yyclearin;}
    | startoutcontent ENDTAG                                       {yyerror("Falta tag de apertura"); yyclearin;}
;

content: data
       | content data
       | STARTTAG content ENDTAG             {compareTags($1, $3);}
       | STARTTAG ENDOFFILE                  {yyerror("Falta tag de cierre"); yyclearin;}
       | STARTTAG content ENDOFFILE          {yyerror("Falta tag de cierre"); yyclearin;}
       | content STARTTAG content ENDOFFILE  {yyerror("Falta tag de cierre"); yyclearin;}
       | content STARTTAG content ENDTAG     {compareTags($2, $4);}
;

data: STARTTAG ENDTAG  {compareTags($1, $2);}
    | EMPTYTAG
    | CONTENT
    | WRONGTEXT        {fprintf (stderr, "Sintaxis XML incorrecta. Se ha encontrado un error en la línea %i: Caracter '%s' inesperado.\n", yylineno, $1); exit(0); yyclearin;}
    | commenttype
;

//Aquí se detectan también las cabeceras en lugares incorrectos
commenttype: COMMENT
           | WRONGCOMMENT  {yyerror("Comentario incorrecto, dentro no deben aparecer los caracteres \"--\"."); yyclearin;}
           | HEADER        {yyerror("La cabecera debe aparecer al principio."); yyclearin;}
           | WRONGHEADER   {yyerror("La cabecera debe aparecer al principio."); yyclearin;}
;

//Para detectar el texto fuera de tags y permitir comentarios. No se incluye la posibilidad de que aparezca aquí una cabecera para evitar conflictos.
startoutcontent: /*vacio*/
               | startoutcontent startoutcontent2
;

startoutcontent2: COMMENT
                | WRONGCOMMENT  {yyerror("Comentario incorrecto, dentro no deben aparecer los caracteres \"--\"."); yyclearin;}
                | CONTENT       {yyerror("Texto fuera de tags."); yyclearin;}
                | WRONGTEXT     {fprintf (stderr, "Sintaxis XML incorrecta. Se ha encontrado un error en la línea %i: Caracter '%s' inesperado.\n", yylineno, $1); exit(0);}
;

//Aquí se detectan también las cabeceras en lugares incorrectos
outcontent: /*vacio*/
          | outcontent outcontent2
;

outcontent2: COMMENT
           | WRONGCOMMENT  {yyerror("Comentario incorrecto, dentro no deben aparecer los caracteres \"--\"."); yyclearin;}
           | CONTENT       {yyerror("Texto fuera de tags."); yyclearin;}
           | WRONGTEXT     {fprintf (stderr, "Sintaxis XML incorrecta. Se ha encontrado un error en la línea %i: Caracter '%s' inesperado.\n", yylineno, $1); exit(0);}
           | HEADER        {yyerror("La cabecera debe aparecer al principio."); yyclearin;}
           | WRONGHEADER   {yyerror("La cabecera debe aparecer al principio."); yyclearin;}
;
%%
int main(int argc, char *argv[]) {
  extern FILE *yyin;
  yyin = fopen(argv[1], "r");
  yyparse();
  return 0;
}

void yyerror(char const *message) { 
  fprintf (stderr, "Sintaxis XML incorrecta. Se ha encontrado un error en la línea %i: %s\n", yylineno, message);
  exit(0);
}

char* tagError(char *startTag, char *endTag) {
  char result[100];
  strcpy(result, "Tag de fin incorrecto, se esperaba : </");
  strcat(result, startTag);
  strcat(result, ". Se encontró: ");
  strcat(result, endTag);
  return strdup(result);
}

void compareTags(char *startTag, char *endTag) {
  if (strcmp(startTag+1, endTag+2)!=0){
    yyerror(tagError(startTag+1, endTag));
    yyclearin;
  }
}

