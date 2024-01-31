	.segment	"PRGFIXED"

	.include	"macros/famicom.inc"
	.include	"macros/ppu.inc"

	.export	reset_vector

	.import	PpuCtrlConfig
	.import	PpuMaskConfig

	.import	oam_init
	.import	vram_queue_init
	.import	main

reset_vector:
	sei	; ignore IRQs
; Set stack
	ldx	#>StackMem-1
	txs	

	ldx	#%00000100
	stx	APUFCOUNT	; Disable APU frame IRQ

	ldx	#>StackMem-1
	txs			; Set up stack

; Clear some PPU registers
	inx			; X = 0 now
	stx	PPUCTRL		; Disable NMI
	stx	PPUMASK		; Disable rendering
	stx	DMC_FREQ	; Disable DMC IRQs

; Wait for first vblank
@waitvbl1:
	lda	#$80
	bit	PPUSTATUS
	bne	@waitvbl1

	dex
	txa  ; X still = 0; clear A with this
@clrmem:
	sta	$000, x
	sta	$100, x
	sta	$200, x
	sta	$300, x
	sta	$400, x
	sta	$500, x
	sta	$600, x
	inx
	bne	@clrmem

; One more vblank
@waitvbl2:
	lda	#$80
	bit	PPUSTATUS
	bne	@waitvbl2

; PPU configuration for actual use
	ldx	#%10001000	; Nominal PPUCTRL settings:
				; NMI enable
				; Slave mode (don't change this!)
				; 8x8 sprites
				; BG at $0000
				; SPR at $1000
				; VRAM auto-inc 1
				; Nametable at $2000
	stx	PpuCtrlConfig
	stx	PPUCTRL

	ldx	#%00011110
	stx	PpuMaskConfig
	stx	PPUMASK

	; TODO: crtc0 stuff

	jsr	oam_init

	ppu_enable

	jmp	main
