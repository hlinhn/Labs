#include <stdio.h>
#include "platform.h"

void print(char *str);

int main()
{

  init_platform();
  char in;
    
  scanf("%c", &in);
  printf("%c\n\r", in);

  return 0;

}
