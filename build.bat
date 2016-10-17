@echo off
tools\cc65\ca65 src\main.asm -g -I src -o main.o
tools\cc65\ld65 -C ldscripts\nes.ld -o main.nes -vm main.o
