# PURPOSE: It's boring to remember all the numbers
#          like system call number, interrupt number, etc.
#          Therefore, in this file we will use the `.equ`
#          directive to assign names to the numbers which
#          makes the code much easier to read and remember.
#
#          Also, in order apply the DRY(Don't Repeat Yourself)
#          principle, we put all the constants in this file, so
#          other files can use it via the `.include "linux.s"`
#          directive.

###### CONSTANTS ######

# system call numbers
.equ SYS_EXIT, 1
.equ SYS_READ, 3
.equ SYS_WRITE, 4
.equ SYS_OPEN, 5
.equ SYS_CLOSE, 6
.equ SYS_BRK, 45

# system call interrupt
.equ LINUX_SYSCALL, 0x80

# standard file descriptors
.equ STDIN, 0
.equ STDOUT, 1
.equ STDERR, 2

# common status codes
.equ END_OF_FILE, 0
