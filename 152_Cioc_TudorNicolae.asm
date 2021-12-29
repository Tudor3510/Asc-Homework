.data
    maxNumber: .space 4
    reqLength: .space 4
    array: .space 500
    fixedPoint: .space 500
    lastNumPosition: .space 500
    usedNum: .space 500
    
    index: .space 4
    tripleMaxNumber: .space 4
    
    scanfIntFormat: .asciz "%d"
    minusOneText: .asciz "-1\n"
    
    currPosNum: .space 4
    spaceBetween: .space 4
    
    toClearStack: .space 4                              #we will use toClearStack as a variable that will help us to clear the stack
.text
verifyGood:
    pushl %ebp
    pushl %ebx
    pushl %edi                                          #here we do a backup of our registers
    movl %esp, %ebp
    
    movl $1, index                                      #here we prepare for completing our numPosition array
    jmp completeLastNumPositionLoop
    
completeLastNumPositionLoop:
    movl maxNumber, %eax                                #here we store the maxNumber in eax in order to use it for comparision
    
    cmpl index, %eax                                    #if maxNumber is smaller than index, then we have finished completing the lastNumPosition
    jl prepareVerifyGoodLoop
    
    movl $lastNumPosition, %edi
    movl index, %ecx
    movl $-200, (%edi, %ecx, 4)                         #we put -200 in every position of the lastNumPosition array because we will need to have
                                                        #a small value when we find the first occurrence
                                                        
    incl index                                          #here we increase index by one position
    jmp completeLastNumPositionLoop
    
prepareVerifyGoodLoop:
    movl $1, index
    jmp verifyGoodLoop
    
verifyGoodLoop:
    movl index, %eax
    cmpl 16(%ebp), %eax                                 #the argument "pos" is at %ebp - 16
    jl verifyGoodReturnPositive

    movl $array, %edi
    movl index, %ecx
    movl (%edi, %ecx, 4), %edx
    movl %edx, currPosNum                               #now currPosNum will have the number that is stored at the array[index]
    
    
    movl index, %eax                                    #we will use %eax to calculate the space between

    movl $lastNumPosition, %edi
    movl currPosNum, %ecx                               #here we calculate the lastNumPosition[currPosNum]. This should remain unchanged bc we use this result again
    subl (%edi, %ecx, 4), %eax                          #after verifying to jump to verifyGoodReturnNegative
    
    decl %eax                                           #here we decrease the %eax because we need to know the space between
    
    
    movl %eax, spaceBetween
    cmpl reqLength, %eax
    jl verifyGoodReturnNegative                         #if space between is smaller than the required length, then it is not a good generation
    
    movl index, %edx                                    
    movl %edx, (%edi, %ecx, 4)                          #here lastNumPosition[currPosNum] = index. !!! %edi and %ecx should not have been changed
    
    incl index                                          #here we increase the index by one unit
    jmp verifyGoodLoop                                  #we start the loop again

verifyGoodReturnNegative:
    popl %edi
    popl %ebx
    popl %ebp
    
    movl $0, %eax
    ret

verifyGoodReturnPositive:
    popl %edi
    popl %ebx
    popl %ebp
    
    movl $1, %eax
    ret

backtracking:
    pushl %ebp
    mov %esp, %ebp
    
    
    movl 8(%ebp), %eax
    addl 12(%ebp), %eax
    movl 16(%ebp),%ebx
    movl %eax, 0(%ebx)
    
    
    
    popl %ebp
    ret
    
.globl main
main:
    movl %esp, %ebp                                     #for correct debugging
    movl $index, %eax                                   #THIS SHOULD BE DELETED!!!!!!
    pushl $1                                            #THIS SHOULD BE DELETED!!!!!!
    popl toClearStack                                   #THIS SHOULD BE DELETED!!!!!!
    
    pushl $maxNumber
    pushl $scanfIntFormat
    call scanf                                          #here we read the maxNumber(n number), as it will help us to make
    popl toClearStack                                   #the list {1, 2, 3, 4, 5, .....}
    popl toClearStack
    
    pushl $reqLength
    pushl $scanfIntFormat
    call scanf                                          #here we read the maxLength that should be between the numbers
    popl toClearStack
    popl toClearStack
    
    movl maxNumber, %eax
    movl $3, %ebx
    imull %ebx
    movl %eax, tripleMaxNumber                          #here we calculate the triple max number variable (3 * maxNumber(3 * n))
    
    movl $1, index
    jmp readArray
    
readArray:
    movl tripleMaxNumber, %eax                          #here we store the tripleMaxNumber in eax in order to use it for comparision
    
    cmpl index, %eax                                    #if 3 * maxNumber is smaller than index, then we have read all the variables
    jl callBacktracking                                 #and we should call the backtracking function
    
    movl $array, %edi                                   #here we start to calculate the address where we should read our number
    movl index, %eax
    movl $4, %ebx
    imull %ebx
    movl %eax, %ebx                                     #%ebx will hold a copy of the calculated position for the current number
    addl %eax, %edi                                     #now the %edi should contain the address where we should read the number
    
    pushl %edi
    pushl $scanfIntFormat
    call scanf
    popl toClearStack
    popl %edi                                           #here we get our %edi back
    
    cmpl $0, (%edi)                                     #we compare 0 with the number that we have just read in order to know if it is a fixed number
    jne foundFixedNumber
    
    jmp prepareNextIndex
    
foundFixedNumber:                                       #this label treat the case in which we have a fixed point
    movl $fixedPoint, %edi                              #here we load the fixedPoint array address to %edi
    addl %ebx, %edi                                     #here we add %ebx (which holds the calculated position for the current number) to %edi
    movl $1, (%edi)
    
    jmp prepareNextIndex
    
prepareNextIndex:
    incl index                                          #here we increase the index by one unit
    jmp readArray                                       #we prepare to read the next input
    
callBacktracking:
    pushl $1            
    call backtracking                                   #here we call backtracking(1), because he have pushed 1
    
    movl $4, %eax
    movl $1, %ebx
    movl $minusOneText, %ecx                            #here we show -1 and a newline if the backtracking program has finished
    movl $3, %edx
    int $0x80
    
    jmp finish

finish:                                                 #the label for finishing the program
    mov $1, %eax
    xor %ebx, %ebx
    int $0x80