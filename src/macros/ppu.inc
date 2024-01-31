; Turn off rendering
.macro ppu_disable
  ; Disable rendering
	lda	#$00
	sta	PPUMASK
.endmacro

; Turn on rendering
.macro ppu_enable
  ; Restore PPUMASK configration.
	lda	PpuMaskConfig
	sta	PPUMASK

  ; Re-enable NMI
	lda	PpuCtrlConfig
	sta	PPUCTRL
.endmacro

; Loads a full palette.
.macro ppu_load_full_palette pal_data
	ppu_load_addr $3f00
	ldx	#$00
:
	lda	pal_data, x
	sta	PPUDATA
	inx
	cpx	#$20
	bne	:-
.endmacro

; Loads a full BG palette.
.macro ppu_load_bg_palette pal_data
	ppu_load_addr $3f00
	ldx	#$00
:
	lda	pal_data, x
	sta	PPUDATA
	inx
	cpx	#$10
	bne	:-
.endmacro

; Loads a full SPR palette
.macro ppu_load_spr_palette pal_data
	ppu_load_addr $3f10
	ldx	#$00
:
	lda	pal_data, x
	sta	PPUDATA
	inx
	cpx	#$10
	bne	:-
.endmacro

; Copies 1KiB (binary nametable + attribute data) into VRAM
.macro ppu_write_8kbit source, index
	ldy	index  ; Upper byte of VRAM Address
	ldx	#$00  ; Lower byte of VRAM Address

	bit	PPUSTATUS
	sty	PPUADDR
	stx	PPUADDR

; X is the offset in both the source table and the nametable destination.
; PPUADDR increments with every write to PPUDATA, so an unrolled two-level
; nested loop becomes four single loops, taking us through the source
; table in four chunks.

:
	lda	source, x  ; Offset within both source and dest.
	sta	PPUDATA
	inx
	bne	:-
:
	lda	source + $100, x  ; Offset within both source and dest.
	sta	PPUDATA
	inx
	bne	:-
:
	lda	source + $200, x  ; Offset within both source and dest.
	sta	PPUDATA
	inx
	bne	:-
:
	lda	source + $300, x  ; Offset within both source and dest.
	sta	PPUDATA
	inx
	bne	:-
.endmacro

; Copies 4KiB into VRAM.
.macro ppu_write_32kbit source, index
	ldy	index  ; Upper byte of VRAM Address
	ldx	#$00  ; Lower byte of VRAM Address

	bit	PPUSTATUS
	sty	PPUADDR
	stx	PPUADDR

:
	lda	source, x  ; Offset within both source and dest.
	sta	PPUDATA
	inx
	bne	:-
:
	lda	source + $100, x  ; Offset within both source and dest.
	sta	PPUDATA
	inx
	bne	:-
:
	lda	source + $200, x  ; Offset within both source and dest.
	sta	PPUDATA
	inx
	bne	:-
:
	lda	source + $300, x  ; Offset within both source and dest.
	sta	PPUDATA
	inx
	bne	:-
:
	lda	source + $400, x  ; Offset within both source and dest.
	sta	PPUDATA
	inx
	bne	:-
:
	lda	source + $500, x  ; Offset within both source and dest.
	sta	PPUDATA
	inx
	bne	:-
:
	lda	source + $600, x  ; Offset within both source and dest.
	sta	PPUDATA
	inx
	bne	:-
:
	lda	source + $700, x  ; Offset within both source and dest.
	sta	PPUDATA
	inx
	bne	:-
:
	lda	source + $800, x  ; Offset within both source and dest.
	sta	PPUDATA
	inx
	bne	:-
:
	lda	source + $900, x  ; Offset within both source and dest.
	sta	PPUDATA
	inx
	bne	:-
:
	lda	source + $a00, x  ; Offset within both source and dest.
	sta	PPUDATA
	inx
	bne	:-
:
	lda	source + $b00, x  ; Offset within both source and dest.
	sta	PPUDATA
	inx
	bne	:-
:
	lda	source + $c00, x  ; Offset within both source and dest.
	sta	PPUDATA
	inx
	bne	:-
:
	lda	source + $d00, x  ; Offset within both source and dest.
	sta	PPUDATA
	inx
	bne	:-
:
	lda	source + $e00, x  ; Offset within both source and dest.
	sta	PPUDATA
	inx
	bne	:-
:
	lda	source + $f00, x  ; Offset within both source and dest.
	sta	PPUDATA
	inx
	bne	:-
.endmacro

; Latches the PPU address
.macro ppu_load_addr addr
	bit	PPUSTATUS
	lda	#(addr >> 8)
	sta	PPUADDR
	lda	#(addr & $FF)
	sta	PPUADDR
.endmacro

; OAM Access macros

; for storing the accumulator (A) as a propery for the specified sprite
.macro oam_write_y idx
	sta	OAM_BASE+((idx) << 2)
.endmacro

.macro oam_write_tile idx
	sta	OAM_BASE+1+((idx) << 2)
.endmacro

.macro oam_write_attr idx
	sta	OAM_BASE+2+((idx) << 2)
.endmacro

.macro oam_write_x idx
	sta	OAM_BASE+3+((idx) << 2)
.endmacro

; Macros to provide a value or address for OAM storage
.macro oam_set_y idx, val
	lda	val
	oam_write_y idx
.endmacro

.macro oam_set_tile idx, val
	lda	val
	oam_write_tile idx
.endmacro

.macro oam_set_attr idx, val
	lda	val
	oam_write_attr idx
.endmacro

.macro oam_set_x idx, val
	lda	val
	oam_write_x idx
.endmacro

; Run an OAM DMA
.macro oam_dma
	lda	#$02
	sta	OAMDMA
.endmacro
