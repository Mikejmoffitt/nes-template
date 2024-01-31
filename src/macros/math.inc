; Add a 16-bit memory value to addr
.macro sum16 addr, val
	clc
	lda	addr
	adc	val
	sta	addr
	lda	addr+1
	adc	val+1
	sta	addr+1
.endmacro

.macro sub16 addr, amt
	sec
	lda	addr
	sbc	amt
	sta	addr
	lda	addr+1
	sbc	amt+1
	sta	addr+1
.endmacro

; Negate a 16-bit address
.macro neg16 addr
	sec
	lda	#$00
	sbc	addr
	sta	addr
	lda	#$00
	sbc	addr+1
	sta	addr+1
.endmacro

