#include <stdio.h>

int main(void)
{
    int x = 1;
    int y = 2;
    float f;
    printf("f= %d/%d\n", x, y);
    f = x / y;
    printf("f= %f\n", f);

    int i = -1;
    unsigned int u = 1;

    if (i < u)
    {
        printf("i < u\n");
    }
    else
    {
        printf("i >= u\n");
    }
}