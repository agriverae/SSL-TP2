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

Programa: INICIO FIN {printf("Se reconoce inicio y fin");}
		| INICIO ListaSentencias FIN
		| Sentencia
    ;

ListaSentencias:  Sentencia
                | ListaSentencias Sentencia
    ;

Sentencia: ID ASIGNACION Expresion PUNTOYCOMA                                   {$$ = $1;}
        | LEER PARENIZQUIERDO ListaIdentificadores PARENDERECHO PUNTOYCOMA
        | ESCRIBIR PARENIZQUIERDO ListaExpresiones PARENDERECHO PUNTOYCOMA
    ;

ListaIdentificadores: ID                                {}
                    | ListaIdentificadores COMA ID      {}
    ;

ListaExpresiones: Expresion                             {printf("Resultado: %i", $1);}
                | ListaExpresiones COMA Expresion       {printf(", Resultado: %i", $3);}
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
    printf("Error: no se reconoce la operacion.\n");
}

int main(void) {
	printf("Ingrese su codigo manualmente: \n");
    yyparse();
}