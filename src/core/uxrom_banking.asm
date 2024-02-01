; Support for UXROM banking without bus conflicts. A table is provided that
; allows you to write to the ROM without conflict, in the case that a bank
; number is not an immediate value in ROM. (For the immediate case, just use
; the macro in macros/uxrom.inc).
	.include	"config.inc"

	.if (HW_MAPPER = 2) || (HW_MAPPER = 94) || (HW_MAPPER = 180)

	.include	"macros/uxrom.inc"

	.segment	"PRGFIXED"

; Banks in the number specified in a.
	.export	uxrom_set_bank_a
uxrom_set_bank_a:
	tay
	sta	@uxrom_bank_tbl, y
	rts
; Table for UxROM bankswitching without bus conflicts.
@uxrom_bank_tbl:
	.byte	0, 1, 2, 3, 4, 5, 6, 7
	.byte	8, 9, 10, 11, 12, 13, 14, 15
	.byte	16, 17, 18, 19, 20, 21, 22, 23
	.byte	24, 25, 26, 27, 28, 29, 30, 31

	.endif  ; HW_MAPPER
