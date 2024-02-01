MEMORY 
{
    # RAM
    ZEROPAGE:  start = $0000, size = $0100, file = "", type = rw;
    STACK:     start = $0100, size = $0100, file = "", type = rw;
    OAM:       start = $0200, size = $0100, file = "", type = rw;
    RAM:       start = $0300, size = $0400, file = "", type = rw;

    # Special
    HEADER:    start = $0000, size = $0010, fill = yes, fillval=$FF;

    # PRG PRG
    PRG0:      start = $8000, size = $4000, file = %O, type = ro, fill=yes, fillval=$00;
    PRG1:      start = $8000, size = $4000, file = %O, type = ro, fill=yes, fillval=$01;
    PRG2:      start = $8000, size = $4000, file = %O, type = ro, fill=yes, fillval=$02;
    PRG3:      start = $8000, size = $4000, file = %O, type = ro, fill=yes, fillval=$03;
    PRG4:      start = $8000, size = $4000, file = %O, type = ro, fill=yes, fillval=$04;
    PRG5:      start = $8000, size = $4000, file = %O, type = ro, fill=yes, fillval=$05;
    PRG6:      start = $8000, size = $4000, file = %O, type = ro, fill=yes, fillval=$06;
    PRG7:      start = $8000, size = $4000, file = %O, type = ro, fill=yes, fillval=$07;
    PRG8:      start = $8000, size = $4000, file = %O, type = ro, fill=yes, fillval=$08;
    PRG9:      start = $8000, size = $4000, file = %O, type = ro, fill=yes, fillval=$09;
    PRGA:      start = $8000, size = $4000, file = %O, type = ro, fill=yes, fillval=$0A;
    PRGB:      start = $8000, size = $4000, file = %O, type = ro, fill=yes, fillval=$0B;
    PRGC:      start = $8000, size = $4000, file = %O, type = ro, fill=yes, fillval=$0C;
    PRGD:      start = $8000, size = $4000, file = %O, type = ro, fill=yes, fillval=$0D;
    PRGE:      start = $8000, size = $4000, file = %O, type = ro, fill=yes, fillval=$0E;
    PRGF:      start = $C000, size = $4000, file = %O, type = ro, fill=yes, fillval=$0F;
}

SEGMENTS 
{
    HEADER:    load = HEADER, type = ro;

    ZEROPAGE:  load = ZEROPAGE, type = zp;
    STACK:     load = STACK, type = bss, align = $100;
    OAM_LIST:  load = OAM, type = bss, align = $100;
    BSS:       load = RAM, type = bss, align = $100;

    # Switchable Banks
    PRG0:     load = PRG0, type = ro, start = $8000, optional = yes;
    PRG1:     load = PRG1, type = ro, start = $8000, optional = yes;
    PRG2:     load = PRG2, type = ro, start = $8000, optional = yes;
    PRG3:     load = PRG3, type = ro, start = $8000, optional = yes;
    PRG4:     load = PRG4, type = ro, start = $8000, optional = yes;
    PRG5:     load = PRG5, type = ro, start = $8000, optional = yes;
    PRG6:     load = PRG6, type = ro, start = $8000, optional = yes;
    PRG7:     load = PRG7, type = ro, start = $8000, optional = yes;
    PRG8:     load = PRG8, type = ro, start = $8000, optional = yes;
    PRG9:     load = PRG9, type = ro, start = $8000, optional = yes;
    PRGA:     load = PRGA, type = ro, start = $8000, optional = yes;
    PRGB:     load = PRGB, type = ro, start = $8000, optional = yes;
    PRGC:     load = PRGC, type = ro, start = $8000, optional = yes;
    PRGD:     load = PRGD, type = ro, start = $8000, optional = yes;
    PRGE:     load = PRGE, type = ro, start = $8000, optional = yes;

    # The last bank, fixed.
    PRGFIXED: load = PRGF, type = ro, start = $C000;
    VECTORS:  load = PRGF, type = ro, start = $FFFA;
}
