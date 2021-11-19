.data
    textToRead: .asciz "Hatz\n"
    
.text

.globl main
main:

readText:
    mov $4, %eax
    mov $1, %ebx
    mov $textToPrint, %ecx
    mov $6, %edx
    int $0x80


finish:
    mov $1, %eax
    mov $0, %ebx
    int $0x80
