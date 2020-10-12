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
%token P_A 
%token P_C
%token LL_A
%token LL_C
%token OP_SUMA
%token OP_REST
%token OP_MULT
%token OP_DIVI
%token OP_ASIG
%token OP_MAYOR
%token OP_MENOR
%token OP_IGUAL
%token OP_MAYORIGUAL
%token OP_MENORIGUAL
%token OP_DISTINTO
%token OP_LOGICO
%token OP_NEGACION
%token CTE_INT
%token CTE_REAL
%token CTE_BIN
%token CTE_HEXA
%token CTE_STRING
%token IF 
%token ELSE	
%token ESPACIO
%token INTEGER
%token FLOAT
%token PUT
%token GET
%token DIM
%token AS
%token WHILE
%token MAXIMO
%token ID

%%
programa:  	   	   
  {printf("INICIA COMPILACION\n");}
  bloque_declaracion bloque
  {printf("FIN COMPILACION\n");} 
;  

bloque_declaracion:         	        	
  bloque_declaracion declaracion
  |declaracion
;

declaracion:  
  DIM OP_MENOR lista_var OP_MAYOR AS OP_MENOR lista_tipos OP_MAYOR
;

lista_var:  
  lista_var COMA ID
  |ID
;

lista_tipos:
  lista_tipos COMA tipo_dato
  |tipo_dato
  ;

tipo_dato:
  INTEGER
  |FLOAT
;

bloque: 
  bloque sentencia
  |sentencia
;

sentencia:
  ciclo
  |if  
  |asignacion
  |salida
  |entrada
;

ciclo:
	WHILE P_A decision P_C LL_A bloque LL_C 
;

asignacion: 
	ID OP_ASIG expresion P_Y_C
;

if: 
	IF P_A decision P_C LL_A bloque LL_C 
	|IF P_A decision P_C LL_A bloque LL_C ELSE LL_A bloque LL_C
;

decision:
  decision OP_LOGICO condicion
  |condicion
;

condicion:
  OP_NEGACION condicion
  |expresion comparador expresion
;

comparador:
  OP_IGUAL
  |OP_DISTINTO
  |OP_MENORIGUAL
  |OP_MAYORIGUAL
  |OP_MAYOR
  |OP_MENOR
;

expresion:
  expresion OP_SUMA termino
	|expresion OP_REST termino
  |termino
;

termino: 
  termino OP_MULT factor 
	|termino OP_DIVI factor 
  |factor
;

factor:
  P_A expresion P_C
  |maximo
	|ID
	|CTE_STRING
	|CTE_INT
	|CTE_REAL
	|CTE_BIN
	|CTE_HEXA
;
maximo:
  MAXIMO P_A lista_expresion P_C
;

lista_expresion:
  lista_expresion COMA expresion
  | expresion
;

salida:
	PUT CTE_STRING P_Y_C
	|PUT ID P_Y_C
;

entrada:
  GET ID P_Y_C
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

