%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>

#define NO_ENCONTRADO -1
typedef struct{
		char nombre[100];
		char tipo;		
		char valor[100];
		int longitud;
		
		} registro;

msj_error(char* mensaje);
FILE  *yyin;
int yylval;
char *yyltext;
registro tabla[100];
int indice=0;

%}
%option noyywrap  
%option yylineno 


DIGITO			[0-9]
HEXA			[A-F]
BIN			[0-1]
LETRA			[a-zA-Z]
CTE_REAL                {DIGITO}+"."{DIGITO}+
CTE_INT              	{DIGITO}+
ID			{LETRA}({LETRA}|{DIGITO})*
OP_ASIG   		":="
OP_COMPARACION          "<"|"=="|">"|"<="|">="|"!="
OP_SUMA                 ["+"]
OP_DIVI                 ["/"]
OP_REST                 ["-"]
OP_MULT                 ["*"]
P_A                     ["("]
P_C                     [")"]
LL_A                    ["{"]
LL_C                    ["}"]
COMENT		        \*-.*\-*
COMA			[","]
P_Y_C			[";"]
ESPACIO			[" "]
CTE_STRING 		\".*\"
PUT			"PUT"
GET			"GET"
INTEGER			"Integer"
FLOAT			"Float"
WHILE 			"while"
IF			"if"
ELSE			"Else"
CONST			"CONST"
CTE_BIN			{BIN}+
CTE_HEXA		{DIGITO|HEXA}+
%%

{PUT}			printf("\nPalabra reservada: %s\n",yytext);
{GET}			printf("\nPalabra reservada: %s\n",yytext);
{INTEGER}		printf("\nPalabra reservada: %s\n",yytext);
{FLOAT}			printf("\nPalabra reservada: %s\n",yytext);
{IF}			printf("\nPalabra reservada: %s\n",yytext);
{ELSE}   		printf("\nPalabra reservada: %s\n",yytext);
{WHILE}	  		printf("\nPalabra reservada: %s\n",yytext);
{CONST}			printf("\nPalabra reservada: %s\n",yytext);
{OP_ASIG}		printf("\nAsignacion: %s\n",yytext);
{OP_SUMA}		printf("\nSuma: %s\n",yytext);
{OP_REST}		printf("\nResta: %s\n",yytext);
{OP_MULT}		printf("\nMultiplicacion: %s\n",yytext);
{OP_DIVI}		printf("\nDivision: %s\n",yytext);
{COMA}			printf("\nComa: %s\n",yytext);
{P_Y_C}			printf("\nPunto y coma: %s\n",yytext);
{P_A}			printf("\nParentesis que abre: %s\n",yytext);
{P_C}			printf("\nParentesis que cierra: %s\n",yytext);
{LL_A}			printf("\nLlave que abre: %s\n",yytext);
{LL_C}			printf("\nLlave que cierra: %s\n",yytext);
{COMENT}		printf("\nComentario: %s\n",yytext);
{OP_COMPARACION}	printf("\nOperacion de comparacion: %s\n",yytext);
{ID}			printf("\nIdentificador: %s\n",yytext);
{CTE_INT}		printf("\nConstante entera: %s\n",yytext);
{CTE_REAL}		printf("\nConstante real: %s\n",yytext);
{CTE_STRING}		printf( "String: %s\n", yytext); 
				
			


\n
\t
%%


int main (int argc,char *argv[]){
 if ((yyin=fopen(argv[1],"rt"))==NULL)
 {
  	printf("\nNo se puede abrir el archivo: %s\n",argv[1]);
 }
 else{
	yylex();
 }
 fclose(yyin);
 return 0;
}
int yyerror(void)
	{ 
 	  printf("Syntax Error\n");
	  system("Pause");
          exit (1);
	}








int msj_error(char* mensaje)
{
	printf("Error lexico: %s\n", mensaje);
	system ("Pause");
	exit (1);
}