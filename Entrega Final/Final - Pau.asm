include macros2.asm
include number.asm

.MODEL LARGE
.386
.STACK 200h




.DATA

contador dd ?                         
promedio dd ?                          
actual dd ?                        
suma dd ?                    
@msg_prueba db "Prueba.txt LyC Tema 2!", '$'   
@msg_prueba_1 db "ENTRO AL WHILE", '$'                       
@msg_ingreso db "Ing entero para actual: ", '$', 16 dup(?)                           
_0 dd 0                        
_2_5 dd 2.500000                       
_0xA2B0 dd 41648                 
_9 dd 9                        
_1 dd 1                         
_0_342 dd 0.342000                           
_2 dd 2                         
_4 dd 4                        
@msg_suma db "La suma es:", '$'                            
_0b10 dd 2                  
@msg_verdadero db "act es > 2 y != de cero", '$'                        
_0b111010 dd 58                          
@msg_falso db "no es mayor que 2", '$'       
@max dd ?
@aux dd ?
@aux2 dd ?
@aux3 dd ?
@max2 dd ?
_cte32767 dd -32767
                     


.CODE

START:

	mov AX,@DATA
	mov DS,AX
	mov DS,AX
	mov es,ax

	DisplayString @msg_prueba,1
	newLine

    DisplayString @msg_ingreso
	GetInteger actual
    
    FILD actual 
    
    FILD _0       ;st0=0
    FSTP contador  
    FLD _2_5 ;st0=2.5
    FILD _0xA2B0 ;st1=41648.0
    FADD  ; st1 y st0 = 41650.5
    FSTP suma
	
    DisplayFloat suma,1
    newLine
Etiq_1:
    FILD contador
	FLD _9 ;st0=9 y st1=contador
    FXCH
    FCOM ;0-1
    FSTSW AX
    SAHF
    FFREE
	   
    JA Etiq_18
	DisplayString @msg_prueba_1,1
    newLine
    FILD contador
    FLD _1
    FADD
    FSTP contador
    DisplayInteger contador
    newLine
    FILD contador
    FLD _0_342
    FDIV 
    FSTP @aux2 ;lo guardo para poder sumarlo con el (contador * @max)
    DisplayFloat @aux2,1
    newLine
    FLD actual
    FILD contador
	FMUL
    FSTP @max
    DisplayInteger @max,1
    newLine
    FLD _cte32767
    FSTP @aux
    
Etiq_2: 
    FLD @max
	FXCH
	FCOM 
    FSTSW AX
    SAHF
    FFREE
    JAE Etiq_4;si @max es mayor que @aux salta a Etiq_4
    
Etiq_3:  ;parte verdadera
	FLD @aux
    FSTP @max
	DisplayInteger @max,1
    newLine

Etiq_4: ;end_if
    FLD _2
    FSTP @aux
	FLD @max
    FCOM 
    FSTSW AX
    SAHF
    FFREE
    JAE Etiq_6 ;si @max es mayor que @aux salta a Etiq_6
    
Etiq_5:  ;parte verdadera
    FLD @aux
    FSTP @max
DisplayInteger @max,1
    newLine
Etiq_6: ;end_if
    
    FLD actual
    FLD suma
    FMUL
    FSTP @aux
	DisplayInteger @aux,1
    newLine
	FXCH
	FLD @max
    FCOM 
    FSTSW AX
    SAHF
    FFREE
    JAE Etiq_8 ;si @max es mayor que @aux salta a Etiq_8
    
Etiq_7:  ;parte verdadera
    FLD @aux ;st0 = @aux
    FSTP @max
DisplayInteger @max,1
    newLine
Etiq_8:
    FLD _4
    FSTP @max2
    
    FLD _cte32767
    FSTP @aux
    
Etiq_9: 
    FLD @max2
	FCOM 
    FSTSW AX
    SAHF
    FFREE
    JAE Etiq_11;si @max es mayor que @aux salta a Etiq_11
    
Etiq_10:  ;parte verdadera
    FLD @aux ;st0 = @aux
    FSTP @max2
    
Etiq_11:
    FLD actual
    FSTP @aux
	FXCH
	
    FLD @max2
    FCOM 
    FSTSW AX
    SAHF
    FFREE
    JAE Etiq_13 ;si @max2 es mayor que @aux salta a Etiq_13

Etiq_12:  ;parte verdadera
    FLD @aux ;st0 = @aux
    FSTP @max2
	
Etiq_13:
    FLD _2
    FSTP @aux
	FXCH
    FLD @max2
    FCOM 
    FSTSW AX
    SAHF
    FFREE
    JAE Etiq_15 ;si @max2 es mayor que @aux salta a Etiq_15
    
Etiq_14:  ;parte verdadera
    FLD @aux ;st0 = @aux
    FSTP @max2
DisplayInteger @max2,1
    newLine
Etiq_15:
	FLD @max2
    FSTP @aux ;pongo en @aux st0 (@max2)
	
	FXCH
    FLD @max
    FCOM 
    FSTSW AX
    SAHF
    FFREE
	
    JAE Etiq_17 ;si @max es mayor que @aux salta a Etiq_17
	

Etiq_16:
    FLD @aux ;st0 = @aux
    FSTP @max
	

Etiq_17:
	FLD @max
	FILD contador ;st0=contador y st1=@max
	FMUL ; st0=(contador * @max)
	FSTP @aux3
	FFREE
    FLD @aux2 ; st0=(contador/_0.342) y st1=(contador * @max)
	FLD @aux3
	FADD
	FSTP actual
	FLD suma
	FADD 
    FSTP suma
	DisplayFloat suma,2
    newLine
	
    JMP Etiq_1 ;fin del while salto a Etiq_1 y vuelvo a preguntar 
    
Etiq_18:
    DisplayString @msg_suma,1
    newLine
    DisplayFloat suma,2
    newLine
	
    FLD actual
    FLD _0b10 ;st0=2 y st1=actual
    FXCH
    FCOM
    FSTSW AX
    SAHF
    FFREE
    JNA Etiq_20 ; si actual no es mayor a 2

Etiq_19:
    DisplayString @msg_verdadero
    newLine
	JMP Etiq_22
    
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
    DisplayString @msg_falso
    newLine
    
Etiq_22:


MOV AH, 1
INT 21h
MOV AX, 4C00h
INT 21h

END START