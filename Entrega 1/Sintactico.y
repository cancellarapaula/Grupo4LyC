%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <float.h>
#include <ctype.h>

char *yytext;

int yystopparser=0;
FILE  *yyin;
%}

%token P_Y_C
%token COMA
%token COMENT
%token P_A 
%token P_C
%token LL_A
%token LL_C
%token OP_SUMA
%token OP_REST
%token OP_MULT
%token OP_DIVI
%token OP_ASIG
%token OP_COMPARACION
%token OP_ASIG 
%token OP_LOGICO
%token OP_NEGACION
%token CTE_INT
%token CTE_REAL
%token CTE_BIN
%token CTE_HEXA
%token IF 
%token ELSE	
%token ESPACIO
%token INTEGER
%token FLOAT
%token PUT
%token GET
%token DIM
%token AS
%token C_A
%token C_C
%token WHILE
%token ID

%%
programa:  	   	   
  {printf("INICIA COMPILACION\n");}
  est_declaracion algoritmo
  {printf("FIN COMPILACION\n");} 
;  

est_declaracion:
  DIM declaraciones ENDDEF 
;

declaraciones:         	        	
  declaracion
  |declaraciones declaracion
;

declaracion:  
  FLOAT DOSPUNTOS lista_var
  |INT DOSPUNTOS lista_var
  |STRING DOSPUNTOS lista_var
;

lista_var:  
  ID
  |lista_var PUNTOCOMA ID  
;

algoritmo: 
  sentencia
  |algoritmo sentencia
;

sentencia:
  ciclo
  |if  
  |asignacion
  |salida
  |entrada
;

ciclo:
	WHILE P_A decision P_C LL_A algoritmo LL_C 
;

asignacion: 
	ID OP_ASIG expresion
;

if: 
	IF P_A decision P_C LL_A algoritmo LL_C 
	|IF P_A decision P_C LL_A algoritmo LL_C ELSE LL_A algoritmo LL_C
;

decision:
	condicion
	|condicion OP_LOGICO condicion
	|OP_NEGACION condicion
;

condicion:
	expresion OP_COMPARACION expresion
;

expresion:
	termino
	|expresion OP_SUMA termino
	|expresion OP_RESTA termino
;

termino: 
	factor
	|termino OP_MULT factor 
	|termino OP_DIVI factor 
;

factor: 
	ID
	|CTE_STRING
	|CTE_INT
	|CTE_REAL
	|CTE_BIN
	|CTE_HEXA
;

salida:
	PUT CONST_STRING 
	|PUT ID
;

entrada:
  GET ID 
;

%%
int main(int argc,char *argv[])
{
  //#ifdef YYDEBUG
    //yydebug = 1;
  //#endif 

  if ((yyin = fopen(argv[1], "rt")) == NULL)
  {
	printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
  }
  else
  {
	yyparse();
  }
  fclose(yyin);
  return 0;
}
int yyerror(void)
     {
       printf("Syntax Error\n");
	 system ("Pause");
	 exit (1);
     }

