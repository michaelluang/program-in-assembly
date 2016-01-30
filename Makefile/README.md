# GNU make

In this project, to build every program, we need to assemble and link the source code that we write. Normally, for example, to build the [helloworld.s](../helloworld.s) program, we would compile the source code by executing the following commands:

    as --32 helloworld.s -o helloworld.o
    ld -m elf_i386 helloworld.o -o helloworld

When you change the source code, as you know, you have to assemble and link it again beforing running it. For efficiency, you may use the up arrow in the terminal to go back to the commands so you don't have to type it each time. However, if you lose the compile commands or switch computers, you have to retype it from scratch which is inacceptable for a real programmer. Truly, compiling the source files is tedious, especially when you have a whole bunch of files to assemble and link.

Want to be cool and more productive? Let's use **make** and write **Makefiles**!

Below is a very very short and simple introduction to **make** and **Makefile**, for more information, check out the [GNU Make Documentation](http://www.gnu.org/software/make/manual/make.html) or search on the web.

**make** is a Unix tool to simplify building program executables from many modules. A **Makefile** is the set of instructions that tell **make** how to build a program. Let's create a **Makefile** for our [helloworld.s](../helloworld.s) program. Note that the file should be named `Makefile` or `makefile`.

    helloworld: helloworld.o
    	ld -m elf_i386 helloworld.o -o helloworld
    helloworld.o: helloworld.s
    	as --32 helloworld.s -o helloworld.o

Then, type `make` in your terminal, **make** will execute the commands as you have written in the Makefile. When you made changes to the source file, just type `make` again to compile the files. One more thing to note is that it's a **tab** key before `ld` and `as` in the **Makefile**! If you replace it with spaces, **make** will not make it.
