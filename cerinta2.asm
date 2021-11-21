.data
    length: .long 100
    textToRead: .space 102
    variables: .space 505

    spaceString: .asciz " "
    whereNumberEnds: .long 57
    
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
    currentIndex: .long 0

.text




.global main
main:
    movl %esp, %ebp #for correct debugging

readText:
    mov $3, %eax
    mov $0, %ebx
    mov $textToRead, %ecx                       #reading the text from the keyboard
    mov $102, %edx
    int $0x80
    jmp processingText
    
processingText:
    pushl $spaceString
    pushl $textToRead
    
    call strtok                                 #calling strtok for the first time
    
    popl %ebx
    popl %ebx
    
    jmp processingTextLoop


handleLet:
    popl %ecx
    
    mov $0, %eax
    call atoi
    movl %eax, numberToPutOnVariable            #converting the number to int in order to put it in the array
    popl %ecx
    
    mov $0, %eax
    popl %ecx
    movb (%ecx), %al
    movl %eax, variableAsciiCode                #converting the first number to ascii code in order to know where to put it in the array
    
    movl variableAsciiCode, %ecx
    mov $variables, %edi
    
    movl numberToPutOnVariable, %eax            #putting the desired number in the INT array
    movl %eax, (%edi, %ecx, 4)
    
    
    jmp nextStrtok


add_firstStackIsNumber:
    
    jmp secondHandleAdd
    

firstHandleAdd:
    popl %ecx
    
    mov $0, %eax
    popl %edx
    movb (%edx), %al
    movl %eax, variableAsciiCode
    
    cmp %eax, whereNumberEnds                   #here we decide if we have a variable or a number
    jge add_firstStackIsNumber
    
    movl variableAsciiCode, %ecx
    mov $variables, %edi
    
    movl (%edi, %ecx, 4), %eax
    movl %eax, firstCalcNumber                  #here we handle the variable
    
    jmp secondHandleAdd
    
secondHandleAdd:
    
    jmp thirdHandleAdd
    
thirdHandleAdd:

    jmp nextStrtok



firstHandleSub:
    popl %ecx
    
    jmp secondHandleSub
    
secondHandleSub:

    jmp thirdHandleSub

thirdHandleSub:
    
    jmp nextStrtok
    
    

firstHandleMul:
    popl %ecx
    
    jmp secondHandleMul
    
secondHandleMul:

    jmp thirdHandleMul

thirdHandleMul:
    
    jmp nextStrtok



firstHandleDiv:
    popl %ecx
    
    jmp secondHandleDiv
    
secondHandleDiv:

    jmp thirdHandleDiv

thirdHandleDiv:
    
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
    je firstHandleAdd
    
    pushl $subText
    call strcmp
    popl %ecx
    cmp %eax, nullPtr           #here we compare to the "sub" string and enter handleSub if the string was found
    je firstHandleSub
    
    pushl $mulText
    call strcmp
    popl %ecx
    cmp %eax, nullPtr           #here we compare to the "mul" string and enter handleMul if the string was found
    je firstHandleMul
    
    pushl $divText
    call strcmp
    popl %ecx
    cmp %eax, nullPtr           #here we compare to the "mul" string and enter handleMul if the string was found
    je firstHandleDiv
    
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
