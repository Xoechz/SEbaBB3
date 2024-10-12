#include <stdio.h>
#include "lib/date.h"

#define ARRAY_LENGHT(a) (sizeof(a) / sizeof(a[0]))

int square(int x)
{
    x = x * x;
    return x;
}

void squareAll(int x[], int length)
{
    for (int i = 0; i < length; i++)
    {
        x[i] = x[i] * x[i];
    }
}

//void printAll(int* x, int length)
// THE SAME AS:
void printAll(int x[], int length)
{
    for (int i = 0; i < length; i++)
    {
        printf("x[%d] = %d\n", i, x[i]);
    }
}

static void increment()
{
    static int cnt;// = 0;
    cnt++;
    printf("cnt = %d\n", cnt);
}

void setToThree(int x)
{
    x = 3;
}

void setToThreeByRef(int* x)
{
    *x = 3;
}

int main(void)
{
    int x = 5;
    printf("%d² = %d\n", x, square(x));
    setToThree(x);
    printf("%d² = %d\n", x, square(x));
    setToThreeByRef(&x);
    printf("%d² = %d\n", x, square(x));


    int y[] = { 1, 2, 3, 4, 5 };
    squareAll(y, ARRAY_LENGHT(y));
    printAll(y, ARRAY_LENGHT(y));

    for (int i = 0; i < 5; i++)
    {
        increment();
    }

    initDate(1, 1, 2021);
    day = 2;// you should set day to static, so only "date.c" can access it
    printDate();

    return 0;
}