
#####################
Compile and execution
#####################

nasm -f elf64 main.asm -o main.o
ld -o main main.o
./main