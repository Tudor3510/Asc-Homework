.data
    matrix: .space 1870
    lineMemoryLength: .long 84
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
    stdioIntSpaceFormat: .asciz "%d "
    newlineString: .asciz "\n"

    instructionToDo: .space 4
    firstString: .space 12
    secondString: .space 12
    
    addText: .asciz "add"
    addNumber: .long 0
    
    subText: .asciz "sub"
    subNumber: .long 1
    
    mulText: .asciz "mul"
    mulNumber: .long 2
    
    divText: .asciz "div"
    divNumber: .long 3
    
    rotText: .asciz "rot90d"
    rotNumber: .long 4
    
    numberToShow: .space 4
    givenNumber: .space 4

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
    
    incl currentColumn                              #we get to the next column
    jmp readNumbersLine
    
preparingNextReadLineLoop:
    movl lineMemoryLength, %eax
    addl %eax, currentLineAddress                   #we calculate the address for the next line
    
    incl currentLine                                #we increase the line index
    
    jmp readLinesLoop
    
opIsAdd:
    popl %ecx
    movl $0, instructionToDo
    
    pushl noLines
    pushl $stdioIntSpaceFormat
    call printf
    popl %ecx
    popl %ecx
    
    pushl noColumns
    pushl $stdioIntSpaceFormat
    call printf
    popl %ecx
    popl %ecx
    
    movl $0, currentLine
    movl $matrix, currentLineAddress
    
    pushl $firstString
    call atoi
    popl %ecx
    movl %eax, givenNumber
    
    jmp showLinesLoop
    
opIsSub:
    popl %ecx
    movl $1, instructionToDo
    
    pushl noLines
    pushl $stdioIntSpaceFormat
    call printf
    popl %ecx
    popl %ecx
    
    pushl noColumns
    pushl $stdioIntSpaceFormat
    call printf
    popl %ecx
    popl %ecx
    
    movl $0, currentLine
    movl $matrix, currentLineAddress
    
    pushl $firstString
    call atoi
    popl %ecx
    movl %eax, givenNumber
    
    jmp showLinesLoop
    
opIsMul:
    popl %ecx
    movl $2, instructionToDo
    
    pushl noLines
    pushl $stdioIntSpaceFormat
    call printf
    popl %ecx
    popl %ecx
    
    pushl noColumns
    pushl $stdioIntSpaceFormat
    call printf
    popl %ecx
    popl %ecx
    
    
    movl $0, currentLine
    movl $matrix, currentLineAddress
    
    pushl $firstString
    call atoi
    popl %ecx
    movl %eax, givenNumber
    
    jmp showLinesLoop

opIsDiv:
    popl %ecx
    movl $3, instructionToDo
    
    pushl noLines
    pushl $stdioIntSpaceFormat
    call printf
    popl %ecx
    popl %ecx
    
    pushl noColumns
    pushl $stdioIntSpaceFormat
    call printf
    popl %ecx
    popl %ecx
    
    
    movl $0, currentLine
    movl $matrix, currentLineAddress
    
    pushl $firstString
    call atoi
    popl %ecx
    movl %eax, givenNumber
    
    jmp showLinesLoop

opIsRot:    
    popl %ecx
    movl $4, instructionToDo
    
    pushl noColumns
    pushl $stdioIntSpaceFormat
    call printf
    popl %ecx
    popl %ecx
    
    pushl noLines
    pushl $stdioIntSpaceFormat
    call printf
    popl %ecx
    popl %ecx
    

    movl lastLine, %eax
    movl %eax, currentLine
    
    movl lastLineAddress, %eax
    movl %eax, currentLineAddress
    movl $0, currentColumn

    jmp showColumnsLoop

identifyingOperation:
    pushl $secondString
    pushl $firstString
    call strcpy                                     #copying the second string in the first string
    popl %ecx
    
    pushl $stdioStringFormat
    call scanf                                      #reading the text from the keyboard
    popl %ecx
    
    
    pushl $addText
    call strcmp                                     #veryfing if it is an add operation
    popl %ecx
    movl $0, %ebx
    cmp %eax, %ebx
    je opIsAdd
    
    pushl $subText
    call strcmp                                     #veryfing if it is an sub operation
    popl %ecx
    movl $0, %ebx
    cmp %eax, %ebx
    je opIsSub
    
    pushl $mulText
    call strcmp                                     #veryfing if it is an mul operation
    popl %ecx
    movl $0, %ebx
    cmp %eax, %ebx
    je opIsMul
    
    pushl $divText
    call strcmp                                     #veryfing if it is an div operation
    popl %ecx
    movl $0, %ebx
    cmp %eax, %ebx
    je opIsDiv
    
    pushl $rotText
    call strcmp                                     #veryfing if it is an rotation operation
    popl %ecx
    movl $0, %ebx
    cmp %eax, %ebx
    je opIsRot
       
    jmp identifyingOperation                        #looping until we find an operation
    
    
makingAdd:
    movl givenNumber, %eax
    addl %eax, numberToShow                         #making the add calculation
    
    jmp continueShowNumbersLine                     #continue to show numbers from line
    
makingSub:
    movl givenNumber, %eax
    subl %eax, numberToShow                         #making the sub calculation
    
    jmp continueShowNumbersLine                     #continue to show numbers from line
    
makingMul:
    movl givenNumber, %eax
    movl numberToShow, %ecx                         #making the mul calculation
    movl $0, %edx
    
    imull %ecx
    
    movl %eax, numberToShow
    
    jmp continueShowNumbersLine                     #continue to show numbers from line
    
makingDiv:
    movl givenNumber, %ecx
    movl numberToShow, %eax                         #making the div calculation
    movl $0, %edx
    
    cdq
    idivl %ecx
    
    movl %eax, numberToShow
    
    jmp continueShowNumbersLine                     #continue to show numbers from line
    
showLinesLoop:
    movl noLines, %eax
    cmp %eax, currentLine
    jge finish
    
    movl $0, currentColumn                          #we set the column to 0
    jmp showNumbersLine                             #here we show the numbers from the line

showNumbersLine:                                    #here we get the number
    movl noColumns, %eax                            #apply the desired operation
    cmp %eax, currentColumn                         #and then we show the final result
    jge preparingNextShowLineLoop
    
    movl currentLineAddress, %edi
    movl currentColumn, %ecx
    movl (%edi, %ecx, 4), %eax
    movl %eax, numberToShow
    
    movl instructionToDo, %ebx
    
    cmp %ebx, addNumber
    je makingAdd
    
    cmp %ebx, subNumber
    je makingSub
    
    cmp %ebx, mulNumber
    je makingMul
    
    cmp %ebx, divNumber
    je makingDiv

    jmp continueShowNumbersLine

continueShowNumbersLine:
    
    pushl numberToShow
    pushl $stdioIntSpaceFormat
    call printf                                     #here we show the number at the stdout
    popl %ecx
    popl %ecx
    
    
    incl currentColumn                              #we get to the next column
    jmp showNumbersLine
    
    

preparingNextShowLineLoop:
    movl lineMemoryLength, %eax
    addl %eax, currentLineAddress                   #we calculate the address for the next line
    
    incl currentLine                                #we increase the line index
    
    jmp showLinesLoop
    

showColumnsLoop:
    movl noColumns, %eax
    cmp %eax, currentColumn
    jge finish
    
    movl lastLine, %eax
    movl %eax, currentLine
    
    movl lastLineAddress, %eax
    movl %eax, currentLineAddress

    jmp showNumbersColumn
    
showNumbersColumn:
    movl $0, %eax
    cmp %eax, currentLine
    jl preparingNextShowColumnLoop
    
    movl currentLineAddress, %edi
    movl currentColumn, %ecx
    
    pushl (%edi, %ecx, 4)
    pushl $stdioIntSpaceFormat
    call printf
    popl %ecx
    popl %ecx
    
    movl lineMemoryLength, %eax
    subl %eax, currentLineAddress
    
    decl currentLine
    
    jmp showNumbersColumn 
    
preparingNextShowColumnLoop:
    incl currentColumn
    
    jmp showColumnsLoop
    

finish:
    pushl $newlineString
    call printf
    popl %ecx
    
    pushl $0
    call fflush
    popl %ecx
    
    movl $1, %eax
    movl $0, %ebx
    int $0x80
    
    
    