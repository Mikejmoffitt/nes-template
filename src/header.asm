.segment "HEADER"

; TODO: This should be somewhat generated based on the resulting output

.byte "NES", $1A
.byte 256/16  ; PRG size / 16KiB
.byte 0/16  ; CHR size / 8KiB
.byte $21  ; Mirror, SRAM, trainer, mapper low nybble
.byte $00  ; VS., PC-10, NES 2.0, mapper high nybble
.byte 0/8  ; PRG ram size / 8KiB
.byte $00  ; NTSC / PAL
