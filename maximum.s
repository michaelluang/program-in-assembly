# PURPOSE:   This program finds the maximium number of a list of numbers.
#
# INPUT:     none
#
# OUTPUT:    returns the maximium number
#            view it by typing `echo $?` after running the program
#
# VARIABLES: %edi - holds the index of the list of data items
#            %eax - holds the current data item being examined
#            %edx - holds the maximum number found
#
# The following memory locations are used:
# data_items - contains the data items. Number 0 indicates the end
#              of the list.

.section .data

data_items:                                  # the data that the program uses
 .long 59, 21, 39, 20, 2, 45, 49, 22, 198, 0 # the data type is long, which 
                                             # takes up 4 bytes

.section .text

.globl _start
_start:
 movl $0, %edi                               # use %edi as the index of the data items
 movl data_items(, %edi, 4), %eax            # move the first item to %eax
 movl %eax, %ebx                             # the first item is current largest number
                                             # so we move to %ebx

start_loop:                                  # loop begins
 cmpl $0, %eax                               # check to see if the current number is 0
 je end_loop                                 # if so, we will exit the loop

 incl %edi                                   # otherwise, we will access the next item
 movl data_items(, %edi, 4), %eax            # move the next number to %eax
 cmpl %ebx, %eax                             # compare the current number with the largest we found
 jle start_loop                              # if the current number is smaller,
                                             # we jump to the loop beginning

 movl %eax, %ebx                             # otherwise, we move it to %ebx as the largest number
 jmp start_loop                              # jump to the loop beginning

end_loop: 
 movl $1, %eax                               # number 1 stands for exit system call
 int $0x80                                   # wake up the Linux kernel to run exit command
                                             # note that %ebx holds the status code when the 
                                             # exit system call is invoked, and it already 
                                             # has the maximum number, so we can get it by typing
                                             # `echo $?` after running the program
# How to run this program?
#
# Firstly, assemble the code to machine code:
# `as maximum.s -o maximum.o`
#
# Then, link the file:
# `ld maximum.o -o maximum`
#
# Run it:
# `./maximum`
#
# If you get 198 by typing `echo $?`, cheer! You're the rockstar!
