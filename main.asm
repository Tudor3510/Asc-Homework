.data
    length: .long 7
    textToRead: .space 102
    currPosition: .space 4
    
    whereNumberEnds: .byte '9'
    whereBigLetterEnds: .byte 'Z'
    whereSmallLetterEnds: .byte 'z'
    
    firstLetter: .space 1
    secondLetter: .space 1
    thirdLetter: .space 1
    
    calculatedNumber: .space 4
.text

.globl main
main:
    movl %esp, %ebp #for correct debugging
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
    subb $47, firstLetter       # 0 will be 1, 1 will be 2, ........
    
    movb firstLetter, %dl
    movb %dl, (%edi, %ecx, 1)
    
    jmp preparingTextLoop
    
preparingTextBigLetter:
    subb $54, firstLetter       # A will be 11, B will be 12, ........
    
    movb firstLetter, %dl
    movb %dl, (%edi, %ecx, 1)

    jmp preparingTextLoop

preparingTextSmallLetter:
    subb $86, firstLetter       # a will be 11, b will be 12, ........


    movb firstLetter, %dl
    movb %dl, (%edi, %ecx, 1)

    jmp preparingTextLoop
    
preparingTextLoop:
    movl length, %eax
    cmpl %eax, currPosition         #here we can exit from our loop when we
    jge processingText              #are at the end (when we reach number 100)
    
    mov $textToRead, %edi
    movl currPosition, %ecx
    movl $0, %edx
    movb (%edi, %ecx, 1), %dl       #the %edi and %ecx registers should remain unchanged when changing our numbers
    movb %dl, firstLetter
    
    incl currPosition               #contorul nostru creste
    
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
    
processingTextLoop:
    movl length, %eax
    cmpl %eax, currPosition         #here we can exit from our loop when we
    jge finish                      #are at the end (when we reach number 99)(we should have a number bigger than 99)
    
    mov $textToRead, %edi
    movl currPosition, %ecx
    movl $0, %edx
    movb (%edi, %ecx, 1), %dl
    movb %dl, thirdLetter           #getting the last number from a pair which is made from 3 hexa numbers
    subl thirdLetter
    
    subl %ecx
    movb (%edi, %ecx, 1), %dl
    movb %dl, secondLetter           #getting the second number from a pair which is made from 3 hexa numbers
    subb secondLetter
    
    subl %ecx
    movb (%edi, %ecx, 1), %dl
    movb %dl, firstLetter           #getting the first number from a pair which is made from 3 hexa numbers
    subb firstLetter


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
