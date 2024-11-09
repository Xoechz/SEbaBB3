#include <stdio.h>

typedef union pixel {
  struct data_data {
    unsigned red   : 8; // 00000000 00000000 00000000 rrrrrrrr
    unsigned green : 8; // 00000000 00000000 gggggggg 00000000
    unsigned blue  : 8; // 00000000 bbbbbbbb 00000000 00000000
    unsigned alpha : 8; // aaaaaaaa 00000000 00000000 00000000
  } data;
  unsigned value;
} pixel_t;

pixel_t screen[600][800];

int main(void) {

  screen[0][0].data.red   = 0xaau;
  screen[0][0].data.green = 0xbbu;
  screen[0][0].data.blue  = 0xccu;

  printf("pixel = 0x%x\n", screen[0][0].value);
  return 0;
}
