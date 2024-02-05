#ifndef FILELIST
#define FILELIST
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <stdlib.h>
#define MALLOC 0
#define MMAP 1
#define SHARED 2

/* Definicion de tipos */
#define LNULL NULL //DEFINIMOS UN LNULL PORQUE EN EL CODIGO PRINCIPAL NO TIENEN QUE SABER DE QUE MANERA LO IMPLEMENTAMOS
typedef struct tNodeM *tPosM;//aquí enlazamos unas con otras
typedef int elemento;

typedef struct{
   int key;
   char* fichero;
   char* texto;
}tItemM;

struct tNodeM {
    tItemM data;
    tPosM next;
};

typedef tPosM tListM;
//el último elemento de la lista no tiene next(no apunta a otro, apunta a un nulo el último)

/* prototipos de funciones */
void createEmptyListM (tListM*);
bool insertItemM(tItemM, tPosM, tListM*);
void updateItemM(tItemM, tPosM, tListM*);
void deleteAtPositionM(tPosM, tListM*);
bool isEmptyListM(tListM);
tItemM getItemM(tPosM, tListM);
tPosM firstM(tListM);
tPosM lastM(tListM);
tPosM previousM(tPosM, tListM);
tPosM nextM(tPosM, tListM);
bool createNodeM(tPosM *p);
void deleteListM(tListM *L);
tPosM findkeyM(int key, tListM L);
void copiarTextoEnPosicion(const char *texto_original, char **nuevo_texto);
void imprimir_listacompleta(tListM M);
int tamList(tListM M);
#endif