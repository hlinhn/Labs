/*
 * Copyright (c) 2009-2012 Xilinx, Inc.  All rights reserved.
 *
 * Xilinx, Inc.
 * XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS" AS A
 * COURTESY TO YOU.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
 * ONE POSSIBLE   IMPLEMENTATION OF THIS FEATURE, APPLICATION OR
 * STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS IMPLEMENTATION
 * IS FREE FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE RESPONSIBLE
 * FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE FOR YOUR IMPLEMENTATION.
 * XILINX EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH RESPECT TO
 * THE ADEQUACY OF THE IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO
 * ANY WARRANTIES OR REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
 * FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.
 *
 */

/*
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#define MATRIC 113022
#define STR6 "72c5846be91fd3a0"
#define MAX_INPUT_LEN 180

void print(char *str);
int position(char c);

int main()
{
    init_platform();

    char line[MAX_INPUT_LEN];
    char accout[MAX_INPUT_LEN + 2];
    char in;
    int pos = 0;
    int posout = 0;
    
    while (pos < MAX_INPUT_LEN && ((in = getchar()) != '\0')) {
      line[pos] = in;
      int trans = position(line[pos]);
      if (trans != -1) {
	accout[posout] = STR6[trans];
        printf("%c", accout[posout]);
	posout++;
      }
      pos++;
    }
    accout[pos] = '\n';
    accout[pos+1] = '\0';
    printf("%s", accout);
    return 0;
}

int position(char c) {
 if (c >= 97 && c <= 102) {
  return (c - 97) + 10;
 }
 if (c >= 48 && c <= 57) {
  return (c - 48);
 }
 return -1;

}
