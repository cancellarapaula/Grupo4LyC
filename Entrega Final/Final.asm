.MODEL LARGE
.386
.STACK 200h



.DATA

contador dd ?                         
promedio dd ?                          
actual dd ?                        
suma dd ?                    
_Prueba.txt LyC Tema 2! db "Prueba.txt LyC Tema 2!", '$'                          
T_Read db "Ing entero para actual", '$', 16 dup (?)                          
_0 dd 0.0                          
_2.500000 dd 2.500000                       
_0xA2B0 dd 41648.0                       
_9 dd 9.0                         
_1 dd 1.0                          
_0.342000 dd 0.342000.0                           
_2 dd 2.0                           
_4 dd 4.0                          
_La suma es: db "La suma es:", '$'                            
_0b10 dd 2.0                  
_act es > 2 y != de cero db "act es > 2 y != de cero", '$'                        
_0b111010 dd 58.0                            
_no es mayor que 2 db "no es mayor que 2", '$'                            


.CODE

START:

MOV AX,@DATA
MOV DS, AX
FINIT

DisplayString _Prueba.txt LyC Tema 2!,1
newLine

mov dx, OFFSET T_Read
    mov ah,9
    int 21h
    
    GetInteger actual
    
    FILD actual ;
    
    FILD _0       ;st0=0
    FSTP contador  
    
    FLD _02.500000 ;st0=2.5
    FILD _0xA2B0 ;st1=41648.0
    FADD  ; st1 y st0 = 41650.5
    FSTP suma
    
Etiq_1:
    FLD contador
    FILD _9 ;st0=9 y st1=contador
    FXCH
    FCOM ;0-1
    FSTSW AX
    SAHF
    FFREE
    JA Etiq_18:
    FLD contador
    FLD _1
    FADD
    FSTP contador
    
    FILD contador
    FLD _0.342000
    FXCH
    FDIV 
    FSTP @aux2 ;lo guardo para poder sumarlo con el (contador * @max)
    
    FLD actual
    FLD contador
    FMUL
    FSTP @max
    
    FLD _cte32767
    FSTP @aux
    
Etiq_2: 
    FLD @max
    FCOM 
    FSTSW AX
    SAHF
    FFREE
    JAE Etiq_4;si @max es mayor que @aux salta a Etiq_4
    
Etiq_3:  ;parte verdadera
    FXCH ;st0 = @aux
    FSTP @max

Etiq_4: ;end_if
    FILD _2
    FSTP @aux
    FLD @max
    FCOM 
    FSTSW AX
    SAHF
    FFREE
    JAE Etiq_6 ;si @max es mayor que @aux salta a Etiq_6
    
Etiq_5:  ;parte verdadera
    FXCH ;st0 = @aux
    FSTP @max

Etiq_6: ;end_if
    
    FLD actual
    FLD suma
    FMUL
    FSTP @aux
    FLD @max
    FCOM 
    FSTSW AX
    SAHF
    FFREE
    JAE Etiq_8 ;si @max es mayor que @aux salta a Etiq_8
    
Etiq_7:  ;parte verdadera
    FXCH ;st0 = @aux
    FSTP @max

Etiq_8:
    FILD _4
    FSTP @max2
    
    FLD _cte32767
    FSTP @aux
    
Etiq_9: 
    FLD @max
    FCOM 
    FSTSW AX
    SAHF
    FFREE
    JAE Etiq_11;si @max es mayor que @aux salta a Etiq_11
    
Etiq_10:  ;parte verdadera
    FXCH ;st0 = @aux
    FSTP @max2
    
Etiq_11:
    FLD actual
    FSTP @aux
    FLD @max
    FCOM 
    FSTSW AX
    SAHF
    FFREE
    JAE Etiq_13 ;si @max2 es mayor que @aux salta a Etiq_13

Etiq_12:  ;parte verdadera
    FXCH ;st0 = @aux
    FSTP @max2

Etiq_13:
    FILD _2
    FSTP @aux
    FLD @max
    FCOM 
    FSTSW AX
    SAHF
    FFREE
    JAE Etiq_15 ;si @max2 es mayor que @aux salta a Etiq_15
    
Etiq_14:  ;parte verdadera
    FXCH ;st0 = @aux
    FSTP @max2

Etiq_15:
    FSTP @aux ;pongo en @aux st0 (@max2)
    FLD @max
    FCOM 
    FSTSW AX
    SAHF
    FFREE
    JAE Etiq_17 ;si @max es mayor que @aux salta a Etiq_17

Etiq_16:
    FXCH ;st0 = @aux
    FSTP @max

Etiq_17:
    FILD contador ;st0=contador y st1=@max
    FMUL ; st0=(contador * @max)
    FSTP @aux2 ; st0=(contador/_0.342) y st1=(contador * @max)
    FADD
    FSTP actual
    
    FLD suma
    FLD actual
    FADD 
    FSTP suma
    
    JMP Etiq_1 ;fin del while salto a Etiq_1 y vuelvo a preguntar 
    
Etiq_18:
    DisplayString _La suma es:,1
    newLine
    DisplayFloat suma,2
    
    FLD actual
    FLD _0b10 ;st0=2 y st1=actual
    FXCH
    FCOM
    FSTSW AX
    SAHF
    FFREE
    JNA Etiq_20 ; si actual no es mayor a 2

Etiq_19:
    DisplayString _act es > 2 y != de cero
    newLine
    
Etiq_20: ;parte falsa
    FLD actual
    FLD _0b111010
    FXCH
    FCOM
    FSTSW AX
    SAHF
    FFREE
    JAE Etiq_22 ;si actual no es menor que 58
    
Etiq_21: ;parte verdadera
    DisplayString _no es mayor que 2
    newLine
    
Etiq_22:


MOV AH, 1
INT 21h
MOV AX, 4C00h
INT 21h

END START