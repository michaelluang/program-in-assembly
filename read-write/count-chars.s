.code32

# PURPOSE:        Count the characters until a null byte is reached.
#                 If you're familiar with C, this program does is the
#                 same as the `strlen` function.
#
# INTPUT:         The address of the character string
#
# OUTPUT:         The count of a character string.
#                 Return the count in %eax
#
# REGISTERS USED: %ecx - character count
#                 %edx - current character address
#                 %al  - current character

.type count_chars, @function
.globl count_chars

.equ ST_STRING_START_ADDRESS, 8           # the stack position
                                          # of the parameter

count_chars:
 pushl %ebp
 movl %esp, %ebp

 movl $0, %ecx                             # initialize the count to 0
 movl ST_STRING_START_ADDRESS(%ebp), %edx # the starting address the string

 count_loop_begin:
  movb (%edx), %al                        # get the current character
  cmpb $0, %al                            # if it is null
  je count_loop_end                       # go to end
  incl %ecx                               # otherwise increment the count
  incl %edx                               # and the pointer
  jmp count_loop_begin                    # go to next loop

 count_loop_end:
  movl %ecx, %eax                         # movl the count to %eax
  movl %ebp, %esp
  popl %ebp
  ret
