#include<stdio.h>

#define LENGTH 10

int main(void)
{
    int x[LENGTH];

    for (int i = 0; i < LENGTH; i++)
    {
        x[i] = i;
    }

    for (int i = 0; i < LENGTH; i++)
    {
        printf("x[%d] = %d\n", i, x[i]);
    }
}