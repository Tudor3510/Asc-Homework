#include <stdio.h>

int maxNumber, reqLength, array[100], fixedPoint[100], usedNum[100];
int index, number;

int verifyGood(int pos){

}


void backtracking(int pos){
    if (fixedPoint[pos] == 1){
        if (verifyGood(pos) == 0)
            return;
        if (usedNum[array[pos]] >= 3)
            return;
        usedNum[array[pos]] += 1;

         backtracking(pos + 1);
    }else{

        for (number=1; number <= maxNumber; number++){
            if (usedNum[number] < 3){
                array[pos] = number;
                if (verifyGood(pos) == 1)
                    backtracking(pos + 1);
            }
        }



    }


    return;

}



int main (){
    scanf("%d", &maxNumber);
    scanf("%d", &reqLength);

    for (index=1; index <= (3 * maxNumber); index++){
        scanf("%d", &array[index]);
        if (array[index] != 0)
            fixedPoint[index] = 1;
    }

    return 0;
}