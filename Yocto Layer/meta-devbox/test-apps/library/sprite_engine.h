#ifndef SPRITE_ENGINE_H_
#define SPRITE_ENGINE_H_

#include <stdint.h>

// Screen Resolution
#define SCREEN_WIDTH 640
#define SCREEN_HEIGHT 480

// Offsets within the video memory (in bytes)
#define BG_BUFFER_OFFSET 0x0
#define TILE_BUFFER_OFFSET 0x96000
#define SPR_BUFFER_OFFSET 0x196000

// Amount of memory userspace can see (up until the first framebuffer)
#define VIDEO_MEM_USER_SIZE 0x216000

#define SPR_WIDTH 32
#define SPR_HEIGHT 32
#define MAX_SPRITES 256
#define SPRITE_ADDR(base,num) ((base) + ((num) * SPR_WIDTH * SPR_HEIGHT))

#define TILE_WIDTH 32
#define TILE_HEIGHT 32
#define TILE_ROWS 15
#define TILE_COLS 20
#define MAX_TILES 512
#define TILE_ADDR(base,num) ((base) + ((num) * TILE_WIDTH * TILE_HEIGHT))

// Convert separate color values into one word (16-bits) of data
//#define pixel_to_int(red,green,blue) (((blue) & 0x1F) | (((green) & 0x3F) << 5) | (((red) & 0x1F) << 11))
inline uint16_t pixel_to_int(uint8_t red, uint8_t green, uint8_t blue)
{
    return ((blue & 0x1F) | ((green & 0x3F) << 5) | ((red & 0x1F) << 11));
}

struct Sprite {
    uint8_t disp_index;
    uint8_t enable;
    uint8_t mem_slot;
    uint8_t width;
    uint8_t height;
    uint16_t x;
    uint16_t y;
};

struct Tile {
    uint8_t x_index;
    uint8_t y_index;
    uint16_t mem_slot;
};

enum SpriteAttribute { 
    SPR_X_ATTR, 
    SPR_Y_ATTR,
    SPR_ENABLE_ATTR,
    SPR_MEM_ATTR, 
    SPR_WIDTH_ATTR, 
    SPR_HEIGHT_ATTR, 
    SPR_XY_ATTR, 
    SPR_EMWH_ATTR,
    SPR_ALL_ATTR
};

class SpriteEngine
{
public:
    // Constructor
    SpriteEngine(int sprite_fd, void * video_mem);

    // Enable/Disable video output
    void Enable();
    void Disable();

    // Switch between the two background modes
    void EnableBufferedBg();
    void EnableTiledBg();

    // Update one or more sprite attributes in hardware
    void UpdateSpriteAttr(Sprite * spr, SpriteAttribute attr);
    void UpdateSpriteAttr(uint8_t index, Sprite * spr, SpriteAttribute attr);

    // Update tile attribute in hardware
    void UpdateTileAttr(Tile * tile);

    // Sets all video memory to zero (black) and disables every sprite
    void ClearAll();

    // Disable every sprite on the screen
    void DisableAllSprites();

    // Set a sprite's video memory to a specified color
    void ClearSpriteMem(uint8_t slot, uint16_t color);
    void ClearSpriteMem(uint8_t slot, uint8_t red, uint8_t green, uint8_t blue);

    // Set a tile's video memory to a specified color
    void ClearTileMem(uint16_t slot, uint16_t color);
    void ClearTileMem(uint16_t slot, uint8_t red, uint8_t green, uint8_t blue);

    // Draw Rectangle in bg buffer
    void DrawRectangleBg(uint16_t x1, uint16_t y1, uint16_t x2, uint16_t y2, uint16_t color);
    void DrawRectangleBg(uint16_t x1, uint16_t y1, uint16_t x2, uint16_t y2, uint8_t red, uint8_t green, uint8_t blue);

    // Set pixels in buffers
    void SetPixelBg(uint16_t x, uint16_t y, uint16_t color);
    void SetPixelBg(uint16_t x, uint16_t y, uint8_t red, uint8_t green, uint8_t blue);
    
    void SetPixelTile(uint16_t slot, uint8_t x, uint8_t y, uint16_t color);
    void SetPixelTile(uint16_t slot, uint8_t x, uint8_t y, uint8_t red, uint8_t green, uint8_t blue);

    void SetPixelSprite(uint8_t slot, uint8_t x, uint8_t y, uint16_t color);
    void SetPixelSprite(uint8_t slot, uint8_t x, uint8_t y, uint8_t red, uint8_t green, uint8_t blue);

    // Destructor
    ~SpriteEngine();

private:
    int m_sprite_fd;    // File descriptor of sprite character file
    uint16_t * m_bg_buffer;
    uint16_t * m_tile_buffer;
    uint16_t * m_spr_buffer;
};

#endif /* SPRITE_ENGINE_H_ */
 