%{
    #include <stdio.h>
%}

%union {
    int ival;
    char* string;
}
/* declaraciones de Bison*/

%token  <ival> CONSTANTE
%token  <string> ID
%token  INICIO   FIN
%token  PARENIZQUIERDO   PARENDERECHO    PUNTOYCOMA  COMA
%token  ASIGNACION   LEER    ESCRIBIR    SUMA    RESTA

%left   SUMA    RESTA

%start Programa

%%

/* reglas gramaticales */

Programa: INICIO ListaSentencias FIN      
    ;

ListaSentencias: Sentencia
               | Sentencia Sentencia
    ;

Sentencia: ID ASIGNACION Expresion PUNTOYCOMA 
        | LEER PARENIZQUIERDO ListaIdentificadores PARENDERECHO PUNTOYCOMA
        | ESCRIBIR PARENIZQUIERDO ListaExpresiones PARENDERECHO PUNTOYCOMA
    ;

ListaIdentificadores: ID
                    | COMA ID
    ;

ListaExpresiones: Expresion
                | COMA Expresion
    ;

Expresion: Primaria
         | OperadorAditivo Primaria
    ;

Primaria: ID
        | CONSTANTE
        | PARENIZQUIERDO Expresion PARENDERECHO
    ;

OperadorAditivo: SUMA
               | RESTA
 

%%
/* codigo C adicional */
int yyerror(char *s) {
    printf("Error: no se reconoce la operacion.\n");
}

int main(void) {
    yyparse();
}