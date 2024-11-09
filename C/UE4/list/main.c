#include <stdio.h>
#include "list.h"

#define DEBUG(X) printf("%s -> %d\n", (#X), (X))

int main(void)
{
  list_t* l = create_list();
  DEBUG(length(l));
  DEBUG(prepend(l, 42));
  DEBUG(length(l));
  DEBUG(prepend(l, 43));
  DEBUG(length(l));
  free_list(l);
  return 0;
}
