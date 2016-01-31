.code32

# PURPOSE: This program prints out the error code
#          and error message when we encounter an error
#
# INPUT: Before calling the function, we need to push the
#        address of the error message and error code onto the stack
#
# OUTPUT: STDERR
#
 .include "linux.s"
 
 .equ ST_ERROR_CODE, 8
 .equ ST_ERROR_MSG, 12

  .globl error_exit
 .type error_exit, @function
error_exit:
 pushl %ebp
 movl %esp, %ebp

# write out the error code
 movl ST_ERROR_CODE(%ebp), %ecx
 pushl %ecx
 call count_chars
 popl %ecx
 movl %eax, %edx
 movl $STDERR, %ebx
 movl $SYS_WRITE, %eax
 int $LINUX_SYSCALL

# write out the error message
 movl ST_ERROR_MSG(%ebp), %ecx
 pushl %ecx
 call count_chars
 popl %ecx
 movl %eax, %edx
 movl $STDERR, %ebx
 movl $SYS_WRITE, %eax
 int $LINUX_SYSCALL

# write out a newline
 pushl $STDERR
 call write_newline

# exit with status code 1
 movl $SYS_EXIT, %eax
 movl $1, %ebx
 int $LINUX_SYSCALL
