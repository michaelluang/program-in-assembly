 .code32

# PURPOSE: Print out a new line to the STDOUT

 .include "../linux.s"

 .type write_newline, @function
 .globl write_newline

 .section .data
new_line:
 .ascii "\n"

 .section .text
 .equ ST_FILEDES, 8

write_newline:
 pushl %ebp
 movl %esp, %ebp

 movl ST_FILEDES(%ebp), %ebx
 movl $new_line, %ecx
 movl $1, %edx               # the file descriptor of STDOUT
 movl $SYS_WRITE, %eax
 int $LINUX_SYSCALL
 
 movl %ebp, %esp
 popl %ebp
 ret
