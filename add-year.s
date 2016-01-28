 .code32

# PURPOSE: This program increments the age item by 1 in each record

 .include "record-def.s"
 .include "linux.s"

 .section .data
input_file_name:
 .ascii "great-programmers.dat\0"

output_file_name:
 .ascii "great-programmers-out.dat\0"

 .section .bss
 .lcomm record_buffer, RECORD_SIZE

# stack offset position of local variables
 .equ ST_INPUT_DESCRIPTOR, -4
 .equ ST_OUTPUT_DESCRIPTOR, -8

 .section .text
 .globl _start
_start:
 movl %esp, %ebp
 subl $8, %esp

# open the input file
 movl $SYS_OPEN, %eax
 movl $input_file_name, %ebx
 movl $0, %ecx
 movl $0666, %edx
 int $LINUX_SYSCALL

# save input file descriptor
 movl %eax, ST_INPUT_DESCRIPTOR(%ebp)

# open the output file
 movl $SYS_OPEN, %eax
 movl $output_file_name, %ebx
 movl $0101, %ecx
 movl $0666, %edx
 int $LINUX_SYSCALL

# save the output file descriptor
 movl %eax, ST_OUTPUT_DESCRIPTOR(%ebp)

loop_begin:
 pushl ST_INPUT_DESCRIPTOR(%ebp)
 pushl $record_buffer
 call read_record
 addl $8, %esp

 cmpl $RECORD_SIZE, %eax
 jne loop_end

# increment the age
 incl record_buffer + RECORD_AGE

# write the record into output file
 pushl ST_OUTPUT_DESCRIPTOR(%ebp)
 pushl $record_buffer
 call write_record
 addl $8, %esp

 jmp loop_begin

loop_end:
 movl $SYS_EXIT, %eax
 movl $0, %ebx
 int $LINUX_SYSCALL
