%{
#include <stdio.h>
#include "calculadora_simple.tab.h"
%}

separador   ([ \t])+
letra [a-zA-Z]
DIGITO  [0-9]
identificador   {letra}({letra}|{DIGITO})*
constEntera {DIGITO}({DIGITO})*
%%

0x[a-fA-F0-9]+ {
    yylval.real = strtol(yytext, NULL, 16); // Convertir a entero hexadecimal
    return TKN_NUM;
}

{DIGITO}+"."{DIGITO}+ {
    yylval.real = atof(yytext);
    return TKN_NUM;
}

{DIGITO}+ {
    yylval.real = atof(yytext);
    return TKN_NUM;
}

{separador} { /* Descartar espacios y tabulaciones */ }

";"     { return TKN_PTOCOMA; }
"+"     { return TKN_MAS; }
"-"     { return TKN_MENOS; }
"^"     { return TKN_POW; }
"*"     { return TKN_MULT; }
"%"     { return TKN_MOD; }
"/"     { return TKN_DIV; }
"&"     { return TKN_AND; }
"|"     { return TKN_OR; }
"("     { return TKN_PA; }
")"     { return TKN_PC; }
"="     { return TKN_ASIGN; }

#.* { /* Descartar comentarios de una línea */ }

{identificador} {
    yylval.cadena=strdup(yytext);
    return TKN_ID;
}

\n  { /* Nueva línea, no hacer nada especial */ }
.   ECHO; /* Cualquier otra cosa, simplemente imprimirlo */

%%
