; Prepare a VRAM transfer buffer.
; addr: immediate PPU address
; vertical: if non-zero, PPU post-increment is 32-bytes (vertical on NT).
.macro	vram_t_set_ppu addr, vertical
	; Set up a data buffer destined for PPU address $2001 (1, 1).
	lda	#addr >> 8
	sta	VramQueuePtr
	lda	#addr & $FF
	sta	VramQueuePtr+1
	.if	vertical = 0
	lda	#$00
	.else
	lda	#$40
	.endif
	jsr	vram_queue_set_ppu
.endmacro

; Get a handle to a newly allocated VRAM transfer buffer.
; The resulting address is loaded into VramQueuePtr.w.
; bytes: immediate
.macro	vram_t_set_buffer bytes
	lda	#bytes
	jsr	vram_queue_set_buffer
.endmacro
