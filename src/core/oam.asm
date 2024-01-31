	.segment	"BANKFIXED"
	.include	"macros/famicom.inc"

	.export	oam_init
	.export	oam_run_dma

; Clear the OAM table
oam_init:
	ldx	#$00
	lda	#$FF
@clroam_loop:
	sta	OamBuffer, x
	inx
	inx
	inx
	inx
	cpx	#$00
	bne	@clroam_loop
	rts

oam_run_dma:
	lda	#>OamBuffer
	sta	OAMDMA
	rts

	.segment	"OAM_LIST"
OamBuffer:
	.res $100

	.export	OamBuffer
