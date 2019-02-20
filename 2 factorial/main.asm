%macro print 2
	mov rax, 1
	mov rdi, 1
	mov rsi, %1
	mov rdx, %2
	syscall
%endmacro

%macro read 2
	mov rax, 0
	mov rdi, 0
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
	m1 db 10d, 13d, "Enter number : ", 10d, 13d
	l1 equ $-m1
	m2 db 10d, 13d, "Factorial is : ", 10d, 13d
	l2 equ $-m2

section .bss
	num resb 16
	Factorial resq 1
	answer resb 16


section .text
	global _start

_start:
	print m1, l1
	read num, 17
	call asciitohex
	mov [Factorial], rbx
	mov rcx, [Factorial]
	call facto
	mov rax, 00
	print m2, l2
	mov rax, qword[Factorial]
	call display
	exit

facto:
	push rcx
	cmp rcx, 01
	jne ahead
	jmp exit2

ahead:
	dec rcx
	mov rax, rcx
	mul qword[Factorial]
	mov qword[Factorial], rax
	call facto

exit2:
	pop rcx
	ret

asciitohex:
	mov rsi, num
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
	print answer, 16
	ret