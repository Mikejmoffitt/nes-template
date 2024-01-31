	.exportzp	Temp, Temp2, Temp3, Temp4, Temp5, Temp6, Temp7, Temp8
	.export	PpuMaskConfig, PpuCtrlConfig

; =============================
; Zero-page and main RAM
; Variables, flags, etc.
; =============================
	.segment "ZP"
Temp:		.res 1
Temp2:		.res 1
Temp3:		.res 1
Temp4:		.res 1
Temp5:		.res 1
Temp6:		.res 1
Temp7:		.res 1
Temp8:		.res 1

	.segment "BSS"
; Flags for PPU control
PpuMaskConfig:	.res 1
PpuCtrlConfig:	.res 1
