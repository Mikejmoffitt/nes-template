	.exportzp	Temp, Temp2, Temp3, Temp4, Temp5, Temp6, Temp7, Temp8
	.exportzp	Addr, Addr2, Addr3, Addr4
	.export	PpuMaskConfig, PpuCtrlConfig

	.segment "ZP"
; Scratch memory for temporary variables and arguments
Addr:		.res 2
Addr2:		.res 2
Addr3:		.res 2
Addr4:		.res 2
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
