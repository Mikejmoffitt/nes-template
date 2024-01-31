HW_PRG_BYTES        = 8192
HW_CHR_BYTES        = 0  ; CHR RAM.
HW_MAPPER           = $02  ; Typical UxROM
; Byte 6
HW_MIRROR           = 0  ; 'H'. 0 = CRAM A10 = PPU A11. 1 = CRAM A10 = PPU A10.
HW_PRG_SRAM_PRESENT = 0  ; If 1, battery-backed RAM is at $6000-$7FFF.
HW_VRAM_EXPANSION   = 0  ; If 1, four-screen VRAM is used instead of mirroring.
; Byte 7
HW_VS_UNISYSTEM     = 0
HW_PLAYCHOICE       = 0
; Byte 8
HW_PRG_SRAM_BYTES   = 0  ; 0 to $2000.
; Byte 9
HW_TV_PAL           = 0  ; 0 for NTSC.

MMC3_PRG_BANK_MODE  = 0  ; $C000-$FFFF fixed region
MMC3_CHR_A12_MODE   = 0  ; Four banks at $1000-$1FFF
