.code32
.include "linux.s"

.section .data


# options for **open**
.equ O_RDONLY, 0
.equ O_CREAT_WRONLY_TRUNC, 03101

# standard file descriptors
.equ STDIN, 0
.equ STDOUT, 1
.equ STDERR, 2

.equ NUMBER_ARGUMENTS, 2

.section .bss

###### BUFFER ######

.equ BUFFER_SIZE, 500
.lcomm BUFFER_DATA, BUFFER_SIZE

.section .text

###### STACK POSITIONS ######
.equ ST_SIZE_RESERVE, 8
.equ ST_FD_IN, -4
.equ ST_FD_OUT, -8

.equ ST_AGRC, 0
.equ ST_ARGV_0, 4
.equ ST_ARGV_1, 8
.equ ST_ARGV_2, 12

.globl _start
_start:
 movl %esp, %ebp

 subl $ST_SIZE_RESERVE, %esp

open_files:
open_fd_in:
 movl $SYS_OPEN, %eax
 movl ST_ARGV_1(%ebp), %ebx
 movl $O_RDONLY, %ecx
 movl $0666, %edx
 int $LINUX_SYSCALL

store_fd_in:
 movl %eax, ST_FD_IN(%ebp)

open_fd_out:
 movl $SYS_OPEN, %eax
 movl ST_ARGV_2(%ebp), %ebx
 movl $O_CREAT_WRONLY_TRUNC, %ecx
 movl $0666,%edx
 int $LINUX_SYSCALL

store_fd_out:
 movl %eax, ST_FD_OUT(%ebp)

read_loop_begin:
 movl $SYS_READ, %eax
 movl ST_FD_IN(%ebp), %ebx
 movl $BUFFER_DATA, %ecx
 movl $BUFFER_SIZE, %edx
 int $LINUX_SYSCALL

 cmpl $END_OF_FILE, %eax
 jle end_loop

continue_read_loop:
 pushl $BUFFER_DATA
 pushl %eax
 call convert_to_upper
 popl %eax
 addl $4, %esp

 movl %eax, %edx
 movl $SYS_WRITE, %eax
 movl ST_FD_OUT(%ebp), %ebx
 movl $BUFFER_DATA, %ecx
 int $LINUX_SYSCALL

 jmp read_loop_begin

end_loop:
 movl $SYS_CLOSE, %eax
 movl ST_FD_OUT(%ebp), %ebx
 int $LINUX_SYSCALL

 movl $SYS_CLOSE, %eax
 movl ST_FD_IN(%ebp), %ebx
 int $LINUX_SYSCALL

 movl $SYS_EXIT, %eax
 movl $0, %ebx
 int $LINUX_SYSCALL

# PURPOSE:   Convert to upper case for a block of memory
#
# INPUT:     The first parameter: the location of the block memory
#            The second parameter: the length of the buffer
#
# OUTPUT:    Overwrite the current buffer with upper-casified version
#
# VARIABLES: %eax: beginning of the buffer
#            %ebx: length of the buffer
#            %edi: current buffer offset
#            %cl:  current byte examined

###### CONSTANTS ######

.equ LOWERCASE_A, 'a'            # the lower boundary of the search
.equ LOWERCASE_Z, 'z'            # the upper boundary of the search

.equ UPPER_CONVERSION, 'A' - 'a' # convert constant between upper and lower case

.equ ST_BUFFER_LEN, 8            # the length of buffer
.equ ST_BUFFER, 12               # the location of buffer

convert_to_upper:
 pushl %ebp
 movl %esp, %ebp

# set up variables
 movl ST_BUFFER(%ebp), %eax
 movl ST_BUFFER_LEN(%ebp), %ebx
 movl $0, %edi

 cmpl $0, %ebx                   # if the length of buffer is 0
 je end_convert_loop             # nothing to convert, just leave

convert_loop:
 movb (%eax, %edi, 1), %cl       # get the curretn byte

# if the byte is not between 'a' and 'z', get the next byte
 cmpb $LOWERCASE_A, %cl
 jl next_byte
 cmpb $LOWERCASE_Z, %cl
 jg next_byte

# otherwise, convert to upper case
 addb $UPPER_CONVERSION, %cl
 movb %cl, (%eax, %edi, 1)

# get the next byte
next_byte:
 incl %edi
 cmpl %edi, %ebx                 # if we didn't reach the end of buffer
 jne convert_loop                # continue

end_convert_loop:
 movl %ebp, %esp
 popl %ebp
 ret
 
