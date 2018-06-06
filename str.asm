	; convert string in esi to number, return in eax
str_tonum:
	mov	eax, 0
	mov	ecx, 10
.lp:
	movzx	ebx, byte [esi]
	cmp	ebx, '0'
	jb	.e
	cmp	ebx, '9'
	ja	.e
	sub	ebx, '0'
	mul	ecx
	add	eax, ebx
	inc	esi
	jmp	.lp
.e:
	ret

;; Function: str_length
;;     returns the length of a null-terminated string
;; Parameters: ax - address of the string
;; Returns: ax - the length of the string
;; Used Registers: ebx, esi
str_length:
	mov	ebx, eax
	mov	esi, 0
.lp:
	cmp	byte [ebx+esi], 0
	je	.e
	inc	esi
	jmp	.lp
.e:
	mov	eax, esi
	ret

;; Function: str_copy
;;     copies a string from source to destination of length byte
;; Parameters:
;;     ecx - number of bytes to copy
;;     esi - address of the source string
;;     edi - address of the destination string
;;
str_copy:
	cmp	ecx, 0
	je	.e
	mov	al, byte [esi]
	mov	byte [edi], al
	inc	esi
	inc	edi
	dec	ecx
	jmp	str_copy
.e:
	ret
