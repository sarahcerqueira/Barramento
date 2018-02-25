.data
.global _start
.equ RxData , 0x9000
.equ TxData, 0x9004
#.equ FlagUART0, 0x9008
.equ Ready, 0x9008
.equ Display7s, 0x9050
.equ Switches, 0x9040
.equ Button, 0x9030

memoriaUart: .skip 20
digitos: .skip 30
memoria: .skip 200

.text

_start:
	movia r2, Switches
	movia r3, Button
	movia r22, Display7s

loop:
	ldwio r4, 0(r3)
	beq r4, r0, loop
	ldwio r4, 0(r2)

options:
	beq r4, r0, anoBissexto
	movi r5, 1
	beq r4, r5, bubbleSort
	movi r5, 2
	beq r4, r5, fatorial
	movi r5, 4
	beq r4, r5, geradorPrimos
	movi r5, 8
	beq r4, r5, sequenciaFibonacci

anoBissexto:
	movi r23, 0b00111111
	stwio r23, 0(r22)
	movia r9, Ready
	movi r12, 128
	movia r13, RxData
	movia r14, TxData
	addi r17, r0, 10
	movi r20, 59 
	
	num0:	
		ldwio r2, 0(r9)
		and r2, r2, r12
		bne r2, r12, num0
		br recebe_dado0
			
	pega_digito0:
		custom 1, r10, r10, r17
		mov r11, r2
		subi r11, r11, 48
		add r10, r10, r11
		call num0
			
	recebe_dado0:
		ldwio r2, 0(r13)
		beq r2, r20, guarda_num0
		br pega_digito0
		
	guarda_num0:	
		mov r5, r10
		call verifica0

	verifica0:
	  	movi r6, 4
	  	call resto_divisao0
		beq r7, r0, verifica20
		br nao_bissexto0
		
	verifica20:
		movi r6, 400
		call resto_divisao0
		beq r7, r0, bissexto0
		br verifica30

	verifica30:
		movi r6, 100
		call resto_divisao0
		bne r7, r0, bissexto0
		br nao_bissexto0
		
	resto_divisao0:
		custom 0, r7, r5, r6
		custom 1, r7, r7, r6
		sub r7, r5, r7
		ret
			
	nao_bissexto0:
		movi r8, 0	
		movi r4, 78
		stwio r4, 0(r14)

		addi r23, r0, 0xfa
		slli r23, r23, 16
		call fornada

		movi r4, 97
		stwio r4, 0(r14)

		addi r23, r0, 0xfa
		slli r23, r23, 16
		call fornada
	
		movi r4, 111
		stwio r4, 0(r14)
	
		call finish0
		
	bissexto0:
		movi r8, 1	
		movi r4, 83
		stwio r4, 0(r14)
		
		addi r23, r0, 0xfa
		slli r23, r23, 16
		call fornada


		movi r4, 105
		stwio r4, 0(r14)
		
		addi r23, r0, 0xfa
		slli r23, r23, 16
		call fornada


		movi r4, 109
		stwio r4, 0(r14)	
		call finish0
		
	finish0:
		call zera
		br _start

bubbleSort:
	movi r23, 0b00000110
	stwio r23, 0(r22)
	addi r17, r0, 10
	movi r20, 32
	movi r19, 59
	movi r6, 0
	movia r7, memoria
	movia r3, digitos	
	movi r9, 0
	call take_v1
	mov r13, r9
	movi r14, 1	
	beq r9, r14, finish1
	movia r7, memoria	
	br buble_sort1

	take_v1:
		stwio ra, 0(r3)
		addi r3, r3, 4
		call num1
		subi r3, r3, 4
		ldwio ra, 0(r3)
		addi r9, r9,1
		stwio r6, 0(r7)	
		beq r4, r19, retorna1
		addi r7, r7, 4
		movi r6, 0
		br take_v1

	retorna1:
		ret

	num1:	
		stwio ra, 0(r3)
		call read1
		ldwio ra, 0(r3)
		beq r4, r20, guarda_num1
		beq r4, r19, guarda_num1
		br pega_digito1
			
	pega_digito1:
		custom 1, r6, r6, r17
		subi r4, r4, 48
		add r6, r6, r4
		br num1
		
	guarda_num1:							
		ret
		
	buble_sort1:
		ldwio r10, 0(r7)
		mov r15, r7		
		addi r7, r7, 4	
		ldwio r11, 0(r7)		
		bgt r10, r11, troca1			
		br atualiza_j1		
			
	troca1:
		mov r12, r10		
		stwio r11, 0(r15)
		stwio r10, 0(r7)		
		add r10, r11, r0
		add r11, r12, r0		
		
	atualiza_j1:	
		addi r14, r14, 1		
		bgt r9, r14, buble_sort1
		br atualiza_k1
				
	atualiza_k1:		
		subi r13, r13 , 1
		movi r14, 1
		movia r7, memoria
		bgt r13, r0, buble_sort1
		movia r7, memoria
		br impressao1
		
	impressao1:	
		ldwio r4, 0(r7)
		call write_number1
		mov r4, r20

		addi r23, r0, 0xaa
		slli r23, r23, 16
		stw ra, 0(r2)
		call fornada
		ldw ra, 0(r2)

	 	call write_caractere1
		addi r7, r7, 4
		subi r9, r9, 1
		beq r9, r0, finish1
		br impressao1

	read1:
		movia r2, memoriaUart
		stwio r3, 0(r2)
		movi r2, 128
		movia r3, Ready

	waiting1:
		ldwio r4, 0(r3)
		and r4, r4, r2
		bne r4, r2, waiting1
		br take1

	take1:
		movia r3, RxData
		ldwio r4, 0(r3)
		movia r2, memoriaUart
		ldwio r3, 0(r2)
		ret

	write_number1:
		movia r2, memoriaUart
		stwio r3, 0(r2)
		addi r2, r2, 4
		stwio r5, 0(r2)
		addi r2, r2, 4
		stwio r6, 0(r2)
		addi r2, r2, 4
		stwio r7, 0(r2)
		addi r2, r2, 4
		stwio r8, 0(r2)
		addi r2, r2, 4
		mov r22, r2

		movia r3, TxData
		movia r7, digitos
		movi r2, 10
		movi r5, 0
		bge r4, r2, broke_number1
		addi r4, r4, 48
		stwio r4, 0(r3)

		addi r23, r0, 0xfa
		slli r23, r23, 16
		stw ra, 0(r22)
		call fornada
		ldw ra, 0(r22)

		br return1

	broke_number1:
		beq r4, r0, write1
		custom 0, r8, r4, r2
		addi r5, r5, 1
		custom 1, r6, r8, r2
		sub r6, r4, r6
		stwio r6, 0(r7)
		addi r7, r7, 4
		mov r4, r8
		br broke_number1

	write1: 
		subi r7, r7, 4
		subi r5, r5, 1
		ldwio r4, 0(r7)
		addi r4, r4, 48
		stwio r4, 0(r3)
		
		addi r23, r0, 0xaa
		slli r23, r23, 16
		stw ra, 0(r22)
		call fornada
		ldw ra, 0(r22)

		bne r5, r0, write1
		br return1

	return1:
		movia r2, memoriaUart
		ldwio r3, 0(r2)
		addi r2, r2, 4
		ldwio r5, 0(r2)
		addi r2, r2, 4
		ldwio r6, 0(r2)
		addi r2, r2, 4
		ldwio r7, 0(r2)
		addi r2, r2, 4
		ldwio r8, 0(r2)
		ret

	write_caractere1:
		movia r2, TxData
		stwio r4, 0(r2)
		ret

	finish1:
		call zera
		br _start

fatorial:
	movi r23, 0b01011011
	stwio r23, 0(r22)
	addi r17, r0, 10
	movia r3, memoria
	movi r6, 0
	movi r20, 59
	call num2
	br ini2
	
num2:	
	stwio ra, 0(r3)
	call read2
	ldwio ra, 0(r3)
	beq r4, r20, guarda_num2
	br pega_digito2
			
pega_digito2:
	custom 1, r6, r6, r17
	subi r4, r4, 48
	add r6, r6, r4
	br num2
		
guarda_num2:							
	ret

ini2:	
	movi r7, 1
	call stack2
	call print2
	br finish2

calcular_fatorial2:		
	subi r6, r6, 1
	call stack2
	ldwio r6, 0(r3)
	ldwio ra, 4(r3)
	subi r3, r3, 8
	custom 1, r4, r4, r6
	ret

stack2:
	stwio ra, 4(r3)
	stwio r6, 0(r3)
	addi r3, r3, 8
	bgt r6, r7, calcular_fatorial2
	movi r4, 1
	subi r3, r3, 8
	ret

print2:
	call write_number2
	br finish2

read2:
	movia r2, memoriaUart
	stwio r3, 0(r2)
	movi r2, 128
	movia r3, Ready

waiting2:
	ldwio r4, 0(r3)
	and r4, r4, r2
	bne r4, r2, waiting2
	br take2

take2:
	movia r3, RxData
	ldwio r4, 0(r3)
	movia r2, memoriaUart
	ldwio r3, 0(r2)
	ret

write_number2:
	movia r2, memoriaUart
	stwio r3, 0(r2)
	addi r2, r2, 4
	stwio r5, 0(r2)
	addi r2, r2, 4
	stwio r6, 0(r2)
	addi r2, r2, 4
	stwio r7, 0(r2)
	addi r2, r2, 4
	stwio r8, 0(r2)
	addi r2, r2, 4
	mov r22, r2	


	movia r3, TxData
	movia r7, digitos
	movi r2, 10
	movi r5, 0
	bge r4, r2, broke_number2
	addi r4, r4, 48
	stwio r4, 0(r3)
	br return2

broke_number2:
	beq r4, r0, write2
	custom 0, r8, r4, r2
	addi r5, r5, 1
	custom 1, r6, r8, r2
	sub r6, r4, r6
	stwio r6, 0(r7)
	addi r7, r7, 4
	mov r4, r8
	br broke_number2

write2: 
	subi r7, r7, 4
	subi r5, r5, 1
	ldwio r4, 0(r7)
	addi r4, r4, 48
	stwio r4, 0(r3)

	addi r23, r0, 0xaa
	slli r23, r23, 16
	stw ra, 0(r22)
	call fornada
	ldw ra, 0(r22)

	bne r5, r0, write2
	br return2

return2:
	movia r2, memoriaUart
	ldwio r3, 0(r2)
	addi r2, r2, 4
	ldwio r5, 0(r2)
	addi r2, r2, 4
	ldwio r6, 0(r2)
	addi r2, r2, 4
	ldwio r7, 0(r2)
	addi r2, r2, 4
	ldwio r8, 0(r2)
	ret

write_caractere2:
	movia r2, TxData
	stwio r4, 0(r2)
	ret
		
finish2:
	call zera
	br _start

geradorPrimos:
	movi r23, 0b01100110
	stwio r23, 0(r22)
	movi r20, 32
	movi r21, 59
	movi r6, 0
	movi r11, 0
	addi r17, r0, 10
	movia r3, memoria
	call num4
	mov r11, r6
	movi r6, 0
	call num4
	br inicializacao4

	num4:	
		stwio ra, 0(r3)
		call read4
		ldwio ra, 0(r3)
		beq r4, r20, guarda_num4
		beq r4, r21, guarda_num4
		br pega_digito4
			
	pega_digito4:
		custom 1, r6, r6, r17
		subi r4, r4, 48
		add r6, r6, r4
		br num4
		
	guarda_num4:								
		ret

	inicializacao4:
		add r12, r9, r6
		movi r9, 2
		mov r6, r9
		custom 0, r8, r11, r9
		
	verifica_se_primo4:	
		bgt r9, r11, atualizar_r114
		beq r9, r11, impressao4
		custom 0, r7, r11, r6
		custom 1, r7, r7, r6
		sub r7, r11, r7
		
		bne r7,r0, atualiza_r64
		br atualizar_r114
			
			
	atualiza_r64:
		addi r6, r6, 1
		bgt r8, r6, verifica_se_primo4
		br impressao4	
		
	atualizar_r114:
		addi r11,r11, 1	
		movi r6, 2
		custom 0, r8, r11, r9		
		bgt r11, r12, finish4
		br verifica_se_primo4

	impressao4: 
		mov r4, r11
		call write_number4
	 	mov r4, r20
	 	call write_caractere4
		br atualizar_r114

	read4:
		movia r2, memoriaUart
		stwio r3, 0(r2)
		movi r2, 128
		movia r3, Ready

	waiting4:
		ldwio r4, 0(r3)
		and r4, r4, r2
		bne r4, r2, waiting4
		br take4

	take4:
		movia r3, RxData
		ldwio r4, 0(r3)
		movia r2, memoriaUart
		ldwio r3, 0(r2)
		ret

	write_number4:
		movia r2, memoriaUart
		stwio r3, 0(r2)
		addi r2, r2, 4
		stwio r5, 0(r2)
		addi r2, r2, 4
		stwio r6, 0(r2)
		addi r2, r2, 4
		stwio r7, 0(r2)
		addi r2, r2, 4
		stwio r8, 0(r2)
		addi r2,r2, 4
		mov r22, r2

		movia r3, TxData
		movia r7, digitos
		movi r2, 10
		movi r5, 0
		bge r4, r2, broke_number4
		addi r4, r4, 48
		stwio r4, 0(r3)
		
		addi r23, r0, 0xaa
		slli r23, r23, 16
		stw ra, 0(r22)
		call fornada
		ldw ra, 0(r22)

		
		br return4

	broke_number4:
		beq r4, r0, write4
		custom 0, r8, r4, r2
		addi r5, r5, 1
		custom 1, r6, r8, r2
		sub r6, r4, r6
		stwio r6, 0(r7)
		addi r7, r7, 4
		add r4, r0, r8
		br broke_number4

	write4: 
		subi r7, r7, 4
		subi r5, r5, 1
		ldwio r4, 0(r7)
		addi r4, r4, 48
		stwio r4, 0(r3)

		addi r23, r0, 0xaa
		slli r23, r23, 16
		addi r22, r22, 4
		stw ra, 0(r22)
		call fornada
		ldw ra, 0(r22)
		subi r22, r22, 4

		bne r5, r0, write4
		br return4

	return4:
		movia r2, memoriaUart
		ldwio r3, 0(r2)
		addi r2, r2, 4
		ldwio r5, 0(r2)
		addi r2, r2, 4
		ldwio r6, 0(r2)
		addi r2, r2, 4
		ldwio r7, 0(r2)
		addi r2, r2, 4
		ldwio r8, 0(r2)
		ret

	write_caractere4:
		movia r2, TxData
		stwio r4, 0(r2)
		ret

	finish4:
		call zera
		br _start

sequenciaFibonacci:
	movi r23, 0b01111111
	stwio r23, 0(r22)
	movi r15, 1
	movi r20, 59
	addi r17, r0, 10
	movia r3, memoria	
	call num8
	br inicio8

	num8:	
		stwio ra, 0(r3)
		call read8
		ldwio ra, 0(r3)
		beq r4, r20, guarda_num8
		br pega_digito8
			
	pega_digito8:
		custom 1, r6, r6, r17
		subi r4, r4, 48
		add r6, r6, r4
		br num8
		
	guarda_num8:							
		ret	
		
	inicio8:
		mov r10, r15
		movi r8, 1
		call fib8  	
		mov r4, r1	
		call write_number8
		mov r4, r20

		addi r23, r0, 0xaa
		slli r23, r23, 16
		stw ra, 0(r2)
		call fornada
		ldw ra, 0(r2)

		call write_caractere8

		addi r23, r0, 0xaa
		slli r23, r23, 16
		stw ra, 0(r2)
		call fornada
		ldw ra, 0(r2)
		    	  
		addi r15, r15, 1
		bge r6, r15, inicio8
		br finish8
	    	   	      
	fib8:
		bgt r10, r8, fibonacci8
		mov r1, r10
		ret
	      
	fibonacci8:
		addi r3, r3, 12
		stwio ra, 0(r3)
		stwio r10, 4(r3)
		subi r10, r10, 1
		call fib8
		ldwio r10, 4(r3)
		stwio r1, 8(r3)            
		subi r10, r10, 2
		call fib8     
		ldwio r5, 8(r3)
		add r1, r5, r1      
		ldwio ra, 0(r3)
		subi r3, r3, 12
		ret

	read8:
		movia r2, memoriaUart
		stwio r3, 0(r2)
		movi r2, 128
		movia r3, Ready

	waiting8:
		ldwio r4, 0(r3)
		and r4, r4, r2
		bne r4, r2, waiting8
		br take8

	take8:
		movia r3, RxData
		ldwio r4, 0(r3)
		movia r2, memoriaUart
		ldwio r3, 0(r2)
		ret

	write_number8:
		movia r2, memoriaUart
		stwio r3, 0(r2)
		addi r2, r2, 4
		stwio r5, 0(r2)
		addi r2, r2, 4
		stwio r6, 0(r2)
		addi r2, r2, 4
		stwio r7, 0(r2)
		addi r2, r2, 4
		stwio r8, 0(r2)
		addi r2, r2, 4
		mov r22, r2


		movia r3, TxData
		movia r7, digitos
		movi r2, 10
		movi r5, 0
		bge r4, r2, broke_number8
		addi r4, r4, 48
		stwio r4, 0(r3)
		br return8

	broke_number8:
		beq r4, r0, write8
		custom 0, r8, r4, r2
		addi r5, r5, 1
		custom 1, r6, r8, r2
		sub r6, r4, r6
		stwio r6, 0(r7)
		addi r7, r7, 4
		add r4, r0, r8
		br broke_number8

	write8: 
		subi r7, r7, 4
		subi r5, r5, 1
		ldwio r4, 0(r7)
		addi r4, r4, 48
		stwio r4, 0(r3)
		
		addi r23, r0, 0xaa
		slli r23, r23, 16
		stw ra, 0(r22)
		call fornada
		ldw ra, 0(r22)

		bne r5, r0, write8
		br return8

	return8:
		movia r2, memoriaUart
		ldwio r3, 0(r2)
		addi r2, r2, 4
		ldwio r5, 0(r2)
		addi r2, r2, 4
		ldwio r6, 0(r2)
		addi r2, r2, 4
		ldwio r7, 0(r2)
		addi r2, r2, 4
		ldwio r8, 0(r2)
		ret

	write_caractere8:
		movia r2, TxData
		stwio r4, 0(r2)
		ret

	finish8:
		call zera
		br _start
	
zera:
	movi r1, 0
	movi r2, 0
	movi r3, 0
	movi r4, 0
	movi r5, 0
	movi r6, 0
	movi r7, 0
	movi r8, 0
	movi r9, 0
	movi r10, 0
	movi r11, 0
	movi r12, 0
	movi r13, 0
	movi r14, 0
	movi r15, 0
	movi r16, 0
	movi r17, 0
	movi r18, 0
	movi r19, 0
	movi r20, 0
	ret

fornada:
	subi r23, r23, 1
	bne r23, r0, fornada
	ret

finish:
	.end
