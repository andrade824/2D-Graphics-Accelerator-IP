/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* XILINX CONSORTIUM BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
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
#include <stdlib.h>
#include "platform.h"
#include <xil_types.h>
#include <xparameters.h>
#include <sprite_engine.h>
#include <xil_io.h>
#include <xil_cache.h>
#include <unistd.h>
#include <stdlib.h>

#define WIDTH 640
#define HEIGHT 480

// Convert separate color values into one word of data
#define pixel_to_int(red,green,blue) ((blue & 0x1F) | ((green & 0x3F) << 5) | ((red & 0x1F) << 11))

void MovingRectangle(u16 * frame);
void RandomRectangles(u16 * frame);
void AlternatingColors(u16 * frame);

void ClearScreen(u16 * frame, u8 red, u8 green, u8 blue);
void DrawRectangle(u16 * frame_start, u32 x1, u32 y1, u32 x2, u32 y2, u8 red, u8 green, u8 blue);

int main()
{
	u16 * frame = 0;
	init_platform();
	Xil_DCacheDisable();
    //print("Hello World\n\r");

    // Allocate enough memory to store pixel data for the entire screen
    frame = (u16 *)malloc(sizeof(u16) * WIDTH * HEIGHT);

    ClearScreen(frame, 0, 0, 0);

    //DrawRectangle(frame, 0, 0, 200, 200, 31, 63, 31);

    // Draw stuff
    //AlternatingColors(frame);

	RandomRectangles(frame);

    //MovingRectangle(frame);

    // Set the Framereader to read from our array
    SPRITE_ENGINE_mWriteReg(XPAR_SPRITE_ENGINE_0_S_TEST_AXI_BASEADDR, 0, frame);

	print("Hello Worfld\n\r");

    while(1)
    {

    }

    cleanup_platform();
    return 0;
}

void MovingRectangle(u16 * frame)
{
	const int rect_size = 20;
	u32 x = 0, y = 300;

	for(x = 0; x < WIDTH - rect_size; x += 1)
	{
		//ClearScreen(frame, 31, 0, 0);
		DrawRectangle(frame, x, y, x + rect_size, y + rect_size, 5, 44, 25);

		usleep(50000);
	}
}

void AlternatingColors(u16 * frame)
{
	int i = 0;

	while(1)
	{
		for(i = 0; i < (WIDTH * HEIGHT) / 2; ++i)
		{
			*(frame + i) = pixel_to_int(31,0,0);
		}

		for(i = (WIDTH * HEIGHT) / 2; i < (WIDTH * HEIGHT); ++i)
		{
			*(frame + i) = pixel_to_int(0,63,0);
		}

		usleep(100000);

		for(i = 0; i < (WIDTH * HEIGHT) / 2; ++i)
		{
			*(frame + i) = pixel_to_int(0,0,31);
		}

		for(i = (WIDTH * HEIGHT) / 2; i < (WIDTH * HEIGHT); ++i)
		{
			*(frame + i) = pixel_to_int(31,63,0);
		}

		DrawRectangle(frame, 200, 200, 400, 300, 31, 63, 31);

		usleep(100000);
	}
}

void RandomRectangles(u16 * frame)
{
	const int rect_size = 200;
	u32 x, y;
	u8 red, green, blue;

	// Seed the random number generator
	srand(50);
	while(1)
	{
		// Get a random coordinate on the screen
		x = rand() % (WIDTH - rect_size);
		y = rand() % (HEIGHT - rect_size);

		// Get a random color
		red = rand() % 256;
		green = rand() % 256;
		blue = rand() % 256;

		// Actually draw the rectangle
		DrawRectangle(frame, x, y, x + rect_size, y + rect_size, red, green, blue);

		// Wait 100ms
		usleep(20000);
	}
}

void ClearScreen(u16 * frame, u8 red, u8 green, u8 blue)
{
	int i = 0;

	for(i = 0; i < (WIDTH * HEIGHT); ++i)
	{
		*(frame + i) = pixel_to_int(red, green, blue);
	}
}

void DrawRectangle(u16 * frame_start, u32 x1, u32 y1, u32 x2, u32 y2, u8 red, u8 green, u8 blue)
{
	int i = 0, j = 0;
	for(i = y1; i <= y2; ++i)
	{
		for(j = x1; j <= x2; ++j)
			 *(frame_start + (i * WIDTH) + j) = pixel_to_int(red, green, blue);
	}
}
