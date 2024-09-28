#include <stdio.h>
#include <stdlib.h>

int main(int argc, char* argv[])
{
    int sum = 0;

    if (argc > 1)
    {
        for (int i = 1; i < argc; i++)
        {
            printf("%2d: Hello, %s!: ", i, argv[i]);
            int number = 0;
            int count = sscanf(argv[i], "%d", &number);
            printf("%s\n", count > 0 ? "OK" : "failed");
            sum += number;
        }
    }
    else
    {
        printf("Hello, World!\n");
    }
    printf("Sum = %d\n", sum);
    return 0;
}