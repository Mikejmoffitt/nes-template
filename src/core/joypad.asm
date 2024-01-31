	.export	read_joy_safe

	.exportzp	Pad1, Pad1Prev
	.exportzp	Pad2, Pad2Prev

	.importzp	Temp, Temp2

	.segment	"BANKFIXED"

	.include	"macros/famicom.inc"

; Reads controller. Reliable when DMC is playing.
; Out: A=buttons held, A button in bit 0
read_joy_safe:
	; Back up previous ones for edge comparisons
	lda	Pad1
	sta	Pad1Prev
	lda	Pad2
	sta	Pad2Prev
	; Get first reading
	jsr	read_joypad_sub
:
	; Save previous reading
	lda	Pad1
	sta	Temp
	lda	Pad2
	sta	Temp2

	; Read again and compare. If they differ,
	; read again.
	jsr	read_joypad_sub
	lda	Pad1
	cmp	Temp
	bne	:-
	lda	Pad2
	cmp	Temp2
	bne	:-
	rts


read_joypad_sub:
	; Strobe
	lda	#1
	sta	JOY1
	sta	Pad2
	lsr	a
	sta	JOY1
:
	lda	JOY1
	and	#$03
	cmp	#$01
	rol	Pad1
	lda	JOY2
	and	#$03
	cmp	#$01
	rol	Pad2
	bcc	:-
	rts

	.segment	"ZP"
Pad1:		.res 1
Pad1Prev:	.res 1
Pad2:		.res 1
Pad2Prev:	.res 1
