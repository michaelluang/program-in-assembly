 .code32
 .include "../linux.s"

 .section .data

tmp_buffer:
 .ascii "\0\0\0\0\0\0\0\0\0\0"

 .section .text
 .globl _start
_start:
 movl %esp, %ebp
 
 pushl $tmp_buffer
 pushl $1990 # number to write out
 call integer2string
 addl $8, %esp

# get the number of characters
 pushl $tmp_buffer
 call count_chars
 addl $4, %esp

# move the count to %edx for SYS_WRITE
 movl %eax, %edx

# make the system call
 movl $SYS_WRITE, %eax
 movl $STDOUT, %ebx
 movl $tmp_buffer, %ecx
 int $LINUX_SYSCALL

# write a carriage return
 pushl $STDOUT
 call write_newline

# finally, exit!
 movl $SYS_EXIT, %eax
 movl $0, %ebx
 int $LINUX_SYSCALL
