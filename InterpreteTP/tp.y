%{
    #include <stdio.h>
	#include <string.h>
	
	/*** Funciones ***/
		
	void porCodigoManual();
	void porArgumentos(int argc, char *argv[]);
	
	void agregarALista(char *nombre, int valor);
	void modificarExistente(char *nombre, int valor);
	void ingresoDeValor(char *nombre);
	
	int obtenerValor(char *id);
	int obtenerIndice(char *nombre);	
%}



%union {
    int ival;
    char* string;
}
/******** Declaraciones de Bison ********/

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

/******** Reglas gramaticales ********/

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

ListaIdentificadores: ID                                {ingresoDeValor($1);}
                    | ListaIdentificadores COMA ID      {ingresoDeValor($3);}
    ;

ListaExpresiones: Expresion                             {printf("Resultado: %d \n", obtenerValor($1));}
                | ListaExpresiones COMA Expresion       {printf("Resultado: %d \n", obtenerValor($3));}
    ;

Expresion: Primaria                     { $$ = $1; }
         | Expresion SUMA Primaria      { $$ = $1 + $3; }
         | Expresion RESTA Primaria     { $$ = $1 - $3; }
    ;

Primaria: ID                                        { $$ = obtenerValor($1); /*printf("Obtiene valor de %s = %d", $1, obtenerValor($1));*/ }
        | CONSTANTE                                 { $$=$1; }
        | PARENIZQUIERDO Expresion PARENDERECHO     { $$=$2; }
    ;

%%

/******** Código C *********/


/* Archivo */
extern FILE *yyin;
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

/* Modificar un identificador que ya existe */
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


int obtenerValor(char *id){
	int indice = obtenerIndice(id);
	if(indice >= 0){
		return  listaIds[indice].valor;
	}
	printf("El identificador nunca fue declarado");
	return -1;
	
}


int yyerror(char *s) {
    printf("Error: no se reconoce la operacion por: %s \n", s);
}



int main(int argc, char *argv[]) {
	printf("Leyendo archivo: %s\n", argv[1]);
	if((yyin=fopen(argv[1],"r"))){
		yyparse();
	} else {
		printf("Error. No se pudo interpretar el archivo %s\n", argv[1]);
	}
	/*if(argc < 2){
		porCodigoManual();
	}
	else{
		porArgumentos(argc, *argv);
	}*/
}

void porCodigoManual(){
	printf("Ingrese el codigo a intepretar: \n");
    yyparse();
}



void porArgumentos(int argc, char *argv[]){
	printf("Leyendo archivo: %s\n", argv[1]);
	if((yyin=fopen(argv[1],"rb"))){
		yyparse();
	} else {
		printf("Error. No se pudo interpretar el archivo %s\n", argv[1]);
	}
}