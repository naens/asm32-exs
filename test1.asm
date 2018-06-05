buf_len		equ	100h

global _start

section .data

section .bss
buf	resb	buf_len
a	resd	1
b	resd	1

section .text

_start:
	; read number
	call	cons_readln

	; convert to number
	mov	esi, eax
	call	str_tonum
	mov	[a], eax

	; goto next number
	call	cons_readln

	; convert to number
	mov	esi, eax
	call	str_tonum
	mov	[b], eax

	; sum numbers
	mov	eax, [a]
	add	eax, [b]

	; print the sum
	call	cons_prnum

	je	exit

exit:
	mov	eax, sys_exit
	mov	ebx, 0
	int	80h

%include "linux.def"
%include "str.asm"
%include "cons.asm"

