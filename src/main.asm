; iNES Header
.include "header.asm"

; =============================
; Zero-page and main RAM
; Variables, flags, etc.
; =============================
.segment "ZEROPAGE"
; Fast variables
temp:		.res 1
temp2:		.res 1
temp3:		.res 1
temp4:		.res 1
temp5:		.res 1
temp6:		.res 1
temp7:		.res 1
temp8:		.res 1
pad_1:		.res 1
pad_1_prev:	.res 1
pad_2:		.res 1
pad_2_prev:	.res 1

.segment "RAM"
; Flags for PPU control
ppumask_config:	.res 1
ppuctrl_config:	.res 1
vblank_flag:	.res 1
xscroll:	.res 2
yscroll:	.res 2

; Some useful macros
.include "cool_macros.asm"

; ============================
; PRG bank F
;
; Bank F is hardwired to $C000 - $FFFF, and is where the boot code resides.
; Subsequently all code in Bank F is accessible when any bank is active. Common
; utility code should go here.
; ============================
.segment "BANKF"
.include "utils.asm"

; ============================
; NMI ISR
; This is run once per frame - it will allow any function spinning on the
; vblank_flag variable to proceed.
;
; For frame synchronization, call wait_nmi:
;
;	jsr wait_nmi
; ============================
nmi_vector:
	pha				; Preseve A
	
	lda #$00
	sta PPUCTRL			; Disable NMI
	sta vblank_flag

	lda #$80			; Bit 7, VBlank activity flag
@vbl_done:
	bit PPUSTATUS			; Check if vblank has finished
	bne @vbl_done			; Repeat until vblank is over

	lda #%10011011
	sta PPUCTRL			; Re-enable NMI

	pla				; Restore registers from stack

	rti

; ============================
; IRQ ISR
; Unused; can be wired to cartridge for special hardware. The UNROM mapper does
; not use the IRQ pin for anything like scanline interrupts or timers, etc.
; ============================
irq_vector:
	rti

; ============================
; Entry vector
; ============================

reset_vector:
; Basic 6502 init, straight outta NESDev
	sei				; ignore IRQs
	cld				; No decimal mode, it isn't supported
	ldx #%00000100
	stx $4017			; Disable APU frame IRQ

	ldx #$ff
	txs				; Set up stack

; Clear some PPU registers
	inx				; X = 0 now
	stx PPUCTRL			; Disable NMI
	stx PPUMASK			; Disable rendering
	stx DMCFREQ			; Disable DMC IRQs

; Set an upper bank
	bank_load #$00

; Wait for first vblank
@waitvbl1:
	lda #$80
	bit PPUSTATUS
	bne @waitvbl1

; Wait for the PPU to go stable
	txa				; X still = 0; clear A with this
@clrmem:
	sta $000, x
	sta $100, x
	; Reserving $200 for OAM display list
	sta $300, x
	sta $400, x
	sta $500, x
	sta $600, x

	inx
	bne @clrmem

; One more vblank
@waitvbl2:
	lda #$80
	bit PPUSTATUS
	bne @waitvbl2

; PPU configuration for actual use
	ldx #%10001000		; Nominal PPUCTRL settings:
				; NMI enable
				; Slave mode (don't change this!)
				; 8x8 sprites
				; BG at $0000
				; SPR at $1000
				; VRAM auto-inc 1
				; Nametable at $2000
	stx ppuctrl_config
	stx PPUCTRL

	ldx #%00011110
	stx ppumask_config
	stx PPUMASK

	ppu_enable

	jmp main_entry ; GOTO main loop

; =============================================================================
; ====                                                                     ====
; ====                            Program Begin                            ====
; ====                                                                     ====
; =============================================================================
main_entry:

	; The PPU must be disabled before we write to VRAM. This is done during
	; the vertical blanking interval typically, so we do not need to blank
	; the video in the middle of a frame.
	ppu_disable

	; Clear sprites
	jsr spr_init

	; Put scroll at 0, 0
	bit PPUSTATUS
	lda #$00
	sta PPUSCROLL ; X scroll
	sta PPUSCROLL ; Y scroll

	; Switch the upper half of PRG memory to Bank E (please see note below)
	bank_load #$0E

	; Load in a palette
	ppu_load_bg_palette sample_palette_data
	
	; Load in CHR tiles to VRAM for BG
	; Remember, BG data starts at $0000 - we must specify the upper byte of
	; the destination address ($00).
	ppu_write_32kbit sample_chr_data, #$00

	; and for sprites, which start at $1000.
	ppu_write_32kbit sample_chr_data + $1000, #$10

	; Bring the PPU back up.
	jsr wait_nmi
	ppu_enable

main_top_loop:

	; Run game logic here

	; End of game logic frame; wait for NMI (vblank) to begin
	jsr wait_nmi

	; Commit VRAM updates while PPU is disabled in vblank
	;ppu_disable

	; Re-enable PPU for the start of a new frame
	;ppu_enable
	jmp main_top_loop; loop forever

; While our main code is in Bank F, the simple palette data (colors),
; CHR data (graphics), and Nametable data (layout) is located in another
; bank.
; Addresses $C000-$FFFF are hardwired to Bank F in the 2A03's data space "PRG",
; but the upper half of ROM space at $8000-BFFF can be switched out when the
; programmer desires. 
.segment "BANKE"

; The sample graphics resources.
sample_chr_data:
	.incbin "resources/chr.chr"

sample_palette_data:
	.byte	$0F, $01, $23, $30
	.byte	$0F, $01, $23, $30
	.byte	$0F, $01, $23, $30
	.byte	$0F, $01, $23, $30
	; For a large project, palette data like this is often separated
	; into a separate file and .incbin'd in, just like the other data.

; These are needed to boot the NES.
.segment "VECTORS"

	.addr	nmi_vector	; Every vblank, this ISR is executed.
	.addr	reset_vector	; On bootup or reset, execution begins here.
	.addr	irq_vector	; Triggered by external hardware in the
				; game cartridge, this ISR is executed. A
				; software break (BRK) will do it as well.
