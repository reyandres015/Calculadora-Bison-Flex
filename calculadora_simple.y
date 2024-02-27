%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <stdbool.h>

#define PI 3.141592
extern int yylex(void);
extern char* yytext;
extern int nlines;
int yyerror(char *s);
void imprime(int resultado);
void imprimeBool(const char* resultado);
void imprime_invalido();
short int valores=1;
extern FILE * yyin;
FILE * fsalida;

typedef struct Elemento {
	
	char nombre[25] ; 
	int valor; 	 
	struct Elemento* siguiente;

}Variable;

Variable *cabeza;
void insertarEnLista(Variable** vCabeza , int valorVar, char* nombreVar);
Variable* nuevaVariable(int valorVar, char* nombreVar);
void imprimirVariables();
Variable* buscarVariable(Variable* cabeza,char* nombreVar);

%}

%union{
	int real;
	char *cadena;
}

%token <real> TKN_NUM
%type <real> expresion
%token TKN_PTOCOMA
%token TKN_MAS
%token TKN_MENOS
%token TKN_MULT
%token TKN_MOD
%token TKN_DIV
%token TKN_POW
%token TKN_AND
%token TKN_OR
%token TKN_PA
%token TKN_PC
%token TKN_ASIGN
%token TKN_ID
%left TKN_ASIGN
%left TKN_MAS TKN_MENOS TKN_MOD
%left TKN_MULT TKN_DIV 
%left TKN_POW
%left TKN_AND TKN_OR
//%left TKN_PA TKN_PC
%start instrucciones
%%

instrucciones : instrucciones calculadora
		| calculadora
		;
		
calculadora	: expresion TKN_PTOCOMA 
			{
				if(valores == 1){
					imprime($1);
				}
				else if (valores == 2){
					if($1 == 1){
						imprimeBool("true");
					} else if ($1 == 0){
						imprimeBool("false");
					}
				}
				else
				{
					imprime_invalido();
					valores = 1;
				}
			}
			| TKN_ID TKN_ASIGN expresion TKN_PTOCOMA
			 {
			 	//dondeGuardas(tkn_id,valor_expresion);
			 	//BUscar variable y traer el valor, si no existe agregar variable
			 }
			;
 

expresion	: TKN_NUM { $$ = $1; }
			| TKN_PA expresion TKN_PC { $$ = $2; }
			| expresion TKN_MAS expresion { $$ = $1 + $3; }
			| expresion TKN_MENOS expresion { $$ = $1 - $3; }
			| expresion TKN_MULT expresion { $$ = $1 * $3; }			
			| expresion TKN_POW expresion { $$ = pow($1,$3); }
			| expresion TKN_MOD expresion { $$ = fmod($1,$3); }
			| expresion TKN_AND expresion 
			{ 
				$$ = $1 & $3; 
				valores = 2;
			}
			| expresion TKN_OR expresion 
			{ 
				$$ = $1 | $3; 
				valores = 2;
			}
			| expresion TKN_DIV expresion
			{
				if($3 == 0)
				{
					valores = 0;
				}
				else
				{
					$$ = $1 / $3;
					valores = 1;
				}
			}
			;

%%

int yyerror(char *s)
{
	printf("%s\n", s);
}

void imprime(int resultado)
{
	fprintf(fsalida,"Resultado %X en Hexadecimal\nResultado %i en Decimal\n\n",resultado,resultado);
}

void imprimeBool(const char* resultado){
    fprintf(fsalida, "Resultado %s\n", resultado);
}

void imprime_invalido()
{
	fprintf(fsalida,"Valor indefinido\n");
}

void insertarEnLista(Variable** cabeza , int valorVar, char nombreVar[]){
	Variable *nueva;
	nueva = nuevaVariable(valorVar,nombreVar);
	nueva -> siguiente = *cabeza;
	*cabeza = nueva;
}


Variable* nuevaVariable(int valorVar, char nombreVar[]){
	Variable *var;
	var = (Variable*)malloc(sizeof(Variable));
	//var -> nombre = nombreVar;
	strcpy( var->nombre, nombreVar );
	var -> valor = valorVar;
	var -> siguiente = NULL;
	printf("\n[vl]Nueva variable: <%s> = %i\n",nombreVar,valorVar);
	return var;
}


Variable* buscarVariable(Variable* cabeza,char nombreVar[]){
	int k;
	Variable *indice;
	printf("\n[vl]Buscando identificador");
		for( k = 0 , indice = cabeza; indice; ){
			if( strcmp( indice->nombre, nombreVar) == 0 )
  			{
     			printf("\n[vl]Var Encontrada...\n");
     			return indice;
  			}else{
  				printf(".");
  				k++;
				indice = indice->siguiente;
  			}
		}
		return NULL;
}


int main(int argc, char **argv)
{
	cabeza = NULL;

	if(argc > 2)
	{
		yyin = fopen(argv[1],"r");
		fsalida = fopen(argv[2], "w");
	}
	else
	{
		printf("Forma de uso: ./salida archivo_entrada archivo_salida\n");
		return 0;
	}
	/*Acciones a ejecutar antes del analisis*/
	yyparse();
	/*Acciones a ejecutar despues del analisis*/
	
	return 0;
}

