%macro print 2
	mov rax, 1
	mov rdi, 1
	mov rsi, %1
	mov rdx, %2
	syscall
%endmacro

%macro exit 0
	mov rax, 60
	mov rdi, 0
	syscall
%endmacro

section .data
	
    real1 db 10d, 13d, "Real Mode", 10d, 13d
	real1_len equ $-real1

	ptd db 10d, 13d, "Protected mode", 10d, 13d
	ptd_len equ $-ptd

	ldt_msg db 10d, 13d, "LDT Contents: ", 10d, 13d
	ldt_len equ $-ldt_msg

    gdt_msg db 10d, 13d, "GDT Contents: ", 10d, 13d
	gdt_len equ $-gdt_msg

    idt_msg db 10d, 13d, "IDT Contents:  ", 10d, 13d
	idt_len equ $-idt_msg

    tr_msg db 10d, 13d, "Task Regsiter: ", 10d, 13d
	tr_len equ $-tr_msg
    
    msw_msg db 10d, 13d, "MSW (Machine Status Word) : ", 10d, 13d
	msw_len equ $-msw_msg

	newline db 10

section .bss

    gdt resd 1
        resw 1
    idt resd 1
        resw 1
    ldt resw 1
    tr  resw 1
    crO resd 1

    answer resb 4

section .text
	global _start
	_start:

	smsw eax
	mov [crO], eax

	bt eax, 0
	jc loop1
	; used together
	
	print real1, real1_len
	jmp next
	loop1:
		print ptd, ptd_len

	next:
		; Get register values for gdt, ldt, idt & tr
		sgdt [gdt]
		sldt [ldt]
		sidt [idt]
		str [tr]
		print gdt_msg, gdt_len

		; Display GTD Contents

		mov bx, [gdt + 4]
		call display

		mov bx, [gdt + 2]
		call display

		mov bx, [gdt]
		call display

		print ldt_msg, ldt_len
		; Display LTD Contents
		mov bx, [ldt]

		; Display IDT Contents
		print idt_msg, idt_len

		mov bx, [idt + 4]
		call display

		mov bx, [idt + 2]
		call display

		mov bx, [idt]
		call display

		print msw_msg, msw_len

		; Display Machine Status Work data
	
		mov bx, [crO + 2]
		call display

		mov bx, [crO]
		call display

		print newline, 1
		print newline, 1

		exit

    


display:
	mov rsi, answer + 3
	mov rcx, 4

	loop2:
		mov rdx, 0
		mov rbx, 16
		div rbx
		cmp dl, 09h
		jbe skip2 ; if less than
		add dl, 07h

	skip2:
		add dl, 30h
		mov [rsi], dl
		dec rsi
		dec rcx
		jnz loop2
		print answer, 4
		ret