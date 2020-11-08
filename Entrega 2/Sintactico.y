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
  
  
  // estructura de nodos para arbol sintactico -----
struct node {
  char *value;
  struct node *left;
  struct node *right;
};

struct node *root = NULL;
struct node *AsignacionP = NULL;
struct node *ConstanteP = NULL;
struct node *AuxConstanteP = NULL;
struct node *ExpresionP = NULL;
struct node *AuxExpresionP = NULL;
struct node *AuxExpresion2P = NULL;
struct node *AuxExpresion3P = NULL;
struct node *TerminoP = NULL;
struct node *AuxTerminoP = NULL;
struct node *FactorP = NULL;

struct node *IFp = NULL;
struct node *DecisionP = NULL;
struct node *CondicionP = NULL;
struct node *AuxCondicionP = NULL;
struct node *OperasignaP = NULL;
struct node *AuxOperasignaP = NULL;
struct node *BloqueSentenciaP = NULL;
struct node *AuxBloqueSentenciaP = NULL;
struct node *BloqueInternoP = NULL;
struct node *AuxBloqueInternoP = NULL;
struct node *BSi = NULL;
struct node *BSd = NULL;
struct node *SentenciaP = NULL;
struct node *CicloP = NULL;
struct node *EntradaP = NULL;
struct node *SalidaP = NULL;
struct node *ListaP = NULL;
struct node *AuxListaP = NULL;
struct node *MaximoP = NULL;

struct node *crearHoja(char *);
struct node *crearNodo(char *, struct node *, struct node *);

void _print_h(struct node *, int);
void print_h(struct node *);

char* _comparacion;

//------------------------------------------------
struct Stack {
    int top;
    unsigned capacity;
    struct node** array;
};

struct Stack *stackDecision;
struct Stack *stackParentesis;

struct Stack* createStack(unsigned capacity);
int isFull(struct Stack* stack);
int isEmpty(struct Stack* stack);
void push(struct Stack* stack, struct node *item);
struct node* pop(struct Stack* stack);
struct node *desapilar(struct Stack* stack, struct node* fp);

// estructura para la tabla de simbolos ----------
typedef struct {
	char nombre[30];
	char tipo[10];
	char valor[30];
	int longitud;
	int es_const;
} t_ts;
//------------------------------------------------
/*graph */
void addDot (struct node *root);
void crearArchivoDot(struct node * root);
char* strReplace(char* search, char* replace, char* subject);

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
                                    printf("Regla 0: PROGRAMA es bloque_declaracion bloque\n");
                                    printf("COMPILACION EXITOSA\n");
                                    guardarTabla();
                                  }
	|bloque						{
                                    printf("Regla 1: PROGRAMA es bloque\n");
                                    printf("COMPILACION EXITOSA\n");
									guardarTabla();
                                  }
	{ root = BloqueSentenciaP; }
;  

bloque_declaracion:         	        	
  bloque_declaracion declaracion {printf("Regla 2: BLOQUE_DECLARACION es bloque_declaracion declaracion\n");}
  |declaracion                   {printf("Regla 3: BLOQUE_DECLARACION es declaracion\n");}
;

declaracion:  
  DIM OP_MENOR lista_var OP_MAYOR AS OP_MENOR lista_tipos OP_MAYOR {printf("Regla 4: DECLARACION\n");}
;

lista_var:  
  lista_var COMA ID              {
                                  printf("Regla 5: LISTA_VAR es lista_var, ID\n");
								  	cantVarsADeclarar++;
                                  	agregarVarATabla(yylval.valor_string);
                                  }
  |ID                            {
                                  printf("Regla 6: LISTA_VAR es id\n");
								  cantVarsADeclarar=0;
                                  agregarVarATabla(yylval.valor_string);
									varADeclarar1 = fin_tabla; /* Guardo posicion de primer variable de esta lista de declaracion. */
                                }
;

lista_tipos:
  lista_tipos COMA tipo_dato    {
                                  printf("Regla 7: LISTA_TIPOS es lista_tipos,tipo_dato\n");
                                  cantTipoDatoDeclarado++;
								  agregarTiposDatosATabla();
                                }
  |tipo_dato                    {
                                  printf("Regla 8: LISTA_TIPOS es tipo_dato\n");
								  cantTipoDatoDeclarado = 0;
                                  agregarTiposDatosATabla();
                                }
  ;

tipo_dato:
  INTEGER                       {
                                  printf("Regla 9: TIPO_DATO es integer\n");
                                  tipoDatoADeclarar = Integer;
                                }
  |FLOAT                        {
                                  printf("Regla 10: TIPO_DATO es float\n");
                                  tipoDatoADeclarar = Float;
                                }
  |STRING                       {
                                  printf("Regla 11: TIPO_DATO es string\n");
                                  tipoDatoADeclarar = String;
                                }
;

bloque: 
  bloque { AuxBloqueSentenciaP = BloqueSentenciaP; } sentencia
								{printf("Regla 12: BLOQUE es bloque sentencia\n");
								BloqueSentenciaP = crearNodo("BS", AuxBloqueSentenciaP, SentenciaP);}
  |sentencia                    {printf("Regla 13: BLOQUE es sentencia\n"); BloqueSentenciaP = SentenciaP;}
;

sentencia:
  ciclo                         {printf("Regla 14: SENTENCIA es ciclo\n");} {SentenciaP = CicloP;}
  |if                           {printf("Regla 15: SENTENCIA es if\n");} {SentenciaP = IFp;}
  |asignacion                   {printf("Regla 16: SENTENCIA es asignacion\n");} {SentenciaP = AsignacionP;}                
  |salida                       {printf("Regla 17: SENTENCIA es salida\n");} {SentenciaP = SalidaP;}
  |entrada                      {printf("Regla 18: SENTENCIA es entrada\n");} {SentenciaP = EntradaP;}             
;

ciclo:
	WHILE P_A decision P_C LL_A bloque LL_C {printf("Regla 19: CICLO es while(decision){bloque}\n");
											DecisionP = desapilar(stackDecision, DecisionP); 
											CicloP = crearNodo("while", DecisionP, BloqueInternoP);}
;

asignacion: 
	ID OP_ASIG expresion P_Y_C {
                                chequearVarEnTabla($1);
                                printf("Regla 20: ASIGNACION es id:=expresion;\n");
								AsignacionP = crearNodo(":=", crearHoja($1), ExpresionP);
                              }
;

if: 
	IF P_A decision P_C LL_A bloque LL_C                        {printf("Regla 21: IF es if(decision){bloque}\n");
																DecisionP = desapilar(stackDecision, DecisionP);  
																IFp = crearNodo("if", DecisionP, BloqueInternoP);}
	|IF P_A decision P_C LL_A bloque LL_C { BSd = BloqueInternoP; } ELSE LL_A bloque LL_C { BSi = BloqueInternoP; }
											{printf("Regla 22: IF es if(decision){bloque} else {bloque}\n");
											DecisionP = desapilar(stackDecision, DecisionP);
											struct node *cuerpo = crearNodo("cuerpo", BSd, BSi);
											IFp = crearNodo("if", DecisionP, cuerpo);}
;

decision:
  decision {AuxDecisionP = DecisionP;} OP_LOGICO condicion {printf("Regla 23: DECISION ES decision op_logico condicion\n");
															DecisionP = crearNodo(OP_LOGICO, AuxCondicionP, CondicionP);
															push(stackDecision, DecisionP);
}
  |condicion                   {printf("Regla 24: DECISION es condicion\n"); DecisionP = CondicionP; push(stackDecision, DecisionP);}
;

condicion:
  OP_NEGACION condicion           {printf("Regla 25: CONDICION es not condicion\n"); CondicionP = crearNodo(“NOT”, CondicionP, CondicionP);}
  |expresion {AuxExpresionP = ExpresionP;} comparador expresion {printf("Regla 26: CONDICION es expresion comparador expresion\n");
																 CondicionP = crearNodo(_comparacion, AuxExpresionP, ExpresionP);}
;

comparador:
  OP_IGUAL                    {printf("Regla 27: COMPARADOR ES =\n");{_comparacion = "==";}}
  |OP_DISTINTO                {printf("Regla 28: COMPARADOR ES <>\n"); {_comparacion = "<>";}}
  |OP_MENORIGUAL              {printf("Regla 29: COMPARADOR ES <=\n"); {_comparacion = "<=";}}
  |OP_MAYORIGUAL              {printf("Regla 30: COMPARADOR ES >=\n"); {_comparacion = ">=";}}
  |OP_MAYOR                   {printf("Regla 31: COMPARADOR ES >\n");{_comparacion = ">";}}
  |OP_MENOR                   {printf("Regla 32: COMPARADOR ES <\n"); {_comparacion = "<";}	}
;

expresion:
  expresion { push(stackParentesis, ExpresionP); } OP_SUMA termino   {printf("Regla 33: EXPRESION es expresion+termino\n");
																	ExpresionP = desapilar(stackParentesis, ExpresionP);
																	ExpresionP = crearNodo("+", ExpresionP, TerminoP);}
	|expresion{ push(stackParentesis, ExpresionP); }  OP_REST termino  {printf("Regla 34: EXPRESION es expresion-termino\n");
																		ExpresionP = desapilar(stackParentesis, ExpresionP);
																		ExpresionP = crearNodo("-", ExpresionP, TerminoP);}
  |termino                    {printf("Regla 35: TERMINO es termino\n"); ExpresionP = TerminoP;}
;

termino: 
  termino { push(stackParentesis, TerminoP); }OP_MULT factor      {printf("Regla 36: TERMINO es termino*factor\n");
																	TerminoP = desapilar(stackParentesis, TerminoP);
																	TerminoP = crearNodo("*", TerminoP, FactorP);}
	|termino{push(stackParentesis, TerminoP) ;}  OP_DIVI factor     {printf("Regla 37: TERMINO es termino/factor\n");
																	TerminoP = desapilar(stackParentesis, TerminoP);
																	TerminoP = crearNodo("/", TerminoP, FactorP);}
    |factor                     {printf("Regla 38: TERMINO es factor\n"); TerminoP = FactorP;}
;

factor:
  P_A expresion P_C           {printf("Regla 39: FACTOR es (expresion)\n");} FactorP = ExpresionP;    
  |maximo                     {printf("Regla 40: FACTOR es maximo\n");} FactorP =MaximoP;
	|ID                         {
                                printf("Regla 41: FACTOR es id\n");
                                chequearVarEnTabla(yylval.valor_string);  
                              }
							  {FactorP = crearHoja(yylval.valor_string);}
	|CTE_STRING                 {
                                printf("Regla 42: FACTOR es cte_string\n");
                                agregarCteStringATabla(yylval.valor_string);
                              }
							  {FactorP = crearHoja(yylval.valor_string);}
	|CTE_INT                    {
                                printf("Regla 43: FACTOR es cte_int\n");
                                agregarCteIntATabla(yylval.valor_int);  
                              }
							  {FactorP = crearHoja(yylval.valor_int);}
	|CTE_REAL                   {
                                printf("Regla 44: FACTOR es cte_real\n");
                                agregarCteRealATabla(yylval.valor_float);
								}
								{FactorP = crearHoja(yylval.valor_float);}
	|CTE_BIN                    {
                                printf("Regla 45: FACTOR es cte_bin\n");
                                agregarCteBinariaATabla(yylval.valor_string);
                              }
							  {FactorP = crearHoja(yylval.valor_string);}
	|CTE_HEXA                   {
                                printf("Regla 46: FACTOR es cte_hexa 1 1 \n");
                                agregarCteHexaATabla(yylval.valor_string);
								
                              }
							  {FactorP = crearHoja(yylval.valor_string);}
;
maximo:
  MAXIMO P_A lista_expresion P_C {printf("Regla 47: MAXIMO es maximo(lista_expresion)\n");}
;

lista_expresion:
  lista_expresion  { AuxListaP = ListaP; } COMA expresion {printf("Regla 48: LISTA_EXPRESION es lista_expresion,expresion\n");
														struct node *compara = crearNodo("==", crearHoja("@aux"), ExpresionP);
														struct node *aumenta = crearNodo("+=", crearHoja("@cont"), crearHoja("1"));
														struct node *condicion = crearNodo("if", compara, aumenta);
														ListaP = crearNodo("Lista", AuxListaP, condicion);}
  | expresion                     {printf("Regla 49: LISTA_EXPRESION es expresion\n");
								    struct node *compara = crearNodo("==", crearHoja("@aux"), ExpresionP);
									struct node *aumenta = crearNodo("+=", crearHoja("@cont"), crearHoja("1"));
									ListaP = crearNodo("if", compara, aumenta);}
;

salida:
	PUT CTE_STRING P_Y_C        {
                                printf("Regla 50: SALIDA es PUT cte_string;\n");
                                agregarCteStringATabla(yylval.valor_string);  
								SalidaP = crearNodo("IO", crearHoja("out"), crearHoja(yylval.valor_string));
                              }
	|PUT ID P_Y_C               {
                                chequearVarEnTabla($2);
                                printf("Regla 51: SALIDA es PUT id;\n");
								SalidaP = crearNodo("IO", crearHoja("out"), crearHoja(yylval.valor_string));   
                              }
;

entrada:
  GET ID P_Y_C                {
                                chequearVarEnTabla($2);
                                printf("Regla 52: ENTRADA es GET id;\n");
								EntradaP = crearNodo("IO", crearHoja("in"), crearHoja(yylval.valor_string));
                              }
;

%%
// ----------------------------------------------------------------------------------

struct node *desapilar(struct Stack* stack, struct node* fp){
  struct node *n = pop(stack);
  if(n) return n;
  return fp;
}

struct node *crearHoja(char *nombre){
	return crearNodo(nombre, NULL, NULL);
}

struct node *crearNodo(char *nombre, struct node *left, struct node *right){
	struct node *hoja;
	hoja = (struct node *) malloc(sizeof(struct node));

	struct node *izq = NULL;
	struct node *der = NULL;

	if(left != NULL && right != NULL){
		izq = left;
		der = right;
	}

	(hoja)->value = nombre;
	(hoja)->right = der;
	(hoja)->left  = izq;

	return hoja;
}

void _print_h(struct node *root, int space) {
	int i;
  if (root == NULL) return;
  space += COUNT;
  _print_h(root->right, space);
  printf("\n");
  for (i = COUNT; i < space; i++) printf(" ");
  printf("%p %s \n", root,root->value);
  _print_h(root->left, space);
}

void print_h(struct node *root){
  _print_h(root, 0);
  printf("\n\n");
}

void crearArchivoDot(struct node * root){
	fp = fopen("intermedia.dot","w");
	fprintf(fp, " ");
	fp = fopen("intermedia.dot", "a");
	fprintf(fp, " digraph G { \n");

	addDot (root);
	fprintf(fp,"}");
    fclose(fp);
	const char * cmd1 = " dot intermedia.dot -Tpng -o intermedia.png ";
	system(cmd1);
}

/*Agrega nodo a .dot*/
void addDot (struct node *root) {
  if (root == NULL) return;
  char* value;
	if (root -> left != NULL){
    value = strReplace("\"", "'", root->left->value);
		fprintf(fp, "\"%p_%s\"->\"%p_%s\" \n",root,root->value, root->left,value);
    	addDot(root->left);
	}
	if (root -> right != NULL){
    value = strReplace("\"", "'", root->right->value);
		fprintf(fp, "\"%p_%s\"->\"%p_%s\" \n",root,root->value, root->right,value);
		addDot(root->right);
	}
}
//---------------------principal 

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
