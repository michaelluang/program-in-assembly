read-records: read-record.o count-chars.o write-newline.o read-records.o
	ld -m elf_i386 read-record.o count-chars.o write-newline.o read-records.o -o read-records
read-record.o: read-record.s
	as --32 read-record.s -o read-record.o
count-chars.o: count-chars.s
	as --32 count-chars.s -o count-chars.o
write-newline.o: write-newline.s
	as --32 write-newline.s -o write-newline.o
read-records.o: read-records.s
	as --32 read-records.s -o read-records.o

clean:
	\rm -f *.o *~ read-records
