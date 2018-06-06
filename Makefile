all: hello test1 palin

hello: hello.asm
	@nasm -O0 -g -F dwarf -f elf hello.asm
	@ld -m elf_i386 -o hello hello.o

test1: test1.asm
	@nasm -O0 -g -F dwarf -f elf test1.asm
	@ld -m elf_i386 -o test1 test1.o

palin: palin.asm
	@nasm -O0 -g -F dwarf -f elf palin.asm
	@ld -m elf_i386 -o palin palin.o

export:
	@./incl.sh test1.asm > test1-all.asm
	@./incl.sh palin.asm > palin-all.asm

clean:
	rm -f *.o test1-all.asm hello test1

