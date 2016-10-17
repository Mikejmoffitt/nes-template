PPUCTRL			= $2000
PPUMASK			= $2001
PPUSTATUS		= $2002
OAMADDR			= $2003
OAMDATA			= $2004
PPUSCROLL		= $2005
PPUADDR			= $2006
PPUDATA			= $2007
OAMDMA			= $4014
DMCFREQ			= $4010

; A button comparison table for reading joypads
BUTTON_A		= %10000000
BUTTON_B		= %01000000
BUTTON_SEL		= %00100000
BUTTON_START		= %00010000
BUTTON_UP		= %00001000
BUTTON_DOWN		= %00000100
BUTTON_LEFT		= %00000010
BUTTON_RIGHT		= %00000001

OAM_BASE		= $200

; Turn off rendering
.macro ppu_disable
	; Disable rendering
	lda #$00
	sta PPUMASK
.endmacro

; Turn on rendering
.macro ppu_enable

	; Restore PPUMASK configration.
	lda ppumask_config
	sta PPUMASK

	; Re-enable NMI
	lda ppuctrl_config
	sta PPUCTRL
.endmacro

; Switch UNROM/UOROM banks
; This macro exists to ensure that the data being presented by the PRG ROM
; chip doesn't conflict with the data the 2A03 is writing to the data bus, as
; UNROM and UOROM make no provisions to prevent a bus conflict, which could
; damage one or more driving chips over time if not handled correct.
.macro bank_load num
:
	ldy num
	sty :- + 1
.endmacro

; OAM Access macros

; for storing the accumulator (A) as a propery for the specified sprite
.macro write_oam_y idx
	sta OAM_BASE+((idx) << 2)
.endmacro

.macro write_oam_tile idx
	sta OAM_BASE+1+((idx) << 2)
.endmacro

.macro write_oam_attr idx
	sta OAM_BASE+2+((idx) << 2)
.endmacro

.macro write_oam_x idx
	sta OAM_BASE+3+((idx) << 2)
.endmacro

; Macros to provide a value or address for OAM storage
.macro set_oam_y idx, val
	lda val
	write_oam_y idx
.endmacro

.macro set_oam_tile idx, val
	lda val
	write_oam_tile idx
.endmacro

.macro set_oam_attr idx, val
	lda val
	write_oam_attr idx
.endmacro

.macro set_oam_x idx, val
	lda val
	write_oam_x idx
.endmacro

; Run an OAM DMA
.macro spr_dma
	lda #$02
	sta OAMDMA
.endmacro

; Latch the PPU address; mangles A
.macro ppu_load_addr addr, addr_e
	bit PPUSTATUS
	lda addr
	sta PPUADDR
	lda addr_e
	sta PPUADDR
.endmacro

; Check if a button is held; branch to :+ if not
.macro key_isdown pad, btn_comp
	lda pad
	bit btn_comp
	beq :+
.endmacro

; Check if a button is up; branch to :+ if not
.macro key_isup pad, btn_comp
	lda pad
	bit btn_comp
	bne :+
.endmacro

; Check if a button has just been pressed; branch to :+ if not
.macro key_down pad, btn_comp
	lda pad
	bit btn_comp
	beq :+
	lda pad+1 ;pad_prev
	bit btn_comp
	bne :+
.endmacro

; Check if a button has just been released; branch to :+ if not
.macro key_up pad, btn_comp
	lda pad
	bit btn_comp
	bne:+
	lda pad+1 ; pad_prev
	bit btn_comp
	beq :+
.endmacro

; Latch the PPU scroll; mangles A
.macro ppu_load_scroll cam_x, cam_y
	bit PPUSTATUS
	lda cam_x
	sta PPUSCROLL
	lda cam_y
	sta PPUSCROLL
	; Clamp scroll values
	lda xscroll+1
	and #%00000001
	sta xscroll+1
	lda yscroll+1
	and #%00000001
	sta yscroll+1

	lda ppuctrl_config
	ora xscroll+1	      ; Bring in X scroll coarse bit
	ora yscroll+1	      ; Y scroll coarse bit
	sta PPUCTRL		     ; Re-enable NMI
.endmacro

; Load a full palette
.macro ppu_load_full_palette pal_data
	ppu_load_addr #$3f, #$00
	ldx #$00
:
	lda pal_data, x
	sta PPUDATA
	inx
	cpx #$20
	bne :-
.endmacro

; Load a full BG palette
.macro ppu_load_bg_palette pal_data
	ppu_load_addr #$3f, #$00
	ldx #$00
:
	lda pal_data, x
	sta PPUDATA
	inx
	cpx #$10
	bne :-
.endmacro

; Load a full SPR palette
.macro ppu_load_spr_palette pal_data
	ppu_load_addr #$3f, #$10
	ldx #$00
:
	lda pal_data, x
	sta PPUDATA
	inx
	cpx #$10
	bne :-
.endmacro

; Add a 16-bit memory value to addr
.macro sum16 addr, val
	clc
	lda addr
	adc val
	sta addr
	lda addr+1
	adc val+1
	sta addr+1
.endmacro

.macro sub16 addr, amt
	sec
	lda addr
	sbc amt
	sta addr
	lda addr+1
	sbc amt+1
	sta addr+1
.endmacro

; Negate a 16-bit address
.macro neg16 addr
	sec
	lda #$00
	sbc addr
	sta addr
	lda #$00
	sbc addr+1
	sta addr+1
.endmacro

; Copy binary nametable + attribute data into VRAM

.macro ppu_write_8kbit source, index
	ldy index		       ; Upper byte of VRAM Address
	ldx #$00			; Lower byte of VRAM Address

	bit PPUSTATUS
	sty PPUADDR
	stx PPUADDR

; X is the offset in both the source table and the nametable destination.
; PPUADDR increments with every write to PPUDATA, so an unrolled two-level
; nested loop becomes four single loops, taking us through the source
; table in four chunks.

:
	lda source, x		   ; Offset within both source and dest.
	sta PPUDATA
	inx
	bne :-
:
	lda source + $100, x	    ; Offset within both source and dest.
	sta PPUDATA
	inx
	bne :-
:
	lda source + $200, x	    ; Offset within both source and dest.
	sta PPUDATA
	inx
	bne :-
:
	lda source + $300, x	    ; Offset within both source and dest.
	sta PPUDATA
	inx
	bne :-
.endmacro

.macro ppu_write_32kbit source, index
	ldy index		       ; Upper byte of VRAM Address
	ldx #$00			; Lower byte of VRAM Address

	bit PPUSTATUS
	sty PPUADDR
	stx PPUADDR

; X is the offset in both the source table and the nametable destination.
; PPUADDR increments with every write to PPUDATA, so an unrolled two-level
; nested loop becomes four single loops, taking us through the source
; table in four chunks.

:
	lda source, x		   ; Offset within both source and dest.
	sta PPUDATA
	inx
	bne :-
:
	lda source + $100, x	    ; Offset within both source and dest.
	sta PPUDATA
	inx
	bne :-
:
	lda source + $200, x	    ; Offset within both source and dest.
	sta PPUDATA
	inx
	bne :-
:
	lda source + $300, x	    ; Offset within both source and dest.
	sta PPUDATA
	inx
	bne :-
:
	lda source + $400, x	    ; Offset within both source and dest.
	sta PPUDATA
	inx
	bne :-
:
	lda source + $500, x	    ; Offset within both source and dest.
	sta PPUDATA
	inx
	bne :-
:
	lda source + $600, x	    ; Offset within both source and dest.
	sta PPUDATA
	inx
	bne :-
:
	lda source + $700, x	    ; Offset within both source and dest.
	sta PPUDATA
	inx
	bne :-
:
	lda source + $800, x	    ; Offset within both source and dest.
	sta PPUDATA
	inx
	bne :-
:
	lda source + $900, x	    ; Offset within both source and dest.
	sta PPUDATA
	inx
	bne :-
:
	lda source + $a00, x	    ; Offset within both source and dest.
	sta PPUDATA
	inx
	bne :-
:
	lda source + $b00, x	    ; Offset within both source and dest.
	sta PPUDATA
	inx
	bne :-
:
	lda source + $c00, x	    ; Offset within both source and dest.
	sta PPUDATA
	inx
	bne :-
:
	lda source + $d00, x	    ; Offset within both source and dest.
	sta PPUDATA
	inx
	bne :-
:
	lda source + $e00, x	    ; Offset within both source and dest.
	sta PPUDATA
	inx
	bne :-
:
	lda source + $f00, x	    ; Offset within both source and dest.
	sta PPUDATA
	inx
	bne :-
.endmacro
