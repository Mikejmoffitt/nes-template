TOOLSDIR := tools/cc65
AS := $(TOOLSDIR)/ca65
LD := $(TOOLSDIR)/ld65
ASFLAGS := -g 
SRCDIR := src
CONFIGNAME := ldscripts/nes.ld
OBJNAME := main.o
MAPNAME := map.txt
LABELSNAME := labels.txt
LISTNAME := listing.txt
LDFLAGS := -Ln $(LABELSNAME)

TOPLEVEL := main.asm

EXECUTABLE := main.nes

.PHONY: all build $(EXECUTABLE)

build: $(EXECUTABLE)

all: $(EXECUTABLE)

clean:
	rm -f main.nes main.o $(LISTNAME) $(LABELSNAME) $(MAPNAME)

$(EXECUTABLE):
	$(AS) $(SRCDIR)/$(TOPLEVEL) $(ASFLAGS) -I $(SRCDIR) -l $(LISTNAME) -o $(OBJNAME)
	$(LD) $(LDFLAGS) -C $(CONFIGNAME) -o $(EXECUTABLE) -m $(MAPNAME) -vm $(OBJNAME)

run: $(EXECUTABLE)
	fceux ./$(EXECUTABLE)
	
debug: $(EXECUTABLE)
	wine tools/fceuxw/fceux.exe ./$(EXECUTABLE)
