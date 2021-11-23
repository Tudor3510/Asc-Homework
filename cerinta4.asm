.data
    matrix: .space 1770
    lineLength: .long 21
    currentLineAddress: .space 4
    currentLine: .space 4
    currentColumn: .space 4
    lastLine: .space 4
    lastLineAddress: .space 4
    matrixVariableString: .space 10
    
    addressToReadMatNumber: .space 4
    
    noLines: .space 4
    noColumns: .space 4
    
    stdioStringFormat: .asciz "%s"
    stdioIntFormat: .asciz "%d"

    instructionToDo: .space 4
    identifyingString: .space 24
    numberToWorkWith: .space 4

.text

.global main
main:
    movl %esp, %ebp #for correct debugging
    jmp readText


readText:
    pushl $matrixVariableString
    pushl $stdioStringFormat
    call scanf                                      #reading the matrix name
    popl %ecx
    popl %ecx
    
    pushl $noLines
    pushl $stdioIntFormat
    call scanf                                      #reading the number of lines
    popl %ecx
    popl %ecx
    
    pushl $noColumns
    pushl $stdioIntFormat
    call scanf                                      #reading the number of columns
    popl %ecx
    popl %ecx
    
    jmp readLines
    
readLines:
    movl $matrix, currentLineAddress
    movl $0, currentLine
    
    jmp readLinesLoop

readLinesLoop:
    movl noLines, %eax
    cmp %eax, currentLine
    jge identifyingOperation
    
    movl currentLineAddress, %eax
    movl %eax, lastLineAddress                      #we store the last line address
    
    movl currentLine, %eax                       
    movl %eax, lastLine                             #we store the last line no
    
    movl $0, currentColumn                          #we set the column to 0
    jmp readNumbersLine                             #here we read the numbers from the line
    
readNumbersLine:
    movl noColumns, %eax
    cmp %eax, currentColumn
    jge preparingNextReadLineLoop                   #here we verify if we should get to the next line
    
    movl currentLineAddress, %edi
    movl currentColumn, %eax
    movl $4, %ebx
    imull %ebx
    addl %eax, %edi
    pushl %edi                                      #now the address where we should store our number is on the stack
    
    pushl $stdioIntFormat
    call scanf                                      #now we read the number
    
    popl %ecx                                       #now we clear the stack
    popl %ecx
    
    incl currentColumn                             #we get to the next column
    jmp readNumbersLine
    
preparingNextReadLineLoop:
    movl lineLength, %eax
    movl $4, %ebx                                   #how much space does an int take
    imull %ebx
    
    addl %eax, currentLineAddress                   #we calculate the address for the next line
    incl currentLine
    
    jmp readLinesLoop
    

identifyingOperation:


    
    
finish:
    movl $1, %eax
    movl $0, %ebx
    int $0x80
    
    
    