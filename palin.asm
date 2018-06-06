global _start

	section	.data

	section	.bss
outstr	resb	100h			; buffer for output string
cnt	resd	1			; counter

	section	.text

_start:
	; read number
	call	cons_readln
	mov	esi, eax
	call	str_tonum

	mov	[cnt], eax		; counter of numbers in ecx
	cmp	dword [cnt], 0
	je	exit
.lp:
	; read string, compute length
	call	cons_readln
	mov	ebx, eax		; string address in ebx
	call	str_length		; eax: length

	; count number of digits
	mov	ecx, 0
	mov	esi, ebx
.cnt:
	cmp	eax, 0
	je	.cnte
	cmp	byte [esi], '0'
	jb	.cnte
	cmp	byte [esi], '9'
	ja	.cnte
	inc	ecx
	inc	esi
	dec	eax
	jmp	.cnt
.cnte:

	; call palin
	mov	esi, ebx		; esi: input string
	mov	eax, ecx		; eax: length of the string
	mov	edi, outstr		; edi: output string
	call	palin			; write to outstr, len in eax

	; print output string
	mov	esi, eax
	mov	byte [outstr + esi], 0	; set outstr[length] = 0
	mov	eax, outstr
	call	cons_prstr

	; print newline
	call	cons_nl
	
	dec	dword [cnt]
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
; Pseudocode:
;     0. make a copy at destination address
;     for i := 0, i < length, i := i + 1
;         dest[i] := src[i]
;     1. compare
;     i := 0
;     j := length - 1
;     while i < length/2
;         if [i] > [j] then
;             goto incleft
;         if [i] < [j] then
;             goto copylr
;         i := i + 1
;         j := j - 1
;incleft:
;     2. increase left (only when left <= right)
;     i := (length - 1) / 2
;     while i > 0 and [i] = '9' do
;         [i] = '0'
;         i := i - 1		; exit i = 0 OR [i] <> '9'
;     if [i] = '9' then		; can still happen (if i = 0)
;         length := length + 1
;         [0] := '1'
;         if length mod 2 = 1 then
;             [length div 2] := '0'
;     else			; [i] <> '9' => can increment
;        [i] := [i] + 1
;copylr:
;     3. copy left to right
;     i := 0
;     j := length - 1
;     while i < length/2
;         [j] := [i]
;         i := i + 1
;         j := j - 1
	section .bss
length	resd	1
src	resd	1
dest	resd	1

	section .text
palin:
; 0: initialize variables and copy source string to destination
	mov	[length], eax
	mov	[src], esi
	mov	[dest], edi

	mov	ecx, eax
	call	str_copy
	mov	ebx, [dest]	; ebx = address of the destination
				;       for the rest of the function

; 1: compare left to right
	mov	esi, [length]
	shr	esi, 1
	dec	esi		; esi = (length / 2) - 1
	mov	edi, [length]
	inc	edi
	shr	edi, 1		; edi = (length + 1) / 2

.w1lp:
	cmp	esi, 0
	jnge	.w1e
	mov	al, [ebx + esi]
	cmp	al, [ebx + edi]
	ja	.copylr
	jb	.incleft
	dec	esi
	inc	edi
	jmp	.w1lp
.w1e:

.incleft:
; 2: increment the left part starting from the middle
	mov	esi, [length]
	dec	esi
	shr	esi, 1

.w2lp:
	cmp	esi, 0
	jbe	.w2e
	cmp	byte [ebx + esi], '9'
	jne	.w2e
	mov	byte [ebx + esi], '0'
	dec	esi
	jmp	.w2lp
.w2e:

	; if [i] = '9' then ...
	cmp	byte [ebx + esi], '9'
	jne	.else

	inc	dword [length]
	mov	byte [ebx], '1'

	; if length mod 2 = 1 then ...
	test	dword [length], 1
	jz	.fi
	mov	esi, [length]
	shr	esi, 1
	mov	byte [ebx + esi], '0'
	jmp	.fi
.else:
	inc	dword [ebx + esi]
.fi:

; 3: copy left to right (mirror)
.copylr:
	mov	esi, 0
	mov	edi, [length]
	dec	dword edi

	mov	ecx, [length]
	shr	ecx, 1

.w3lp:
	cmp	esi, ecx
	jnb	.w3e
	mov	al, [ebx + esi]
	mov	byte [ebx + edi], al
	inc	esi
	dec	edi
	jmp	.w3lp
.w3e:
	ret

%include "linux.def"
%include "str.asm"
%include "cons.asm"

