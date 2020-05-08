#include "p16F628a.inc"    ;incluir librerias relacionadas con el dispositivo
 __CONFIG _FOSC_INTOSCCLK & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _CP_OFF    
;configuraci�n del dispositivotodo en OFF y la frecuencia de oscilador
;es la del "reloj del oscilador interno" (INTOSCCLK)     
RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    START                   ; go to beginning of program
; TODO ADD INTERRUPTS HERE IF USED
MAIN_PROG CODE                      ; let linker place main program
;variables para el contador:
 i equ 0x30
 j equ 0x31
 k equ 0x32
 
;inicio del programa: 
START
BSF STATUS, RP0 ;Ingreso al banco 1
CLRF TRISB  ;puerto B salida
BSF TRISA,1 ; pin 1 puerto A entrada
BCF STATUS, RP0 ;Regresar al banco 0
 
inicio  
MOVLW b'00001001'
MOVWF PORTB
 
proceso: BTFSS PORTA,1
GOTO proceso
CALL confirmacion
goto bandera
 
 
confirmacion: BTFSC PORTA,1
GOTO confirmacion
CALL restar
    RETURN
    
restar: 
MOVLW b'00000001'
SUBWF PORTB,1
 CLRW
 RETURN
    
bandera: MOVLW b'11111111'
    SUBWF PORTB, 0
    BTFSS STATUS, Z ;Z==1?
    goto posoneg
    call cero
   ;Positivo c=1, z=0
   ;Negativo c=0, z=0
   ;Cero     c=1, z=1
   
posoneg: BTFSS STATUS, C ;c=1?
   goto negativo
   goto positivo
negativo: BCF PORTB, 3
    BCF PORTB, 2
    BCF PORTB, 4
    BSF PORTB, 3 
   goto restart
positivo: BCF PORTB, 3
    BCF PORTB, 2
    BCF PORTB, 4
    BSF PORTB, 2
   goto proceso
cero: BCF PORTB, 3
   BCF PORTB, 2
   BCF PORTB, 4
   BSF PORTB, 4
   goto restart
    
    
restart: MOVLW b'00001001'
    MOVWF PORTB
    GOTO proceso
   
    END