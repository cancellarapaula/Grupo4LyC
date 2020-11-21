flex lexico.l
pause
bison -dyv Sintactico.y
pause
gcc.exe lex.yy.c y.tab.c -o Segunda.exe
pause
pause
Segunda.exe Prueba.txt

del Segunda.exe
del lex.yy.c
del y.tab.c
del y.output
del y.tab.h
pause

