;working
.model small

.stack 100

.data
msg db 10,13,'this is cos wave$'
x dd 0.0
xad dd 3.0
one80 dd 180.0
sixty dd 30.0
hundred dd 50.0
row db 00
col db 00
xcursor dd 00
ycursor dt 00
count dw 360
x1 dw 0


.code
.386
main: mov ax,@data
mov ds,ax                                                                                                                                                                                                                                                                                                                                                                       

mov ah,00               ;set video mode    	
mov al,6     ;AL = video mode
int 10h

up1:finit

fldpi                                                        ;FLDPI   ; D9 EB   [8086,FPU] floating point constant
fdiv one80
fmul x
fsin
fmul sixty
fld hundred
fsub st,st(1)   ;=100-60 sin((pi/180))*x


fbstp ycursor     ; Store ST(0) in ycursor and pop ST(0)
lea esi,ycursor

mov ah,0ch              ;write graphics pixel , 
mov al,01h      ; AL = Color
mov bh,0h     ;BH = Page Number
mov cx,x1    ; CX = x cordinator
mov dx,[si]     ; DX = y cordinator
int 10h

inc x1                 
fld x      ;load x in ST(0)            
fadd xad   ;add xad + ST(0)=ST(0)            
fst x       ;store ST(0) in x variable           
dec count              
jnz up1                


mov ah,09h                      ; display message
lea dx,msg
int 21h


mov ah,4ch
int 21h
end main

