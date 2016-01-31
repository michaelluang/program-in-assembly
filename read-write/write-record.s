.code32

.include "record-def.s"
.include "linux.s"

# PURPUSE: This program writes a record to a file descriptor
#
# INTPUT: file descriptor
#         buffer location
#
# OUTPUT: writes the records to a file and return a
#         status code.

# Stack local variables
.equ ST_WRITE_BUFFER, 8
.equ ST_FILEDES, 12

.section .text
.globl write_record
.type write_record, @function

write_record:
 pushl %ebp
 movl %esp, %ebp

 pushl %ebx

 movl ST_FILEDES(%ebp), %ebx
 movl ST_WRITE_BUFFER(%ebp), %ecx
 movl $RECORD_SIZE, %edx
 movl $SYS_WRITE, %eax
 int $LINUX_SYSCALL

 popl %ebx

 movl %ebp, %esp
 popl %ebp
 ret
