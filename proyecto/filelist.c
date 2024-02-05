
#include "filelist.h"
void createEmptyListM(tListM *L){
    *L= LNULL;
}
bool createNodeM(tPosM *p){

    //si malloc no es capaz de crear la variable porque no hay memoria en el heap y devuelve nulo
    *p= malloc(sizeof(struct tNodeM));
    return *p != NULL;
}
bool insertItemM(tItemM d, tPosM p, tListM* L){

    tPosM q,r;
    if(!createNodeM(&q)){
        return false;//si no hay memoria para meter el item devuelve false
    }else{
        q->data = d;
        q->next =LNULL;
        if(*L == LNULL){
            *L =q;
        }else if(p==LNULL){//insertar al final de lista no vacia
            for(r=*L; r->next!= LNULL; r=r->next);
            r->next = q;
        }else if(p==*L){ //insertar cabeza, si p apunta al primer elemento de la lista
            q->next =p;//antes p era el primero, y ahora q hacemos que sea el primero diciendo que p sea el siguiente
            *L = q;//y ahora decimos que el contenido de p será el contenido de q
        }else{//insertar en posicion anterior(mirar esta parte)
            q->data =p->data;
            p->data = d;
            q->next = p->next;
            p->next = q;
        }
        return true;
    }
}
void updateItemM(tItemM d, tPosM p, tListM* L ){
    p->data=d;
}

bool isEmptyListM(tListM L){
    return(L==LNULL);
}
tItemM getItemM(tPosM p, tListM L){
    //aqui ponemos tlista porque para arrays hace falta
    return p->data;//nos devuelve el campo data del elemento apuntado por p
}
tPosM  firstM(tListM L){
    return L;
}
tPosM lastM(tListM L){

    //declaramos "p" que recorerá la lista hasta llegar al último elemento
    tPosM p;
    for(p=L;p->next != LNULL;p = p->next);
    return p;

}
tPosM previousM(tPosM p, tListM L){
    tPosM q;
    if(p==L) { //caso de la 1era posición
        return LNULL;
    }else{
        //se recorre la lista con la variable "p"
        for(q=L;q->next!=p;q=q->next);
        return q;
    }
}
tPosM nextM(tPosM p, tListM L){
    return p->next;
}
void deleteAtPositionM(tPosM p, tListM *L){
    tPosM  q;
    if(p==*L) {//borrar 1er elemento
        *L = (*L)->next;
    }else if(p->next == LNULL){ //borrar último elemento
        for(q=*L;q->next!=p;q=q->next);
        q->next = LNULL;
        //es lo mismo que hacer q=previous(q,L);
    }else{//borrar en intermedio
        q=p->next;
        p->data = q->data;
        p->next = q->next;
        p=q;
    }
    //liberaramos la variable
    free(p->data.texto);
    free(p->data.fichero);
    free(p);
}
void deleteListM(tListM *L){
    tPosM p;
    while(*L != LNULL) {
        p = *L;
        *L = (*L)->next;
        free(p->data.texto);
        free(p->data.fichero);
        free(p);
    }
}
//funciones especificas:
tPosM findkeyM(int key, tListM L){

    //declaramos la variable "p" que recorrerá la lista
    tItemM item;
    tPosM p;
    for(p=L;(p!=NULL);p=p->next){
        item=getItemM(p,L);
        if(item.key==key){
            return p;
        }
    }
    
    return p;

}
int tamList(tListM M){
    int num=0;
    for(tPosM p=M; p!=NULL; p=nextM(p,M)){
        num++;
    }
    return num;
}
void imprimirSinExtremos(const char *cadena) {
    int longitud = strlen(cadena);

    // Verificar que la cadena tiene al menos 3 caracteres (para eliminar el primer y último)
    if (longitud >= 3) {
        // Imprimir la cadena sin el primer y último caracter
        for (int i = 1; i < longitud - 1; i++) {
            putchar(cadena[i]);
        }
        putchar('\n');  // Imprimir un salto de línea al final
    } else {
        // Imprimir un mensaje de error si la cadena es demasiado corta
        printf("La cadena es demasiado corta para eliminar el primer y último caracter.\n");
    }
}

void imprimir_listacompleta(tListM M){
        tItemM item;
    for(tPosM p=M; p!=NULL; p=nextM(p,M)){
        item=getItemM(p,M);
        printf("%d: ", item.key);
        imprimirSinExtremos(item.texto);
    }

}

void copiarTextoEnPosicion(const char *texto_original, char **nuevo_texto) {
    // Verifica que el texto original no sea nulo
    if (texto_original == NULL) {
        fprintf(stderr, "Error: Texto original nulo.\n");
        return;
    }

    // Tamaño del texto
    size_t longitud = strlen(texto_original);

    // Reserva memoria para el nuevo texto (+1 para el carácter nulo)
    *nuevo_texto = (char *)malloc((longitud + 1) * sizeof(char));

    // Verifica que la reserva de memoria sea exitosa
    if (*nuevo_texto != NULL) {
        // Copia el texto en la posición especificada
        strcpy(*nuevo_texto, texto_original);
    } else {
        fprintf(stderr, "Error: No se pudo reservar memoria.\n");
    }
}