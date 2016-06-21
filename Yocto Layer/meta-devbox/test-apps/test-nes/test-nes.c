/**
 * @file   testebbchar.c
 * @author Derek Molloy
 * @date   7 April 2015
 * @version 0.1
 * @brief  A Linux user space program that communicates with the ebbchar.c LKM. It passes a
 * string to the LKM and reads the response from the LKM. For this example to work the device
 * must be called /dev/ebbchar.
 * @see http://www.derekmolloy.ie/ for a full description and follow-up descriptions.
*/
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <fcntl.h>
#include <string.h>
#include <stdint.h>
#include <unistd.h>

int main(){
   int ret, fd;
   uint8_t receive = 0;
   printf("Starting device test code example...\n");
   fd = open("/dev/nes", O_RDONLY);             // Open the device with read/write access
   if (fd < 0){
      perror("Failed to open the device...");
      return errno;
   }

   printf("Reading from the device...\n");
   while(1)
   {
       ret = read(fd, (void*)&receive, sizeof(receive));        // Read the response from the LKM
       if (ret < 0){
          perror("Failed to read the message from the device.");
          return errno;
       }
       printf("Button values: %x\n", receive);
       usleep(16666);
    }

   printf("End of the program\n");
   return 0;
}