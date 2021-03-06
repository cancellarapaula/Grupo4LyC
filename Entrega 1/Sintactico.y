/**
 * 
 *  UNLaM
 *  Lenguajes y Compiladores ( 2020 2C )
 *
 *  Grupo 4. Integrantes:
 *	  Rapetti, Pablo.
 *    Gomez Nespola, Daiana.
 *    De Donato, Jonathan.
 *    Cancellara, Paula.
 *    Ávila, Martin.      
 *
 *  Temas especiales: 
 *     1-Constante Binaria y Hexadecimal
 *	   2-Máximo
 *
 */
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <float.h>
#include <ctype.h>
#include "y.tab.h"

	/* Tipos de datos para la tabla de simbolos */
  #define Integer 1
	#define Float 2
	#define String 3
	#define CteInt 4
	#define CteReal 5
	#define CteString 6
 	#define CteBinaria 7
	#define CteHexa 8 

	#define TAMANIO_TABLA 3000
	#define TAM_NOMBRE 32

	int yylex();
	
	/* Funciones necesarias */
	int yyerror(char* mensaje);
	void agregarVarATabla(char* nombre);
	void agregarTiposDatosATabla(void);
	void agregarCteStringATabla(char* str);
	void agregarCteIntATabla(int valor);
	void agregarCteRealATabla(float valor);
  	void agregarCteBinariaATabla(char* str);
  	void agregarCteHexaATabla(char* str);
	void chequearVarEnTabla(char* nombre);
	int buscarEnTabla(char * name);
	void escribirNombreEnTabla(char* nombre, int pos);
	void guardarTabla(void);

	int yystopparser=0;
	FILE  *yyin;

	/* Estructura de tabla de simbolos */
	typedef struct {
		char nombre[TAM_NOMBRE];
		int tipo_dato;
		char valor_s[TAM_NOMBRE];
		float valor_f;
		int valor_i;
		int longitud;
	} simbolo;

	simbolo tabla_simbolo[TAMANIO_TABLA];
	int fin_tabla = -1;

	/* Globales para la declaracion de variables y la tabla de simbolos */
	int varADeclarar1 = 0;
	int cantVarsADeclarar = 0;
	int cantTipoDatoDeclarado = 0;
	int tipoDatoADeclarar;

%}

  /* Tipo de estructura de datos*/
  %union {
    int valor_int;
    float valor_float;
    char *valor_string;
  }

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
%token <valor_int>CTE_INT
%token <valor_float>CTE_REAL
%token <valor_string>CTE_BIN
%token <valor_string>CTE_HEXA
%token <valor_string>CTE_STRING
%token IF 
%token ELSE	
%token ESPACIO
%token INTEGER
%token FLOAT
%token STRING
%token PUT
%token GET
%token DIM
%token AS
%token WHILE
%token MAXIMO
%token <valor_string>ID

%%
programa:  	   	   
  bloque_declaracion bloque       {
                                    printf("Regla PROGRAMA es bloque_declaracion bloque\n");
                                    printf("COMPILACION EXITOSA\n");
                                    guardarTabla();
                                  }
	|bloque						{
                                    printf("Regla PROGRAMA es bloque_declaracion bloque\n");
                                    printf("COMPILACION EXITOSA\n");
                                    guardarTabla();
                                  }
;  

bloque_declaracion:         	        	
  bloque_declaracion declaracion {printf("Regla BLOQUE_DECLARACION es bloque_declaracion declaracion\n");}
  |declaracion                   {printf("Regla BLOQUE_DECLARACION es declaracion\n");}
;

declaracion:  
  DIM OP_MENOR lista_var OP_MAYOR AS OP_MENOR lista_tipos OP_MAYOR {printf("Regla DECLARACION\n");}
;

lista_var:  
  lista_var COMA ID              {
                                  printf("Regla LISTA_VAR es lista_var, ID\n");
								  	cantVarsADeclarar++;
                                  	agregarVarATabla(yylval.valor_string);
                                  }
  |ID                            {
                                  printf("Regla LISTA_VAR es id\n");
								  cantVarsADeclarar=0;
                                  agregarVarATabla(yylval.valor_string);
									varADeclarar1 = fin_tabla; /* Guardo posicion de primer variable de esta lista de declaracion. */
                                }
;

lista_tipos:
  lista_tipos COMA tipo_dato    {
                                  printf("Regla LISTA_TIPOS es lista_tipos,tipo_dato\n");
                                  cantTipoDatoDeclarado++;
								  agregarTiposDatosATabla();
                                }
  |tipo_dato                    {
                                  printf("Regla LISTA_TIPOS es tipo_dato\n");
								  cantTipoDatoDeclarado = 0;
                                  agregarTiposDatosATabla();
                                }
  ;

tipo_dato:
  INTEGER                       {
                                  printf("Regla TIPO_DATO es integer\n");
                                  tipoDatoADeclarar = Integer;
                                }
  |FLOAT                        {
                                  printf("Regla TIPO_DATO es float\n");
                                  tipoDatoADeclarar = Float;
                                }
  |STRING                       {
                                  printf("Regla TIPO_DATO es string\n");
                                  tipoDatoADeclarar = String;
                                }
;

bloque: 
  bloque sentencia              {printf("Regla BLOQUE es bloque sentencia\n");}
  |sentencia                    {printf("Regla BLOQUE es sentencia\n");}
;

sentencia:
  ciclo                         {printf("Regla SENTENCIA es ciclo\n");}
  |if                           {printf("Regla SENTENCIA es if\n");}
  |asignacion                   {printf("Regla SENTENCIA es asignacion\n");}
  |salida                       {printf("Regla SENTENCIA es salida\n");}
  |entrada                      {printf("Regla SENTENCIA es entrada\n");}
;

ciclo:
	WHILE P_A decision P_C LL_A bloque LL_C {printf("Regla CICLO es while(decision){bloque}\n");}
;

asignacion: 
	ID OP_ASIG expresion P_Y_C {
                                chequearVarEnTabla($1);
                                printf("Regla ASIGNACION es id:=expresion;\n");
                              }
;

if: 
	IF P_A decision P_C LL_A bloque LL_C                        {printf("Regla IF es if(decision){bloque}\n");}
	|IF P_A decision P_C LL_A bloque LL_C ELSE LL_A bloque LL_C {printf("Regla IF es if(decision){bloque} else {bloque}\n");}
;

decision:
  decision OP_LOGICO condicion {printf("Regla DECISION ES decision op_logico condicion\n");}
  |condicion                   {printf("Regla DECISION es condicion\n");}
;

condicion:
  OP_NEGACION condicion           {printf("Regla CONDICION es not condicion\n");}
  |expresion comparador expresion {printf("Regla CONDICION es expresion comparador expresion\n");}
;

comparador:
  OP_IGUAL                    {printf("Regla COMPARADOR ES =\n");}
  |OP_DISTINTO                {printf("Regla COMPARADOR ES <>\n");}
  |OP_MENORIGUAL              {printf("Regla COMPARADOR ES <=\n");}
  |OP_MAYORIGUAL              {printf("Regla COMPARADOR ES >=\n");}
  |OP_MAYOR                   {printf("Regla COMPARADOR ES >\n");}
  |OP_MENOR                   {printf("Regla COMPARADOR ES <\n");}
;

expresion:
  expresion OP_SUMA termino   {printf("Regla EXPRESION es expresion+termino\n");}
	|expresion OP_REST termino  {printf("Regla EXPRESION es expresion-termino\n");}
  |termino                    {printf("Regla TERMINO es termino\n");}
;

termino: 
  termino OP_MULT factor      {printf("Regla TERMINO es termino*factor\n");}
	|termino OP_DIVI factor     {printf("Regla TERMINO es termino/factor\n");}
  |factor                     {printf("Regla FACTOR es factor\n");}
;

factor:
  P_A expresion P_C           {printf("Regla FACTOR es (expresion)\n");}
  |maximo                     {printf("Regla FACTOR es maximo\n");}
	|ID                         {
                                printf("Regla FACTOR es id\n");
                                chequearVarEnTabla(yylval.valor_string);  
                              }
	|CTE_STRING                 {
                                printf("Regla FACTOR es cte_string\n");
                                agregarCteStringATabla(yylval.valor_string);
                              }
	|CTE_INT                    {
                                printf("Regla FACTOR es cte_int\n");
                                agregarCteIntATabla(yylval.valor_int);  
                              }
	|CTE_REAL                   {
                                printf("Regla FACTOR es cte_real\n");
                                agregarCteRealATabla(yylval.valor_float);
														  }
	|CTE_BIN                    {
                                printf("Regla FACTOR es cte_bin\n");
                                agregarCteBinariaATabla(yylval.valor_string);
                              }
	|CTE_HEXA                   {
                                printf("Regla FACTOR es cte_hexa 1 1 \n");
                                agregarCteHexaATabla(yylval.valor_string);
								printf("Regla FACTOR es cte_hexa 2\n");
                              }
;
maximo:
  MAXIMO P_A lista_expresion P_C {printf("Regla MAXIMO es maximo(lista_expresion)\n");}
;

lista_expresion:
  lista_expresion COMA expresion {printf("Regla LISTA_EXPRESION es lista_expresion,expresion\n");}
  | expresion                     {printf("Regla LISTA_EXPRESION es expresion\n");}
;

salida:
	PUT CTE_STRING P_Y_C        {
                                printf("Regla SALIDA es PUT cte_string;\n");
                                agregarCteStringATabla(yylval.valor_string);  
                              }
	|PUT ID P_Y_C               {
                                chequearVarEnTabla($2);
                                printf("Regla SALIDA es PUT id;\n");
                              }
;

entrada:
  GET ID P_Y_C                {
                                chequearVarEnTabla($2);
                                printf("Regla ENTRADA es GET id;\n");
                              }
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
    fclose(yyin);
  }
  return 0;
}

int yyerror(char* mensaje)
 {
	printf("Syntax Error: %s\n", mensaje);
	system ("Pause");
	exit (1);
 }


/* Funciones de las constantes especiales */
int binarioADecimal(char *cadenaBinaria, int longitud) {
  int decimal = 0;
  int multiplicador = 1;
  char caracterActual;
  int i;
  for (i = longitud - 1; i >= 0; i--) {
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

int hexadecimalADecimal(char *cadenaHexadecimal, int longitud) {
  int decimal = 0;
  int potencia = 0;
  int i;
  for (i = longitud - 1; i >= 0; i--) {
    
    int valorActual = caracterHexadecimalADecimal(cadenaHexadecimal[i]);
    int elevado = pow(16, potencia) * valorActual;
  
    decimal += elevado;
    potencia++;
  }
  return decimal;
}

/* Funciones de la tabla de simbolos */

/* Devuleve la posicion en la que se encuentra el elemento buscado, -1 si no encuentra el elemento */
int buscarEnTabla(char * name){
   int i=0;
   while(i<=fin_tabla){
	   if(strcmp(tabla_simbolo[i].nombre,name) == 0){
		   return i;
	   }
	   i++;
   }
   return -1;
}

/** Escribe el nombre de una variable o constante en la posición indicada */
void escribirNombreEnTabla(char* nombre, int pos){
	strcpy(tabla_simbolo[pos].nombre, nombre);
}

 /** Agrega un nuevo nombre de variable a la tabla **/
 void agregarVarATabla(char* nombre){
	 //Si se llena la tabla, sale por error
	 if(fin_tabla >= TAMANIO_TABLA - 1){
		 printf("Error: No hay mas espacio en la tabla de simbolos.\n");
		 system("Pause");
		 exit(2);
	 }
	 //Si no existe en la tabla, lo agrega
	 if(buscarEnTabla(nombre) == -1){
		 fin_tabla++;
		 escribirNombreEnTabla(nombre, fin_tabla);
	 }
	 else 
	 {
	  char msg[100] ;
	  sprintf(msg,"'%s' ya se encuentra declarada previamente.", nombre);
	  yyerror(msg);
	}
 }

/** Agrega los tipos de datos a las variables declaradas. Usa las variables globales varADeclarar1, cantVarsADeclarar y tipoDatoADeclarar */
void agregarTiposDatosATabla(){
	tabla_simbolo[varADeclarar1 + cantTipoDatoDeclarado].tipo_dato = tipoDatoADeclarar;
}

/** Guarda la tabla de simbolos en un archivo de texto */
void guardarTabla(){
	if(fin_tabla == -1)
		yyerror("No se encontro la tabla de simbolos");
	FILE* arch;

	arch = fopen("ts.txt", "w");
	if(!arch){
		printf("No se pudo crear el archivo ts.txt\n");
		return;
	}

	int i;

	fprintf(arch, "%-30s|%-30s|%-30s|%-30s\n","NOMBRE","TIPO","VALOR","LONGITUD");
	fprintf(arch, ".........................................................................................................\n");
	for(i = 0; i <= fin_tabla; i++){
		fprintf(arch, "%-30s", &(tabla_simbolo[i].nombre) );

		switch (tabla_simbolo[i].tipo_dato){
		case Float:
			fprintf(arch, "|%-30s|%-30s|%-30s","FLOAT","--","--");
			break;
		case Integer:
			fprintf(arch, "|%-30s|%-30s|%-30s","INTEGER","--","--");
			break;
		case String:
			fprintf(arch, "|%-30s|%-30s|%-30s","STRING","--","--");
			break;
		case CteReal:
			fprintf(arch, "|%-30s|%-30f|%-30s", "CTE_REAL",tabla_simbolo[i].valor_f,"--");
			break;
		case CteInt:
			fprintf(arch, "|%-30s|%-30d|%-30s", "CTE_INT",tabla_simbolo[i].valor_i,"--");
			break;
		case CteString:
			fprintf(arch, "|%-30s|%-30s|%-30d", "CTE_STRING",&(tabla_simbolo[i].valor_s), tabla_simbolo[i].longitud);
			break;
    	case CteBinaria:
			fprintf(arch, "|%-30s|%-30d|%-30d", "CTE_BINARIA",tabla_simbolo[i].valor_i, "--");
			break;
    	case CteHexa:
			fprintf(arch, "|%-30s|%-30d|%-30d", "CTE_HEXA",tabla_simbolo[i].valor_i, "--");
			break;
		}

		fprintf(arch, "\n");
	}
	fclose(arch);
}

/** Agrega una constante string a la tabla de simbolos */
void agregarCteStringATabla(char* str){
	if(fin_tabla >= TAMANIO_TABLA - 1){
		printf("Error: No hay mas espacio en la tabla de simbolos.\n");
		system("Pause");
		exit(2);
	}

	char nombre[31] = "_";

	int length = strlen(str);
	char auxiliar[length];
	strcpy(auxiliar,str);
	auxiliar[strlen(auxiliar)-1] = '\0';

	//Queda en auxiliar el valor SIN COMILLAS
	strcpy(auxiliar, auxiliar+1);

	//Queda en nombre como lo voy a guardar en la tabla de simbolos 
	strcat(nombre, auxiliar); 

	//Si no hay otra variable con el mismo nombre...
	if(buscarEnTabla(nombre) == -1){
		//Agregar nombre a tabla
		fin_tabla++;
		escribirNombreEnTabla(nombre, fin_tabla);

		//Agregar tipo de dato
		tabla_simbolo[fin_tabla].tipo_dato = CteString;

		//Agregar valor a la tabla
		strcpy(tabla_simbolo[fin_tabla].valor_s, auxiliar); 

		//Agregar longitud
		tabla_simbolo[fin_tabla].longitud = strlen(tabla_simbolo[fin_tabla].valor_s);
	}
}

/** Agrega una constante real a la tabla de simbolos */
void agregarCteRealATabla(float valor){
	if(fin_tabla >= TAMANIO_TABLA - 1){
		printf("Error: No hay mas espacio en la tabla de simbolos.\n");
		system("Pause");
		exit(2);
	}

	//Genero el nombre
	char nombre[12];
	sprintf(nombre, "_%f", valor);

	//Si no hay otra variable con el mismo nombre...
	if(buscarEnTabla(nombre) == -1){
		//Agregar nombre a tabla
		fin_tabla++;
		escribirNombreEnTabla(nombre, fin_tabla);

		//Agregar tipo de dato
		tabla_simbolo[fin_tabla].tipo_dato = CteReal;

		//Agregar valor a la tabla
		tabla_simbolo[fin_tabla].valor_f = valor;
	}
}

/** Agrega una constante entera a la tabla de simbolos */
void agregarCteIntATabla(int valor){
	if(fin_tabla >= TAMANIO_TABLA - 1){
		printf("Error: No hay mas espacio en la tabla de simbolos.\n");
		system("Pause");
		exit(2);
	}

	//Genero el nombre
	char nombre[30];
	sprintf(nombre, "_%d", valor);

	//Si no hay otra variable con el mismo nombre...
	if(buscarEnTabla(nombre) == -1){
		//Agregar nombre a tabla
		fin_tabla++;
		escribirNombreEnTabla(nombre, fin_tabla);

		//Agregar tipo de dato
		tabla_simbolo[fin_tabla].tipo_dato = CteInt;

		//Agregar valor a la tabla
		tabla_simbolo[fin_tabla].valor_i = valor;
	}
}

/** Agrega una constante binaria a la tabla de simbolos */
void agregarCteBinariaATabla(char* str){
	if(fin_tabla >= TAMANIO_TABLA - 1){
		printf("Error: No hay mas espacio en la tabla de simbolos.\n");
		system("Pause");
		exit(2);
	}

	char nombre[31] = "_";
	//Queda en nombre como lo voy a guardar en la tabla de simbolos 
	strcat(nombre, str); 

	int longitud = strlen(str);
	char binario2[longitud-2];
	quitarPrefijo(str,binario2,longitud);
	longitud =  strlen(binario2);
	
	int decimal = binarioADecimal(binario2,longitud);

	//Si no hay otra variable con el mismo nombre...
	if(buscarEnTabla(nombre) == -1){
		//Agregar nombre a tabla
		fin_tabla++;
		escribirNombreEnTabla(nombre, fin_tabla);

		//Agregar tipo de dato
		tabla_simbolo[fin_tabla].tipo_dato = CteBinaria;

		//Agregar valor a la tabla
		tabla_simbolo[fin_tabla].valor_i = decimal;
	}
}

/** Agrega una constante hexa a la tabla de simbolos */
void agregarCteHexaATabla(char* str){
	if(fin_tabla >= TAMANIO_TABLA - 1){
		printf("Error: No hay mas espacio en la tabla de simbolos.\n");
		system("Pause");
		exit(2);
	}

	char nombre[31] = "_";
	//Queda en nombre como lo voy a guardar en la tabla de simbolos 
	strcat(nombre, str); 

	int longitud = strlen(str);
	char hexa2[longitud-2];
	quitarPrefijo(str,hexa2,longitud);
	longitud =  strlen(hexa2);
	int decimal = hexadecimalADecimal(hexa2,longitud);

	//Si no hay otra variable con el mismo nombre...
	if(buscarEnTabla(nombre) == -1){
		//Agregar nombre a tabla
		fin_tabla++;
		escribirNombreEnTabla(nombre, fin_tabla);

		//Agregar tipo de dato
		tabla_simbolo[fin_tabla].tipo_dato = CteHexa;

		//Agregar valor a la tabla
		tabla_simbolo[fin_tabla].valor_i = decimal;
	}
}

/** Se fija si ya existe una entrada con ese nombre en la tabla de simbolos. Si no existe, muestra un error de variable sin declarar y aborta la compilacion. */
void chequearVarEnTabla(char* nombre){
	//Si no existe en la tabla, error
	if( buscarEnTabla(nombre) == -1){
		char msg[100];
		sprintf(msg,"La variable '%s' debe ser declarada previamente en la seccion de declaracion de variables", nombre);
		yyerror(msg);
	}
	//Si existe en la tabla, dejo que la compilacion siga
}
