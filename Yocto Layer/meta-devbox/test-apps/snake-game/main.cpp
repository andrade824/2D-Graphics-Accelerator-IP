#include <stdio.h>
#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>
#include <error.h>
#include <sys/mman.h>

#include "game.h"

// Open up the files needed by the sprite and nes controller libraries
bool InitializeFiles(int & sprite_fd, int & nes_fd, void *& video_mem);

// Close files and unmap video memory
bool CloseFiles(int sprite_fd, int nes_fd, void * video_mem);

int main(int argc, char ** argv)
{
    void * video_mem = 0;
    int sprite_fd = 0;
    int nes_fd = 0;
    int ret_val = 0;

    if(InitializeFiles(sprite_fd, nes_fd, video_mem))
    {
        Game game(sprite_fd, nes_fd, video_mem);
        game.Run();

        if(!CloseFiles(sprite_fd, nes_fd, video_mem))
            ret_val = 2;
    }
    else
    {
        ret_val = 1;
    }

    // Create the Sprite Engine
    /*SpriteEngine sprite(sprite_fd, video_mem);
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
    }*/

    
    return ret_val;
}

/**
 * @brief Open up the files needed by the sprite and nes controller libraries
 * 
 * @param sprite_fd File descriptor for /dev/sprite
 * @param nes_fd File descriptor for /dev/nes
 * @param video_mem Pointer to the beginning of video memory
 * 
 * @return True if successful, false if there was an issue
 */
bool InitializeFiles(int & sprite_fd, int & nes_fd, void *& video_mem)
{
    bool result = true;

    // Open up the character files
    sprite_fd = open("/dev/sprite", O_RDWR | O_SYNC);
    if(sprite_fd < 0)
    {
        perror("Failed to open the Sprite Engine");
        result = false;
    }
    else
    {
        // mmap() the video memory into this address space
        video_mem = mmap(0, VIDEO_MEM_USER_SIZE, PROT_READ|PROT_WRITE, MAP_SHARED, sprite_fd, 0);
        if(video_mem == MAP_FAILED)
        {
            perror("Failed to memory map video memory");
            close(sprite_fd);
            result = false;
        }
    }

    nes_fd = open("/dev/nes", O_RDONLY);
    if (nes_fd < 0)
    {
        perror("Failed to open the NES Controller");
        result = false;
    }

    return result;
}

/**
 * @brief Close files and unmap video memory
 * 
 * @param sprite_fd File descriptor for /dev/sprite
 * @param nes_fd File descriptor for /dev/nes
 * @param video_mem Pointer to the beginning of video memory
 * 
 * @return True if successful, false if there was an issue
 */
bool CloseFiles(int sprite_fd, int nes_fd, void * video_mem)
{
    int result = 0;

    // Unmap video memory
    result = munmap(video_mem, VIDEO_MEM_USER_SIZE); 
    if(result < 0)
    {
        perror("video mem munmap");
        close(sprite_fd);
        exit(EXIT_FAILURE);
    }

    close(sprite_fd);
    close(nes_fd);
}