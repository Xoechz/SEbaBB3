#include <stdio.h>
#include "date.h"

int day, month, year;

void initDate(int d, int m, int y)
{
    day = d;
    month = m;
    year = y;
}

void printDate()
{
    printf("%02d.%02d.%04d\n", day, month, year);
}