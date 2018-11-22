%{
    #include "tp.tab.h"
    #include <stdlib.h>
    #include <stdio.h>
%}
%option noyywrap

espacio                 [ \t]+
digito                  [0-9]
integer                 {digito}+
alfanum                 [A-Za-z0-9]
identificador           [A-Za-z]{alfanum}{0,31}

%%

"fin"                   return(FIN);
"inicio"                return(INICIO);
"leer"                  return(LEER);
"escribir"              return(ESCRIBIR);
"exit"|"quit"|"bye"	    {printf("Terminando programa\n");exit(0);}
{espacio}               { /* Ignoramos espacios en blanco */ }
{integer}               {
                            yylval.ival=atof(yytext);
                            return (CONSTANTE);
                        }
{identificador}         {
                            yylval.string=strdup(yytext);
                            return (ID);
                        }
"+"                     return(SUMA);
"-"                     return(RESTA);
"("                     return(PARENIZQUIERDO);
")"                     return(PARENDERECHO);
","                     return(COMA);
";"                     return(PUNTOYCOMA);
":="                    return(ASIGNACION);

%%