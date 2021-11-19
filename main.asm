.data
    textToRead: .space 102
    test1: .long 4
    test2: .space 4
.text

.globl main
main:
    movl %esp, %ebp #for correct debugging

readText:
    mov $3, %eax
    mov $0, %ebx
    mov $textToRead, %ecx
    mov $102, %edx
    int $0x80

testulet:
    mov $test1, %eax
    addl $1, test1
    mov %eax, test2
    

showText:
    mov $4, %eax
    mov $1, %ebx
    mov $textToRead, %ecx
    mov $102, %edx
    int $0x80

finish:
    mov $1, %eax
    mov $0, %ebx
    int $0x80
