global _start

	section	.data

	section	.bss
outstr	resb	100h		; buffer for output string

	section	.text

_start:
	; read number
	call	cons_readln
	mov	esi, eax
	call	str_tonum

	mov	ecx, eax	; counter of numbers in ecx
	cmp	ecx, 0
	je	exit
.lp:
	; read string, compute length
	call	cons_readln
	mov	ebx, eax	; save the string address in ebx
	call	str_length	; eax: length

	; call palin
	mov	esi, ebx
	; string length already in eax
	mov	edi, outstr
	call	palin		; write to outstr, len in eax

	; print output string
	mov	esi, eax
	mov	[outstr + esi], 0	; set outstr[length] = 0
	mov	eax, out_str
	call	cons_prstr
	
	dec	ecx
	jnz	.lp

exit:
	mov	eax, sys_exit
	mov	ebx, 0
	int	80h

;; Function: palin
;;     creates next palindrome of input number
;; Parameters:
;;     esi - input string address
;;     edi - output string address
;;     eax - length of the input string
;; Returns:
;;     eax - length of the output string
palin:
	;TODO
	ret

%include "linux.def"
%include "str.asm"
%include "cons.asm"
