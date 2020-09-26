%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>

FILE  *yyin;
int yylval;
char *yyltext;

%}
%option noyywrap  
%option yylineno 


DIGITO			[0-9]
LETRA			[a-zA-Z]
CONST_REAL              {DIGITO}+"."{DIGITO}+
CONST_INT               {DIGITO}+
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
COMENT_A                "*-"
COMENT_C                "-*"
COMA			[","]
P_Y_C			[";"]
ESPACIO			[" "]
STRING 			\".*\"
PUT			"PUT"
GET			"GET"
INTEGER			"Integer"
FLOAT			"Float"
WHILE 			"while"
IF			"if"
ELSE			"Else"
CONST			"CONST"
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
{COMENT_A}		printf("\nComentario que abre: %s\n",yytext);
{COMENT_C}		printf("\nComentario que cierra: %s\n",yytext);
{OP_COMPARACION}	printf("\nOperacion de comparacion: %s\n",yytext);
{ID}			printf("\nIdentificador: %s\n",yytext);
{CONST_INT}		printf("\nConstante entera: %s\n",yytext);
{CONST_REAL}		printf("\nConstante real: %s\n",yytext);
{STRING}		printf("\nString: %s\n", yytext);


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