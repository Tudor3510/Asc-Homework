.data
    length: .long 100
    textToRead: .space 102
    variables: .space 500

    spaceString: .asciz " "
    
    nullPtr: .long 0
    
    letText: .asciz "let"
    addText: .asciz "add"
    subText: .asciz "sub"
    mulText: .asciz "mul"
    divText: .asciz "div"

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
    
handleLet:
    jmp nextStrtok

handleAdd:
    jmp nextStrtok

handleSub:
    jmp nextStrtok

handleMul:
    jmp nextStrtok

handleDiv:
    jmp nextStrtok

processingTextLoop:
    cmp %eax, nullPtr
    je finish
    
    pushl %eax                  #pushing the current string returned by the strtok in order to use it with strcmp
    
    pushl $letText
    call strcmp
    popl %ecx
    cmp %eax, nullPtr           #here we compare to the "let" string and enter handleLet if the string was found
    je handleLet
    
    pushl $addText
    call strcmp
    popl %ecx
    cmp %eax, nullPtr           #here we compare to the "add" string and enter handleAdd if the string was found
    je handleAdd
    
    pushl $subText
    call strcmp
    popl %ecx
    cmp %eax, nullPtr           #here we compare to the "sub" string and enter handleSub if the string was found
    je handleSub
    
    pushl $mulText
    call strcmp
    popl %ecx
    cmp %eax, nullPtr           #here we compare to the "mul" string and enter handleMul if the string was found
    je handleMul
    
    pushl $divText
    call strcmp
    popl %ecx
    cmp %eax, nullPtr           #here we compare to the "mul" string and enter handleMul if the string was found
    je handleDiv
    
    popl %ecx
    jmp nextStrtok
    
    
nextStrtok:

    pushl $spaceString
    pushl nullPtr
    
    mov $0, %eax    
    call strtok
    
    popl %ecx                   #!!!!! folosim ecx pentru a goli stiva
    popl %ecx                   #!!!!! folosim ecx pentru a goli stiva
    
    jmp processingTextLoop
    
    
finish:
    mov $1, %eax
    mov $0, %ebx
    int $0x80
