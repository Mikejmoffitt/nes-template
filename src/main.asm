	.include	"macros/famicom.inc"
	.include	"macros/uxrom.inc"
	.include	"macros/ppu.inc"
	.include	"macros/vramqueue.inc"

; -----------------------------------------------------------------------------

	.segment	"PRGFIXED"

	.export		main

	.importzp	Addr
	.importzp	VramQueuePtr

; =============================================================================
; ====                                                                     ====
; ====                              Main Begin                             ====
; ====                                                                     ====
; =============================================================================
main:
	; The PPU must be disabled before we write to VRAM. This is done during
	; the vertical blanking interval typically, so we do not need to blank
	; the video in the middle of a frame.
	ppu_disable

	jsr	vram_queue_init

	; Switch the upper half of PRG memory to Bank E
	uxrom_bank_load	#$0E

	; Load in a palette
	ppu_load_bg_palette	sample_palette_data
	
	; Load in CHR tiles to VRAM for BG
	ppu_write_32kbit	sample_chr_data + $1000, #$00

	; Write a sample using the VRAM queue system.
	lda	#<str_hello_world
	sta	Addr
	lda	#>str_hello_world
	sta	Addr+1
	jsr	string_print_sub

	; Bring the PPU back up.
	jsr	wait_nmi

@main_top_loop:
	jsr	read_joy_safe

	jsr	post_logic
	jmp	@main_top_loop; loop forever

; -----------------------------------------------------------------------------

post_logic:
	jsr	wait_nmi
	ppu_disable
	jsr	oam_run_dma
	jsr	vram_queue_poll

	lda	PpuCtrlConfig
	sta	PPUCTRL
	lda	PpuMaskConfig
	sta	PPUMASK

	; Put scroll at 0, 0
	bit	PPUSTATUS
	lda	#$00
	sta	PPUSCROLL ; X scroll
	sta	PPUSCROLL ; Y scroll
	ppu_enable
	rts


; -----------------------------------------------------------------------------

; Load Addr.w with the string address.
string_print_sub:
	vram_t_set_ppu $21AA, 0
	vram_t_set_buffer (str_hello_world_end - str_hello_world - 1)
	; Copy our tile data (string) to the buffer.
	ldy	#$00
@copytop:
	lda	(Addr), y
	beq	@finished
	sta	(VramQueuePtr), y
	iny
	bne	@copytop
@finished:
	rts

str_hello_world:
	.byte	"HELLO FAMICOM",0
str_hello_world_end:

