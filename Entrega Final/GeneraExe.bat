flex lexico.l
pause
bison -dyv Sintactico.y
pause
gcc.exe lex.yy.c y.tab.c -o Grupo04.exe
pause
pause
Grupo04.exe Prueba.txt

del Grupo04.exe
del lex.yy.c
del y.tab.c
del y.output
del y.tab.h
pause

