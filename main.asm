.data
    length: .long 15
    textToRead: .space 102
    currPosition: .space 4
    
    whereNumberEnds: .byte '9'
    whereBigLetterEnds: .byte 'Z'
    whereSmallLetterEnds: .byte 'z'
    
    wherePositiveEnds: .long 2303
    whereNegativeEnds: .long 2559
    whereEncodingEnds: .long 2815
    
    firstLetter: .space 1
    secondLetter: .space 1
    thirdLetter: .space 1
    
    calculatedNumber: .long 0
    smallCalculatedNumber: .long 4
    
    letText: .asciz "let "
    letNumber: .long 3072
    
    addText: .asciz "add "
    addNumber: .long 3073
    
    subText: .asciz "sub "
    subNumber: .long 3074
    
    mulText: .asciz "mul "
    mulNumber: .long 3075
     
    divText: .asciz "div "
    divNumber: .long 3076
    
    printfTextPositive: .asciz "%d "
.text

.global main
main:
    movl %esp, %ebp                     #for correct debugging
    jmp readText

readText:
    mov $3, %eax
    mov $0, %ebx
    mov $textToRead, %ecx
    mov $102, %edx
    int $0x80
    jmp preparingText

preparingText:
    movl $0, currPosition
    jmp preparingTextLoop
    
preparingTextNumber:
    subb $47, firstLetter               # 0 will be 1, 1 will be 2, ........
    
    movb firstLetter, %dl
    movb %dl, (%edi, %ecx, 1)
    
    jmp preparingTextLoop
    
preparingTextBigLetter:
    subb $54, firstLetter               # A will be 11, B will be 12, ........
    
    movb firstLetter, %dl
    movb %dl, (%edi, %ecx, 1)

    jmp preparingTextLoop

preparingTextSmallLetter:
    subb $86, firstLetter               # a will be 11, b will be 12, ........


    movb firstLetter, %dl
    movb %dl, (%edi, %ecx, 1)

    jmp preparingTextLoop
    
preparingTextLoop:
    movl length, %eax
    cmpl %eax, currPosition             #here we can exit from our loop when we
    jge processingText                  #are at the end (when we reach number 100)
    
    mov $textToRead, %edi
    movl currPosition, %ecx
    movl $0, %edx
    movb (%edi, %ecx, 1), %dl           #the %edi and %ecx registers should remain unchanged when changing our numbers
    movb %dl, firstLetter
    
    incl currPosition                   #contorul nostru creste
    
    mov $0, %eax
    movb whereNumberEnds, %al
    cmpb %al, firstLetter
    jle preparingTextNumber
    
    mov $0, %eax
    movb whereBigLetterEnds, %al
    cmpb %al, firstLetter
    jle preparingTextBigLetter
    
    mov $0, %eax
    movb whereSmallLetterEnds, %al
    cmpb %al, firstLetter
    jle preparingTextSmallLetter
    


processingText:
    movl $2, currPosition
    jmp processingTextLoop
    
showLet:
    mov $4, %eax
    mov $1, %ebx
    mov $letText, %ecx
    mov $4, %edx
    int $0x80
    
    jmp processingTextLoop

showAdd:
    mov $4, %eax
    mov $1, %ebx
    mov $addText, %ecx
    mov $4, %edx
    int $0x80
    
    jmp processingTextLoop
    
showSub:
    mov $4, %eax
    mov $1, %ebx
    mov $subText, %ecx
    mov $4, %edx
    int $0x80
    
    jmp processingTextLoop
    
showMul:
    mov $4, %eax
    mov $1, %ebx
    mov $mulText, %ecx
    mov $4, %edx
    int $0x80
    
    jmp processingTextLoop
    
showDiv:
    mov $4, %eax
    mov $1, %ebx
    mov $divText, %ecx
    mov $4, %edx
    int $0x80
    
    jmp processingTextLoop
    
showPositiveNumber:
    pushl smallCalculatedNumber
    push $printfTextPositive
    
    call printf
    

    jmp processingTextLoop
    
showNegativeNumber:
    jmp processingTextLoop
    
showEncoding:
    jmp processingTextLoop
    
processingTextLoop:
    movl length, %eax
    cmpl %eax, currPosition             #here we can exit from our loop when we
    jge finish                          #are at the end (when we reach number 99)(we should have a number bigger than 99)
    
    mov $textToRead, %edi
    movl currPosition, %ecx
    movl $0, %edx
    movb (%edi, %ecx, 1), %dl
    movb %dl, thirdLetter               #getting the last number from a pair which is made from 3 hexa numbers
    decb thirdLetter
    
    decl %ecx
    movb (%edi, %ecx, 1), %dl
    movb %dl, secondLetter              #getting the second number from a pair which is made from 3 hexa numbers
    decb secondLetter
    
    decl %ecx
    movb (%edi, %ecx, 1), %dl
    movb %dl, firstLetter               #getting the first number from a pair which is made from 3 hexa numbers
    decb firstLetter
    
    addl $3, currPosition                   #contorul nostru creste
    
    movl $0, %eax
    movb thirdLetter, %al
    movl %eax, %ecx                     #thirdLetter * 16^0 in %ecx
    
    movb secondLetter, %al
    movl $16, %ebx
    imul %ebx
    addl %eax, %ecx                     #+secondLetter * 16^1 in %ecx
    
    movl %ecx, smallCalculatedNumber    #smallCalculatedNumber will now have the number made using the last 2 hexa numbers
    
    mov $0, %eax
    movb firstLetter,%al
    movl $256, %ebx
    imul %ebx
    addl %eax, %ecx                     #+thirdLetter * 16^2 in %ecx
    
    movl %ecx, calculatedNumber         #calculatedNumber will now have our number
    
    cmpl %ecx, letNumber
    je showLet
    
    cmpl %ecx, addNumber
    je showAdd
    
    cmpl %ecx, subNumber
    je showSub
    
    cmpl %ecx, mulNumber
    je showMul
    
    cmpl %ecx, divNumber
    je showDiv
    
    cmpl %ecx, divNumber
    je showDiv
    
    cmpl %ecx, wherePositiveEnds
    jge showPositiveNumber
    
    cmpl %ecx, whereNegativeEnds
    jle showNegativeNumber
    
    cmpl %ecx, whereEncodingEnds
    jle showEncoding

finish:
    mov $1, %eax
    mov $0, %ebx
    int $0x80
