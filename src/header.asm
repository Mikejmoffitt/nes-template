	.segment	"HEADER"

; iNes header

PRG_BYTES        = 256
CHR_BYTES        = 0  ; CHR RAM.
MAPPER           = $02  ; Typical UxROM
; Byte 6
MIRROR           = 0  ; 'H'. 0 = CRAM A10 = PPU A11. 1 = CRAM A10 = PPU A10.
PRG_SRAM_PRESENT = 0  ; If 1, battery-backed RAM is at $6000-$7FFF.
VRAM_EXPANSION   = 0  ; If 1, four-screen VRAM is used instead of mirroring.
; Byte 7
VS_UNISYSTEM     = 0
PLAYCHOICE       = 0
INES2_FORMAT     = 1
; Byte 8
PRG_SRAM_BYTES   = 0  ; 0 to $2000.
; Byte 9
TV_PAL           = 0  ; 0 for NTSC.


; iNES signature
.byte	"NES", $1A

.byte	(PRG_BYTES) / 16  ; PRG size / 16KiB
.byte	(CHR_BYTES) / 16  ; CHR size / 8KiB
FLAG6_MIRROR = MIRROR
FLAG6_SRAM = PRG_SRAM_PRESENT << 1
FLAG6_VRAM_EXP = VRAM_EXPANSION << 3
FLAG6_MAPPER_LO = (MAPPER & $0F) << 4
.byte	FLAG6_MIRROR|FLAG6_SRAM|FLAG6_VRAM_EXP|FLAG6_MAPPER_LO
FLAG7_UNI = VS_UNISYSTEM
FLAG7_PC10 = PLAYCHOICE << 1
FLAG7_MAPPER_HI = (MAPPER & $F0)
.byte	FLAG7_UNI|FLAG7_PC10|FLAG7_MAPPER_HI
.byte	(PRG_SRAM_BYTES) / 8  ; PRG ram size / 8KiB
.byte	(TV_PAL)
.byte	(PRG_SRAM_PRESENT << 4)
