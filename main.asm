.data
    length: .long 100
    textToRead: .space 102
    currPosition: .space 4
    
    whereNumberEnds: .byte 57
    
    firstLetter: .space 1
    secondLetter: .space 1
    thirdLetter: .space 1
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
    subb $47, firstLetter
    
preparingTextLoop:
    cmpl $length, currPosition      #here we can exit from
    jge processingTextLoop          #our loop when we are at the end (when we reach number 100)
    
    mov $textToRead, %edi
    movl currPosition, %ecx
    movl $0, %edx
    movb (%edi, %ecx, 1), %dl       #the %edi and %ecx registers should remain unchanged when changing our numbers
    movb %dl, firstLetter
    
    incl currPosition
    
    cmpb $whereNumberEnds, firstLetter
    jle preparingTextNumber
    
    
    
    
   # cmpl letterToProcess
    

processingTextLoop:
    


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
