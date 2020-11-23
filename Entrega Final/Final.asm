include macros2.asm
include number.asm

.MODEL LARGE
.STACK 200h
.386
.387

MAXTEXTSIZE equ 30

.DATA

contador                            DD (?)
promedio                            DD (?)
actual                              DD (?)
suma                                DD (?)
_prueba.txtLycTema2!                DB "Prueba.txt LyC Tema 2!",'$', 022 dup (?)
_ingEnteroParaactual                DB "Ing entero para actual: ",'$', 024 dup (?)
_0                                  DD 0.00
_2.500000                           DD 2.500000
_0xA2B0                             DD 41648.00
_9                                  DD 9.00
_1                                  DD 1.00
_0.342000                           DD 0.342000
@max0                               DD (?)
@aux0                               DD (?)
_2                                  DD 2.00
_4                                  DD 4.00
@max1                               DD (?)
@aux1                               DD (?)
_laSumaEs                           DB "La suma es: ",'$', 012 dup (?)
_0b10                               DD 2.00
_actEs>2Y!=DeCero                   DB "act es > 2 y != de cero",'$', 023 dup (?)
_0b111010                           DD 58.00

.CODE

START:
MOV AX, @DATA
MOV DS,AX
FINIT
FFREE

FINAL:
mov ah, 1
int 21h
MOV AX, 4C00h
INT 21h
END START