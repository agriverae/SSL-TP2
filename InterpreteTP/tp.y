%{    
	#include <string.h>
	#include <stdlib.h>
	#include <stdio.h>
	
	/*** Funciones ***/
		
	void porCodigoManual();
	void porArgumentos(char nombreArch[]);
	
	void agregarALista(char *nombre, int valor);
	void ingresoDeValor(char *nombre);
	void modificarExistente(char *nombre, int valor);
		
	int obtenerValor(char *id);
	int obtenerIndice(char *nombre);	
%}



%union {
    int ival;
    char* string;
}

/******** Declaraciones de Bison ********/

%token <string> ID
%token  <ival> CONSTANTE
%token  PARENIZQUIERDO   PARENDERECHO  PUNTOYCOMA  COMA 
%token  ASIGNACION   LEER    ESCRIBIR    SUMA    RESTA
%token  INICIO   FIN

%left    RESTA
%left    SUMA
%right   ASIGNACION 

%type   <ival> Primaria Expresion

%start Programa

%%

/******** Reglas gramaticales ********/

Programa: INICIO ListaSentencias FIN 
    ;

ListaSentencias:  Sentencia
                | ListaSentencias Sentencia
    ;

Sentencia: ID ASIGNACION Expresion PUNTOYCOMA {printf("Se asigna: %s = %d \n", $1 ,$3);agregarALista($1,$3);}
			| ESCRIBIR PARENIZQUIERDO ListaExpresiones PARENDERECHO PUNTOYCOMA
			| LEER PARENIZQUIERDO ListaIdentificadores PARENDERECHO PUNTOYCOMA
        
    ;

ListaIdentificadores: ID                                {ingresoDeValor($1);}
                    | ListaIdentificadores COMA ID      {ingresoDeValor($3);}
    ;

ListaExpresiones: Expresion                             {printf("Resultado: %d \n", $1);}
                | ListaExpresiones COMA Expresion       {printf("Resultado: %d \n", $3);}
    ;

Expresion: Primaria                     { $$ = $1; }
         | Expresion SUMA Primaria      { $$ = $1 + $3; }
         | Expresion RESTA Primaria     { $$ = $1 - $3; }
    ;

Primaria: ID                                        { $$ = obtenerValor($1);}
        | CONSTANTE                                 { $$=$1; }
        | PARENIZQUIERDO Expresion PARENDERECHO     { $$=$2; }
    ;

%%

/******** Código C *********/


/* Archivo */
extern FILE *yyin;

/* Inicializamos el tipo de dato Identificador */
typedef struct{
   int   valor;
   char  name[53];   
}Identificador;

/* Creamos la lista donde guardamos todos los identificadores */
Identificador listaIds[200];

/* Contador para saber el siguiente espacio libre */
int cantidadDeIDs = 0;

/* Agrega identificador a la lista */
void agregarALista(char *nombre, int valor){	
	if(obtenerIndice(nombre) != -1){ // Si ya existe modificamos
		modificarExistente(nombre,valor);
	}
	else{ //Si no agregamos
		listaIds[cantidadDeIDs].valor = valor;
		strcpy(listaIds[cantidadDeIDs].name, nombre);	
		cantidadDeIDs++;
	}	
}

/* Modifica un identificador que ya existe */
void modificarExistente(char *nombre, int valor){
	int indiceEnLista = obtenerIndice(nombre);	
	listaIds[indiceEnLista].valor = valor;
}

/* Obtiene la posición del identificador en la lista */
int obtenerIndice(char *nombre){
	for(int i = 0; i < 200; i++){
		if(strcmp(listaIds[i].name, nombre) == 0){
			return i;
		}
	}
	return -1;
}

/* Se pide por pantalla el ingreso del valor del identificador */
void ingresoDeValor(char *id){
	int valor;
	printf("Ingrese valor de identificador %s: ", id);
	scanf("%d",&valor); 
	agregarALista(id, valor);	
}


/* Obtiene el valor del identificador recibido */
int obtenerValor(char *id){
	int indice = obtenerIndice(id);
	if(indice >= 0){
		return  listaIds[indice].valor;
	}
	yyerror("identificador no declarado. ");
	return -1;	
}


int yyerror(char *s) {
    printf("Error: no se reconoce la operacion por: %s \n", s);
	exit(-1);
}


int main(int argc, char *argv[]) {
	if(argc < 2){
		porCodigoManual();
	}
	else{
		porArgumentos(argv[1]);
	}
}


void porCodigoManual(){
	printf("Ingrese el codigo a intepretar: \n");
    yyparse();
}

void porArgumentos(char nombreArch[100]){
		printf("Interpretando el archivo: %s\n", nombreArch);
		if((yyin=fopen(nombreArch,"rb"))){
			yyparse();
		} else {
			printf("Error. No se encontró el archivo %s\n", nombreArch);
		}
}