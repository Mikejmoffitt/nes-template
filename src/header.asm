.segment "HEADER"

; Magic cookie
.byte "NES", $1a

; Size of PRG in 16 KB units
.byte 16

; Size of CHR in 8 KB units (0 = CHR RAM)
.byte 0

; Mirroring, save RAM, trainer, mapper low nybble
.byte $21                                   ; UNROM

; Vs., PlayChoice-10, NES 2.0, mapper high nybble
.byte $00

; Size of PRG RAM in 8 KB units
.byte 0

; NTSC/PAL
.byte $00
