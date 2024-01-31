	.include	"macros/famicom.inc"
	.include	"macros/uxrom.inc"
	.include	"macros/ppu.inc"

; -----------------------------------------------------------------------------

	.segment	"BANKFIXED"

	.export	main

	.importzp	Addr

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

	; Switch the upper half of PRG memory to Bank E
	uxrom_bank_load	#$0E

	; Load in a palette
	ppu_load_bg_palette	sample_palette_data
	
	; Load in CHR tiles to VRAM for BG
	; Remember, BG data starts at $0000 - we must specify the upper byte of
	; the destination address ($00).
	ppu_write_32kbit	sample_chr_data, #$00

	; and for sprites, which start at $1000.
	ppu_write_32kbit	sample_chr_data + $1000, #$10

	; Write a sample string.
	ppu_load_addr ($2000 + (1 * $20) + 1)  ; (1, 1)

	lda	#<str_hello_world
	sta	Addr
	lda	#>str_hello_world
	sta	Addr+1
	jsr	string_print_sub

	; Put scroll at 0, 0
	bit	PPUSTATUS
	lda	#$00
	sta	PPUSCROLL ; X scroll
	sta	PPUSCROLL ; Y scroll

	; Bring the PPU back up.
	jsr	wait_nmi

	ppu_enable

@main_top_loop:
	jsr	read_joy_safe
	; Run game logic here
	jsr	wait_nmi
	ppu_disable

	lda	PpuCtrlConfig
	sta	PPUCTRL
	lda	PpuMaskConfig
	sta	PPUMASK

	; Commit VRAM updates while PPU is disabled in vblank
	; TODO: Sample VRAM queue process
	ppu_enable
	jmp	@main_top_loop; loop forever

; Load Addr.w with the string address.
string_print_sub:
	ldy	#$00
	lda	(Addr), y
	bne	@copytop
	rts

@copytop:
	iny
	sta	PPUDATA
	lda	(Addr), y
	bne	@copytop
@finished:
	rts

str_hello_world:
	.byte	"HELLO FAMICOM",0
