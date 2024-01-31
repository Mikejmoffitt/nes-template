MEMORY 
{
    # RAM
    ZP:        start = $0000, size = $0100, file="";
    STACK:     start = $0100, size = $0100, file="";
    OAM:       start = $0200, size = $0100, file="";
    RAM:       start = $0300, size = $0400, file="";

    # Special
    HEADER:    start = $0000, size = $0010, fill = yes, fillval=$FF;

    # PRG ROM
    ROM0:      start = $8000, size = $4000, file = %O, type = ro, fill=yes, fillval=$00;
    ROM1:      start = $8000, size = $4000, file = %O, type = ro, fill=yes, fillval=$01;
    ROM2:      start = $8000, size = $4000, file = %O, type = ro, fill=yes, fillval=$02;
    ROM3:      start = $8000, size = $4000, file = %O, type = ro, fill=yes, fillval=$03;
    ROM4:      start = $8000, size = $4000, file = %O, type = ro, fill=yes, fillval=$04;
    ROM5:      start = $8000, size = $4000, file = %O, type = ro, fill=yes, fillval=$05;
    ROM6:      start = $8000, size = $4000, file = %O, type = ro, fill=yes, fillval=$06;
    ROM7:      start = $8000, size = $4000, file = %O, type = ro, fill=yes, fillval=$07;
    ROM8:      start = $8000, size = $4000, file = %O, type = ro, fill=yes, fillval=$08;
    ROM9:      start = $8000, size = $4000, file = %O, type = ro, fill=yes, fillval=$09;
    ROMA:      start = $8000, size = $4000, file = %O, type = ro, fill=yes, fillval=$0A;
    ROMB:      start = $8000, size = $4000, file = %O, type = ro, fill=yes, fillval=$0B;
    ROMC:      start = $8000, size = $4000, file = %O, type = ro, fill=yes, fillval=$0C;
    ROMD:      start = $8000, size = $4000, file = %O, type = ro, fill=yes, fillval=$0D;
    ROME:      start = $8000, size = $4000, file = %O, type = ro, fill=yes, fillval=$0E;
    ROMF:      start = $C000, size = $4000, file = %O, type = ro, fill=yes, fillval=$0F;
}

SEGMENTS 
{
    HEADER:    load = HEADER, type = ro;

    ZP:        load = ZP, type = zp;
    STACK:     load = STACK, type = bss, align = $100;
    OAM_LIST:  load = OAM, type = bss, align = $100;
    BSS:       load = RAM, type = bss, align = $100;

    # Switchable Banks
    BANK0:     load = ROM0, type = ro, start = $8000, optional = yes;
    BANK1:     load = ROM1, type = ro, start = $8000, optional = yes;
    BANK2:     load = ROM2, type = ro, start = $8000, optional = yes;
    BANK3:     load = ROM3, type = ro, start = $8000, optional = yes;
    BANK4:     load = ROM4, type = ro, start = $8000, optional = yes;
    BANK5:     load = ROM5, type = ro, start = $8000, optional = yes;
    BANK6:     load = ROM6, type = ro, start = $8000, optional = yes;
    BANK7:     load = ROM7, type = ro, start = $8000, optional = yes;
    BANK8:     load = ROM8, type = ro, start = $8000, optional = yes;
    BANK9:     load = ROM9, type = ro, start = $8000, optional = yes;
    BANKA:     load = ROMA, type = ro, start = $8000, optional = yes;
    BANKB:     load = ROMB, type = ro, start = $8000, optional = yes;
    BANKC:     load = ROMC, type = ro, start = $8000, optional = yes;
    BANKD:     load = ROMD, type = ro, start = $8000, optional = yes;
    BANKE:     load = ROME, type = ro, start = $8000, optional = yes;

    # The last bank, fixed.
    BANKFIXED: load = ROMF, type = ro, start = $C000;
    VECTORS:   load = ROMF, type = ro, start = $FFFA;

}
