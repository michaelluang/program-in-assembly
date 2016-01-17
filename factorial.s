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

.section .data

.section .text

.globl _start
_start:
 pushl $5
 call factorial
 addl $8, %esp
 
 movl %eax, %ebx

 movl $1, %eax
 int $0x80

.type factorial, @function
factorial:
 pushl %ebp
 movl %esp, %ebp

 movl 8(%ebp), %eax

 cmp $1, %eax
 je end_factorial

 decl %eax
 pushl %eax
 call factorial

 movl 8(%ebp), %ebx
 imull %ebx, %eax

 end_factorial:
  movl %ebp, %esp
  pop %ebp
  ret
