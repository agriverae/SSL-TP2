%{
    #include <stdio.h>
	#include <string.h>
	
	/// Funciones
	
	void agregarALista(char *nombre, int valor);
	void modificarExistente(char *nombre, int valor);
	int obtenerValor(char *id);
	int obtenerIndice(char *nombre);
%}



%union {
    int ival;
    char* string;
}
/* declaraciones de Bison*/

%token  <ival> CONSTANTE
/*%token  <string> */
%token  PARENIZQUIERDO   PARENDERECHO  ID   PUNTOYCOMA  COMA 
%token  ASIGNACION   LEER    ESCRIBIR    SUMA    RESTA
%token  INICIO   FIN

%left    RESTA
%left    SUMA
%right   ASIGNACION 

%type   <ival> Primaria Expresion
%type   <string> Sentencia ID

%start Programa

%%

/* Reglas gramaticales */

Programa: INICIO FIN 
		| INICIO ListaSentencias FIN 
    ;

ListaSentencias:  Sentencia {}
                | ListaSentencias Sentencia
    ;

Sentencia: ID ASIGNACION Expresion PUNTOYCOMA                                   {printf("Se le asigna a %s = %d \n", $1 ,$3);agregarALista($1,$3);}
        | LEER PARENIZQUIERDO ListaIdentificadores PARENDERECHO PUNTOYCOMA
        | ESCRIBIR PARENIZQUIERDO ListaExpresiones PARENDERECHO PUNTOYCOMA
    ;

ListaIdentificadores: ID                                {}
                    | ListaIdentificadores COMA ID      {}
    ;

ListaExpresiones: Expresion                             {printf("Resultado: %d \n", obtenerValor($1));}
                | ListaExpresiones COMA Expresion       {printf("Resultado: %d \n", obtenerValor($3));}
    ;

Expresion: Primaria                     { $$ = $1; }
         | Expresion SUMA Primaria      { $$ = $1 + $3; }
         | Expresion RESTA Primaria     { $$ = $1 - $3; }
    ;

Primaria: ID                                        { $$ = $1; }
        | CONSTANTE                                 { $$=$1; }
        | PARENIZQUIERDO Expresion PARENDERECHO     { $$=$2; }
    ;

%%
/* codigo C adicional */


/* Inicializamos el tipo de dato Identificador */
typedef struct Identificador {
   char  name[53];
   int   valor;
}Identificador;

/* Creamos la lista donde guardamos todos los identificadores */
Identificador listaIds[200];
/* Contador para saber el siguiente espacio libre */
int cantidadDeIDs = 0;

/* Agregamos identificador a la lista */
void agregarALista(char *nombre, int valor){	
	if(obtenerIndice(nombre) != -1){ // Si ya existe modificamos
		modificarExistente(nombre,valor);
	}
	else{ // Agregamos
		listaIds[cantidadDeIDs].valor = valor;
		strcpy(listaIds[cantidadDeIDs].name, nombre);	
		cantidadDeIDs++;
	}	
}


void modificarExistente(char *nombre, int valor){
	int indiceEnLista = obtenerIndice(nombre);
	
	listaIds[indiceEnLista].valor = valor;
}

int obtenerIndice(char *nombre){
	for(int i = 0; i < 200; i++){
		if(strcmp(listaIds[i].name, nombre) == 0){
			return i;
		}
	}
	return -1;
}



int obtenerValor(char *id){
	return  listaIds[obtenerIndice(id)].valor;
}


int yyerror(char *s) {
    printf("Error: no se reconoce la operacion.\n en %s", s);
}

int main(void) {
	printf("Ingrese su codigo manualmente: \n");
    yyparse();
}