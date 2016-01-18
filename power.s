.code32

# Note that if you assemble the code in a 64-bit mode machine,
# prepend `.code32` as the first line. And run the code in the
# following instructions:
#
# as --32 power.s -o power.o
# ld -m elf_i386 power.o -o power
# ./power
# 
# You should get `89` in the terminal


# In this program, we will get to understand how the **stack**
# works when you write **functions**.
#
# The **stack** is the key element for implementing a **function**'s
# local variables, parameters and return address.
# 
# Let's get started!

# PURPOSE:   This program will calculate the value of
#            4^3 + 5^2 to illustrate how funciton works
#
# INPUT:     the base number and its power
#            we do this by pushing them to the stack 
#            before calling the power function
#
# OUTPUT:    Return the value of 4^3 + 5^2. You can view the value
#            by typing `echo $?` after running the program
#
# VARIABLES: %ebx holds the return value of 4^3 + 5^2 
 
.section .data   # We store all the data in registers, so the data section
                 # doesn't have anything here.

.section .text

.globl _start
_start:
 pushl $3        # we will compute 4^3 first, and push the parameters
 pushl $4        # to the stack in the reverse order.
 call power      # call the power function
 addl $8, %esp   # we don't need the values of the parameters(ie, 3 and 4),
                 # so we get back the stack pointer where it was
 pushl %eax      # save the value returned by function power

 pushl $2        # then, we compute 5^2, the same way as above
 pushl $5
 call power
 addl $8, %esp

 popl %ebx       # As we have saved the first return value in stack
                 # we need to  pop it out into %ebx, and %eax holds
                 # the second return value
 addl %eax, %ebx # add them together, save it to %ebx

 movl $1, %eax   # exit, and return the value of 4^3 + 5^2(in %ebx)
 int $0x80

# PURPOSE:   The function is used to compute the value of a number
#            raised to a power.
#
# INPUT:     First argument: the base number
#            Second argument: the power of the base
#
# OUTPUT:    The value of the calculation
#
# NOTE:      The power must be an integer that greater than 0
#
# VARIABLES: %ebx holds the base number
#            %ecx holds the power the the base number
#            -4(%ebp) holds the current result
#            %eax holds the temporary variable
 
.type power, @function
power:
 pushl %ebp            # save the old base pointer
 movl %esp, %ebp       # copy the stack pointer into the base pointer
                       # This is the standard way every function does,
                       # for more information, see the C Calling Convention in the doc
 subl $4, %esp         # spare room for local storage

 movl 8(%ebp), %ebx    # get the first argument(ie, the base number)
 movl 12(%ebp), %ecx   # get the second argument(ie, the power)

 movl %ebx, -4(%ebp)   # store the current result

 power_start_loop:
  cmpl $1, %ecx        # if the power is 1
  je end_power         # we are done
  movl -4(%ebp), %eax  # copy the current result to %eax
  imull %ebx, %eax     # multiply the current result by the base number

  movl %eax, -4(%ebp)  # store the current result

  decl %ecx            # decrease the power
  jmp power_start_loop # go for next loop

 end_power:
  movl -4(%ebp), %eax  # move the return value to %eax
  movl %ebp, %esp      # restore the stack pointer
  popl %ebp            # restore the base pointer
                       # This is the standard way every function does
                       # see the C Calling Convention chapter in the doc
  ret
