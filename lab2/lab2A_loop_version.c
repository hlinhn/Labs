#include <stdio.h>
#include "platform.h"

void print(char *str);
int main()

{
  
  init_platform();
  char in;
  char discard;
  while (1) {
    scanf("%c", &in);
    printf("%c\n\r", in);
    while ((discard = getchar()) != '\n' && discard != EOF);
  }

  return 0;
}
