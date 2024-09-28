#include <stdio.h>
#include "lib/lib.h"

int main(void)
{
    int i = 24;
    float f = 2.718f;
    double d = 3.14159265358979323846;
    char c = 'A';
    char* s = "Hello, World!";
    char a[] = "Hello, World!";

    printf("i = %03d\n", i);
    printf("f = %f\n", f);
    printf("d = %10.2f\n", d);
    printf("c = %c\n", c);
    printf("s = %s\n", s);
    printf("a = %s\n", a);
    printf("%10d + %10.2f = %10.2f\n", i, f, i + f);
    printf("Add: %d\n", add(i, i));
    printf("Sub: %d\n", sub(i, i));
    return 0;
}