#include <stdint.h>
#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>
#include <error.h>
#include <sys/mman.h>
#include <sys/ioctl.h>
#include <string.h>

#include "sprite_engine.h"
#include "sprite_engine_ioctl.h"

/**
 * @brief Constructor
 * 
 * @details You need to have already opened up the character file and memory 
 *          mapped the video memory successfully.
 * 
 * @param sprite_fd The file descriptor for the sprite character file
 * @param video_mem Pointer returned back from mmap()
 */
SpriteEngine::SpriteEngine(int sprite_fd, void * video_mem) :
    m_sprite_fd(sprite_fd), m_bg_buffer(nullptr), m_tile_buffer(nullptr), m_spr_buffer(nullptr)
{
    // Set pointers to video memory
    m_bg_buffer = (uint16_t*)((uint8_t*)video_mem + BG_BUFFER_OFFSET);
    m_tile_buffer = (uint16_t*)((uint8_t*)video_mem + TILE_BUFFER_OFFSET);
    m_spr_buffer = (uint16_t*)((uint8_t*)video_mem + SPR_BUFFER_OFFSET);

    // Clear out video memory and disable all sprites
    ClearAll();
    Enable();
}

/**
 * @brief Enables video output
 */
void SpriteEngine::Enable()
{
    ioctl(m_sprite_fd, SPRITE_ENABLE, 1);
}

/**
 * @brief Disables video output
 */
void SpriteEngine::Disable()
{
    ioctl(m_sprite_fd, SPRITE_ENABLE, 0);
}

/**
 * @brief Switches to using a buffered background image
 */
void SpriteEngine::EnableBufferedBg()
{
    ioctl(m_sprite_fd, SPRITE_BG_MODE, 0);
}

/**
 * @brief Switches to using a tiled background image
 */
void SpriteEngine::EnableTiledBg()
{
    ioctl(m_sprite_fd, SPRITE_BG_MODE, 1);
}

/**
 * @brief Updates the specified sprite attribute in hardware
 * 
 * @param spr The sprite object that contains the updated attributes
 * @param attr The attribute that will get updated within hardware
 */
void SpriteEngine::UpdateSpriteAttr(Sprite * spr, SpriteAttribute attr)
{
    switch(attr)
    {
        case SPR_X_ATTR: ioctl(m_sprite_fd, SPRITE_X_ATTR, spr); break;

        case SPR_Y_ATTR: ioctl(m_sprite_fd, SPRITE_Y_ATTR, spr); break;

        case SPR_ENABLE_ATTR: ioctl(m_sprite_fd, SPRITE_ENABLE_ATTR, spr); break;

        case SPR_MEM_ATTR: ioctl(m_sprite_fd, SPRITE_MEM_ATTR, spr); break;

        case SPR_WIDTH_ATTR: ioctl(m_sprite_fd, SPRITE_WIDTH_ATTR, spr); break;

        case SPR_HEIGHT_ATTR: ioctl(m_sprite_fd, SPRITE_HEIGHT_ATTR, spr); break;

        case SPR_XY_ATTR: ioctl(m_sprite_fd, SPRITE_XY_ATTR, spr); break;

        case SPR_EMWH_ATTR: ioctl(m_sprite_fd, SPRITE_EMWH_ATTR, spr); break;

        case SPR_ALL_ATTR:
            ioctl(m_sprite_fd, SPRITE_XY_ATTR, spr);
            ioctl(m_sprite_fd, SPRITE_EMWH_ATTR, spr);
            break;
    }
}

/**
 * @brief Same as the other UpdateSpriteAttr function except it ignores the
 *        index field in the Sprite Object and uses the passed in one
 * 
 * @param index The display index of the sprite to modify
 * @param spr The sprite object that contains the updated attributes
 * @param attr The attribute that will get updated within hardware
 */
void SpriteEngine::UpdateSpriteAttr(uint8_t index, Sprite * spr, SpriteAttribute attr)
{
    Sprite temp = *spr;
    temp.disp_index = index;

    UpdateSpriteAttr(&temp, attr);
}

/**
 * @brief Updates the specified tile attribute in hardware
 * 
 * @param tile The tile object that contains the updated attributes
 */
void SpriteEngine::UpdateTileAttr(Tile * tile)
{
    ioctl(m_sprite_fd, SPRITE_TILE_ATTR, tile);
}

/**
 * @brief Clears out all video memory (to black) and disables every sprite. All
 *        tiles are reset to using mem slot 0.
 */
void SpriteEngine::ClearAll()
{
    Sprite spr;
    Tile tile;
    spr.enable = 0;
    tile.mem_slot = 0;

    // Clear out video memory to black
    memset((void*)m_bg_buffer, 0, VIDEO_MEM_USER_SIZE);

    // Disable all of the sprites
    for(int i = 0; i < MAX_SPRITES; ++i)
    {
        spr.disp_index = i;
        ioctl(m_sprite_fd, SPRITE_ENABLE_ATTR, &spr);
    }

    // Set every tile to use mem slot 0
    for(int i = 0; i < TILE_ROWS; ++i)
    {
        for(int j = 0; j < TILE_COLS; ++j)
        {
            tile.x_index = j;
            tile.y_index = i;
            UpdateTileAttr(&tile);
        }
    }
}

/**
 * @brief Disable every sprite on the screen
 */
void SpriteEngine::DisableAllSprites()
{
    Sprite spr;
    spr.enable = 0;

    // Disable all of the sprites
    for(int i = 0; i < MAX_SPRITES; ++i)
    {
        spr.disp_index = i;
        ioctl(m_sprite_fd, SPRITE_ENABLE_ATTR, &spr);
    }
}

/**
 * @brief Clears out the specified sprite to a specific color
 * 
 * @param slot Memory slot of the sprite to clear out
 * @param color The color to set the sprite to
 */
void SpriteEngine::ClearSpriteMem(uint8_t slot, uint16_t color)
{
    uint16_t * spr_addr = SPRITE_ADDR(m_spr_buffer, slot);

    for(int i = 0; i < (SPR_WIDTH * SPR_HEIGHT); ++i)
        *(spr_addr + i) = color;
}

/**
 * @brief Wrapper for ClearSpriteMem() that has separate color parameters
 */
void SpriteEngine::ClearSpriteMem(uint8_t slot, uint8_t red, uint8_t green, uint8_t blue)
{
    ClearSpriteMem(slot, pixel_to_int(red, green, blue));
}

/**
 * @brief Clears out the specified tile to a specific color
 * 
 * @param slot Memory slot of the tile to clear out
 * @param color The color to set the tile to
 */
void SpriteEngine::ClearTileMem(uint16_t slot, uint16_t color)
{
    // Ensure only valid tiles are being modified
    if(slot < MAX_TILES)
    {
        uint16_t * tile_addr = TILE_ADDR(m_tile_buffer, slot);

        for(int i = 0; i < (TILE_WIDTH * TILE_HEIGHT); ++i)
            *(tile_addr + i) = color;
    }
}

/**
 * @brief Wrapper for ClearTileMem() that has separate color parameters
 */
void SpriteEngine::ClearTileMem(uint16_t slot, uint8_t red, uint8_t green, uint8_t blue)
{
    ClearTileMem(slot, pixel_to_int(red, green, blue));
}

/**
 * @brief Draw a rectangle into the buffered background
 * 
 * @param x1 Top-left corner x-position
 * @param y1 Top-left corner y-position
 * @param x2 Bottom-right corner x-position
 * @param y2 Bottom-right corner y-position
 * color The color to set the rectangle to
 */
void SpriteEngine::DrawRectangleBg(uint16_t x1, uint16_t y1, uint16_t x2, uint16_t y2, uint16_t color)
{
    // Perform bounds checking
    if(x1 < x2 && y1 < y2 && x2 < SCREEN_WIDTH && y2 < SCREEN_HEIGHT)
    {
        for(int i = y1; i <= y2; ++i)
        {
            for(int j = x1; j <= x2; ++j)
                *(m_bg_buffer + (i * SCREEN_WIDTH) + j) = color;
        }
    }
}

/**
 * @brief Wrapper for DrawRectangleBg() that has separate color parameters
 */
void SpriteEngine::DrawRectangleBg(uint16_t x1, uint16_t y1, uint16_t x2, uint16_t y2, uint8_t red, uint8_t green, uint8_t blue)
{
    DrawRectangleBg(x1, y1, x2, y2, pixel_to_int(red, green, blue));
}

/**
 * @brief Sets a single pixel within the buffered background image
 * 
 * @param x X-coordinate of pixel to change
 * @param y Y-coordinate of pixel to change
 * @param color The color to set the pixel to
 */
void SpriteEngine::SetPixelBg(uint16_t x, uint16_t y, uint16_t color)
{
    if(x < SCREEN_WIDTH && y < SCREEN_HEIGHT)
        *(m_bg_buffer + (y * SCREEN_WIDTH) + x) = color;
}

/**
 * @brief Wrapper for SetPixelBg() that has separate color parameters
 */
void SpriteEngine::SetPixelBg(uint16_t x, uint16_t y, uint8_t red, uint8_t green, uint8_t blue)
{
    SetPixelBg(x, y, pixel_to_int(red, green, blue));
}

/**
 * @brief Sets a single pixel within the specified tile
 * 
 * @param slot_x X-coordinate of tile on the screen to modify
 * @param slot_y Y-coordinate of tile on the screen to modify
 * @param x X-coordinate of pixel within the tile to modify
 * @param y Y-coordinate of pixel within the tile to modify
 * @param color The color to set the pixel to
 */
void SpriteEngine::SetPixelTile(uint16_t slot, uint8_t x, uint8_t y, uint16_t color)
{
    // Ensure only valid tiles/pixels are being modified
    if(x < TILE_WIDTH && y < TILE_HEIGHT && slot < MAX_TILES)
    {
        uint16_t * tile_addr = TILE_ADDR(m_tile_buffer, slot);

        *tile_addr = color;
    }
}

/**
 * @brief Wrapper for SetPixelTile() that has separate color parameters
 */
void SpriteEngine::SetPixelTile(uint16_t slot, uint8_t x, uint8_t y, uint8_t red, uint8_t green, uint8_t blue)
{
    SetPixelTile(slot, x, y, pixel_to_int(red, green, blue));
}

/**
 * @brief Sets a single pixel within the specified sprite
 * 
 * @param slot Memory slot of sprite to modify
 * @param x X-coordinate of pixel within the sprite to modify
 * @param y Y-coordinate of pixel within the sprite to modify
 * @param color The color to set the pixel to
 */
void SpriteEngine::SetPixelSprite(uint8_t slot, uint8_t x, uint8_t y, uint16_t color)
{
    // Ensure only valid pixels are being modified
    if(x < SPR_WIDTH && y < SPR_HEIGHT && slot < MAX_SPRITES)
    {
        uint16_t * spr_addr = SPRITE_ADDR(m_spr_buffer, slot);

        *spr_addr = color;
    }
}

/**
 * @brief Wrapper for SetPixelSprite() that has separate color parameters
 */
void SpriteEngine::SetPixelSprite(uint8_t slot, uint8_t x, uint8_t y, uint8_t red, uint8_t green, uint8_t blue)
{
    SetPixelSprite(slot, x, y, pixel_to_int(red, green, blue));
}

/**
 * @brief Destructor
 */
SpriteEngine::~SpriteEngine()
{
    // Do nothing
}