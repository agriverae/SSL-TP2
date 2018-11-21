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
{espacio}               { /* Ignoramos espacios en blanco */ }
{integer}               {
                            yylval.ival=atof(yytext);
                            return (CONSTANTE);
                        }
{identificador}         {
                            yylval.string=yytext;
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