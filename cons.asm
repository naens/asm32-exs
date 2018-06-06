;; equates
max_num_len	equ	8
cons_rdbf_len	equ	200h

;: cons_prstr: print null-terminated string
cons_prstr:
	mov	ebx, eax	; string address in ebx
	mov	esi, 0		; length in esi
.lp:
	cmp	byte [ebx+esi], 0
	je	.e
	inc	esi
	jmp	.lp
.e:
	mov	ecx, ebx	; string address
	mov	eax, sys_write
	mov	ebx, stdout
	mov	edx, esi
	int	80h
	ret



;; Function: cons_prnum
;;     print number in eax

	section .bss
prnum_buf2	resb	max_num_len

	section .text
cons_prnum:
	mov	esi, prnum_buf2 + max_num_len - 1
	mov	byte [esi], 0ah
	dec	esi
	cmp	eax, 0
	je	.0
	mov	ecx, 10
.lp:
	mov	edx, 0
	div	ecx		; eax=div, edx=mod
	add	dl, '0'
	mov	[esi], dl
	cmp	eax, 0
	je	.pr
	dec	esi
	jmp	.lp
.pr:
	mov	eax, sys_write
	mov	ebx, stdout
	mov	ecx, esi
	mov	edx, prnum_buf2 + max_num_len
	sub	edx, esi
	int	80h
	ret
.0:
	mov	byte [esi], '0'
	mov	eax, sys_write
	mov	ebx, stdout
	mov	ecx, esi
	mov	edx, 1
	int	80h
	ret


;; Function: cons_readln
;;     Reads one line from the console even if the user enter several
;;     lines at the same time.  The rest of the lines are returned on
;;     following calls.
;;
;; Parameters: nothing
;;
;; Returns: ax - pointer to the null-teminated string read.
;;
;  Pseudocode:
;      rdbf_len: size of the buffer, maximum amount that can be read
;      buf: array of *bufsz* bytes
;      buflen: number of bytes read
;      bufind: index into the buffer
;                 if equals buflen: no more bytes to read
;                 if less than buflen: points to the current bytes
;      if bufind = buflen then // must read
;          bufind = 0
;          buflen = read(buf, bufsz)
;      fi
;      result = bufind
;      while buf[bufind] <> NL do
;          inc bufind
;      buf[bufind] = 0
;      inc bufind
;      return result
;
	section .data
readln_buflen	dd	0
readln_bufind	dd	0

	section .bss
readln_buf	resb	cons_rdbf_len

	section .text

cons_readln:
	; if bufind <> buflen then skip
	mov	eax, [readln_buflen]
	cmp	[readln_bufind], eax
	jl	.ife

	; bufind = 0
	mov	dword [readln_bufind], 0

	; buflen = read(buf, bufsz)
	mov	eax, sys_read
	mov	ebx, stdin
	mov	ecx, readln_buf
	mov	edx, cons_rdbf_len
	int	80h
	mov	dword [readln_buflen], eax
.ife:

	; result = bufind
	mov	ebx, [readln_bufind]		; bufind in ebx
	lea	eax, [readln_buf+ebx]	; result in eax

	; while buf[bufind] <> 0ah
.whlp:
	cmp	byte [readln_buf+ebx], 0ah
	je	.whe
	inc	ebx
	jmp	.whlp
.whe:

	; buf[bufind] = 0
	mov	byte [readln_buf+ebx], 0

	inc	ebx
	mov	[readln_bufind], ebx		; put ebx in bufind
	ret

;; Function: cons_nl
;;     prints new line on console
cons_nl:
	mov	eax, 0ah
	push	eax
	mov	eax, sys_write
	mov	ebx, stdout
	mov	ecx, esp
	mov	edx, 1
	int	80h
	pop	eax
	ret

