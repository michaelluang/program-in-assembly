# Get the habit of writing comments in the code
#
# Always include the following in the comments:
#
# - The purpose of the code
# - An overview of the processing involved
# - Anything strange the program performs and why it does it
# 
# Let's get started!

# PURPOSE:    A simple program that exits and returns a status
#             code back to the Linux kernel

# INPUT:      none

# OUTPUT:     returns a status code.
#             you can view the status code by typing the command:
#             `echo $?` after running the program

# VARIABLES:  %eax holds the system call number
#             %ebx holds the status code

.section .data # the program doesn't use any data, so we leave it blank
               # we write the assembler directive here just for completeness

.section .text
.globl _start

_start:
 movl $1, %eax # this is the system call of Linux kernel for 
               # exiting a program

 movl $0, %ebx # this is the status code we will return to the OS

 int  $0x80    # wake up the Linux kernel to run exit command

# How to run this program?
#
# Firstly, assemble the code to machine code, run the command:
# `as exit.s -o exit.o`
#
# Then, link the file, run this command:
# `ld exit.o -o exit`
#
# Finally, run the program:
# `./exit`
#
# If you type `echo $?` and get `0`, everything went well, cheers!
