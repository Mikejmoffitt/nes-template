	.include	"def/famicom.inc"
	.include	"def/macros.inc"

; -----------------------------------------------------------------------------

	.segment	"BANKFIXED"

	.export	main

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

	; Put scroll at 0, 0
	bit	PPUSTATUS
	lda	#$00
	sta	PPUSCROLL ; X scroll
	sta	PPUSCROLL ; Y scroll

	; Switch the upper half of PRG memory to Bank E (please see note below)
	bank_load	#$0E

	; Load in a palette
	ppu_load_bg_palette	sample_palette_data
	
	; Load in CHR tiles to VRAM for BG
	; Remember, BG data starts at $0000 - we must specify the upper byte of
	; the destination address ($00).
	ppu_write_32kbit	sample_chr_data, #$00

	; and for sprites, which start at $1000.
	ppu_write_32kbit	sample_chr_data + $1000, #$10

	; Finally, bring in a nametable so the background will draw something.
	; The first nametable begins at $2000, so we specify $20(00).
	ppu_write_8kbit	sample_nametable_data, #$20

	; Duplicate the nametable into the other screen as well.
	ppu_write_8kbit	sample_nametable_data, #$24

	; Bring the PPU back up.
	jsr	wait_nmi

	ppu_enable

@main_top_loop:
	; Run game logic here

	; End of game logic frame; wait for NMI (vblank) to begin
	jsr	wait_nmi

	; Commit VRAM updates while PPU is disabled in vblank
	;ppu_disable

	; Re-enable PPU for the start of a new frame
	;ppu_enable
	jmp	@main_top_loop; loop forever
