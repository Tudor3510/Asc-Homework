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
    finalCalcNumber: .space 4
    
    toAddOnStack: .space 22000
    currentIndex: .space 4
    currentIndexConsideringNumberLength: .space 4
    #the maximum digits number is 3 and we should have the null terminating character, so 4 bytes are allocated for a number
    #currentIndexConsideringNumberLength = currentIndex * 4
    
    printfTextPositive: .asciz "%d"
    newlineToPrint: .asciz "\n"

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
    pushl %edi
    call atoi
    popl %edi
    
    movl %eax, firstCalcNumber
    
    jmp secondHandleAdd
    
add_secondStackIsNumber:
    pushl %edi
    call atoi
    popl %edi
    
    movl %eax, secondCalcNumber
    
    jmp thirdHandleAdd
    

firstHandleAdd:
    popl %ecx
    
    mov $0, %eax
    popl %edi
    movb (%edi), %al                            #%edi should remain unchanged in order to use it in the firstStackIsNumber
    movl %eax, variableAsciiCode
    
    cmp %eax, whereNumberEnds                   #here we decide if last number from stack is a variable or a number
    jge add_firstStackIsNumber
    
    movl variableAsciiCode, %ecx
    mov $variables, %edi
    
    movl (%edi, %ecx, 4), %eax
    movl %eax, firstCalcNumber                  #here we handle the variable and get its value in firstCalcNumber
    
    jmp secondHandleAdd
    
secondHandleAdd:
    mov $0, %eax
    popl %edi
    movb (%edi), %al                            #%edi should remain unchanged in order to use it in the secondStackIsNumber
    movl %eax, variableAsciiCode
    
    cmp %eax, whereNumberEnds                   #here we decide if last(the second when we have entered firstHandleAdd) number from stack is a variable or a number
    jge add_secondStackIsNumber
    
    movl variableAsciiCode, %ecx
    mov $variables, %edi
    
    movl (%edi, %ecx, 4), %eax
    movl %eax, secondCalcNumber                 #here we handle the variable and get its value in secondCalcNumber

    jmp thirdHandleAdd
    
thirdHandleAdd:                                 #here we have eliminated the last 2 values from the stack, firstCalcNumber and secondCalcNumber holding their decimal value
    movl firstCalcNumber, %eax
    addl secondCalcNumber, %eax
    movl %eax, finalCalcNumber
    
    pushl finalCalcNumber
    pushl $printfTextPositive
    
    movl currentIndex, %eax
    movl $11, %ebx
    imull %ebx
    mov $toAddOnStack, %edi                     #calculating the memory address where we would store our number as string
    addl %eax, %edi
    pushl %edi
    
    call sprintf                                #transform the number into the string
    popl %edi
    
    popl %ecx                                   #we pop these 2 arguments in order to store the resultedNumber(on the stack) as a string
    popl %ecx
    
    pushl %edi
    
    incl currentIndex                           #the index moves to the next element in the array which stores the string made by us
    
    jmp nextStrtok


sub_firstStackIsNumber:
    pushl %edi
    call atoi
    popl %edi
    
    movl %eax, firstCalcNumber
    
    jmp secondHandleSub
    
sub_secondStackIsNumber:
    pushl %edi
    call atoi
    popl %edi
    
    movl %eax, secondCalcNumber
    
    jmp thirdHandleSub
    

firstHandleSub:
    popl %ecx
    
    mov $0, %eax
    popl %edi
    movb (%edi), %al                            #%edi should remain unchanged in order to use it in the firstStackIsNumber
    movl %eax, variableAsciiCode
    
    cmp %eax, whereNumberEnds                   #here we decide if last number from stack is a variable or a number
    jge sub_firstStackIsNumber
    
    movl variableAsciiCode, %ecx
    mov $variables, %edi
    
    movl (%edi, %ecx, 4), %eax
    movl %eax, firstCalcNumber                  #here we handle the variable and get its value in firstCalcNumber
    
    jmp secondHandleSub
    
secondHandleSub:
    mov $0, %eax
    popl %edi
    movb (%edi), %al                            #%edi should remain unchanged in order to use it in the secondStackIsNumber
    movl %eax, variableAsciiCode
    
    cmp %eax, whereNumberEnds                   #here we decide if last(the second when we have entered firstHandleSub) number from stack is a variable or a number
    jge sub_secondStackIsNumber
    
    movl variableAsciiCode, %ecx
    mov $variables, %edi
    
    movl (%edi, %ecx, 4), %eax
    movl %eax, secondCalcNumber                 #here we handle the variable and get its value in secondCalcNumber

    jmp thirdHandleSub
    
thirdHandleSub:                                 #here we have eliminated the last 2 values from the stack, firstCalcNumber and secondCalcNumber holding their decimal value
    movl secondCalcNumber, %eax
    subl firstCalcNumber, %eax
    movl %eax, finalCalcNumber
    
    pushl finalCalcNumber
    pushl $printfTextPositive
    
    movl currentIndex, %eax
    movl $11, %ebx
    imull %ebx
    mov $toAddOnStack, %edi                     #calculating the memory address where we would store our number as string
    addl %eax, %edi
    pushl %edi
    
    call sprintf                                #transform the number into the string
    popl %edi
    
    popl %ecx                                   #we pop these 2 arguments in order to store the resultedNumber(on the stack) as a string
    popl %ecx
    
    pushl %edi
    
    incl currentIndex                           #the index moves to the next element in the array which stores the string made by us
    
    jmp nextStrtok
    

mul_firstStackIsNumber:
    pushl %edi
    call atoi
    popl %edi

    movl %eax, firstCalcNumber

    jmp secondHandleMul

mul_secondStackIsNumber:
    pushl %edi
    call atoi
    popl %edi

    movl %eax, secondCalcNumber

    jmp thirdHandleMul


firstHandleMul:
    popl %ecx

    mov $0, %eax
    popl %edi
    movb (%edi), %al                            #%edi should remain unchanged in order to use it in the firstStackIsNumber
    movl %eax, variableAsciiCode

    cmp %eax, whereNumberEnds                   #here we decide if last number from stack is a variable or a number
    jge mul_firstStackIsNumber

    movl variableAsciiCode, %ecx
    mov $variables, %edi

    movl (%edi, %ecx, 4), %eax
    movl %eax, firstCalcNumber                  #here we handle the variable and get its value in firstCalcNumber

    jmp secondHandleMul

secondHandleMul:
    mov $0, %eax
    popl %edi
    movb (%edi), %al                            #%edi should remain unchanged in order to use it in the secondStackIsNumber
    movl %eax, variableAsciiCode

    cmp %eax, whereNumberEnds                   #here we decide if last(the second when we have entered firstHandleMul) number from stack is a variable or a number
    jge mul_secondStackIsNumber

    movl variableAsciiCode, %ecx
    mov $variables, %edi

    movl (%edi, %ecx, 4), %eax
    movl %eax, secondCalcNumber                 #here we handle the variable and get its value in secondCalcNumber

    jmp thirdHandleMul

thirdHandleMul:                                 #here we have eliminated the last 2 values from the stack, firstCalcNumber and secondCalcNumber holding their decimal value
    movl firstCalcNumber, %eax
    movl secondCalcNumber, %ebx
    imull %ebx
    movl %eax, finalCalcNumber

    pushl finalCalcNumber
    pushl $printfTextPositive

    movl currentIndex, %eax
    movl $11, %ebx
    imull %ebx
    mov $toAddOnStack, %edi                     #calculating the memory address where we would store our number as string
    addl %eax, %edi
    pushl %edi

    call sprintf                                #transform the number into the string
    popl %edi

    popl %ecx                                   #we pop these 2 arguments in order to store the resultedNumber(on the stack) as a string
    popl %ecx

    pushl %edi
    
    incl currentIndex                           #the index moves to the next element in the array which stores the string made by us

    jmp nextStrtok



div_firstStackIsNumber:
    pushl %edi
    call atoi
    popl %edi

    movl %eax, firstCalcNumber

    jmp secondHandleDiv

div_secondStackIsNumber:
    pushl %edi
    call atoi
    popl %edi

    movl %eax, secondCalcNumber

    jmp thirdHandleDiv


firstHandleDiv:
    popl %ecx

    mov $0, %eax
    popl %edi
    movb (%edi), %al                            #%edi should remain unchanged in order to use it in the firstStackIsNumber
    movl %eax, variableAsciiCode

    cmp %eax, whereNumberEnds                   #here we decide if last number from stack is a variable or a number
    jge div_firstStackIsNumber

    movl variableAsciiCode, %ecx
    mov $variables, %edi

    movl (%edi, %ecx, 4), %eax
    movl %eax, firstCalcNumber                  #here we handle the variable and get its value in firstCalcNumber

    jmp secondHandleDiv

secondHandleDiv:
    mov $0, %eax
    popl %edi
    movb (%edi), %al                            #%edi should remain unchanged in order to use it in the secondStackIsNumber
    movl %eax, variableAsciiCode

    cmp %eax, whereNumberEnds                   #here we decide if last(the second when we have entered firstHandleDiv) number from stack is a variable or a number
    jge div_secondStackIsNumber

    movl variableAsciiCode, %ecx
    mov $variables, %edi

    movl (%edi, %ecx, 4), %eax
    movl %eax, secondCalcNumber                 #here we handle the variable and get its value in secondCalcNumber

    jmp thirdHandleDiv

thirdHandleDiv:                                 #here we have eliminated the last 2 values from the stack, firstCalcNumber and secondCalcNumber holding their decimal value
    movl $0, %edx
    movl secondCalcNumber, %eax
    movl firstCalcNumber, %ebx
    idivl %ebx
    movl %eax, finalCalcNumber

    pushl finalCalcNumber
    pushl $printfTextPositive

    movl currentIndex, %eax
    movl $11, %ebx
    imull %ebx
    mov $toAddOnStack, %edi                     #calculating the memory address where we would store our number as string
    addl %eax, %edi
    pushl %edi

    call sprintf                                #transform the number into the string
    popl %edi

    popl %ecx                                   #we pop these 2 arguments in order to store the resultedNumber(on the stack) as a string
    popl %ecx

    pushl %edi

    incl currentIndex                           #the index moves to the next element in the array which stores the string made by us

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
    mov $4, %eax
    mov $1, %ebx
    popl %ecx                           #here we print the result
    mov $100, %edx
    int $0x80
    
    mov $4, %eax
    mov $1, %ebx
    mov $newlineToPrint, %ecx           #here we print the newline
    mov $1, %edx
    int $0x80

    mov $1, %eax
    mov $0, %ebx
    int $0x80
