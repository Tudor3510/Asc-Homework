.data
    length: .long 100
    textToRead: .space 102
    variables: .space 500

    spaceString: .asciz " "
    
    nullPtr: .long 0

.text




.global main
main:
    movl %esp, %ebp #for correct debugging

readText:
    mov $3, %eax
    mov $0, %ebx
    mov $textToRead, %ecx
    mov $102, %edx
    int $0x80
    jmp processingText
    
processingText:
    pushl $spaceString
    pushl $textToRead
    
    call strtok
    
    popl %ebx
    popl %ebx
    
    jmp processingTextLoop    

processingTextLoop:
    cmp %eax, nullPtr
    je finish
    
    mov %eax, %ecx
    mov $4, %eax
    mov $1, %ebx
    mov $3, %edx
    int $0x80
    
    mov $4, %eax
    mov $1, %ebx
    mov $spaceString, %ecx
    mov $1, %edx
    int $0x80
    
    pushl $spaceString
    pushl nullPtr
    
    call strtok
    
    popl %ecx
    popl %ecx
    
    jmp processingTextLoop
    
    
finish:
    mov $1, %eax
    mov $0, %ebx
    int $0x80
