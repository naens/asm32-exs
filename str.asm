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

