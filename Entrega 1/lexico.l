%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>
#include "y.tab.h"

typedef struct{
		char nombre[100];
		char tipo;		
		char valor[100];
		int longitud;
		
		} simbolos;


FILE  *yyin;
int yylval;
char *yyltext;
registro tabla[100];
int indice=0;

unsigned long long binarioADecimal(char *, int );
unsigned long long hexaADecimal(char *, int );
void quitarPrefijo(char *, char * , int);
unsigned long long hexadecimalADecimal(char *, int );
int caracterHexadecimalADecimal(char );
void mensajeDeError(int );

%}
%option noyywrap  
%option yylineno 


DIGITO		[0-9]
HEXA		[A-F]
BIN			[0-1]
LETRA		[a-zA-Z]
CTE_REAL    	{DIGITO}+"."{DIGITO}+
CTE_INT     	{DIGITO}+
ID		{LETRA}({LETRA}|{DIGITO})*
OP_ASIG   	":="
OP_LOGICO	["and"|"or"]
OP_NEGACION 	"not"
OP_COMPARACION  ["<"|"=="|">"|"<="|">="|"<>"]
OP_SUMA         ["+"]
OP_DIVI         ["/"]
OP_REST         ["-"]
OP_MULT         ["*"]
P_A             ["("]
P_C             [")"]
LL_A            ["{"]
LL_C            ["}"]
COMENT		\*-.*\-*
COMA		[","]
P_Y_C		[";"]
ESPACIO		[" "]
CTE_STRING 	\".*\"
PUT		"PUT"
GET		"GET"
INTEGER		"Integer"
FLOAT		"Float"
WHILE 		"while"
IF		"if"
ELSE		"Else"
CTE_BIN		"0b"{BIN}+
CTE_HEXA	"0x"({DIGITO}|{HEXA})*
MAXIMO		"maximo"
DIM		"DIM"
AS		"AS"

%%

{PUT}			{
				printf("\nPalabra reservada: %s\n",yytext);
				return PUT;
				}
{GET}			{
				printf("\nPalabra reservada: %s\n",yytext);
				return GET;
				}
{INTEGER}		{
				printf("\nPalabra reservada: %s\n",yytext);
				return INTEGER;
				}
{FLOAT}			{
				printf("\nPalabra reservada: %s\n",yytext);
				return FLOAT;
				}
{IF}			{
				printf("\nPalabra reservada: %s\n",yytext);
				return IF;
				}
{ELSE}   		{
				printf("\nPalabra reservada: %s\n",yytext);
				return ELSE;
				}
{WHILE}	  		{
				printf("\nPalabra reservada: %s\n",yytext);
				return WHILE;
				}
{MAXIMO}		{
				printf("\nPalabra reservada: %s\n",yytext);
				return MAXIMO;
				}
{DIM}			{
				printf("\nPalabra reservada: %s\n",yytext);
				return DIM;
				}
{AS}			{
				printf("\nPalabra reservada: %s\n",yytext);
				return AS;
				}
{OP_ASIG}		{
				printf("\nAsignacion: %s\n",yytext);
				return OP_ASIG;
				}
{OP_NEGACION}	{
				printf("\nNegacion: %s\n",yytext);
				return OP_NEGACION;
				}
{OP_SUMA}		{
				printf("\nSuma: %s\n",yytext);
				return OP_SUMA;
				}
{OP_REST}		{
				printf("\nResta: %s\n",yytext);
				return OP_REST;
				}
{OP_MULT}		{
				printf("\nMultiplicacion: %s\n",yytext);
				return OP_MULT;
				}
{OP_DIVI}		{
				printf("\nDivision: %s\n",yytext);
				return OP_DIVI;
				}
{COMA}			{
				printf("\nComa: %s\n",yytext);
				return COMA;
				}
{P_Y_C}			{
				printf("\nPunto y coma: %s\n",yytext);
				return P_Y_C;
				}
{P_A}			{
				printf("\nParentesis que abre: %s\n",yytext);
				return P_A;
				}
{P_C}			{
				printf("\nParentesis que cierra: %s\n",yytext);
				return P_C;
				}
{LL_A}			{
				printf("\nLlave que abre: %s\n",yytext);
				return LL_A;
				}
{LL_C}			{
				printf("\nLlave que cierra: %s\n",yytext);
				return LL_C;
				}
{COMENT}		{
				printf("\nComentario: %s\n",yytext);
				return COMENT;
				}
				
{ID}			{
				printf("\nIdentificador: %s\n",yytext);
				return ID;
				}
				
{CTE_INT}		{
				printf("\nConstante entera: %s\n",yytext);
				if(atoll(yytext)<=32767)
				{
					int length = strlen(yytext);
					char cte_nombre[length];
					strcpy(cte_nombre, "_");
					strcat(cte_nombre, yytext);
				}
				else
				{
				mensajeDeError(1);
				}
				
				return CTE_INT;
				}
{CTE_REAL}		{
				printf("\nConstante real: %s\n",yytext);
				if(atof(yytext)<=3.40282347e+38F)
				{
				int length = strlen(yytext);
				char cte_nombre[length];
				strcpy(cte_nombre, "_");
				strcat(cte_nombre, yytext);
				}
				else{
				void mensajeDeError(2);
				}
				return CTE_REAL;
				}
{CTE_STRING}	{
				printf( "\nString: %s\n", yytext); 
				if(strlen(yytext)<=30){

				int length = strlen(yytext);
				char cte_nombre[length];
				strcpy(cte_nombre, "_");
				strcat(cte_nombre, yytext);
					
					return CTE_STRING;
				}
				else{
					void mensajeDeError(3);
				}
				return CTE_STRING;
				}
{CTE_HEXA}		{
				printf("\nConstante hexa: %s\n",yytext);
				int length = strlen(yytext);
				char cte_nombre[length];
				strcpy(cte_nombre, "_");
				strcat(cte_nombre, yytext);
				
				int longitud = strlen(yytext);
				char hexa[longitud-2];
				quitarPrefijo(yytext,hexa,longitud);
				longitud =  strlen(hexa);
				unsigned long long decimal = hexadecimalADecimal(yytext,longitud);
				return CTE_HEXA;
				}
{CTE_BIN}		{
				printf( "\nConstante binaria: %s\n", yytext); 
				int length = strlen(yytext);
				char cte_nombre[length];
				strcpy(cte_nombre, "_");
				strcat(cte_nombre, yytext);
				
				int longitud = strlen(yytext);
				char binario2[longitud-2];
				quitarPrefijo(yytext,binario2,longitud);
				longitud =  strlen(binario2);
				unsigned long long decimal = binarioADecimal(binario2,longitud);
				return CTE_BIN;
				}

{OP_COMPARACION}	{
						printf("\nOperador de comparacion: %s\n", yytext);
						return OP_COMPARACION;
					}
			
{OP_LOGICO}	{
				printf("\nOperador logico: %s\n", yytext);
				return OP_LOGICO;
		}

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

unsigned long long binarioADecimal(char *cadenaBinaria, int longitud) {
  unsigned long long decimal = 0;
  int multiplicador = 1;
  char caracterActual;
  for (int i = longitud - 1; i >= 0; i--) {
    caracterActual = cadenaBinaria[i];
    if (caracterActual == '1') {
      decimal += multiplicador;
    }
    multiplicador = multiplicador * 2;
  }
  return decimal;
}

void quitarPrefijo(char *cadena, char *nuevaCadena, int longitud) {
	int j=0;
    int i;
	for(i=2;i<=longitud-1;i++){

		nuevaCadena[j]=cadena[i];
		j++;
	}
	nuevaCadena[j]='\0';

}

int caracterHexadecimalADecimal(char caracter) {
  if (isdigit(caracter))
    return caracter - '0';
  return 10 + (toupper(caracter) - 'A');
}

unsigned long long hexadecimalADecimal(char *cadenaHexadecimal, int longitud) {
  unsigned long long decimal = 0;
  int potencia = 0;
  for (int i = longitud - 1; i >= 0; i--) {
    
    int valorActual = caracterHexadecimalADecimal(cadenaHexadecimal[i]);
    unsigned long long elevado = pow(16, potencia) * valorActual;
  
    decimal += elevado;
    potencia++;
  }
  return decimal;
}
void mensajeDeError(int error){

	switch(error){

        case 1:
            printf("ERROR LEXICO. Descripcion: Int fuera de rango. Debe ser un int de 16bits.\n");
            break ;

		case 2:
            printf("ERROR LEXICO. Descripcion: Float fuera de rango. Debe ser un float de 32bits.\n");
            break ;

        case 3:
            printf("ERROR LEXICO. Descripcion: String fuera de rango. La longitud maxima es de 30 caracteres.\n");
            break ;

        }

    system ("Pause");
	exit (1);
	
}
