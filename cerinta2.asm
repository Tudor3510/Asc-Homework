.data
    length: .long 100
    textToRead: .space 102
    variables: .space 505

    spaceString: .asciz " "
    
    nullPtr: .long 0
    
    letText: .asciz "let"
    addText: .asciz "add"
    subText: .asciz "sub"
    mulText: .asciz "mul"
    divText: .asciz "div"
    
    variableAsciiCode: .space 4
    numberToPutOnVariable: .space 4
    
    firstCalcNumber: .space 4
    secondCalcNumber: .space 4
    
    toAddOnStack: .space 505
    currentIndex: .space 0

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
    popl %ecx
    
    mov $0, %eax
    call atoi
    movl %eax, numberToPutOnVariable
    popl %ecx
    
    mov $0, %eax
    popl %ecx
    movb (%ecx), %al
    movl %eax, variableAsciiCode
    
    movl variableAsciiCode, %ecx
    mov $variables, %edi
    
    movl numberToPutOnVariable, %eax
    movl %eax, (%edi, %ecx, 4)
    
    
    
    jmp nextStrtok


firstHandleAdd:
    popl %ecx
    
    jmp secondHandleAdd
    
secondHandleAdd:
    
    jmp thirdHandleAdd
    
thirdHandleAdd:

    jmp nextStrtok



handleSub:
    popl %ecx
    
    
    
    
    
    jmp nextStrtok

handleMul:
    popl %ecx
    
    
    
    
    
    jmp nextStrtok

handleDiv:
    popl %ecx
    
    
    
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
    
   # popl %ecx                   #we should not pop the string here bc if it was not found it should remain on the stack
    
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
