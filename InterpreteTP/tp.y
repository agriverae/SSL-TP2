%{
    #include <stdio.h>
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

/* reglas gramaticales */

Programa: INICIO FIN 
		| INICIO ListaSentencias FIN 
    ;

ListaSentencias:  Sentencia {printf("Se reconoce sentencia");}
                | ListaSentencias Sentencia
    ;

Sentencia: ID ASIGNACION Expresion PUNTOYCOMA                                   {printf("Se le asigna a %s = %d ", $1 ,$3);}
        | LEER PARENIZQUIERDO ListaIdentificadores PARENDERECHO PUNTOYCOMA
        | ESCRIBIR PARENIZQUIERDO ListaExpresiones PARENDERECHO PUNTOYCOMA
    ;

ListaIdentificadores: ID                                {}
                    | ListaIdentificadores COMA ID      {}
    ;

ListaExpresiones: Expresion                             {printf("Resultado: %d", $1);}
                | ListaExpresiones COMA Expresion       {printf(", Resultado: %d", $3);}
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

struct ID {
   char  name[53];
   int   valor;
};



int yyerror(char *s) {
    printf("Error: no se reconoce la operacion.\n en %s", s);
}

int main(void) {
	printf("Ingrese su codigo manualmente: \n");
    yyparse();
}