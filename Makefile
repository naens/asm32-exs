all: hello test1

hello: hello.asm
	@nasm -O0 -g -F dwarf -f elf hello.asm
	@ld -m elf_i386 -o hello hello.o

test1: test1.asm
	@nasm -O0 -g -F dwarf -f elf test1.asm
	@ld -m elf_i386 -o test1 test1.o

export:
	@./incl.sh test1.asm > test1-all.asm
	@nasm -O0 -g -F dwarf -f elf test1-all.asm
	@ld -m elf_i386 -o test1 test1-all.o

clean:
	rm -f *.o test1-all.asm hello test1

