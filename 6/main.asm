%macro dispmsg 2
	mov rax, 1
	mov rdi, 1
	mov rsi, %1
	mov rdx, %2
	syscall
%endmacro

%macro accept 2
	mov rax, 0
	mov rdi, 0
	mov rsi, %1
	mov rdx, %2
	syscall
%endmacro

section .data
	menumsg db 10, 10, '---- Menu for Non-Overlapped Block Transfer ----', 10
			db 10, '1. Block transfer without using string instructions'
			db 10, '2. Block transfer with using string instructions'
			db 10, 'Enter your choice::'
	menumsg_len equ $-menumsg

	wrchmsg db 10,10, 'wrong choice entered... please try again!!!', 10, 10
	wrchmsg_len equ $-wrchmsg

	blk_bfrmsg db 10, 'Block contents before transfer::'
	blk_bfrmsg_len equ $-blk_bfrmsg

	blk_afrmsg db 10, 'Block contents after transfer::'
	blk_afrmsg_len equ $-blk_afrmsg

	srcblk db 01h, 02h, 03h, 04h, 05h, 00h, 00h, 00h, 00h, 00h

	cnt equ 05
	spacechar db 20h
	lfmsg db 10, 10


section .bss

    optionbuff resb 02
	dispbuff resw 02


section .text
	global _start
	_start:
		dispmsg blk_bfrmsg, blk_bfrmsg_len
		menu:
			dispmsg menumsg, menumsg_len
			accept optionbuff, 02
			cmp byte[optionbuff], '1'
			jne case2
			call blkxferwo_proc
			jmp exit1
		case2:
			cmp byte[optionbuff], '2'
			jne case3
			call blkxferw_proc
			jmp exit1
		case3:
			cmp byte[optionbuff], '3'
			je ext
			dispmsg wrchmsg, wrchmsg_len
			jmp menu
		exit1:
			dispmsg blk_afrmsg, blk_afrmsg_len
			call dispblk_proc
			dispmsg lfmsg, 2
		ext:
			mov rax, 60
			mov rbx, 0
			syscall
		dispblk_proc:
			mov rsi, srcblk
			mov rcx, cnt
			add rcx, rcx
		rdisp:
			push rcx
			mov bl, [rsi]
			push rsi
			call disp8_proc
			pop rsi
			inc rsi
			push rsi
			dispmsg spacechar, 1
			pop rsi
			pop rcx
			loop rdisp
			ret
		blkxferwo_proc:
			mov rsi, srcblk+4
			mov rdi, rsi
			mov rcx, cnt
			add rdi, rcx
		blkup1:
			mov al, [rsi]
			mov [rdi], al
			dec rsi
			dec rdi
			loop blkup1
			ret
		blkxferw_proc:
			mov rsi, srcblk+4
			mov rdi, rsi
			mov rcx, cnt
			add rdi, rcx
			std
			rep movsb
			ret
		disp8_proc:
			mov cl, 2
			mov rdi, dispbuff
		dup1:
			rol bl, 4
			mov dl, bl
			and dl, 0fh
			cmp dl, 09
			jbe dskip
			add dl, 07h
		dskip:
			add dl, 30h
			mov [rdi], dl
			inc rdi
			loop dup1
			dispmsg dispbuff, 2
			ret
