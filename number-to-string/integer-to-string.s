 .code32
# PURPOSE: this program converts a number to a string for display
#
# INTPUT: the buffer location to hole the number
#         the number to convert
#
# OUTPUT: the buffer will be overwritten with the decimal string
#
# VARIABLES: %ecx holds the count of the characters processed
#            %eax holds the current value
#            %edi holds the base 10

 .equ ST_VALUE, 8
 .equ ST_BUFFER, 12

 .globl integer2string
 .type integer2string, @function

integer2string:
 pushl %ebp
 movl %esp, %ebp

# initialize the count value to 0
 movl $0, %ecx

# move the number to %eax
 movl ST_VALUE(%ebp), %eax

# move the base 10 to %edi
 movl $10, %edi

# the conversion loop
conversion_loop:
# %edx holds the remainder of the division,
# beforing dividing, we need to clear out it
 movl $0, %edx
 divl %edi

 addl $'0', %edx # get the corresponding ascii code for the value
 pushl %edx

 incl %ecx

 cmpl $0, %eax   # %eax holds the quotient
 je end_conversion_loop

 jmp conversion_loop

end_conversion_loop:
 movl ST_BUFFER(%ebp), %edx

# copy the characters to the buffer
copy_reversing_loop:
 popl %eax
 movb %al, (%edx)

 decl %ecx
 incl %edx

 cmpl $0, %ecx
 je end_copy_reversing_loop
 jmp copy_reversing_loop

end_copy_reversing_loop:
 movb $0, (%edx)

 movl %ebp, %esp
 popl %ebp
 ret
