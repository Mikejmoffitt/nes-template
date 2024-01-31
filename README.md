NES / Famicom Project Template
==============================

What's the deal?
----------------
This repository aims to provide a starting point for an assembly or C project targeting the Famicom or NES platforms. A sample Makefile and basic system code are provided and may be modified as desired.
The Makefile builds separate assembly files as individual objects and links them together at the end.

How do I use it?
----------------
First, clone this repository. For Windows users, Windows Subsystem for Linux (WSL) is the suggested usage environment, but you may be able to massage this to work with MSys2 or something similar.

In a terminal:
```
	$ git clone git@github.com:mikejmoffitt/nes-template
```

You will need a basic C toolchain to compile the CC65 toolchain.

```
	$ sudo apt install build-essential  # for GCC, etc.
```

Now, try to build the template project. It will clone and compile the CC65 toolchain as needed.

```
	$ cd nes-template && make
```

If you have the emulator `fceux` in your PATH, you may use the `test` target:

```
	$ make test
```

If you wish to use another emulator, you can change the executable name in the Makefile. For Windows usage, you will want to point towards a native Windows-built emulator most likely.

What's in the box?
------------------
The project comes with:
+	Demo source code
+	Sample graphics data for the demo
+	Linker configuration for a UxROM project (we have segments!)
+	Comments on what does what
+	Makefile

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
