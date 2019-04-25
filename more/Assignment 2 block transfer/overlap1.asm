section .data
	menumsg db 10,10,'----- Menu for Overlapped Block Transfer -----',10
		db 10,'1.Block Transfer without using string instructions'
		db 10,'2.Block Transfer with using string instructions'
		db 10,'3.Exit'
		db 10,'Enter Youe choice::'
	menumsg_len equ $-menumsg

	wrchmsg db 10,10,'Wrong Choice Entered....Please try again!!!',10,10
	wrchmsg_len equ $-wrchmsg

	blk_bfrmsg db 10,'Block contents before transfer::'
	blk_bfrmsg_len equ $-blk_bfrmsg

	blk_afrmsg db 10,'Block contents after transfer::'
	blk_afrmsg_len equ $-blk_afrmsg

	position db 10,'Enter position to overlap::'
	pos_len equ $-position

	srcblk db 01h,02h,03h,04h,05h,00h,00h,00h,00h,00h

	cnt equ 05
	spacechar db 20h
	lfmsg db 10,10

section .bss
	optionbuff resb 02
	dispbuff resw 02
	pos resb 00

%macro dispmsg 2
	mov rax,01
	mov rdi,01
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

%macro accept 2
	mov rax,0
	mov rdi,0
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro


section .text
	global _start
_start:
	dispmsg blk_bfrmsg,blk_bfrmsg_len
	call dispblk_proc

menu:	dispmsg menumsg,menumsg_len

	accept optionbuff,02

	cmp byte [optionbuff],'1'
	jne case2

	dispmsg position,pos_len
	accept optionbuff,02
	call packnum_proc

	call blkxferwo_proc
	jmp exit1

case2:	cmp byte [optionbuff],'2'
	jne case3

	dispmsg position,pos_len
	accept optionbuff,02
	call packnum_proc

	call blkxferw_proc

	jmp exit1	

case3:	cmp byte [optionbuff],'3'
	je ext
	dispmsg wrchmsg,wrchmsg_len 

	jmp menu

exit1:	dispmsg blk_afrmsg,blk_afrmsg_len
	call dispblk_proc
	dispmsg lfmsg,2

ext:	mov rax,60
	mov rbx,0
	syscall

dispblk_proc:
 
    mov rsi,srcblk
    mov rcx,cnt
    add rcx,[pos]
rdisp:
    push rcx
    mov bl,[rsi]        ;Read ASCII value char by char
    push rsi
    call disp8_proc        ;& Display 
    pop rsi
    inc rsi            ;Point to next char
    push rsi
    dispmsg spacechar,1    ;Display space
    pop rsi   
    pop rcx
    loop rdisp        ;Decrement count
                ;Repeat display process till actual count becomes zero
    ret

blkxferwo_proc:
	mov rsi,srcblk+4
	mov rdi,rsi
	add rdi,[pos]

	mov rcx,cnt
blkup1:
	mov al,[rsi]
	mov [rdi],al
	dec rsi
	dec rdi
	loop blkup1

	ret

blkxferw_proc:
	mov rsi,srcblk+4
	mov rdi,rsi
	add rdi,[pos]

	mov rcx,cnt

	std
	rep movsb

	ret

disp8_proc:
	mov cl,2
        mov rdi,dispbuff
dup1:
	rol bl,4
	mov dl,bl
	and dl,0fh
	cmp dl,09
	jbe dskip
	add dl,07h
dskip:	add dl,30h
	mov [rdi],dl
	inc rdi
	loop dup1

	dispmsg dispbuff,2
	ret

;--------------------------------------
; Procedure to convert character to no.
;--------------------------------------

packnum_proc:

	mov rsi,optionbuff
	mov bl,[rsi]

	cmp bl,39h
	jbe skip1
	sub bl,07h

skip1:	sub bl,30h
	mov [pos],bl
	ret	


