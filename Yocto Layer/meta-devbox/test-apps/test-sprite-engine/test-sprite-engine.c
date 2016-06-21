#include <stdio.h>
#include <stdint.h>
#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>
#include <error.h>
#include <sys/mman.h>
#include <sys/ioctl.h>

// Header file containing IOCTL commands and other useful macros
#include "../recipes-kernel/sprite_engine/files/sprite_engine.h"

// How much to delay (in microseconds) between moving the sprites
#define DELAY 7000

// Prototypes
void ClearSprite(uint16_t * sprite, uint8_t red, uint8_t green, uint8_t blue);
void ClearTile(uint16_t * tile, uint8_t red, uint8_t green, uint8_t blue);

int main(int argc, char ** argv)
{
    void * video_mem = 0;
    uint16_t * bg_buffer = 0;
    uint16_t * tile_buffer = 0;
    uint16_t * spr_buffer = 0;
    int sprite_fd = 0;
    struct Tile tile;
    struct Sprite sprites[MAX_SPRITES];
    uint8_t bg_mode = 0;
    int result = 0;

    // Open up the character file
    sprite_fd = open("/dev/sprite", O_RDWR | O_SYNC);
    if(sprite_fd < 0) {
        perror("sprite character file already open");
        exit(EXIT_FAILURE);
    }

    // mmap() the video memory into this address space
    video_mem = mmap(0, VIDEO_MEM_USER_SIZE, PROT_READ|PROT_WRITE, MAP_SHARED, sprite_fd, 0); 
    if(video_mem == MAP_FAILED) {
        perror("video mem mmap failed");
        close(sprite_fd);
        exit(EXIT_FAILURE);
    }

    // Setup pointers to the individual buffers within video memory
    bg_buffer = (uint16_t*)(video_mem + BG_BUFFER_OFFSET);
    tile_buffer = (uint16_t*)(video_mem + TILE_BUFFER_OFFSET);
    spr_buffer = (uint16_t*)(video_mem + SPR_BUFFER_OFFSET);

    // Set the background color to green
    printf("Drawing green to the screen...");
    for(int i = 0; i < (WIDTH * HEIGHT); ++i) {
        *(bg_buffer + i) = pixel_to_int(0, 63, 0);
    }
    printf("Done!\n");

    // Initialize the background tiles
    printf("Initializing background tiles...");
    for(int i = 0; i < TILE_ROWS; ++i)
    {
        for(int j = 0; j < TILE_COLS; ++j)
        {
            tile.x_index = j;
            tile.y_index = i;
            tile.mem_slot = (i * TILE_COLS + j);

            ClearTile(TILE_ADDR(tile_buffer,j,i), 12 + i, (i)*4, i);

            ioctl(sprite_fd, SPRITE_TILE_ATTR, &tile);
        }
    }
    printf("Done!\n");

    // Set background mode to "buffered background" by default
    ioctl(sprite_fd, SPRITE_BG_MODE, 0);

    // Initialize sprites
    printf("Initializing sprites...");
    int index = 0;
    for(int page = 0; page < 4; ++page)
    {
        for(int i = 0; i < 8; ++i)
        {
            for(int j = 0; j < 8; ++j)
            {
                index = (i*8 + j + (page*64));
                sprites[index].disp_index = index;
                sprites[index].enable = 1;
                sprites[index].height = 32;
                sprites[index].width = 32;
                sprites[index].mem_slot = index;
                sprites[index].x = (j * 50) + (page * 8);
                sprites[index].y = (i * 50) + (page * 8);

                ClearSprite(SPRITE_ADDR(spr_buffer,index), page*10, (i+1)*7, page*5);

                ioctl(sprite_fd, SPRITE_XY_ATTR, &sprites[index]);
                ioctl(sprite_fd, SPRITE_EMWH_ATTR, &sprites[index]);
            }
        }
    }
    printf("Done!\n");

    printf("Moving sprites and swapping background modes...\n");
    while(1)
    {
        for(int x_coord = 0; x_coord < 50; x_coord++)
        {
            usleep(DELAY);
            for(int i = 0; i < MAX_SPRITES; i++)
            {
                sprites[i].x += 1;
                ioctl(sprite_fd, SPRITE_X_ATTR, &sprites[i]);
            }
        }

        for(int y_coord = 0; y_coord < 50; y_coord++)
        {
            usleep(DELAY);
            for(int i = 0; i < MAX_SPRITES; i++)
            {
                sprites[i].y += 1;
                ioctl(sprite_fd, SPRITE_Y_ATTR, &sprites[i]);
            }
        }

        for(int x_coord = 50; x_coord > 0; x_coord--)
        {
            usleep(DELAY);
            for(int i = 0; i < MAX_SPRITES; i++)
            {
                sprites[i].x -= 1;
                ioctl(sprite_fd, SPRITE_X_ATTR, &sprites[i]);
            }
        }

        for(int y_coord = 50; y_coord > 0; y_coord--)
        {
            usleep(DELAY);
            for(int i = 0; i < MAX_SPRITES; i++)
            {
                sprites[i].y -= 1;
                ioctl(sprite_fd, SPRITE_Y_ATTR, &sprites[i]);
            }
        }

        // Swap the background mode
        if(bg_mode)
            bg_mode = 0;
        else
            bg_mode = 1;

        ioctl(sprite_fd, SPRITE_BG_MODE, bg_mode);
    }

    // Unmap everything and close the /dev/mem file descriptor
    result = munmap(video_mem, VIDEO_MEM_USER_SIZE); 
    if(result < 0) {
        perror("video mem munmap");
        close(sprite_fd);
        exit(EXIT_FAILURE);
    }

    close(sprite_fd);
    exit(EXIT_SUCCESS);
}

/**
* Clears out the passed in sprite's memory to the specified color
*
* @sprite Starting address of the sprite's memory region
* @red The red component of the color
* @green The green component of the color
* @blue The blue component of the color
*
* @retval none
*/
void ClearSprite(uint16_t * sprite, uint8_t red, uint8_t green, uint8_t blue)
{
    for(int i = 0; i < (SPR_WIDTH * SPR_HEIGHT); ++i)
    {
        *(sprite + i) = pixel_to_int(red, green, blue);
    }
}

/**
* Clears out the passed in tile's memory to the specified color
*
* @tile Starting address of the tile's memory region
* @red The red component of the color
* @green The green component of the color
* @blue The blue component of the color
*
* @retval none
*/
void ClearTile(uint16_t * tile, uint8_t red, uint8_t green, uint8_t blue)
{
    for(int i = 0; i < (TILE_WIDTH * TILE_HEIGHT); ++i)
    {
        *(tile + i) = pixel_to_int(red, green, blue);
    }
}