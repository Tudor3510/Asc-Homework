.data
    maxNumber: .space 4
    reqLength: .space 4
    array: .space 500
    fixedPoint: .space 500
    lastNumPosition: .space 500
    usedNum: .space 500
    
    index: .space 4
    
    scanfIntFormat: .asciz "%d"
    toClearStack: .space 4                              #we will use toClearStack as a variable that will help us to clear the stack
.text
verifyGood:
    

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
    
readArray:
    movl maxNumber, %eax                               #calculating 3 * maxNumber(3 * n), as we need to know when to stop reading
    movl $3, %ebx
    imull %ebx
    
    cmpl index, %eax                                    #if 3 * maxNumber is smaller than index, then we have read all the variables
    jl callBacktracking                                 #and we should call the backtracking function
    
    movl $array, %edi                                   #here we start to calculate the address where we should read our number
    movl index, %eax
    movl $4, %ebx
    imull %ebx
    movl %eax, %ebx                                     #%ebx will hold a copy of the calculated position for the current number
    addl %edi, %eax                                     #now the %eax should contain the address where we should read the number
    
    pushl %eax
    pushl $scanfIntFormat
    call scanf
    popl toClearStack
    popl %eax                                           #here we get our %eax back
    
    cmp $0, (%eax)
    jne foundFixedNumber
    
foundFixedNumber:
    
    movl $1, 8(%ebp)
    
    popl %ebp
    ret
    
prepareNextIndex:
    
    
callBacktracking:
    

finish:
    mov $1, %eax
    xor %ebx, %ebx
    int $0x80