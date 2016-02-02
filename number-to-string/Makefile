conversion-program: integer-to-string.o count-chars.o write-newline.o conversion-program.o
	ld -m elf_i386 integer-to-string.o count-chars.o write-newline.o conversion-program.o -o conversion-program
integer-to-string.o: integer-to-string.s
	as --32 integer-to-string.s -o integer-to-string.o
count-chars.o: count-chars.s
	as --32 count-chars.s -o count-chars.o
write-newline.o: write-newline.s
	as --32 write-newline.s -o write-newline.o
conversion-program.o: conversion-program.s
	as --32 conversion-program.s -o conversion-program.o
clean:
	\rm -f *.o *~ conversion-program
