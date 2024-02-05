%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "textlist.h"
#include "filelist.h"
void imprimir(const char *cadena);
void convertirAMayusculas(char *cadena);
int yylex(void);
void vaciarListas();
void anadirAListaTexto(char* texto);
void anadirAListaOpciones(char* nameFile, char* text, int key);
void yyerror (char const *);
extern int yylineno;
tListM listaOpciones;
tListT listaTexto;
int num = 0;
int final = 0;
char* ficheroActual;
%}

%union{
  char* valString;
  int valInt;
}
%token HISTORIA
%token TITULO
%token CAPITULO
%token ELECCION
%token OPCION
%token FIN
%token <valString> TEXTO
%token <valString> TEXTOTITULO
%token <valString> FICHERO
%token <valInt> NUM
%type <valString> titulo
%type <valString> eleccion
%type <valString> historia
%type <valString> opcion
%start S
%%

S : historia titulo contenido eleccion opcion fin  {
                                                    if(tamList(listaOpciones)==1){
                                                      char str1[256] = "La elección tiene una única opción: ";
                                                      strcat(str1,$5);
                                                      strcat(str1,". Debe haber como mínimo dos.");
                                                      yyerror(str1);
                                                    }
                                                    imprimir(strdup($2));
                                                    imprimir(strdup(".-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-."));
                                                    imprimir_listacompleta2(listaTexto);
                                                    imprimir(strdup($4));
                                                    imprimir_listacompleta(listaOpciones);
                                                   }
  | historia contenido eleccion opcion fin         {
                                                    if(tamList(listaOpciones)==1){
                                                      char str1[256] = "La elección tiene una única opción: ";
                                                      strcat(str1,$4);
                                                      strcat(str1,". Debe haber como mínimo dos.");
                                                      yyerror(str1);
                                                    }
                                                    imprimir_listacompleta2(listaTexto);
                                                    imprimir(strdup($3));
                                                    imprimir_listacompleta(listaOpciones);
                                                   }
  | historia titulo contenido opcion fin           {yyerror("Si hay opciones debe haber una elección.");}
  | historia contenido opcion fin                  {yyerror("Si hay opciones debe haber una elección.");}
  | historia titulo contenido eleccion fin         {yyerror("Una elección debe ir acompañada de opciones.");}
  | historia contenido eleccion fin                {yyerror("Una elección debe ir acompañada de opciones.");}
  | historia titulo contenido fin                  {
                                                    final = 1;
                                                    imprimir(strdup($2));
                                                    imprimir(strdup(".-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-."));
                                                    imprimir_listacompleta2(listaTexto);
                                                   }
  | historia contenido fin                         {
                                                    final = 1;
                                                    imprimir_listacompleta2(listaTexto);
                                                   }                                  
;

historia:           {yyerror("El fichero debe empezar con 'historia'.");}
        | HISTORIA  {}
;

fin:      {yyerror("El fichero debe finalizar con 'fin'.");}
   | FIN  {}
;

titulo: TITULO TEXTOTITULO  {
                             convertirAMayusculas($2);
                             $$ = $2;
                            }
      | TITULO              {yyerror("El título está vacío.");}
;

eleccion: ELECCION TEXTO  {$$ = $2;}
        | ELECCION        {yyerror("La elección debe incluir una explicación.");}
;

contenido: TEXTO                           {anadirAListaTexto($1);}
         | CAPITULO TEXTOTITULO            {anadirAListaTexto($2);} 
         | contenido TEXTO                 {anadirAListaTexto($2);} 
         | contenido CAPITULO TEXTOTITULO  {anadirAListaTexto($3);} 
         | CAPITULO                        {yyerror("El capítulo está vacío.");}
         | contenido CAPITULO              {yyerror("El capítulo está vacío.");}
;

opcion: OPCION NUM TEXTO FICHERO         {
                                          $$ = $3;
                                          anadirAListaOpciones($4,$3,$2);
                                          
                                         }
      | opcion OPCION NUM TEXTO FICHERO  {anadirAListaOpciones($5,$4,$3);} 
      | OPCION NUM FICHERO               {yyerror("La opción debe incluir una explicación.");}
      | opcion OPCION NUM FICHERO        {yyerror("La opción debe incluir una explicación.");} 
      | OPCION NUM TEXTO                 {yyerror("Debe indicarse en qué fichero continua la historia.");} 
      | opcion OPCION NUM TEXTO          {yyerror("Debe indicarse en qué fichero continua la historia.");}                                         
;

%%
int main(int argc, char *argv[]) {
  extern FILE *yyin;
  copiarTextoEnPosicion(argv[1],&ficheroActual);
  yyin = fopen(argv[1], "r");
  createEmptyListM(&listaOpciones);
  createEmptyListT(&listaTexto);
   if (yyin==NULL){
    fprintf(stderr,"El fichero de la historia no existe.\n");
    exit(0);
  }
  yyparse();
  while (final!=1) {
    //Para leer por pantalla
    if (freopen("/dev/tty", "r", stdin) == NULL) {
      fprintf(stderr, "Error al redirigir stdin\n");
      exit(0);
    }
 
    int numeroUsuario;
    int ficheroEncontrado = 0;
    
    //Solicitar al usuario que ingrese un número
    while (ficheroEncontrado == 0) {
      printf("¿Qué opción eliges? :O (Puedes presionar 0 para salir)\n> ");
      if (scanf("%d", &numeroUsuario) != 1) {
        //Manejo de error si la entrada no es un número entero
        printf("Error: Por favor, introduce un número válido :)\n");
            
        //Limpiar el búfer de entrada
        int c;
        while ((c = getchar()) != '\n' && c != EOF);
            
        continue;
      }
      if(numeroUsuario==0){
        printf("¡Has llegado al final!\n¡Gracias por jugar a nuestra historia interactiva!\n¡Esperamos volver a verte pronto! :D\n");
        break;
      }
      tPosM pos = findkeyM(numeroUsuario,listaOpciones);
        if (pos != LNULL) {
          tItemM item= getItemM(pos,listaOpciones);
          free(ficheroActual);
          copiarTextoEnPosicion(item.fichero,&ficheroActual);
          ++ficheroEncontrado;
          yyin = fopen(ficheroActual, "r");
          if (yyin==NULL){
            fprintf(stderr,"El fichero en el que debería continuar la historia no existe.\n");
            exit(0);
          }
          vaciarListas();
          break;
        }

      if (ficheroEncontrado == 0) {
        printf("Error: Opción no válida. Por favor, introduce un número válido :)\n");
      }
    }
    yyparse();
    if (final==1) printf("¡Has llegado al final!\n¡Gracias por jugar a nuestra historia interactiva!\n¡Esperamos volver a verte pronto! :D\n");
  }
    
  free(ficheroActual);
  return 0;
}

void vaciarListas() {
  deleteListM(&listaOpciones);
  createEmptyListM(&listaOpciones);
  deleteListT(&listaTexto);
  createEmptyListT(&listaTexto);
}

void anadirAListaTexto(char* texto) {
  tItemT p;
  p.key = num;
  num++;
  copiarTextoEnPosicion(texto, &p.texto);
  insertItemT(p, LNULL, &listaTexto);    
}

void anadirAListaOpciones(char* nameFile, char* text, int key){
  tItemM p;
  p.key = key;
  if(findkeyM(key,listaOpciones)==LNULL){
    copiarTextoEnPosicion(nameFile,&p.fichero);
    copiarTextoEnPosicion(text,&p.texto);
    insertItemM(p, LNULL, &listaOpciones);
  }else{
    yyerror("No puede haber dos opciones con el mismo número.");
  }
}

void imprimir(const char *cadena) {
  int longitud = strlen(cadena);
  //Verificar que la cadena tiene al menos 3 caracteres (para eliminar el primer y último)
  if (longitud >= 3) {
    for (int i = 1; i < longitud - 1; i++) {
      putchar(cadena[i]);
    }
    putchar('\n');
  } else {
    printf("La cadena es demasiado corta para eliminar el primer y último caracter.\n");
  }
}

void convertirAMayusculas(char *cadena) {
  while (*cadena) {
    *cadena = toupper(*cadena);
    cadena++;
  }
}

void yyerror(char const *message) { 
  fprintf (stderr, "Sintaxis de la historia incorrecta :(. Se ha encontrado un error en la línea %i en el fichero %s: %s\n", yylineno, ficheroActual, message);
  exit(0);
}
