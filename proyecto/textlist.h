#ifndef TEXTLIST
#define TEXTLIST
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <stdlib.h>
#define MALLOC 0
#define MMAP 1
#define SHARED 2

/* Definicion de tipos */
#define LNULL NULL //DEFINIMOS UN LNULL PORQUE EN EL CODIGO PRINCIPAL NO TIENEN QUE SABER DE QUE MANERA LO IMPLEMENTAMOS
typedef struct tNodeT *tPosT;//aquí enlazamos unas con otras
typedef int elemento;
typedef struct{
   int key;
   char* texto;
}tItemT;
struct tNodeT {
    tItemT data;
    tPosT next;
};
typedef tPosT tListT;
//el último elemento de la lista no tiene next(no apunta a otro, apunta a un nulo el último)

/* prototipos de funciones */
void createEmptyListT (tListT*);
bool insertItemT(tItemT, tPosT, tListT*);
void updateItemT(tItemT, tPosT, tListT*);
void deleteAtPositionT(tPosT, tListT*);
bool isEmptyListT(tListT);
tItemT getItemT(tPosT, tListT);
tPosT firstT(tListT);
tPosT lastT(tListT);
tPosT previousT(tPosT, tListT);
tPosT nextT(tPosT, tListT);
bool createNodeT(tPosT *p);
void deleteListT(tListT *L);
tPosT findtamt(unsigned long int, tListT);
tPosT findfichT(char *fich, tListT L);
tPosT finddirT(void *dir, tListT L);
tPosT findkeyT(int key, tListT L);
void copiarTextoEnPosicion(const char *texto_original, char **nuevo_texto);
void imprimir_listacompleta2(tListT M);
#endif
