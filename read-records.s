.code32

# PURPOSE: Read every record of the `great-programmers.dat` file
#          and print out the first name of each record.

.include "linux.s"
.include "record-def.s"

 .section .data
file_name:
 .ascii "great-programmers.dat\0"

 .section .bss
 .lcomm record_buffer, RECORD_SIZE

 .section .text
 .globl _start

_start:
 .equ ST_INPUT_DESCRIPTOR, -4
 .equ ST_OUTPUT_DESCRIPTOR, -8

 movl %esp, %ebp
 subl $8, %esp

 movl $SYS_OPEN, %eax
 movl $file_name, %ebx
 movl $0, %ecx                            # permission: read only
 movl $0666, %edx
 int $LINUX_SYSCALL

 movl %eax, ST_INPUT_DESCRIPTOR(%ebp)     # store input file descriptor
 movl $STDOUT, ST_OUTPUT_DESCRIPTOR(%ebp) # store output file descriptor
# read every record in the file
record_read_loop:
 pushl ST_INPUT_DESCRIPTOR(%ebp)
 pushl $record_buffer
 call read_record
 addl $4, %esp

 cmpl $RECORD_SIZE, %eax                  # %eax stores the returned bytes and if doesn't
 jne finished_reading                     # equal the required size, then we will qiut

 pushl $RECORD_FIRSTNAME + record_buffer
 call count_chars
 addl $4, %esp
 movl %eax, %edx

 movl ST_OUTPUT_DESCRIPTOR(%ebp), %ebx
 movl $RECORD_FIRSTNAME + record_buffer, %ecx
 movl $SYS_WRITE, %eax
 int $LINUX_SYSCALL

 pushl ST_OUTPUT_DESCRIPTOR(%ebp)
 call write_newline
 addl $4, %esp

 jmp record_read_loop

finished_reading:
 movl $SYS_EXIT, %eax
 movl $0, %ebx
 int $LINUX_SYSCALL
 
