#include <stdio.h>
#include <string.h>

int main(void)
{
    char first[] = "Elias";
    char last[] = "Leonhardsberger";
    char full[22] = "";
    size_t n = 21;

    printf("full = '%s'\n", full);

    strncpy(full, first, n);
    full[n] = '\0';
    printf("full = '%s'\n", full);

    strncat(full, " ", n - strlen(full));

    printf("full = '%s'\n", full);

    strncat(full, last, n - strlen(full));

    printf("full = '%s'\n", full);

    printf("strncmp(first, last, 6) = %d\n", strncmp(first, last, 6));
    printf("strncmp(last, last, 6) = %d\n", strncmp(last, last, 6));

    return 0;
}