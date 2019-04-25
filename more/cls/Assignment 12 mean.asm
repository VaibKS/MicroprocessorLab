section .data

	welmsg db 10,'Welcome to Assembly Language Program: Coprocessor: Mean',10
	welmsg_len equ $-welmsg
	sdmsg db 10,"CALCULATED STANDARD DEVIATION IS:-"
    	sdmsg_len equ $-sdmsg
    	varmsg db 10,"CALCULATED VARIANCE IS:-"
    	varmsg_len equ $-varmsg
	array dd 10.0,20.0,30.0
	arrcnt dq 03
	hdec dw 100
	resmsg db 10,10,'Mean = '
	resmsg_len equ $-resmsg
	decpt db '.'
	thankmsg db 10,10,'Thank you for using Program',10
	thankmsg_len equ $-thankmsg

;---------------------------------------------------------------------------------------------------

section .bss
	
	realres rest 1
	intres rest 1
	dispbuff resb 2
	mean resd 1
	variance resd 1


	%macro linuxsyscall 4
	mov rax,%1	
	mov rdi,%2	
	mov rsi,%3	
	mov rdx,%4	
	syscall
	%endmacro

;-----------------------------------------------------------------------------------------------------

section .text
	
global _start

_start:
	linuxsyscall 01,01,welmsg,welmsg_len
	finit
	fldz
	mov rcx,[arrcnt]
	mov rbx,array
	mov rsi,0

up1:	fadd dword [rbx+rsi*4]
	inc rsi
	loop up1
	fild qword [arrcnt]
	fdiv
	fst dword[mean]
	fimul word [hdec]
	fbstp [intres]
	linuxsyscall 01,01,resmsg,resmsg_len
	
	call dispres_proc
; variance and standard deviation

	MOV RCX,00
	MOV CX,[arrcnt]
	MOV RBX,array
	MOV RSI,00
	FLDZ
up2:	FLDZ
	FLD DWORD[RBX+RSI*4]
	FSUB DWORD[mean]
	FST ST1
	FMUL
	FADD
	INC RSI
	LOOP up2
	FIDIV word[arrcnt]
	FST dWORD[variance]
	FSQRT 						;standard deviation

	linuxsyscall 01,01,sdmsg,sdmsg_len
	fimul word [hdec]
	fbstp [intres]
	call dispres_proc
	FLD dWORD[variance]
	fimul word [hdec]
	fbstp [intres]
	linuxsyscall 01,01,varmsg,varmsg_len

	call dispres_proc
	
exit:
	linuxsyscall 01,01,thankmsg,thankmsg_len
	mov rax,60		;Exit
	mov rbx,00
	syscall


dispres_proc:
	mov rsi,intres+9
	mov rcx,09

dresup:
	mov bl,[rsi]
	push rcx
	push rsi
	call disp8_proc
	pop rsi
	pop rcx
	dec rsi
	loop dresup
	push rsi
	linuxsyscall 01,01,decpt,1
	pop rsi
	mov bl,[rsi]
	call disp8_proc
	ret

;-----------------------------------------------------------------------------------------------------
disp8_proc:
	mov rcx,2
	mov rdi,dispbuff

dup1:
	rol bl,4
	mov al,bl
	and al,0fh
	cmp al,09
	jbe dskip
	add al,07h
dskip:	add al,30h
	mov [rdi],al
	inc rdi
	loop dup1
	linuxsyscall 01,01,dispbuff,2
	ret
