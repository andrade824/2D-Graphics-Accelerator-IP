#include <stdio.h>
#include <stdint.h>
#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>
#include <error.h>
#include <sys/mman.h>
#include <sys/ioctl.h>

#include "sprite_engine.h"
#include "nesctrl.h"

// How much to delay (in microseconds) between moving the sprites
#define DELAY 7000

int main(int argc, char ** argv)
{
    void * video_mem = 0;
    int sprite_fd = 0;
    int nes_fd = 0;
    Tile tile;
    Sprite player;
    int result = 0;
    int delay = DELAY;

    if(argc == 2)
    {
        delay = atoi(argv[1]);
    }
    // Open up the character files
    sprite_fd = open("/dev/sprite", O_RDWR | O_SYNC);
    if(sprite_fd < 0) {
        perror("Failed to open the Sprite Engine");
        exit(EXIT_FAILURE);
    }

    nes_fd = open("/dev/nes", O_RDONLY);
    if (nes_fd < 0){
        perror("Failed to open the NES Controller");
        exit(EXIT_FAILURE);
    }

    // mmap() the video memory into this address space
    video_mem = mmap(0, VIDEO_MEM_USER_SIZE, PROT_READ|PROT_WRITE, MAP_SHARED, sprite_fd, 0); 
    if(video_mem == MAP_FAILED) {
        perror("video mem mmap failed");
        close(sprite_fd);
        exit(EXIT_FAILURE);
    }

    // Create the Sprite Engine
    SpriteEngine sprite(sprite_fd, video_mem);
    NesController nes(nes_fd);

    // Set Background to green
    sprite.DrawRectangleBg(0, 0, WIDTH - 1, HEIGHT - 1, 0, 63, 0);

    // Initialize the background tiles
    for(int i = 0; i < TILE_ROWS; ++i)
    {
        for(int j = 0; j < TILE_COLS; ++j)
        {
            tile.x_index = j;
            tile.y_index = i;
            tile.mem_slot = (i * TILE_COLS + j);

            sprite.ClearTileMem(j, i, 12 + i, (i) * 4, i);
            sprite.UpdateTileAttr(&tile);
        }
    }

    // Initialize player sprite
    player.disp_index = 0;
    player.enable = 1;
    player.mem_slot = 0;
    player.width = 32;
    player.height = 32;
    player.x = 0;
    player.y = 0;

    sprite.ClearSpriteMem(player.mem_slot, 31, 10, 25);
    sprite.UpdateSpriteAttr(&player, SPR_XY_ATTR);
    sprite.UpdateSpriteAttr(&player, SPR_EMWH_ATTR);

    while(!nes.Start())
    {
        nes.Update();

        if(nes.Right() && player.x < WIDTH)
            player.x++;

        if(nes.Left() && player.x > 0)
            player.x--;

        if(nes.Up() && player.y > 0)
            player.y--;

        if(nes.Down() && player.y < HEIGHT)
            player.y++;

        sprite.UpdateSpriteAttr(&player, SPR_XY_ATTR);

        if(nes.A())
            sprite.EnableTiledBg();
        else
            sprite.EnableBufferedBg();
        
        usleep(delay);
    }

    // Unmap everything
    result = munmap(video_mem, VIDEO_MEM_USER_SIZE); 
    if(result < 0) {
        perror("video mem munmap");
        close(sprite_fd);
        exit(EXIT_FAILURE);
    }

    close(sprite_fd);
    close(nes_fd);
    exit(EXIT_SUCCESS);
}