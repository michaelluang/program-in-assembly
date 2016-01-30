.code32

.include "linux.s"
.include "record-def.s"

.section .data

record1:
 .ascii "Donald\0"
 .rept 33
 .byte 0
 .endr

 .ascii "Knuth\0"
 .rept 34
 .byte 0
 .endr

 .ascii "Science is what we understand well enough to explain to a computer. Art is everything else we do.\0"
 .rept 142
 .byte 0
 .endr

 .long 78

record2:
 .ascii "Ken\0"
 .rept 36
 .byte 0
 .endr

 .ascii "Thompson\0"
 .rept 31
 .byte 0
 .endr

 .ascii "When in doubt, use brute force.\0"
 .rept 208
 .byte 0
 .endr

 .long 73

record3:
 .ascii "Linus\0"
 .rept 34
 .byte 0
 .endr

 .ascii "Torvalds\0"
 .rept 31
 .byte 0
 .endr

 .ascii "Talk is cheap. Show me the code.\0"
 .rept 207
 .byte 0
 .endr

 .long 46

# This is the file name we will write to
file_name:
 .ascii "great-programmers.dat\0"

 .equ ST_FILE_DESCRIPTOR, -4

 .globl _start

_start:
 movl %esp, %ebp
 subl $4, %esp # allocate space for file descriptor

 # open the file
 movl $SYS_OPEN, %eax
 movl $file_name, %ebx
 movl $0101, %ecx # create if it doesn't exist, and open for writing
 movl $0666, %edx
 int $LINUX_SYSCALL

 # store the file descriptor
 movl %eax, ST_FILE_DESCRIPTOR(%ebp)
 
 # write the first record
 pushl ST_FILE_DESCRIPTOR(%ebp)
 pushl $record1
 call write_record
 addl $8, %esp

 # write the second record
 pushl 	ST_FILE_DESCRIPTOR(%ebp)
 pushl $record2
 call write_record
 addl $8, %esp

 # write the third record
 pushl ST_FILE_DESCRIPTOR(%ebp)
 pushl $record3
 call write_record
 addl $8, %esp

 # close the file
 movl ST_FILE_DESCRIPTOR(%ebp), %ebx
 movl $SYS_CLOSE, %eax
 int $LINUX_SYSCALL

 # exit!
 movl $SYS_EXIT, %eax
 movl $0, %ebx
 int $LINUX_SYSCALL

