# PURPOSE: Program to manage memory usage - allocates
#          deallocates memory as requested

 .section .data

###### GLOBAL VARIABLES ######

heap_begin:
 .long 0

current_break:
 .long 0

###### STRUCTURE INFORMATION ######

 .equ HEADER_SIZE, 8
 .equ HDR_AVAIL_OFFSET, 0
 .equ HDR_SIZE_OFFSET, 4

###### CONSTANTS ######
 .equ UNAVAILABLE, 0
 .equ AVAILABLE, 1
 .equ SYS_BRK, 45
 .equ LINUX_SYSCALL, 0x80

 .section .text

###### FUNCTIONS ######

##### FUNCTION: allocate_init #####

# PURPOSE: call this function to initialize the functons,
#          specifically, this sets heap_begin and current_break.

 .globl allocate_init
 .type allocate_init, @function
allocate_init:

 pushl %ebp
 movl %esp, %ebp

 movl $SYS_BRK, %eax # if the brk system call is called with 0
 movl $0, %ebx # in %ebx, it returns the last valid usable address
 int $LINUX_SYSCALL

 incl %eax # we want the memory location after that

 movl %eax, current_break
 movl %eax, heap_begin

 movl %ebp, %esp
 popl %ebp
 ret

##### END OF FUNCTON #####

##### FUNCTION: allocate #####

# PURPOSE: 
