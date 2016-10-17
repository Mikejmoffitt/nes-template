NES Project Template
====================

What's the deal?
----------------
This is a Nintendo Entertainment System project template. A short demonstration file is included that simply displays "HELLO NES!" on screen. The demo is strongly commented so as to assist newcomers. Also included is a collection of useful macros, which are also commented.

If an aspiring programmer wishes to try out a new architecture or language, there are often simple toolchains that may be installed and used, with ample "getting started" materials. At the very least, providing a simple "Hello World" program is an encouraging start for a soon-to-be developer taking the first step. I have put this template together so I can point people towards it as a starting place for making something for the NES.

How do I use it?
----------------
First, clone this repository.
+	On Windows, just run build.bat and run.bat (preferably from the Command Prompt). Build.bat will assemble the .nes file using the included ca65 assembler (in tools/cc65), while run.bat will invoke the included FCEUX emulator (in tools/fceuxw).
+	On Linux, fceux should be installed with your package manager, alongside the GNU Make utility. After that, you may build the project by just typing `make` in the terminal. A `run` target is specified, which will invoke FCEUX. A `debug` target is also specified, which will run the included Windows FCEUX, as the Linux SDL port does not include the debugging features.
+	On Mac, the instructions are the same as on Linux, except that the included ca65 binary is an ELF binary, not the Mach-O binary required. You will have to build ca65 yourself (from the cc65 project). Choosing an emulator is an exercise for the user.

What's in the box?
------------------
The project comes with:
+	Demo source code
+	Sample graphics data for the demo
+	Linker configuration for a UxROM project (we have segments!)
+	Comments on what does what
+	Makefile and build/run scripts (for Linux and Windows respectively)
+	ca65 toolchain binaries (to simplify Windows use for new users)

Technical stuff
---------------
This project targets the UxROM family of cartridges for the NES. This board uses CHR-RAM to store graphical tile data, as opposed to a fixed ROM chip. This allwos for flexibility in storing graphics data, and may be a more relatable schema for developers used to other systems that work this way (like Genesis, SNES, etc). The UxROM series also supports up to 16 banks of PRG data, which allows for programs up to 256KiB in size (including data). For many NES projects, this is more than ample room.

The included demo program shows the following:
+	Initializing the NES
+	Basic VBlank timing
+	UxROM bankswitching
+	Writing data to CHR-RAM
+	Writing a palette to the PPU
+	Writing a nametable to the PPU
+	When to disable the PPU
+	Very basic use of macros
