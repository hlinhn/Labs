/***************************** Include Files ********************************/

#include "xtft.h"
#include "xparameters.h"
#include "xuartps_hw.h"

#include "xuartps.h"

#include "tables.h"
#include "xaxidma.h"
#include "xdebug.h"
/************************** Constant Definitions ****************************/
/**
 * The following constants map to the XPAR parameters created in the
 * xparameters.h file. They are defined here such that a user can easily
 * change all the needed parameters in one place.
 */
#define TFT_DEVICE_ID    XPAR_TFT_0_DEVICE_ID
#define DDR_HIGH_ADDR    XPAR_PS7_DDR_0_S_AXI_HIGHADDR
#define UART_DEVICE_ID                  XPAR_XUARTPS_0_DEVICE_ID


#ifdef XPAR_V6DDR_0_S_AXI_HIGHADDR
#define DDR_HIGH_ADDR		XPAR_V6DDR_0_S_AXI_HIGHADDR
#elif XPAR_S6DDR_0_S0_AXI_HIGHADDR
#define DDR_HIGH_ADDR		XPAR_S6DDR_0_S0_AXI_HIGHADDR
#elif XPAR_AXI_7SDDR_0_S_AXI_HIGHADDR
#define DDR_HIGH_ADDR		XPAR_AXI_7SDDR_0_S_AXI_HIGHADDR
#elif XPAR_MPMC_0_MPMC_HIGHADDR
#define DDR_HIGH_ADDR		XPAR_MPMC_0_MPMC_HIGHADDR
#endif



#ifndef DDR_HIGH_ADDR
#warning "CHECK FOR THE VALID DDR ADDRESS IN XPARAMETERS.H"
#endif

#define DISPLAY_COLUMNS  640
#define DISPLAY_ROWS     480

#define PICTURE_C 	320
#define PICTURE_R	240
/**
 * User has to specify a 2MB memory space for filling the frame data.
 * This constant has to be updated based on the memory map of the
 * system.
 */
#define PICTURE_SIZE_BYTES 	30720
#define TFT_FRAME_ADDR        0x10000000//0x001FFFFF//001FFFFF

#define SIZE 16
#define NUM_KEYS 11
#define ROW 4
#define COL 4

#define DMA_DEV_ID        XPAR_AXIDMA_0_DEVICE_ID
#define DDR_BASE_ADDR        XPAR_DDR_MEM_BASEADDR

#ifndef DDR_BASE_ADDR
#warning CHECK FOR THE VALID DDR ADDRESS IN XPARAMETERS.H, \
  DEFAULT SET TO 0x01000000
#define MEM_BASE_ADDR        0x01000000
#else
#define MEM_BASE_ADDR        (DDR_BASE_ADDR + 0x1000000)
#endif

#define TX_BUFFER_BASE        (MEM_BASE_ADDR + 0x00100000)
#define RX_BUFFER_BASE        (MEM_BASE_ADDR + 0x00300000)
#define RX_BUFFER_HIGH        (MEM_BASE_ADDR + 0x004FFFFF)

#define NUMBER_OF_WORDS     4
#define NUMBER_OF_BYTES         NUMBER_OF_WORDS * 4

#define TEST_START_VALUE    340282366920938463463374607431768211415// MAX VALUE
#define TO_CO    			4
#define FROM_CO   			4

#define NUMBER_OF_TRANSFERS    NUMBER_OF_WORDS / 4

/**************************** Type Definitions ******************************/

/************************** Function Prototypes *****************************/

int Tft4218Example(u32 TftDeviceId);
int XTft_DrawSolidBox(XTft *Tft, int x1, int y1, int x2, int y2, unsigned int col);
int UartPsHelloWorldExample(u16 DeviceId);
unsigned int getColor(unsigned char bit1, unsigned char bit2, unsigned char bit3);
void copyKey (u8 *toCopy, u8 *dest);
void writeOut(u8 *buffer);

#if (!defined(DEBUG))
extern void xil_printf(const char *format, ...);
#endif

int XAxiDma_SimplePollExample(u16 DeviceId);
static int CheckData(u32 cur_indx);

/************************** Variable Definitions ****************************/
XUartPs Uart_Ps;		/* The instance of the UART Driver */
static XTft TftInstance;
static u8 RecvBuffer[PICTURE_SIZE_BYTES];
static u8 colorBits[PICTURE_R*PICTURE_C*3];
u8 key[SIZE] = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p'};
u8 keys[NUM_KEYS][SIZE];

XAxiDma AxiDma;
/************************** Function Definitions ****************************/
/*****************************************************************************/
/**
 *
 * Main function that invokes the Tft example.
 *
 * @param    None.
 *
 * @return
 *        - XST_SUCCESS if successful.
 *        - XST_FAILURE if unsuccessful.
 *
 * @note        None.
 *
 ******************************************************************************/
int main()
{
  int Status;
  Xil_DCacheDisable();


	XUartPs_ResetHw(&Uart_Ps);
	Status = Tft4218Example(TFT_DEVICE_ID);
	Status = UartPsHelloWorldExample(UART_DEVICE_ID);

	expandKey(key);

	int i = 0;
	for (i = 0; i < PICTURE_SIZE_BYTES; i+=SIZE) {
		decrypt(&RecvBuffer[i]);
	}
	sendEncodedPicture();
	displayPicture();
	print("SUCCCESS\n");
//	writeOut(key);
//	print("SUCCCESS\n");
	//  if ( Status != XST_SUCCESS) {
	//    return XST_FAILURE;
	//  }
	//  return XST_SUCCESS;


	///////////////CO PROCESSOR/////////////////
	  xil_printf("\r\n--- Entering Co Processor() --- \r\n");

	  /* Run the poll example for simple transfer */
	  Status = XAxiDma_SimplePollExample(DMA_DEV_ID);

	  if (Status != XST_SUCCESS) {

	    xil_printf("XAxiDma_SimplePollExample: Failed\r\n");
	    return XST_FAILURE;
	  }

	  xil_printf("XAxiDma_SimplePollExample: Passed\r\n");

	  xil_printf("--- Exiting main() --- \r\n");

}


int Tft4218Example(u32 TftDeviceId)
{
  int Status;
  XTft_Config *TftConfigPtr;
  unsigned int *col;

  unsigned char c;

  /*
   * Get address of the XTft_Config structure for the given device id.
   */
  TftConfigPtr = XTft_LookupConfig(TftDeviceId);
  if (TftConfigPtr == (XTft_Config *)NULL) {
    return XST_FAILURE;
  }

  /*
   * Initialize all the TftInstance members and fills the screen with
   * default background color.
   */
  Status = XTft_CfgInitialize(&TftInstance, TftConfigPtr,
      TftConfigPtr->BaseAddress);
  if (Status != XST_SUCCESS) {
    return XST_FAILURE;
  }

  /*
   * Wait till Vsync(Video address latch) status bit is set before writing
   * the frame address into the Address Register. This ensures that the
   * current frame has been displayed and we can display a new frame of
   * data. Checking the Vsync state ensures that there is no data flicker
   * when displaying frames in real time though there is some delay due to
   * polling.
   */
  while (XTft_GetVsyncStatus(&TftInstance) !=
      XTFT_IESR_VADDRLATCH_STATUS_MASK);

  /*
   * Change the Video Memory Base Address from default value to
   * a valid Memory Address and clear the screen.
   */
  XTft_SetFrameBaseAddr(&TftInstance, TFT_FRAME_ADDR);
  XTft_ClearScreen(&TftInstance);
  XTft_DisableDisplay(&TftInstance);
  print("Finish initializing TFT\n\r");

  print("  Display color ");
  print("\r\n");
  XTft_SetColor(&TftInstance, 0, 0);
  XTft_ClearScreen(&TftInstance);

  print("  Writing Color Bar Pattern\r\n");

  XTft_DrawSolidBox(&TftInstance,   0, 0, 79,479,0x00ffffff); // white

  XTft_SetPos(&TftInstance, 0,0);
  XTft_SetPosChar(&TftInstance, 0,0);
  XTft_SetColor(&TftInstance, 0x000000, 0x00ffffff);

  XTft_Write(&TftInstance,'E');
  XTft_Write(&TftInstance,'E');


  XTft_SetPosChar(&TftInstance, 100,100);
  XTft_SetColor(&TftInstance, 0x000000, 0x00ffffff);

  XTft_Write(&TftInstance,'4');
  XTft_Write(&TftInstance,'2');
  XTft_Write(&TftInstance,'1');
  XTft_Write(&TftInstance,'8');


  XTft_DrawSolidBox(&TftInstance,  80, 0,159,479,0x00ff0000); // red
  XTft_DrawSolidBox(&TftInstance, 160, 0,239,479,0x0000ff00); // green
  XTft_FillScreen(&TftInstance, 240, 0,319,479,0x000000ff); // blue
  XTft_FillScreen(&TftInstance, 320, 0,399,479,0x00ffffff); // white
  XTft_DrawSolidBox(&TftInstance, 400, 0,479,479,0x00ffff00);
  XTft_DrawSolidBox(&TftInstance, 480, 0,559,479,0x0000ffff);
  XTft_DrawSolidBox(&TftInstance, 560, 0,639,479,0x00ff00ff);
  XTft_EnableDisplay(&TftInstance);

  print("  TFT test completed!\r\n");
  print("  You should see vertical color and grayscale bars\r\n");
  print("  across your VGA Output Monitor\r\n\r\n");
  return 0;
}

int XTft_DrawSolidBox(XTft *Tft, int x1, int y1, int x2, int y2, unsigned int col)
{
  int xmin,xmax,ymin,ymax,i,j;

  if (x1 >= 0 &&
      x1 <= DISPLAY_COLUMNS-1 &&
      x2 >= 0 &&
      x2 <= DISPLAY_COLUMNS-1 &&
      y1 >= 0 &&
      y1 <= DISPLAY_ROWS-1 &&
      y2 >= 0 &&
      y2 <= DISPLAY_ROWS-1) {
    if (x2 < x1) {
      xmin = x2;
      xmax = x1;
    }
    else {
      xmin = x1;
      xmax = x2;
    }
    if (y2 < y1) {
      ymin = y2;
      ymax = y1;
    }
    else {
      ymin = y1;
      ymax = y2;
    }

    for (i=xmin; i<=xmax; i++) {
      for (j=ymin; j<=ymax; j++) {
        XTft_SetPixel(Tft, i, j, col);
      }
    }
    return 0;
  }
  return 1;

}
int UartPsHelloWorldExample(u16 DeviceId)
{
	u8 colorCode[PICTURE_R* PICTURE_C];
	u8 HelloWorld[] = "Hello World";

	int RecvCount = 0;

	int Status;
	XUartPs_Config *Config;

	/*
	 * Initialize the UART driver so that it's ready to use
	 * Look up the configuration in the config table and then initialize it.
	 */
	Config = XUartPs_LookupConfig(DeviceId);
	if (NULL == Config) {
		return XST_FAILURE;
	}

	Status = XUartPs_CfgInitialize(&Uart_Ps, Config, Config->BaseAddress);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	XUartPs_SetBaudRate(&Uart_Ps, 115200);

	u16 Index;

	for (Index = 0; Index < PICTURE_SIZE_BYTES; Index++) {
			RecvBuffer[Index] = 0;
		}
	//XUartPs_DisableUart(&Uart_Ps);
	RecvCount = 0;
	int RecvCount1 = 0;
	XUartPs_SetOptions(&Uart_Ps, XUARTPS_OPTION_RESET_RX);
	XUartPs_EnableUart(&Uart_Ps);

	print("Waiting for data");
	while (RecvCount < PICTURE_SIZE_BYTES) {
						/*
						 * Receive the data
						 */
					RecvCount += XUartPs_Recv(&Uart_Ps,
									   &RecvBuffer[RecvCount], 1);
		//RecvCount++;

					}
	//printf("Total Bytes Received: %d\n", RecvCount);

	//sendEncodedPicture();

	return 1;
}
void sendEncodedPicture()
{
	int SentCount = 0;
	while (SentCount < PICTURE_SIZE_BYTES) {
			/*
			 * Transmit the data
			 */
			SentCount += XUartPs_Send(&Uart_Ps,
						   &RecvBuffer[SentCount], 1);
		}
}
void displayPicture()
{
	u32 count = 0;


	u8 mask = 1; // Bit mask

	u32 i =0, j = 0,k =0;


	for(k=0; k<PICTURE_SIZE_BYTES/2; k++)
	{
		u8 byte = RecvBuffer[2*k];
		for (i = 0; i < 8; i++) {
		    // Mask each bit in the byte and store it
			colorBits[count+i] = (byte & (mask << i)) != 0;
		}
		count = count + 8;

		byte = RecvBuffer[(2*k)+1];
		for (i = 0; i < 7; i++) {
			// Mask each bit in the byte and store it
			colorBits[count+i] = (byte & (mask << i)) != 0;
		}
		count = count + 7;
	}

	//print("SHOWING PICTURE");
	count=0;
	for(i=0; i< PICTURE_R; i++)
	{
		for(j=0;j<PICTURE_C; j++)
		{
			unsigned int color = getColor(colorBits[count],colorBits[count+1], colorBits[count+2]);
			XTft_SetPixel(&TftInstance, j, i, color);
			count = count + 3;
		}
	}
}

unsigned int getColor(unsigned char bit1, unsigned char bit2, unsigned char bit3)
{
	uint32_t color = 0;
	if(bit1 == 1)
	{
		color = color | 0x00ff0000;
	}
	if(bit2 == 1)
		{
			color = color | 0x0000ff00;
		}
	if(bit3 == 1)
		{
			color = color | 0x000000ff;
		}
	return color;
}

void copyKey (u8 *toCopy, u8 *dest) {
	int i = 0;
  for (i = 0; i < SIZE; i++) {
    dest[i] = toCopy[i];
  }
}

void writeOut(u8 *buffer) {
	int i = 0;
	for (i = 0; i < SIZE; i++) {
		printf("%c", buffer[i]);
	}
	printf("\n");
}


void transform (u8 *col, int ord) {
  u8 temp[ROW];
  int i = 0;
  for (i = 0; i < ROW; i++) {
    temp[i] = sbox[col[i]];
  }
  i = 0;
  for (i = 0; i < ROW; i++) {
    col[i] = temp[(i+1)%ROW];
  }
  col[0] ^= rcons[ord];
}

//expand key
void expandKey (u8 *init) {
  copyKey(init, keys[0]);
  int i = 1;
  for (i = 1; i < 11; i++) {
    u8 temp[SIZE], prev[SIZE];
    copyKey(keys[i - 1], temp);
    copyKey(temp, prev);
    transform(temp + 3 * COL, i);
    int j = 0;
    for (j = 0; j < COL; j++) {
      if (j == 0) {
    	  int k = 0;
    	  for (k = 0; k < ROW; k++) {
    		  temp[k] = temp[(j + 3) * COL + k] ^ prev[k];
    	  }
      }
      else {
    	  int k = 0;
    	  for (k = 0; k < ROW; k++) {
    		  temp[j * COL + k] = temp[(j - 1) * COL + k] ^ prev[j * COL + k];
    	  }
      }
    }
    copyKey(temp, keys[i]);
  }
}

void addRound (u8 *mes, u8 *key) {
	int i = 0;
  for (i = 0; i < COL * ROW; i++) {
    mes[i] = mes[i] ^ key[i];
  }
}

void shiftRows (u8 *mes) {
  u8 temp[SIZE];
  int shuffles[SIZE] = {0, 13, 10, 7, 4, 1, 14, 11,
			8, 5, 2, 15, 12, 9, 6, 3};
  int i = 0;
  for (i = 0; i < SIZE; i++) {
    temp[i] = mes[i];
  }
  i = 0;
  for (i = 0; i < SIZE; i++) {
    mes[i] = temp[shuffles[i]];
  }
}
void subBytes (u8 *mes) {
	int i = 0;
  for (i = 0; i < SIZE; i++) {
    mes[i] = inv[mes[i]];
  }
}

u8 multDec (u8 num, u8 mul) {
  //possible improvement: need to think about timing attack
  if (num == 0 || mul == 0) {
    return 0;
  }
  //another (improvement?) approach could be hard coding 9, 11, 13, 14
  u16 logN = ltable[num];
  u16 logM = ltable[mul];
  u16 logS = logN + logM;

  /*hardware implementation with 8 bits number can skip this*/
  //possible timing attack?
  if (logS >= 255) {
    logS -= 255;
  }
  return atable[logS];
}

void mixCol (u8 *mes) {
  int op[ROW][COL] = {{3, 1, 2, 0}, {0, 3, 1, 2},
		      {2, 0, 3, 1}, {1, 2, 0, 3}};
  u8 lutMes[SIZE][4];
  int i = 0;
  for (i = 0 ; i < SIZE; i++) {
    lutMes[i][0] = multDec(mes[i], 9);//mult8 ^ mes[i];
    lutMes[i][1] = multDec(mes[i], 11);//lutMes[i][0] ^ mult2;
    lutMes[i][2] = multDec(mes[i], 13);//lutMes[i][0] ^ mult4;
    lutMes[i][3] = multDec(mes[i], 14);//mult8 ^ mult4 ^ mult2;
  }
  i = 0;
  for (i = 0; i < COL; i++) {
	  int j = 0;
      int ind = i * COL;
    for (j = 0; j < ROW; j++) {
      u8 acc = 0;
      int k = 0;
      for (k = 0; k < ROW; k++) {
    	  acc ^= lutMes[ind + k][op[j][k]];
      }
      mes[ind + j] = acc;
    }
  }
}

void decrypt (u8 *mes) {
	int i = 1;
  for (i = 1; i < 11; i++) {
    if (i == 1) {
      addRound(mes, keys[10]);
      shiftRows(mes);
      subBytes(mes);
    }
    else {
      addRound(mes, keys[11 - i]);
      mixCol(mes);
      shiftRows(mes);
      subBytes(mes);
    }
  }
  addRound(mes, keys[0]);
}



////////////////////////////////////////////////////////////CO PROCESSOR//////////////////////////////////////////
int XAxiDma_SimplePollExample(u16 DeviceId)
{
  XAxiDma_Config *CfgPtr;
  int Status;
  u32 Index;
  u32 *TxBufferPtr;
  u32 *RxBufferPtr;
  u32 Value;
  //__uint128_t  huge_integer;


  TxBufferPtr = (u32 *)TX_BUFFER_BASE ;
  RxBufferPtr = (u32 *)RX_BUFFER_BASE;

  /* Initialize the XAxiDma device.
   */
  CfgPtr = XAxiDma_LookupConfig(DeviceId);
  if (!CfgPtr) {
    xil_printf("No config found for %d\r\n", DeviceId);
    return XST_FAILURE;
  }
  xil_printf("Found config for AXI DMA\n\r");

  Status = XAxiDma_CfgInitialize(&AxiDma, CfgPtr);
  if (Status != XST_SUCCESS) {
    xil_printf("Initialization failed %d\r\n", Status);
    return XST_FAILURE;
  }
  xil_printf("Finish initializing configurations for AXI DMA\n\r");

  if(XAxiDma_HasSg(&AxiDma)){
    xil_printf("Device configured as SG mode \r\n");
    return XST_FAILURE;
  }
  xil_printf("AXI DMA is configured as Simple Transfer mode\n\r");

  /* Disable interrupts, we use polling mode
   */
  XAxiDma_IntrDisable(&AxiDma, XAXIDMA_IRQ_ALL_MASK,
      XAXIDMA_DEVICE_TO_DMA);
  XAxiDma_IntrDisable(&AxiDma, XAXIDMA_IRQ_ALL_MASK,
      XAXIDMA_DMA_TO_DEVICE);

  TxBufferPtr[0] = (TEST_START_VALUE>>96) & 0xFFFFFFFF;
  TxBufferPtr[1] = (TEST_START_VALUE>>64) & 0xFFFFFFFF;
  TxBufferPtr[2] = (TEST_START_VALUE>>32) & 0xFFFFFFFF;
  TxBufferPtr[3] = (TEST_START_VALUE>>0) & 0xFFFFFFFF;

//  for(Index = 0; Index < NUMBER_OF_WORDS; Index ++) {
//    TxBufferPtr[Index] = Value;
//    Value = Value + 1;
//  }
  /* Flush the SrcBuffer before the DMA transfer, in case the Data Cache
   * is enabled
   */
  Xil_DCacheFlushRange((u32)TxBufferPtr, NUMBER_OF_BYTES);

  for(Index = 0; Index < NUMBER_OF_TRANSFERS; Index ++) {

    Status = XAxiDma_SimpleTransfer(&AxiDma,(u32) (RxBufferPtr + Index * FROM_CO),
    		FROM_CO * 4, XAXIDMA_DEVICE_TO_DMA);

    u32 *TxPacket = (u32 *) (TxBufferPtr + Index * FROM_CO);

    /* Invalidate the DestBuffer before receiving the data, in case the
     * Data Cache is enabled
     */
    xil_printf("Data SENT(Hex Form): %08x%08x%08x%08x\r\n", (unsigned int)TxPacket[0],(unsigned int)TxPacket[1],(unsigned int)TxPacket[2],(unsigned int)TxPacket[3]);

    if (Status != XST_SUCCESS) {
      return XST_FAILURE;
    }


    Status = XAxiDma_SimpleTransfer(&AxiDma,(u32) (TxBufferPtr + Index * TO_CO),
    		TO_CO * 4, XAXIDMA_DMA_TO_DEVICE);

    if (Status != XST_SUCCESS) {
      return XST_FAILURE;
    }

    xil_printf("Waiting for AXI DMA \n\r");

    while (XAxiDma_Busy(&AxiDma,XAXIDMA_DMA_TO_DEVICE)) {
    	//wait
    }
    xil_printf("DMA_TO_DEVICE finishes \n\r");

    while (XAxiDma_Busy(&AxiDma,XAXIDMA_DEVICE_TO_DMA)) {
      //wait
    }
    xil_printf("DEVICE_TO_DMA finishes \n\r");

    Status = CheckData(Index);
    if (Status != XST_SUCCESS) {
      return XST_FAILURE;
    }

  }

  /* Test finishes successfully
   */
  return XST_SUCCESS;
}



/*****************************************************************************/
/*
 *
 * This function checks data buffer after the DMA transfer is finished.
 *
 * @param    None
 *
 * @return
 *
 * @note        None.
 *
 ******************************************************************************/
static int CheckData(u32 cur_indx)
{
  u32 *RxPacket;
  int Index = 0;

  RxPacket = (u32 *) (RX_BUFFER_BASE + cur_indx * FROM_CO * 4);

  /* Invalidate the DestBuffer before receiving the data, in case the
   * Data Cache is enabled
   */
  Xil_DCacheInvalidateRange((u32)RxPacket, NUMBER_OF_BYTES);
//
//  for(Index = 0; Index < FROM_CO; Index++) {
//      xil_pr
 // xil_printf("Data %d: %08x\r\n", Index, (unsigned int)RxPacket[Index]);
//  }
  xil_printf("Output(Hex Form): %08x%08x%08x%08x\r\n", (unsigned int)RxPacket[0], (unsigned int)RxPacket[1],(unsigned int)RxPacket[2],(unsigned int)RxPacket[3]);
  return XST_SUCCESS;
}
