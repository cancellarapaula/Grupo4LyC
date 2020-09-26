c:\GnuWin32\bin\flex lexico.l
pause
c:\MinGW\bin\gcc.exe lex.yy.c -o Grupo4.exe
pause
pause
Grupo4.exe Prueba.txt

del lex.yy.c
del Grupo4.exe
pause