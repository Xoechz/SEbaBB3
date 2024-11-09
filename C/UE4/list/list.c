#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

#include "list.h"

typedef struct node
{
    int data;
    struct node* next;
} node_t;

typedef struct list
{
    node_t* first;
    int n;
} list_t;

list_t* create_list(void)
{
    list_t* l = malloc(sizeof(list_t));

    if (l == NULL)
    {
        return NULL;
    }

    l->first = NULL;
    l->n = 0;
    return l;
}

int length(const list_t* l)
{
    if (l == NULL)
    {
        return -1;
    }

    return l->n;
}

static node_t* create_node(int data)
{
    node_t* new_node = malloc(sizeof(node_t));

    if (new_node == NULL)
    {
        return NULL;
    }

    new_node->data = data;
    new_node->next = NULL;
    return new_node;
}

bool prepend(list_t* l, int data)
{
    node_t* new_node = create_node(data);

    if (new_node == NULL)
    {
        return false;
    }

    new_node->next = l->first;
    l->first = new_node;
    l->n++;
    return true;
}

void free_list(list_t* l)
{
    while (l->first != NULL)
    {
        node_t* next = l->first->next;
        free(l->first);
        l->first = next;
    }

    free(l);
}
