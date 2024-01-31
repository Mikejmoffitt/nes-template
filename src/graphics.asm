; While our main code is in Bank F, the simple palette data (colors),
; CHR data (graphics), and Nametable data (layout) is located in another
; bank.
; Addresses $C000-$FFFF are hardwired to Bank F in the 2A03's data space "PRG",
; but the upper half of ROM space at $8000-BFFF can be switched out when the
; programmer desires. 
	.segment "BANKE"

	.export	sample_chr_data
	.export	sample_palette_data

; The sample graphics resources.
sample_chr_data:
	.incbin "resources/chr.chr"

sample_palette_data:
	.byte	$0F, $01, $23, $30
	.byte	$0F, $01, $23, $30
	.byte	$0F, $01, $23, $30
	.byte	$0F, $01, $23, $30
	; For a large project, palette data like this is often separated
	; into a separate file and .incbin'd in, just like the other data.
