; Switch UNROM/UOROM banks
; This macro exists to ensure that the data being presented by the PRG ROM
; chip doesn't conflict with the data the 2A03 is writing to the data bus, as
; UNROM and UOROM make no provisions to prevent a bus conflict, which could
; damage one or more driving chips over time if not handled correct.
.macro uxrom_bank_load num
:
	ldy	num
	sty	:- + 1
.endmacro
