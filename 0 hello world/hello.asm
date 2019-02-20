%macro print 2
	mov rax, 1
	mov rdi, 1
	mov rsi, %1
	mov rdx, %2
	syscall
%endmacro

%macro exit 0
	mov rax, 60
	mov rdx, 0
	syscall
%endmacro

section .data
	msg1 db 'Hello, Programmer!', 10
	len1 equ $-msg1
	
	msg2 db 'Welcome to Assembly Programming!', 10
	len2 equ $-msg2

section .text
	global _start

_start:
	print msg1, len1
	print msg2, len2
	exit



