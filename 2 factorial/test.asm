%macro print 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

%macro read 1
mov rax,0
mov rdi,0
mov rsi,%1
mov rdx,%2
%endmacro

%macro exit 1
mov rax,60
mov rdi,0
syscall
%endmacro

section .data
msg1 db 10d,13d,'enter the input number',10d,13d
msglen equ $-msg1
msg2 db 10d,13d,'factorial of given no is',10d,13d
msglen equ $-msg2

section .bss
numascii resb 16
factorial resq1
answer resb 16

section .text
global _start
_star:
print msg1,msglen
read numascii,17
call asciitohex
mov [facrial],rbx
mov rcx,[factorial]
call factorial

mov rax,00
print msg2,msglen
mov rax,qword[factorial]
call display
exit

factorial:
          push rcx
          cmp rcx,1
          jne ahead
          jmp exit 2

ahead:
       dec rcx
       mov rax,rcx
       mul qword[factorial]
       mov qword[factorial],rax
       call factorial
       
exit 2:       
pop rcx
ret

asciitohex:
           mov rsi,numascii
           mov rcx,16
           mov rbx,0
           mov rax,0  
           
loop1:
      rol rbx,04
      mov al,[rsi]
      cmp al,39h
      jbe next
      sub al,07h
      
next:
     sub al,30h
     add rbx,rax
     inc rsi
     dec rcx
     jnz loop1
ret

display:
        mov rsi,answer+15
        mov rcx,16
        
loop2:mov rdx,0
      mov rbx,16
      div rbx
      cmp dl,09h
      jbe next1
      add dl,07h
      
next1:
      add dl,30h
      mov rsi,dl
      dec rsi
      dec rcx
      jnz loop2
      print answer,16
ret
      
      
            
      
                                