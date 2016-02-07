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

# PURPOSE: grab a section of memory. It checks to see if there
#          are any free blocks, if not, it asks Linux for a new one.
#
# PARAMETERS: the size of the memory block we want to allocate.
#
# RETURN VALUE: return the address of the allocated memory in %eax.
#               if there is no memory available, it will return 0 in %eax.
#
# VARIABLES USED: %ecx - the size of the request memory
#                 %eax - current memory region being examined
#                 %ebx - current break position
#                 %edx - size of the current memory region
#

 .globl allocate
 .type allocate, @function
 .equ ST_MEM_SIZE, 8

allocate:
 pushl %ebp
 movl %esp, %ebp

# load the parameters
 movl ST_MEM_SIZE(%ebp), %ecx
 movl heap_begin, %eax
 movl current_break, %ebx

alloc_loop_begin:
 
 
