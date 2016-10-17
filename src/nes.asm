.macpack generic
.feature force_range


; These are fairly standard names
PPUCTRL     = $2000
PPUMASK     = $2001
PPUSTATUS   = $2002
OAMADDR     = $2003
OAMDATA     = $2004
PPUSCROLL   = $2005
PPUADDR     = $2006
PPUDATA     = $2007
OAMDMA      = $4014

; These are names I made up
SQ1VOL      = $4000
SQ1SWP      = $4001
SQ1FREQ     = $4002
SQ1LEN      = $4003
SQ2VOL      = $4004
SQ2SWP      = $4005
SQ2FREQ     = $4006
SQ2LEN      = $4007
TRICNTR     = $4008
; nothing at $4009
TRIFREQ     = $400a
TRILEN      = $400b
NOISEVOL    = $400c
; Nothing at $400d
NOISEFREQ   = $400e
NOISELEN    = $400f
DMCFREQ     = $4010
DMCDELTA    = $4011
DMCADDR     = $4012
DMCLEN      = $4013
; $4014 is handled above
CHANCTRL    = $4015
JOY1        = $4016                         ; when reading
JOYSTROBE   = $4016                         ; when writing
JOY2        = $4017                         ; when reading
APUIRQ      = $4017                         ; when writing


; Controller buttons
JOY_A       = $01
JOY_B       = $02
JOY_SELECT  = $04
JOY_START   = $08
JOY_UP      = $10
JOY_DOWN    = $20
JOY_LEFT    = $40
JOY_RIGHT   = $80
