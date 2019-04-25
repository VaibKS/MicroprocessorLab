section .data
m1 db 10,13,'Enter a 4-digit Hexadecimal Number: '
m1len equ $-m1
 
m2 db 10,13,'Its equivalent BCD Number is: '
m2len equ $-m2
 
m3 db 10,13,'Enter a 4-digit BCD Number: '
m3len equ $-m3
 
m4 db 10,13,'Its equivalent Hexadecimal Number is: '
m4len equ $-m4
 
m5 db 10,13,'Wrong choice..'
m5len equ $-m5
 
menu db 10,13,'-----MENU-----'
     db 10,'1.Hexadecimal to BCD'
     db 10,'2.BCD to Hexadecimal'
     db 10,'3.Exit'
     db 10,'Enter your choice: '
mlen equ $-menu
newline db 10
 
section .bss
num resb 6
choice resb 2
res resb 6
disp_buff resb 8
disp_buff1 resb 5                   
 
%macro disp 2
mov eax,4
mov ebx,1
mov ecx,%1
mov edx,%2
int 80h
%endmacro
 
%macro accept 2
mov eax,3
mov ebx,0
mov ecx,%1
mov edx,%2
int 80h
%endmacro
 
section .text
global _start
_start:
menum:	
	disp menu,mlen
	accept choice,2
	cmp byte[choice],'1'
	je h2b
	cmp byte[choice],'2'
	je b2h
	cmp byte[choice],'3'
	je exit
	disp m5,m5len
	jmp menum
 
exit:	mov eax,1
	mov ebx,0
	int 80h
 
convert:
mov bx,00
mov esi,num
mov ecx,4
 
h2b:	disp m1,m1len
	accept num,6
	call convert
	mov ax,bx  		;ax,bx
	mov bx,10		;bx,10
	mov rcx,00		;rcx,00
	
	up:	mov rdx,00
		div bx
		push rdx
		inc rcx
		cmp ax,0
		jne up
	
	mov rdi,disp_buff1
	up1:	pop rdx
		add dl,30h
		mov [rdi],dl
		inc rdi
		loop up1
	disp m2,m2len
	disp disp_buff1,5
	jmp menum
 
b2h:	disp m3,m3len
	accept num,6
	mov rsi,num
	mov ecx,5
	mov rax,00
	mov ebx,0Ah
 
	xy: 	mov rdx,00
		mul ebx
		mov dl,[esi]
		sub dl,30h
		add rax,rdx
		inc rsi
		loop xy
		mov [res],rax
		disp m4,m4len
		mov ebx,[res]
		call disp8
		jmp menum
 
 
disp8:
mov ecx,8
mov edi,disp_buff
 
up2:	rol ebx,4
	mov al,bl
	and al,0fh
	cmp al,09                      
	jbe x
	add al,07h
x:	add al,30h
	mov [edi],al
	inc edi
	loop up2
	disp disp_buff+3,5
ret
 
 
 
back:	rol ebx,4
	mov al,[esi]
	cmp al,39h
	jbe y
	sub al,07h
 
y:	sub al,30h
	add bl,al
	inc esi
	loop back
ret