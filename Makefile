# -----------------------------------------------------------------------------
#
# Essential Configuration
#
# -----------------------------------------------------------------------------

# The base program name.
PROJECT_NAME = nes_template

# The mapper and linker script to be used (in `cfg/`)
LDSCRIPT := uorom.ld

# It is assumed that `fceux` is in the user's path.
EMULATOR := fceux

# -----------------------------------------------------------------------------
#
# Paths and tools
#
# -----------------------------------------------------------------------------

# Utilities used for the toolchain or otherwise in the build process.
TOOLS_DIR := tools
TOOLCHAIN := $(TOOLS_DIR)/cc65

BASH := bash
MKDIR := mkdir
MAKE := make

# The CA65 toolchain.
AR65 := $(TOOLCHAIN)/bin/ar65
CA65 := $(TOOLCHAIN)/bin/ca65
CC65 := $(TOOLCHAIN)/bin/cc65
CHRCVT65 := $(TOOLCHAIN)/bin/chrcvt65
CL65 := $(TOOLCHAIN)/bin/cl65
CO65 := $(TOOLCHAIN)/bin/co65
DA65 := $(TOOLCHAIN)/bin/da65
GRC65 := $(TOOLCHAIN)/bin/grc65
LD65 := $(TOOLCHAIN)/bin/ld65
OD65 := $(TOOLCHAIN)/bin/od65
SIM65 := $(TOOLCHAIN)/bin/sim65
sp65 := $(TOOLCHAIN)/bin/sp65

# Paths and files.
SRCDIR := src
OUTDIR := out
OBJDIR := $(OUTDIR)/obj
LDSDIR := cfg
MAPNAME := map.txt
LABELSNAME := labels.txt
LISTNAME := listing.txt
ROMNAME := $(PROJECT_NAME).nes
DBGNAME := $(PROJECT_NAME).dbg

# Toolchain configuration.
ASFLAGS := --include-dir $(SRCDIR) \
           -g \
           -U

CCFLAGS := -I $(SRCDIR) \
           -Cl \
           -O \
           -Or \

LDFLAGS := -C $(LDSDIR)/$(LDSCRIPT) \
           -m $(OUTDIR)/$(MAPNAME) \
           -Ln $(OUTDIR)/$(LABELSNAME) \
           --dbgfile $(OUTDIR)/$(DBGNAME)

# Sources. You may replace the wildcards with explicit files if desired.
SOURCES_H := $(shell find $(SRCDIR)/ -name '*.h' -print)
SOURCES_C := $(shell find $(SRCDIR)/ -name '*.c' -print)
SOURCES_ASM := $(shell find $(SRCDIR)/ -name '*.asm' -print)

OBJECTS_C := $(addprefix $(OBJDIR)/, $(SOURCES_C:.c=.o))
OBJECTS_ASM := $(addprefix $(OBJDIR)/, $(SOURCES_ASM:.asm=.o))

# -----------------------------------------------------------------------------
#
# Recipies
#
# -----------------------------------------------------------------------------

.PHONY: clean

all: $(OUTDIR)/$(ROMNAME)

# Directories and build dependencies.
$(TOOLS_DIR):
	$(MKDIR) -p $@

$(OUTDIR):
	$(MKDIR) -p $@

$(OBJDIR):
	$(MKDIR) -p $@

$(TOOLCHAIN): $(TOOLS_DIR)
	git clone git@github.com:cc65/cc65 $@
	$(MAKE) -j$(nproc) -C $@

# The 2A03 software build.
$(OUTDIR)/$(ROMNAME): $(OBJECTS_ASM) $(OBJECTS_C) $(OUTDIR) $(TOOLCHAIN)
	@$(BASH) -c 'printf "\t\e[94m[ LNK ]\e[0m $(OBJECTS_ASM) $(OBJECTS_C)\n"'
	$(LD65) -o $@ $(LDFLAGS) $(OBJECTS_ASM) $(OBJECTS_C)

$(OBJDIR)/%.o: %.asm $(SOURCES_H) $(OBJDIR) $(TOOLCHAIN)
	@$(BASH) -c 'printf "\t\e[96m[ ASM ]\e[0m $<\n"'
	@$(MKDIR) -p $(OBJDIR)/$(<D)
	$(CA65) $(ASFLAGS) $< -o $@

$(OBJDIR)/%.o: %.c $(SOURCES_H) $(OBJDIR) $(TOOLCHAIN)
	@$(BASH) -c 'printf "\t\e[96m[  C  ]\e[0m $<\n"'
	@$(MKDIR) -p $(OBJDIR)/$(<D)
	$(CC65) $(CFLAGS) $< -o $@

test: $(OUTDIR)/$(ROMNAME)
	$(EMULATOR) $<

clean:
	rm -rf $(OUTDIR)
