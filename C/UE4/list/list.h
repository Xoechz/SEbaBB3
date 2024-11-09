#pragma once

#include <stdbool.h>    

typedef struct list list_t;

void free_list(list_t* l);
list_t* create_list(void);
int length(const list_t* l);
bool prepend(list_t* l, int data);