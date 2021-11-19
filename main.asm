.data
    length: .long 100
    textToRead: .space 102
    currPosition: .space 4
    
    letterToProcess: .space 1
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

preparingText:
    movl $0, currPosition
    
    cmpl $length, currPosition   #here we can exit from
    jge processingTextLoop       #our loop when we are at the end
    
    mov $textToRead, %edi
    movl currPosition, %ecx
    movl $0, %edx
    movb (%edi, %ecx, 1), %dl
    movb %dl, letterToProcess
    
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
