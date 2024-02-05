FUENTE = proyecto
LIB = lfl

all: compile run

compile:
	flex $(FUENTE).l
	bison -o $(FUENTE).tab.c $(FUENTE).y -yd -r all
	gcc -o $(FUENTE) lex.yy.c filelist.h filelist.c textlist.h textlist.c $(FUENTE).tab.c -$(LIB) -ly

run:
	./$(FUENTE) tragedia/tragedia.txt

run2:
	./$(FUENTE) errores/1opcion.txt
	
run3:
	./$(FUENTE) errores/nofin.txt
	
run4:
	./$(FUENTE) errores/nohistoria.txt
	
run5:
	./$(FUENTE) errores/noopciones.txt
	
run6:
	./$(FUENTE) errores/notextocapitulo.txt
	
run7:
	./$(FUENTE) errores/notextoeleccion.txt
	
run8:
	./$(FUENTE) errores/notextotitulo.txt

run9:
	./$(FUENTE) errores/notokeneleccion.txt

run10:
	./$(FUENTE) errores/opcionesnumrepes.txt

run11:
	./$(FUENTE) errores/ficheronoexiste.txt

run12:
	./$(FUENTE) errores/notextoopcion.txt

run13:
	./$(FUENTE) errores/noficheroopcion.txt

clean:
	rm $(FUENTE) lex.yy.c $(FUENTE).tab.c $(FUENTE).tab.h
