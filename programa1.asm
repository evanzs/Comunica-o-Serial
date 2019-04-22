#include <PIC16f873A.inc>


; PROGRAMA 1
; Programa feito para comunicação serial com o pic16f873a para matéria de compiladores
; Evandro Fernandes e Leonardo Silvatti
;  UNESP - BAURU - 2019


;O PIC deverá ficar em um loop constante enviando o byte 65 para o PC,
; via interface serial, com taca de 9600 bps.


ORG 0x00
GOTO LOOP
ORG 0X04

; CONFIGURANDO A PORTA SERIAL PARA FUNCIONAR COMO 9600



;NOTA: TODOS OS REGISTRADORES USADOS ABAIXOS ESTÃO NO BANK1 DO JUNTOS COM O TRISB
BANKSEL TRISB ; ALOCA A MEMORIA PARA O BANCO DO TRISB




MOVLW b'0000 01101' ; 3º mais sig  BRGH = 1
MOVWF TRISB         ; TRISB = W 

; CONFIGURANDO OS REGISTRADORES DE TRANSMISÃO (TXSTA) E RECEPCAO (RCSTA)
MOVLW b'0010 0110' ; W = O BIT B 'usando o clock interno/8 bits transmissão/ Habilita transmisão/aasincrini/x/alta velocidade/vazio/bit de paridade 
MOVWF TXSTA        ; TXTSTA = W  REGISTRADOR DE TRANSMISÃO
MOVLW d'25'        ; W = VALOR LITERAL DECIMAL 25
MOVWF SPBRG        ; VALOR DO REGISTRADOR PARA FUNCIONAR A 9600 


BANKSEL PORTB ; ALOCA A MEMORIA PARA O BANCO DO PORTB (BANK0)
MOVLW b'1001 0000' ; habilita porta serial/8 bits de recepção/ não importa no assin/recebimento continuo/detecção de ende desabilitado/erro de enquadramento (sem erro)/ bit cheio (sem erro)/
MOVWF RCSTA        ; RCSTA = W  REGISTRADOR DE RECEPCAO

;FIM DAS CONFIGURAÇÕES



;CONTA FEITA  SPRG = (4/ 16*9600) C0OM BRGH =0 POR QUE TEM MENOS ERRO

;TXREG funciona como buffer de transmissão
;RCREG funciona como bufer de cominicação

LOOP:
	BTFSS TXSTA,TRMT ; BOFFER TA VAZIO?
	GOTO LOOP        ; NÃO
	MOVLW d'65'  	 ; ENVIA UM VALOR PARA O REGISTRADOR W
	MOVWF  TXREG 	 ; MANDO O VALOR DE W PARA TRANSMISSÃO
	GOTO LOOP    	 ; VOLTA PRO LOOP 
END