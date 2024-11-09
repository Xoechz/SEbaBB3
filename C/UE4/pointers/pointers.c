#include <stdlib.h> // for malloc & free
#include <stdio.h>
#include <string.h> // for strlcpy
#include "utils.h"

#define LENGTH 50

void test_malloc(void)
{
  char* s = malloc(sizeof(char) * LENGTH);
  if (s == NULL)
  {
    printf("Memory allocation failed\n");
    return;
  }
  strncpy(s, "Hello, dynamic memory!", LENGTH);
  printf("%s\n", s);
  free(s);
}

void print_char_array(const char s[])
{
  for (int i = 0; s[i] != '\0'; i++)
  {
    putchar(s[i]);
  }
}

void print_char_pointer(char* s)
{
  while (*s != '\0')
  {
    putchar(*s);
    s++;
  }
}

void test_print(void)
{
  char s[] = "Hello, World!";
  print_char_array(s);
  print_char_pointer(s);
}

int my_strncmp(char* a, char* b, int maxlen)
{
  int i;
  for (i = 0; i < maxlen && a[i] != '\0' && b[i] != '\0'; i++)
  {
    if (a[i] != b[i])
    {
      return (int)a[i] - (int)b[i];
    }
  }

  if (a[i] != '\0' && b[i] == '\0')
  {
    return (int)a[i];
  }

  if (a[i] == '\0' && b[i] != '\0')
  {
    return -(int)b[i];
  }

  return 0;
}

#define MYCMP(a, b) DEBUG(my_strncmp(a, b, MIN_ALEN(a, b)))

void test_my_strncmp(void)
{
  char a[] = "Hello, World!";
  char b[] = "Hello, World!";
  char c[] = "Hallo, World!";
  char d[] = "Hello, World!!";
  char e[] = "Hello, World";

  MYCMP(a, a);
  MYCMP(a, b);
  MYCMP(a, c);
  MYCMP(a, d);
  MYCMP(a, e);
}

void print_array_of_pointers(const char* a[], int len)
{
  for (int i = 0; i < len; i++)
  {
    print_char_array(a[i]);
  }
  printf("\n");
}

void test_array_of_pointers(void)
{
  const char* a[] = { "Hello, ", "World!", "" };
  print_array_of_pointers(a, 3);
}

void test_pointer_of_pointer(void)
{
  int i = 42;
  int* p = &i;
  int** pp = &p;
  printf("i = %d\n", i);
  printf("p = %p, *p = %d\n", (void*)p, *p);
  printf("pp = %p, *pp = %p, **pp = %d\n", (void*)pp, (void*)*pp, **pp);
}

int add(int a, int b)
{
  return a + b;
}
int sub(int a, int b)
{
  return a - b;
}

typedef int (*binary_int_op_t)(int, int);

void test_function_pointer(void)
{
  binary_int_op_t ops[] = { add, sub };
  DEBUG(ops[0](1, 2));
  DEBUG(ops[1](1, 2));
}

typedef struct address
{
  char street[40];
  int number;
  int zip;
  char* city;
} address_t;

void print_address(const address_t* a)
{
  printf("a.street = %s\n", a->street);
  printf("a.number = %d\n", (*a).number);
  printf("a.zip = %d\n", a->zip);
  printf("a.city = %s\n", a->city);
}

void test_struct(void)
{
  address_t a;
  strncpy(a.street, "High Street", 12);
  a.number = 23;
  a.zip = 54321;
  a.city = malloc(sizeof(*a.city) * 50);
  strncpy(a.city, "St. Oswald", 11);
  print_address(&a);
  address_t b = { "Main Street", 42, 12345, "St.Oswald" };
  print_address(&b);

  address_t c = a;
  c.number = 42;
  print_address(&a);
  print_address(&c);

  free(a.city);

  printf("sizeof(a) = %lu\n", sizeof(a));
}


int main(void)
{
  test_malloc();
  test_print();
  test_my_strncmp();
  test_array_of_pointers();
  test_pointer_of_pointer();
  test_function_pointer();
  test_struct();

  return 0;
}
