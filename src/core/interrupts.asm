	.export	nmi_vector
	.export	irq_vector
	.export	wait_nmi

	.include	"macros/famicom.inc"

	.segment "BANKFIXED"

; ============================
; NMI ISR
; This is run once per frame - it will allow any function spinning on the
; VblFlag variable to proceed.
;
; For frame synchronization, call wait_nmi:
;
;	jsr wait_nmi
; ============================
nmi_vector:
	pha			; Preseve A
	
	lda	#$00
	sta	PPUCTRL		; Disable NMI
	sta	VblFlag

	lda	#$80		; Bit 7, VBlank activity flag
@vbl_done:
	bit	PPUSTATUS		; Check if vblank has finished
	bne	@vbl_done		; Repeat until vblank is over

	lda	#%10011011
	sta	PPUCTRL		; Re-enable NMI

	pla			; Restore registers from stack

	rti

wait_nmi:
	lda	VblFlag
	bne	wait_nmi	; Spin here until NMI lets us through
	lda	#$01
	sta	VblFlag
	rts

; ============================
; IRQ ISR
; Unused; can be wired to cartridge for special hardware. The UNROM mapper does
; not use the IRQ pin for anything like scanline interrupts or timers, etc.
; ============================
irq_vector:
	rti

	.segment	"BSS"
VblFlag:	.res 1
