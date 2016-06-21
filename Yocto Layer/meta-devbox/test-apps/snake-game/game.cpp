#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include <error.h>
#include "game.h"
#include "snake.h"

/**
 * @brief Constructor
 * 
 * @param sprite_fd File descriptor for /dev/sprite
 * @param nes_fd File descriptor for /dev/nes
 * @param video_mem Pointer to the beginning of video memory
 */
Game::Game(int sprite_fd, int nes_fd, void * video_mem) 
    : m_score(0), m_sprite(sprite_fd, video_mem), m_nes(nes_fd), m_snake(m_sprite), m_target()
{
    // Seed random number generator
    srand(time(0));

    // Initialize target to a random position
    m_target.disp_index = 0;
    m_target.enable = 1;
    m_target.mem_slot = 1;
    m_target.height = 16;
    m_target.width = 16;
    m_sprite.ClearSpriteMem(m_target.mem_slot, 0, 0, 31);
    m_sprite.UpdateSpriteAttr(&m_target, SPR_EMWH_ATTR);
    GetNewTarget();

    // Set up background tiles
    m_sprite.EnableTiledBg();
    m_sprite.ClearTileMem(0, 0, 10, 0);
    m_sprite.ClearTileMem(1, 10, 20, 10);
    Tile tile = {0, 0, 1};

    for(int i = 0; i < TILE_ROWS; ++i)
    {
        tile.x_index = 0;
        tile.y_index = i;
        m_sprite.UpdateTileAttr(&tile);
    }

    for(int i = 0; i < TILE_ROWS; ++i)
    {
        tile.x_index = TILE_COLS - 1;
        tile.y_index = i;
        m_sprite.UpdateTileAttr(&tile);
    }

    for(int i = 0; i < TILE_COLS; ++i)
    {
        tile.x_index = i;
        tile.y_index = 0;
        m_sprite.UpdateTileAttr(&tile);
    }

    for(int i = 0; i < TILE_COLS; ++i)
    {
        tile.x_index = i;
        tile.y_index = TILE_ROWS - 1;
        m_sprite.UpdateTileAttr(&tile);
    }
}

/**
 * @brief Runs the game
 */
void Game::Run()
{
    bool running = true;
    const int delay = 15000;

    while(running)
    {
        // Grab input and update snake direction
        for(int i = 0; i < 22; ++i)
        {
            usleep(delay);
            m_nes.Update();

            if(m_nes.Up())
                m_snake.SetDir(Snake::UP);
            else if(m_nes.Down())
                m_snake.SetDir(Snake::DOWN);
            else if(m_nes.Left())
                m_snake.SetDir(Snake::LEFT);
            else if(m_nes.Right())
                m_snake.SetDir(Snake::RIGHT);
            else if(m_nes.Start() && m_nes.Select())
                running = false;
        }
        

        // Move snake to new position
        m_snake.Move();
        m_snake.Render(m_sprite);

        // Check for death collisions
        if(m_snake.IsCollidedWithWall() || m_snake.IsCollidedWithSelf())
            running = false;

        // Check if target is consumed
        if(m_snake.IsCollidedWithTarget(m_target))
        {
            m_score++;
            m_snake.ConsumeTarget();
            GetNewTarget();
        }
    }
    
    // Show a square for each target they consumed
    m_sprite.DisableAllSprites();

    Sprite temp = {0, 1, 0, 16, 16, 0, 0};
    m_sprite.ClearSpriteMem(temp.mem_slot, 0, 0, 31);
    for(int i = 0; i < m_score; ++i)
    {
        temp.disp_index = i;
        temp.x = 48 + (i % 17) * 32;
        temp.y = 48 + (i / 17) * 32;
        m_sprite.UpdateSpriteAttr(&temp, SPR_ALL_ATTR);
    }
}

/**
 * @brief Randomizes the x and y coordinates of the target
 */
void Game::GetNewTarget()
{
    int new_x = 0;
    int new_y = 0;

    do
    {
        new_x = rand() % 36;
        new_y = rand() % 26;

        m_target.x = 32 + (16 * new_x);
        m_target.y = 32 + (16 * new_y);
    } while(m_snake.IsCollidedWithTarget(m_target));

    m_sprite.UpdateSpriteAttr(&m_target, SPR_XY_ATTR);
}