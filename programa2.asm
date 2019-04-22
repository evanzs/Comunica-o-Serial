#include <PIC16f873A.inc>


; PROGRAMA 1
; Programa feito para comunica��o serial com o pic16f873a para mat�ria de compiladores
; Evandro Fernandes e Leonardo Silvatti
;  UNESP - BAURU - 2019



;a) O PIC dever� enviar uma �nica vez o valor 123 para o PC, via serial
;b) O PIC dever� fica esperando a chegada de algum byte qualquer pela serial. 
;c) Quando o byte chegar o PIC dever� somar um ao mesmo e ent�o enviar o valor somado para o PC
;d) Voltar para o passo 'a'


ORG 0x00
GOTO LOOP
ORG 0X04

; CONFIGURANDO A PORTA SERIAL PARA FUNCIONAR COMO 9600



;NOTA: TODOS OS REGISTRADORES USADOS ABAIXOS EST�O NO BANK1 DO JUNTOS COM O TRISB
BANKSEL TRISB ; ALOCA A MEMORIA PARA O BANCO DO TRISB




MOVLW b'0000 01101' ; 3� mais sig  BRGH = 1
MOVWF TRISB         ; TRISB = W 

; CONFIGURANDO OS REGISTRADORES DE TRANSMIS�O (TXSTA) E RECEPCAO (RCSTA)
MOVLW b'0010 0110' ; W = O BIT B 'usando o clock interno/8 bits transmiss�o/ Habilita transmis�o/aasincrini/x/alta velocidade/vazio/bit de paridade 
MOVWF TXSTA        ; TXTSTA = W  REGISTRADOR DE TRANSMIS�O
MOVLW d'25'        ; W = VALOR LITERAL DECIMAL 25
MOVWF SPBRG        ; VALOR DO REGISTRADOR PARA FUNCIONAR A 9600 


BANKSEL PORTB ; ALOCA A MEMORIA PARA O BANCO DO PORTB (BANK0)
MOVLW b'1001 0000' ; habilita porta serial/8 bits de recep��o/ n�o importa no assin/recebimento continuo/detec��o de ende desabilitado/erro de enquadramento (sem erro)/ bit cheio (sem erro)/
MOVWF RCSTA        ; RCSTA = W  REGISTRADOR DE RECEPCAO

;FIM DAS CONFIGURA��ES


;CONTA FEITA  SPRG = (4/ 16*9600) C0OM BRGH =0 POR QUE TEM MENOS ERRO

;TXREG funciona como buffer de transmiss�o
;RCREG funciona como bufer de cominica��o

; PASSO A
LOOP:
	BTFSS TXSTA,TRMT ; BOFFER TA VAZIO?
	GOTO LOOP        ; N�O
	MOVLW d'123'  	 ; ENVIA UM VALOR PARA O REGISTRADOR W
	MOVWF  TXREG 	 ; MANDO O VALOR DE W PARA TRANSMISS�O
; PASSO B
WAIT:
	BTFSS PIR1,RCIF	 ; CHEGOU ALGUMA COISA? 
	GOTO WAIT        ; N�O CHEGOU
;PASSO C
	MOVWF RCREG,W    ; SIM  ENT�O: W = RCREG GUARDADO O DADO Q CHEGOU EM W
	ADDLW 1 		 ; SOMA O VALOR Q CHEGOU W+1
	MOVWF TXREG		 ; MANDO O VALOR DE W PARA TRANSMISS�O
;PASSO D
	GOTO LOOP        ; VOLTA PARA O LOOP (PASSO A)

END