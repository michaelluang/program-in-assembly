.code32

# Note that if you assemble the code in a 64-bit mode machine,
# prepend `.code32` as the first line. And run the code in the
# following instructions:
#
# as --32 power.s -o power.o
# ld -m elf_i386 power.o -o power
# ./power
#
# In this program, we will get to understand how the **stack**
# works when you write **functions**.
#
# The **stack** is the key element for implementing a **function**'s
# local variables, parameters and return address.
# 
# Let's get started!

.section .data

.section .text

.globl _start
_start:
 pushl $3
 pushl $4
 call power
 addl $8, %esp
 pushl %eax

 pushl $2
 pushl $5
 call power
 addl $8, %esp

 popl %ebx
 addl %eax, %ebx

 movl $1, %eax
 int $0x80

.type power, @function
power:
 pushl %ebp
 movl %esp, %ebp
 subl $4, %esp

 movl 8(%ebp), %ebx
 movl 12(%ebp), %ecx

 movl %ebx, -4(%ebp)

 power_start_loop:
  cmpl $1, %ecx
  je end_power
  movl -4(%ebp), %eax
  imull %ebx, %eax

  movl %eax, -4(%ebp)

  decl %ecx
  jmp power_start_loop

 end_power:
  movl -4(%ebp), %eax
  movl %ebp, %esp
  popl %ebp
  ret
