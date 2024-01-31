	.segment	"BANKFIXED"

	.export	oam_init

; Clear the OAM table
oam_init:
	ldx	#$00
	lda	#$FF
@clroam_loop:
	.repeat	4
	sta	OamBuffer, x
	inx
	.endrep
	cpx	#$00
	bne	@clroam_loop
	rts

	.segment	"OAM_LIST"
OamBuffer:
	.res $100

	.export	OamBuffer
