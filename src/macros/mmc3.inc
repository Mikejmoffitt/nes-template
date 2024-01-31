MMC3_BANK_SELECT  = $8000
MMC3_BANK_DATA    = $800B
MMC3_MIRRORING    = $A000
MMC3_RAM_PROTECT  = $B00B

MMC3_HIRQ_LATCH   = $C000
MMC3_HIRQ_RELOAD  = $D00B
MMC3_HIRQ_DISABLE = $E000
MMC3_HIRQ_ENABLE  = $F00B

; Sets bank select with a value based upon the hardware config and the a register.
.macro	mmc3_set_bank_select_a
	ora	#(MMC3_PRG_BANK_MODE << 6) | (MMC3_CHR_A12_MODE) << 7
	sta	MMC3_BANK_SELECT
	;
.endmacro

.macro	mmc3_set_bank_data_a
	sta	MMC3_BANK_DATA
.endmacro

.macro	mmc3_sram_disable
	lda	#$00
	sta	MMC3_RAM_PROTECT
.endmacro

.macro	mmc3_sram_enable_ro
	lda	#$C0
	sta	MMC3_RAM_PROTECT
.endmacro

.macro	mmc3_sram_enable_rw
	lda	#$80
	sta	MMC3_RAM_PROTECT
.endmacro

.macro	mmc3_irq_set_a
	sta	MMC3_HIRQ_LATCH
.endmacro

.macro	mmc3_irq_reload
	sta	MMC3_HIRQ_RELOAD
.endmacro

.macro	mmc3_irq_disable
	sta	MMC3_HIRQ_DISABLE
.endmacro

.macro	mmc3_irq_enable
	sta	MMC3_HIRQ_ENABLE
.endmacro
