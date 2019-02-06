%macro scall 4
	mov rax, %1
	mov rdi, %2
	mov rsi, %3
	mov rdx, %4
	syscall
%endmacro

%macro exit 0
	mov rax, 60
	mov rdi, 0
	syscall
%endmacro

section .data
	m1 db 10d, 13d, "Enter number #1 : ", 10d, 13d
	l1 equ $-m1
	m2 db 10d, 13d, "Enter number #2 : ", 10d, 13d
	l2 equ $-m2

	m3 db 10d, 13d, "Multiplication is : ", 10d, 13d
	l3 equ $-m3

section .bss
	num1 resb 20
	num2 resb 20
	tmp resb 20
	answer resb 20

section .text
	global _start
	_start:

		scall 1, 1, m1, l1
		scall 0, 0, tmp, 17
		call asciitohex
		mov [num1], rbx

		scall 1, 1, m2, l2
		scall 0, 0, tmp, 17
		call asciitohex
		mov [num2], rbx

		mov rbx, [num1]
		mov rcx, [num2]
		mov rax, 0

		cmp rcx, 0
		je muloop
		addloop:
			add rax, rbx
		loop addloop

		muloop:
			mov rbx, rax
			scall 1, 1, m3, l3
			mov rax, rbx
			call display
			exit

asciitohex:
	mov rsi, tmp
	mov rcx, 16
	mov rbx, 0
	mov rax, 0

	loop1:
		rol rbx, 04
		mov al, [rsi]
		cmp al, 39h
		jbe skip1
		sub al, 07h

	skip1:
		sub al, 30h
		add rbx, rax
		inc rsi
		dec rcx
		jnz loop1
		ret

display:
	mov rsi, answer + 15
	mov rcx, 16

	loop2:
		mov rdx, 0
		mov rbx, 16
		div rbx
		cmp dl, 09h
		jbe skip2
		add dl, 07h

	skip2:
		add dl, 30h
		mov [rsi], dl
		dec rsi
		dec rcx
		jnz loop2
		scall 1, 1, answer, 16
		ret