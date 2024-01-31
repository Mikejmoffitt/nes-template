	.segment	"PRGFIXED"
	.include	"macros/famicom.inc"
	.include	"macros/mmc3.inc"
	.include	"config.inc"

	.exportzp	VramQueuePtr

; Initializes buffers and vars for the VRAM queue.
	.export		vram_queue_init

; Call once per frame to process queued VRAM transfers.
	.export		vram_queue_poll

; Call to queue a PPU address set.
; Set VramQueuePtr to the PPU address in question.
; Set A to $00 for a post-inc of 1, or $40 for a post-inc of 32.
; You should call this at least once before queueing a transfer.
	.export		vram_queue_set_ppu

; Call to queue a transfer buffer.
; A indicates the requested buffer size.
; Sets VramQueuePtr to the address within the buffer.
	.export		vram_queue_set_buffer

; Operator byte format:

; 7654 3210
; a... .... PPU address set marker
; If PPU address:
; .v.. .... PPU post-inc mode (0 = 1, 1 = 32)
; .... hhhh High PPU address bits
; Else:
; ..ll llll Data byte count (if PPU address set marker is 0)

	.segment	"PRGFIXED"

vram_queue_set_ppu:
	ldx	VramQueueReadIdx
	; Check that two bytes are available in the queue.
	.repeat	2
	dex
	cpx	VramQueueWriteIdx
	beq	@no_space
	.endrepeat

	and	#$40  ; Allow post-inc setting through
	ora	#$80  ; Mark as PPU address command
	ora	VramQueuePtr

	ldx	VramQueueWriteIdx
	sta	VramQueueBuffer, x
	inx
	lda	VramQueuePtr+1
	sta	VramQueueBuffer, x
	inx
	stx	VramQueueWriteIdx
@no_space:
	rts

vram_queue_set_buffer:
; TODO: Handle wrapping more gracefully
	ldx	VramQueueReadIdx
	tay	; Y as byte counter
@chktop:
	dex
	cpx	VramQueueWriteIdx
	beq	@no_space
	dey
	bne	@chktop
	; Move to the next byte
	ldx	VramQueueWriteIdx
	and	#$3F  ; Byte count limited to $3F
	sta	VramQueueBuffer, x

	; Set buffer address
	txa	; A = X = VramQueueWriteIdx offset @ length field
	sec	; Free +1 to point to data field
	adc	#<VramQueueBuffer  ; LSB of buffer base
	sta	VramQueuePtr
	lda	#>VramQueueBuffer
	adc	#$00
	sta	VramQueuePtr+1

	; Set new write ptr
	txa	; Offset @ length field
	sec	; Free +1 again
	adc	VramQueueBuffer, x  ; Add length of buffer
	sta	VramQueueWriteIdx
@no_space:
	rts

vram_queue_init:
	lda	#$00
	sta	VramQueueWriteIdx
	sta	VramQueueReadIdx
	sta	VramQueueParseMode
	rts

vram_queue_poll:
	ldx	VramQueueReadIdx
@outer:
	cpx	VramQueueWriteIdx
	beq	@finished
; Read the next thing in the buffer
	lda	VramQueueBuffer, x
	bmi	@is_ppu_cmd

; Data copy
@is_bytes_list:
	inx
	and	#$3F  ; Max $40 bytes
	tay  ; Y contains byte tranfer count.

@byte_copy_top:
	lda	VramQueueBuffer, x
	sta	PPUDATA
	dey
	beq	@next
	inx
	jmp	@byte_copy_top

; PPU command (PPUCTRL and PPUADDR)
@is_ppu_cmd:
	; Store upper byte for some bit tests
	tay
	; Write upper address
	bit	PPUSTATUS
	and	#$3F
	sta	PPUADDR
	; Write lower address
	inx
	lda	VramQueueBuffer, x
	sta	PPUADDR
	; Set up PPUCTRL
	tya
	and	#$40
	beq	@set_ppuctrl_h_inc
@set_ppuctrl_v_inc:
	lda	PpuCtrlConfig
	ora	#$04  ; Set post-inc bit to add 32
	sta	PPUCTRL
	bne	@next  ; Always taken
@set_ppuctrl_h_inc:
	lda	PpuCtrlConfig
	and	#$FC  ; Clear post-inc bit to add 1
	sta	PPUCTRL
	; Fall-through to next
@next:
	; Go to next, wrapping on depth boundary
	inx
	stx	VramQueueReadIdx
	jmp	@outer

@finished:
	; Put back PPUCTRL how we found it.
	lda	PpuCtrlConfig
	sta	PPUCTRL
	rts

	.segment	"ZP"
; Indexing for array commands
VramQueueWriteIdx:	.res 1
VramQueueReadIdx:	.res 1
VramQueueParseMode:	.res 1
VramQueuePtr:	.res 2

	.segment	"BSS"
VramQueueBuffer:	.res $100
