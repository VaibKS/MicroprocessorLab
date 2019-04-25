
#####################
Compile and execution
#####################


nasm -f elf64 main.asm -o main.o

ld -o main main.o
./main


###################
Hex <=> Decimal
###################

Convert dec to hex:
    printf "%x\n" 255

Convert hex to dec:
    printf "%d\n" 0xff