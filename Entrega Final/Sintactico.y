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
 *	   3-Árbol Sintáctico
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
	
	// estructura de nodos para arbol sintactico -----
	struct nodo {
	char *valor;
	struct nodo *left;
	struct nodo *right;
	};

	struct nodo *raiz = NULL;
	struct nodo *AsigP = NULL;
	struct nodo *ExpP = NULL;
	struct nodo *AuxExpP = NULL;
	struct nodo *TermP = NULL;
	struct nodo *FactP = NULL;

	struct nodo *IFp = NULL;
	struct nodo *DecisionP = NULL;
	struct nodo *AuxDecisionP = NULL;
	struct nodo *CondP = NULL;
	struct nodo *AuxCondP = NULL;
	struct nodo *BloqueSentP = NULL;
	struct nodo *AuxBloqueSentP = NULL;
	struct nodo *BloqueIntP = NULL;
	struct nodo *BSi = NULL;
	struct nodo *BSd = NULL;
	struct nodo *SentP = NULL;
	struct nodo *CicloP = NULL;
	struct nodo *EntradaP = NULL;
	struct nodo *SalidaP = NULL;
	struct nodo *ListaP = NULL;
	struct nodo *AuxListaP = NULL;
	struct nodo *MaximoP = NULL;
	struct nodo *AuxBloqueInternoP = NULL;
	struct nodo *BloqueInternoP = NULL;

	struct nodo *crearHojaArbol(char *);
	struct nodo *crearNodoArbol(char *, struct nodo *, struct nodo *);

	char* _comparacion;
	char* _decision;

	//------------------------------------------------
	struct Stack {
		int top;
		unsigned capacity;
		struct nodo** array;
	};

	struct Stack *stackDecision;
	struct Stack *stackParentesis;
	struct Stack *stackBloque;
	struct Stack *stackBloqueInterno;
	struct Stack *stackLista;

	struct Stack* createStack(unsigned capacity);
	int isFull(struct Stack* stack);
	int isEmpty(struct Stack* stack);
	void push(struct Stack* stack, struct nodo *item);
	struct nodo* pop(struct Stack* stack);
	struct nodo *desapilar(struct Stack* stack);

	//------------------------------------------------
	/*graph */
	void addDot (struct nodo *raiz);
	void crearArchivoDot(struct nodo * raiz);
	char* strReplace(char* search, char* replace, char* subject);

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
	FILE* archIntermedia = NULL;

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
%token OP_AND
%token OP_OR
%token OP_NEGACION
%token <valor_string>CTE_INT
%token <valor_string>CTE_REAL
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

%start start

%%
start: programa                   {
									printf("Regla 0: START es programa\n");
									printf("\n\nCOMPILACION EXITOSA\n\n");
                                    guardarTabla();
								}
programa:  	   	   
  	bloque_declaracion bloque   {
                                    printf("Regla 1: PROGRAMA es bloque_declaracion bloque\n");
									raiz = BloqueSentP;
                                  }
	|bloque						{
                                    printf("Regla 2: PROGRAMA es bloque\n");
									raiz = BloqueSentP;
                                  }
;  

bloque_declaracion:         	        	
  bloque_declaracion declaracion {printf("Regla 3: BLOQUE_DECLARACION es bloque_declaracion declaracion\n");}
  |declaracion                   {printf("Regla 4: BLOQUE_DECLARACION es declaracion\n");}
;

declaracion:  
  DIM OP_MENOR lista_var OP_MAYOR AS OP_MENOR lista_tipos OP_MAYOR {printf("Regla 5: DECLARACION\n");}
;

lista_var:  
  lista_var COMA ID              {
                                  printf("Regla 6: LISTA_VAR es lista_var, ID\n");
								  	cantVarsADeclarar++;
                                  	agregarVarATabla(yylval.valor_string);
                                  }
  |ID                            {
                                  printf("Regla 7: LISTA_VAR es id\n");
								  cantVarsADeclarar=0;
                                  agregarVarATabla(yylval.valor_string);
									varADeclarar1 = fin_tabla; /* Guardo posicion de primer variable de esta lista de declaracion. */
                                }
;

lista_tipos:
  lista_tipos COMA tipo_dato    {
                                  printf("Regla 8: LISTA_TIPOS es lista_tipos,tipo_dato\n");
                                  cantTipoDatoDeclarado++;
								  agregarTiposDatosATabla();
                                }
  |tipo_dato                    {
                                  printf("Regla 9: LISTA_TIPOS es tipo_dato\n");
								  cantTipoDatoDeclarado = 0;
                                  agregarTiposDatosATabla();
                                }
  ;

tipo_dato:
  INTEGER                       {
                                  printf("Regla 10: TIPO_DATO es integer\n");
                                  tipoDatoADeclarar = Integer;
                                }
  |FLOAT                        {
                                  printf("Regla 11: TIPO_DATO es float\n");
                                  tipoDatoADeclarar = Float;
                                }
  |STRING                       {
                                  printf("Regla 12: TIPO_DATO es string\n");
                                  tipoDatoADeclarar = String;
                                }
;

bloque: 
  bloque sentencia
								{
									printf("Regla 13: BLOQUE es bloque sentencia\n");
									AuxBloqueSentP = desapilar(stackBloque);
									BloqueSentP = crearNodoArbol("BS", AuxBloqueSentP, SentP);
									push(stackBloque, BloqueSentP);
								}
  |sentencia                    {
	  								printf("Regla 14: BLOQUE es sentencia\n"); 
									BloqueSentP = SentP;
									push(stackBloque, BloqueSentP);
								}
;
bloque_interno:
  bloque_interno sentencia
								{
									printf("Regla 15: BLOQUE_INTERNO es bloque_interno sentencia\n");
									AuxBloqueInternoP = desapilar(stackBloqueInterno);
									BloqueInternoP = crearNodoArbol("BI", AuxBloqueInternoP, SentP);
									push(stackBloqueInterno, BloqueInternoP);
								}
  |sentencia
								{
									printf("Regla 16: BLOQUE_INTERNO es sentencia\n");
									BloqueInternoP = SentP;
									push(stackBloqueInterno, BloqueInternoP);
								}
;
sentencia:
  ciclo                         {
	  								printf("Regla 17: SENTENCIA es ciclo\n");
  									SentP = CicloP;}
  |if                           {
	  								printf("Regla 18: SENTENCIA es if\n");
									SentP = IFp;
								}
  |asignacion                   {
	  								printf("Regla 19: SENTENCIA es asignacion\n");
									SentP = AsigP;
								}                
  |salida                       {
									printf("Regla 20: SENTENCIA es salida\n");
									SentP = SalidaP;
								}
  |entrada                      {
	  								printf("Regla 21: SENTENCIA es entrada\n");
									SentP = EntradaP;
								}             
;

ciclo:
	WHILE P_A decision P_C LL_A bloque_interno LL_C {
												printf("Regla 22: CICLO es while(decision){bloque}\n");
												DecisionP = desapilar(stackDecision); 
												BloqueInternoP = desapilar(stackBloqueInterno);
												CicloP = crearNodoArbol("while", DecisionP, BloqueInternoP);
											}
;

asignacion: 
	ID OP_ASIG expresion P_Y_C {
                                chequearVarEnTabla($1);
                                printf("Regla 23: ASIGNACION es id:=expresion; \n");
								AsigP = crearNodoArbol(":=", crearHojaArbol($1), ExpP);
                              }
;

if: 
	IF P_A decision P_C LL_A bloque LL_C	{
												printf("Regla 24: IF es if(decision){bloque}\n");
												DecisionP = desapilar(stackDecision);  
												BloqueSentP = desapilar(stackBloque);
												IFp = crearNodoArbol("if", DecisionP, BloqueSentP);
											}
	|IF P_A decision P_C LL_A bloque LL_C	{ BSd = desapilar(stackBloque); } ELSE LL_A bloque LL_C { BSi = desapilar(stackBloque); }
											{
												printf("Regla 25: IF es if(decision){bloque} else {bloque}\n");
												DecisionP = desapilar(stackDecision);
												struct nodo *cuerpo = crearNodoArbol("cuerpo", BSd, BSi);
												IFp = crearNodoArbol("if", DecisionP, cuerpo);
											}
;

decision:
  decision {AuxDecisionP = DecisionP;} logico condicion {
	  															printf("Regla 26: DECISION ES decision op_logico condicion\n");
																DecisionP = crearNodoArbol(_decision, AuxDecisionP, CondP);
																push(stackDecision, DecisionP);
															}
  |condicion                   {
	  								printf("Regla 27: DECISION es condicion\n"); 
									DecisionP = CondP;
									push(stackDecision, DecisionP);
								}
;

logico:
  OP_AND						{printf("Regla 28: LOGICO es and\n");{_decision = "AND";}}
  |OP_OR						{printf("Regla 29: LOGICO es or\n");{_decision = "OR";}}
;
condicion:
  OP_NEGACION condicion			{
	  								printf("Regla 30: CONDICION es not condicion\n"); 
									CondP = crearNodoArbol("NOT", CondP, CondP);
								}
  |expresion {AuxExpP = ExpP;} comparador expresion {
	  													printf("Regla 31: CONDICION es expresion comparador expresion\n");
														CondP = crearNodoArbol(_comparacion, AuxExpP, ExpP);
													}
;

comparador:
  OP_IGUAL                    {printf("Regla 32: COMPARADOR ES =\n");{_comparacion = "==";}}
  |OP_DISTINTO                {printf("Regla 33: COMPARADOR ES <>\n"); {_comparacion = "<>";}}
  |OP_MENORIGUAL              {printf("Regla 34: COMPARADOR ES <=\n"); {_comparacion = "<=";}}
  |OP_MAYORIGUAL              {printf("Regla 35: COMPARADOR ES >=\n"); {_comparacion = ">=";}}
  |OP_MAYOR                   {printf("Regla 36: COMPARADOR ES >\n");{_comparacion = ">";}}
  |OP_MENOR                   {printf("Regla 37: COMPARADOR ES <\n"); {_comparacion = "<";}	}
;

expresion:
  expresion { push(stackParentesis, ExpP); } OP_SUMA termino   {
	  																printf("Regla 38: EXPRESION es expresion+termino\n");
																	ExpP = desapilar(stackParentesis);
																	ExpP = crearNodoArbol("+", ExpP, TermP);
																}
	|expresion{push(stackParentesis, ExpP); }  OP_REST termino  {
																	printf("Regla 39: EXPRESION es expresion-termino\n");
																	ExpP = desapilar(stackParentesis);
																	ExpP = crearNodoArbol("-", ExpP, TermP);
																}
  |termino                   {
	  							printf("Regla 40: EXPRESION es termino\n"); 
  								ExpP = TermP;
							}
;

termino: 
  termino { push(stackParentesis, TermP); } OP_MULT factor      {
	  																printf("Regla 41: TERMINO es termino*factor\n");
																	TermP = desapilar(stackParentesis);
																	TermP = crearNodoArbol("*", TermP, FactP);
																}
	|termino{push(stackParentesis, TermP) ;} OP_DIVI factor     {
																	printf("Regla 42: TERMINO es termino/factor\n");
																	TermP = desapilar(stackParentesis);
																	TermP = crearNodoArbol("/", TermP, FactP);
																}
    |factor                     {
									printf("Regla 43: TERMINO es factor\n"); 
									TermP = FactP;
								}
;

factor:
  P_A expresion P_C				{printf("Regla 44: FACTOR es (expresion)\n");FactP = ExpP;  }  
	|maximo						{printf("Regla 45: FACTOR es maximo\n"); FactP =MaximoP;} 
	|ID                         {
                                	printf("Regla 46: FACTOR es id\n");
                                	chequearVarEnTabla(yylval.valor_string);  
                            		FactP = crearHojaArbol(yylval.valor_string);
								}
	|CTE_STRING                 {
									printf("Regla 47: FACTOR es cte_string\n");
									agregarCteStringATabla(yylval.valor_string);
                            		FactP = crearHojaArbol(yylval.valor_string);
								}
	|CTE_INT                    {
									printf("Regla 48: FACTOR es cte_int\n");
									agregarCteIntATabla(atoi(yylval.valor_string));  
									FactP = crearHojaArbol(yylval.valor_string);
								}
	|CTE_REAL                   {
									printf("Regla 49: FACTOR es cte_real\n");
									agregarCteRealATabla(atof(yylval.valor_string));
									FactP = crearHojaArbol(yylval.valor_string);
								}
	|CTE_BIN                    {
									printf("Regla 50: FACTOR es cte_bin\n");
									agregarCteBinariaATabla(yylval.valor_string);
									FactP = crearHojaArbol(yylval.valor_string);
								}
	|CTE_HEXA                   {
                                	printf("Regla 51: FACTOR es cte_hexa\n");
                                	agregarCteHexaATabla(yylval.valor_string);
									FactP = crearHojaArbol(yylval.valor_string);
								}
;
maximo:
  MAXIMO P_A lista_expresion P_C {printf("Regla 52: MAXIMO es maximo(lista_expresion)\n");
													ListaP = desapilar(stackLista);
													MaximoP=ListaP;}
;

lista_expresion:
  lista_expresion COMA expresion {
	  													printf("Regla 53: LISTA_EXPRESION es lista_expresion,expresion\n");
														ListaP = desapilar(stackLista); 
														struct nodo *asigna = crearNodoArbol(":=", crearHojaArbol("@aux"), ExpP);
														struct nodo *condicion = crearNodoArbol("<", crearHojaArbol("@max"), asigna);
														struct nodo *accion = crearNodoArbol(":=", crearHojaArbol("@max"), crearHojaArbol("@aux"));
														struct nodo *aumenta = crearNodoArbol("if", condicion, accion);
														ListaP = crearNodoArbol("Lista", ListaP, aumenta);
														push(stackLista, ListaP);
														}
  | expresion					{
	  								printf("Regla 54: LISTA_EXPRESION es expresion\n");
									struct nodo * max = crearNodoArbol(":=", crearHojaArbol("@max"), ExpP);
									struct nodo * aux = crearNodoArbol(":=", crearHojaArbol("@aux"), crearHojaArbol("-32767"));
								    struct nodo *condicion = crearNodoArbol("<", max, aux);
									struct nodo *accion = crearNodoArbol(":=", crearHojaArbol("@max"), crearHojaArbol("@aux"));
									ListaP = crearNodoArbol("if", condicion, accion);
									push(stackLista, ListaP);
									
								}
;

salida:
	PUT CTE_STRING P_Y_C		{
									printf("Regla 55: SALIDA es PUT cte_string;\n");
									agregarCteStringATabla(yylval.valor_string);  
									SalidaP = crearNodoArbol("IO", crearHojaArbol("out"), crearHojaArbol(yylval.valor_string));
                            	}
	|PUT ID P_Y_C               {
									chequearVarEnTabla($2);
									printf("Regla 56: SALIDA es PUT id;\n");
									SalidaP = crearNodoArbol("IO", crearHojaArbol("out"), crearHojaArbol(yylval.valor_string));   
                            	}
;

entrada:
  GET ID P_Y_C                {
                            	chequearVarEnTabla($2);
                                printf("Regla 57: ENTRADA es GET id;\n");
								EntradaP = crearNodoArbol("IO", crearHojaArbol("in"), crearHojaArbol(yylval.valor_string));
                              }
;

%%
// ----------------------------------------------------------------------------------

struct nodo *desapilar(struct Stack* stack){
  struct nodo *n = pop(stack);
  if(n) return n;
  printf("ERROR en GCI: El stack se encuentra vacio.\n");
  system("Pause");
  exit(2);
}

struct nodo *crearHojaArbol(char *nombre){
	return crearNodoArbol(nombre, NULL, NULL);
}

struct nodo *crearNodoArbol(char *nombre, struct nodo *left, struct nodo *right){
	struct nodo *hoja;
	hoja = (struct nodo *) malloc(sizeof(struct nodo));

	struct nodo *izq = NULL;
	struct nodo *der = NULL;

	if(left != NULL && right != NULL){
		izq = left;
		der = right;
	}

	(hoja)->valor = nombre;
	(hoja)->right = der;
	(hoja)->left  = izq;

	return hoja;
}

void crearArchivoDot(struct nodo * raiz){
	archIntermedia = fopen("intermedia.dot","w");
	fprintf(archIntermedia, " ");
	archIntermedia = fopen("intermedia.dot", "a");
	fprintf(archIntermedia, " digraph G { \n");

	addDot (raiz);
	fprintf(archIntermedia,"}");
    fclose(archIntermedia);
	const char * cmd1 = " dot intermedia.dot -Tpng -o intermedia.png ";
	system(cmd1);
}

/*Agrega nodo a .dot*/
void addDot (struct nodo *raiz) {	
  if (raiz == NULL) return;
  char* valor;
	if (raiz -> left != NULL){
    	valor = strReplace("\"", "'", raiz->left->valor);
		fprintf(archIntermedia, "\"%p_%s\"->\"%p_%s\" \n",raiz,raiz->valor, raiz->left,valor);
    	addDot(raiz->left);
	}
	if (raiz -> right != NULL){
    	valor = strReplace("\"", "'", raiz->right->valor);
		fprintf(archIntermedia, "\"%p_%s\"->\"%p_%s\" \n",raiz,raiz->valor, raiz->right,valor);
		addDot(raiz->right);
	}
}

// Funciones de pila de punteros  ----------------------------------------
struct Stack* createStack(unsigned capacity) {
  struct Stack* stack = (struct Stack*)malloc(sizeof(struct Stack));
  stack->capacity = capacity;
  stack->top = -1;
  stack->array = (struct nodo**)malloc(stack->capacity * sizeof(struct nodo));
  return stack;
}

int isFull(struct Stack* stack) {
  return stack->top == stack->capacity - 1;
}

int isEmpty(struct Stack* stack) {
  return stack->top == -1;
}

void push(struct Stack* stack, struct nodo *item) {
  if (isFull(stack)) return;
  stack->array[++stack->top] = item;
}

struct nodo* pop(struct Stack* stack) {
  if (isEmpty(stack)) return NULL;
  return stack->array[stack->top--];
}

char* strReplace(char* search, char* replace, char* subject) {
	int i, j, k;

	int searchSize = strlen(search);
	int replaceSize = strlen(replace);
	int size = strlen(subject);

	char* ret;

	if (!searchSize) {
		ret = malloc(size + 1);
		for (i = 0; i <= size; i++) {
			ret[i] = subject[i];
		}
		return ret;
	}

	int retAllocSize = (strlen(subject) + 1) * 2;
	ret = malloc(retAllocSize);

	int bufferSize = 0;
	char* foundBuffer = malloc(searchSize);

	for (i = 0, j = 0; i <= size; i++) {
		if (retAllocSize <= j + replaceSize) {
			retAllocSize *= 2;
			ret = (char*) realloc(ret, retAllocSize);
		}
		else if (subject[i] == search[bufferSize]) {
			foundBuffer[bufferSize] = subject[i];
			bufferSize++;

			if (bufferSize == searchSize) {
				bufferSize = 0;
				for (k = 0; k < replaceSize; k++) {
					ret[j++] = replace[k];
				}
			}
		}
		else {
			for (k = 0; k < bufferSize; k++) {
				ret[j++] = foundBuffer[k];
			}
			bufferSize = 0;

			ret[j++] = subject[i];
		}
	}

	free(foundBuffer);
	return ret;
}

//---------------------principal 

int main(int argc,char *argv[])
{
  if ((yyin = fopen(argv[1], "rt")) == NULL)
  {
	  printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
  }
  else
  {
	stackDecision = createStack(100);
    stackParentesis = createStack(100);
	stackBloque = createStack(100);
	stackBloqueInterno = createStack(100);
	stackLista = createStack(100);
	yyparse();

	crearArchivoDot(raiz);
    fclose(yyin);
  }
  return 0;
}

int yyerror(char* mensaje)
 {
	printf("ERROR SINTACTICO: %s\n", mensaje);
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
		 yyerror("No hay mas espacio en la tabla de simbolos");
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
			fprintf(arch, "|%-30s|%-30d|%-30s", "CTE_BINARIA",tabla_simbolo[i].valor_i, "--");
			break;
    	case CteHexa:
			fprintf(arch, "|%-30s|%-30d|%-30s", "CTE_HEXA",tabla_simbolo[i].valor_i, "--");
			break;
		}

		fprintf(arch, "\n");
	}
	fclose(arch);
}

/** Agrega una constante string a la tabla de simbolos */
void agregarCteStringATabla(char* str){
	if(fin_tabla >= TAMANIO_TABLA - 1){
		yyerror("No hay mas espacio en la tabla de simbolos");
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
		yyerror("No hay mas espacio en la tabla de simbolos");
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
		yyerror("No hay mas espacio en la tabla de simbolos");
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
		yyerror("No hay mas espacio en la tabla de simbolos");
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
		yyerror("No hay mas espacio en la tabla de simbolos");
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
