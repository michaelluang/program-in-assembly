# Program in Assembly

> Don't overlook the importance of low-level programming!

If you're familiar with a language like C or Java, and don't know how the computer actually works underneath the hood, you should learn to program using **assembly language** to really understand what the computer thinks and acts when it is running a program.

## The First Program

In this simple program: [exit.s](exit.s), we will learn the structure of assembly-language programs, and a few assembly-language commands.

As the file name implies, the program does nothing but exit! Go through the comments in the code to see what really happens when you run the program.

## The Basics

There some concepts you should be familiar with in order to fully understand [the first program](exit.s).

### x86 Instructions

In order to help your learn assembly language, you should know about the common assembly language commands. As we run our programs on x86 processor, x86 instructions will be used. For more information, please search on the web.

### Registers

On x86 processors, there are some general-purpose registers:

- %eax
- %ebx
- %ecx
- %edx
- %edi
- %esi

Below are several special-purpose registers:

- %ebp
- %esp
- %eip
- %eflags

Their meanings and usages are not covered in the tutorials. If you want to know the details, please search on the web.
 
### System Call

Operating System features are accessed through **system calls**, such as calling other programs, dealing with files. These operations are all handled by the operating system through system calls. When you make a system call, **the system call number** has to be loaded in the %eax register. For example, the numer 1 is the number of the **exit** systam call, therefore the instruction in [exit.s](exit.s) `movl $1, %eax` will call the Linux kernel to do the exit opetation.

When calling the Linux kernel, the operating system usually needs more information. For example, when dealing with files, the operating system needs to know which file you are dealing with, what data you want to write, and other details. This informations called **parameters** which are also stored in register. Let's take a look at our first program again, when the **exit** system call is invoked, the operating system requires a **status code** be loaded in %ebx register, this is done by the instruction `movl $0, %ebx`. We can access the number 0 after running the program by typing `echo $?`. You may ask why is `0` loaded in `%ebx`? How about `1` or `99` or whatever you want? While, in Linux or other operating systems that modeled after Unix, every program when it exits gives the operating system an exit status code. If everything was OK, it returns `0`, otherwise to indicate failure or other errors, warnings, or statuses. The programmer determines what each number means. You may as well change the number and watch it come out.

Finally, let's talk about this instruction `int $0x80`at the end of the file. What is it means? The `int` stands for *interrupt*, and `0x80`is the interrupt number to use. When we signalling the interrupt, the system cal(exit) will be performed.

## Data Accessing Methods

Before you learn all the types of addressing modes in assembly language, there's a general form of memory address references you should keep in mind:

    ADDRESS_OR_OFFSET(%BASE_OR_OFFSET, %INDEX, MULTIPLIER)

Then calculate the address:

    ADDRESS = ADDRESS_OR_OFFSET + %BASE_OR_OFFSET + MULTIPILER * %INDEX

Note that all of the fields are **optional**, and if any of the pieces is left out, it is just substituted with `0` in the equation.

All of the data accessing methods except immediate-mode can be represented in this fashion.

## Procedures

Here are some notes from *Computer System: A Programmer's Perspective*

### What is Procedure Calls?

A procedure call involves passing both data(in the form of procedure parameters and return values) and control from one part of a program to another. In addition, it must allocate space for the local variables of the procefure on entry and deallocate them on exit.

### Stack Frame Structure

The machine use the **stack** to pass procedure arguments, to store return information, to save registers for late restoration, and for local storage.

Linux starts the stack from location `0xbfffffff` and grows it downwards.

The topmost stack frame is delimited by two pointers, with register **%ebp** serving as the **frame pointer**, and **%esp** serving as the **stack pointer**.

The stack discipline provides a mechanism where an invocation of a function has its own *private* storage for state information(save values for the return location, frame pointer and callee-save registers).

Therefore, the **stack** is an important component of **procedure calls**.

### Transferring Control

It is important for all procedures to follow a *consistent* set of conventions for setting up and restoring the stack in order for the program to execute properly.

The **call** and **ret** instructions do the job of transferring control.

The effect of a **call** instruction is to push the a return address on the stack and jump to the start of the called procedure. The **return address** is the address of the instruction immediately following the **call** in the program.

The **ret** instruciton pops an address off the stack and jumps to this location(i.e. the instruciton that follows **call**). 

#### Exercise

      call next
    next:
      popl %eax

There is no maching `ret` instruction to this call, what purpose does this code fragment serve?

## Buffers

A **buffer** is a continuous block of bytes used for bulk data transfer.

When you request to read a file, the operating system needs to have a place to store the data it reads. The place is called a **Buffer**.  

### .bss Section

Unlike .data section which you can reserve storage and set it to an initial value, the .bss section doesn't take up space in the executable(but it still reserves storage), and you can't set an initial value for it(because we don't need to initialize it anyway, we just want to reserve storage).

How to create a buffer? Do the following commands:

    .section .bss
    .lcomm my_buffer, 500

The `.lcomm` directive used for creating a buffer, and `my_buffer` refers to a 500-byte storage location.

## The Memory Layout of a Linux Program

| Memory Layout of a Linux Program||
| ----                  | ----                                      |
| Environment Variables | :point_left: Memory Address: `0xbfffffff` |
| ...                   |                                           |
| Arguments #1          |                                           |
| Arguments #2          |                                           |
| Program Name          |                                           |
| Number of Arguments   |                                           |
| Unmapped Memory       |                                           |
| Program Code and Data | :point_left: Memory Address: `0x08048000` |
