.code32

# If you run the code in a 64-bit mode machine,
# prepend `.code32` as the first line of the file.
# Then assemble the code in the following instructions:
#
# as --32 factorial.s -o factorial.o
# ld -m elf_i386 factorial.o -o factorial
# ./factorial
# echo $?
#
# If you get `120` finally, cheers!
#
# In the program, we will learn to program a **factorial function**,
# which is a great example to understand the **Recursive Functions**.
#
# Also, you should able to know the components of a function:
#
# - function name
# - function parameters
# - local variables
# - global variables
# - static variables
# - return address
# - return value 
#
# Let's begin!
#
# PURPOSE: Compute the factorial of 5
#          i.e. 5! = 5 * 4 * 3 * 2 * 1 = 120,
#          and it will show how to call a function RECURSIVELY
#
# INPUT:   The number(i.e. 5) that we compute its factorial
#          We push it into the stack before calling 
#          the factorial function
#
# OUTPUT:  The factorial of 5, we can get it by typing
#          `echo $?` after running the program

.section .data

                 # There is no global data in this program

.section .text

.globl _start
_start:
 pushl $5        # before calling the function, we need to push the
                 # parameter into stack 
 call factorial
 addl $8, %esp   # as we don't need the parameter, deallocated!
 
 movl %eax, %ebx # move the return result to %ebx

 movl $1, %eax   # exit!
 int $0x80

#
# The recursive factorial function
#

.type factorial, @function
factorial:
 pushl %ebp         # the conventions that every function should
                    # follow for setting up and restoring the stack
                    # in order for the program to run properly.
 movl %esp, %ebp

 movl 8(%ebp), %eax # move the only parameter to %eax

 cmp $1, %eax       # test the base case, if %eax == 1, 
 je end_factorial   # jump to end_factorial where it will
                    # be returned

 decl %eax          # otherwise, compute (n - 1)
 pushl %eax         # store at the top of stack for next call
 call factorial     # compute factorial of (n - 1)

 movl 8(%ebp), %ebx # in order to understand this two 
 imull %ebx, %eax   # lines of code, you should know the concepts of
                    # **Procedures** and **Stack frame structure** in CS
                    #
                    #  Let me explain it briefly:
                    # 
                    # - when we hit the base case, i.e %eax == 1, we 
                    #   will jump to end_factorial part where the current stack 
                    #   frame is deallocated
                    #
                    # - after that, we come back to the code(`movl 8(%ebp), %ebx`) 
                    #   to be executed, this was done by the `ret` instruction 
                    #
                    # - we pull the previous parameter from the stack via 
                    #   `movl 8(%ebp), %ebx`
                    # 
                    # - the result of the function was kept in %eax, so we do this:
                    #   `imull %ebx, %eax`, this also stores the result in %eax
                    # 
                    # Remember that, at the start of the function, it is the procedure of 
                    # creating stack frame, and when we hit the base case, it is the
                    # procedure of destroying(deallocating) stack frame reversely. This was
                    # done by the **end_factorial** part
 end_factorial:
  movl %ebp, %esp
  pop %ebp
  ret
