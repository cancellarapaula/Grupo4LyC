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
  bloque_declaracion declaracion {printf("regla BLOQUE_DECLARACION es declaracion\n");}
  |declaracion {printf("regla BLOQUE_DECLARACION es declaracion\n");}
;

declaracion:  
  DIM OP_MENOR lista_var OP_MAYOR AS OP_MENOR lista_tipos OP_MAYOR {printf("regla DECLARACION;\n");}
;

lista_var:  
  lista_var COMA ID {printf("regla LISTA_VAR es lista_var, ID\n");}
  |ID {printf("regla LISTA_VAR es id\n");}
;

lista_tipos:
  lista_tipos COMA tipo_dato {printf("regla LISTA_TIPOS es lista_tipos,tipo_dato \n");}
  |tipo_dato {printf("regla LISTA_TIPOS es tipo_dato\n");}
  ;

tipo_dato:
  INTEGER {printf("regla TIPO_DATO es integer\n");}
  |FLOAT {printf("regla TIPO_DATO es foat\n");}
;

bloque: 
  bloque sentencia {printf("regla BLOQUE es bloque sentencia\n");}
  |sentencia {printf("regla BLOQUE es sentencia\n");}
;

sentencia:
  ciclo {printf("regla SENTENCIA es ciclo\n");}
  |if  {printf("regla SENTENCIA es if\n");}
  |asignacion {printf("regla SENTENCIA es asignacion\n");}
  |salida {printf("regla SENTENCIA es salida\n");}
  |entrada {printf("regla SENTENCIA es entrada\n");}
;

ciclo:
	WHILE P_A decision P_C LL_A bloque LL_C {printf("regla CICLO es while(decision){bloque}\n");}
;

asignacion: 
	ID OP_ASIG expresion P_Y_C {printf("regla ASIGNACION es id:=expresion;\n");}
;

if: 
	IF P_A decision P_C LL_A bloque LL_C {printf("regla IF es if(decision){bloque}\n");}
	|IF P_A decision P_C LL_A bloque LL_C ELSE LL_A bloque LL_C {printf("regla IF es if(decision){bloque} else {bloque}\n");}
;

decision:
  decision OP_LOGICO condicion {printf("regla DECISION ES decision op_logico condicion\n");}
  |condicion {printf("regla DECISION es condicion\n");}
;

condicion:
  OP_NEGACION condicion {printf("regla CONDICION es not condicion\n");}
  |expresion comparador expresion {printf("regla CONDICION es expresion comparador expresion\n");}
;

comparador:
  OP_IGUAL {printf("regla COMPARADOR ES =\n");}
  |OP_DISTINTO {printf("regla COMPARADOR ES <>\n");}
  |OP_MENORIGUAL {printf("regla COMPARADOR ES <=\n");}
  |OP_MAYORIGUAL {printf("regla COMPARADOR ES >=\n");}
  |OP_MAYOR {printf("regla COMPARADOR ES >\n");}
  |OP_MENOR {printf("regla COMPARADOR ES <\n");}
;

expresion:
  expresion OP_SUMA termino {printf("regla EXPRESION es expresion+termino\n");}
	|expresion OP_REST termino {printf("regla EXPRESION es expresion-termino\n");}
  |termino {printf("regla TERMINO es termino\n");}
;

termino: 
  termino OP_MULT factor {printf("regla TERMINO es termino*factor\n");}
	|termino OP_DIVI factor {printf("regla TERMINO es termino/factor\n");}
  |factor {printf("regla FACTOR es factor\n");}
;

factor:
  P_A expresion P_C {printf("regla FACTOR es (expresion)\n");}
  |maximo {printf("regla FACTOR es maximo\n");}
	|ID {printf("regla FACTOR es id\n");}
	|CTE_STRING {printf("regla FACTOR es cte_string\n");}
	|CTE_INT {printf("regla FACTOR es cte_int\n");}
	|CTE_REAL {printf("regla FACTOR es cte_real\n");}
	|CTE_BIN {printf("regla FACTOR es cte_bin\n");}
	|CTE_HEXA {printf("regla FACTOR es cte_hexa\n");}
;
maximo:
  MAXIMO P_A lista_expresion P_C {printf("regla MAXIMO es maximo(lista_expresion)\n");}
;

lista_expresion:
  lista_expresion COMA expresion {printf("regla LISTA_EXPRESION es lista_expresion,expresion\n");}
  | expresion {printf("regla LISTA_EXPRESION es expresion\n");}
;

salida:
	PUT CTE_STRING P_Y_C {printf("regla SALIDA es PUT cte_string;\n");}
	|PUT ID P_Y_C {printf("regla SALIDA es PUT id;\n");}
;

entrada:
  GET ID P_Y_C {printf("regla ENTRADA es GET id;\n");}
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

