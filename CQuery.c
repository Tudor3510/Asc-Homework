#include <stdio.h>
#include <stdlib.h>

int maxNumber, reqLength, array[100], fixedPoint[100], usedNum[100], lastNumPosition[100];
int index, number, tripleMaxNumber;
int currPosNum, spaceBetween;

int verifyGood(int pos){
    for (index =1; index <= maxNumber; index++)
        lastNumPosition[index] = -35;

    for (index =1; index <= pos; index++){
        currPosNum = array[index];
        spaceBetween = index - lastNumPosition[currPosNum] - 1;

        if (spaceBetween < reqLength)
            return 0;
    }
    return 1;
}


void backtracking(int pos){
    if (pos > tripleMaxNumber){
        for (index=1; index <= tripleMaxNumber; index++)
            printf("%d ", array[index]);
        printf("\n");
        exit(0);
    }

    if (fixedPoint[pos] == 1){
        if (verifyGood(pos) == 0)
            return;
        if (usedNum[array[pos]] >= 3)
            return;
        usedNum[array[pos]] += 1;

        backtracking(pos + 1);

        usedNum[array[pos]] -= 1;
    }else{

        for (number=1; number <= maxNumber; number++){
            if (usedNum[number] < 3){
                array[pos] = number;
                if (verifyGood(pos) == 1){
                    usedNum[number] += 1;
                    backtracking(pos + 1);
                    usedNum[number] -= 1;
                }
            }
        }
    }
}



int main (){
    scanf("%d", &maxNumber);
    scanf("%d", &reqLength);

    tripleMaxNumber = 3 * maxNumber;

    for (index=1; index <= tripleMaxNumber; index++){
        scanf("%d", &array[index]);
        if (array[index] != 0)
            fixedPoint[index] = 1;
    }
    backtracking(1);

    return 0;
}