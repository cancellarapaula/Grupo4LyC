c:\GnuWin32\bin\flex lexico.l
pause
c:\GnuWin32\bin\bison -dyv Sintactico.y
pause
c:\MinGW\bin\gcc.exe lex.yy.c y.tab.c -o Primera.exe
pause
pause
Primera.exe Prueba.txt

del Primera.exe
del lex.yy.c
del y.tab.c
del y.output
del y.tab.h
del TPFinal.exe
pause

