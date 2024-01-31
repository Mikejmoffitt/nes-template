; Checks if a button is held; branch to :+ if not
.macro key_isdown pad, comparison
	lda	pad
	bit	comparison
	beq	:+
.endmacro

; Checks if a button is up; branch to :+ if not
.macro key_isup pad, comparison
	lda	pad
	bit	comparison
	bne	:+
.endmacro

; Checks if a button has just been pressed; branch to :+ if not
.macro key_down pad, comparison
	lda	pad
	bit	comparison
	beq	:+
	lda	pad+1 ;pad_prev
	bit	comparison
	bne	:+
.endmacro

; Checks if a button has just been released; branch to :+ if not
.macro key_up pad, comparison
	lda	pad
	bit	comparison
	bne	+
	lda	pad+1 ; pad_prev
	bit	comparison
	beq	:+
.endmacro
