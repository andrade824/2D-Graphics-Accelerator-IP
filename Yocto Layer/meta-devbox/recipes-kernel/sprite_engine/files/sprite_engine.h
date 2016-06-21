#ifndef SPRITE_ENGINE_H_
#define SPRITE_ENGINE_H_

#include <linux/types.h>
#include <linux/ioctl.h>

// Screen Resolution
#define WIDTH 640
#define HEIGHT 480

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
#define TILE_ADDR(base,x,y) ((base) + (((y) * TILE_COLS + (x)) * TILE_WIDTH * TILE_HEIGHT))

// Convert separate color values into one word (16-bits) of data
#define pixel_to_int(red,green,blue) (((blue) & 0x1F) | (((green) & 0x3F) << 5) | (((red) & 0x1F) << 11))

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

// Ioctl Commands
#define SPRITE_XY_ATTR      _IOW('d', 1, struct Sprite *)
#define SPRITE_EMWH_ATTR    _IOW('d', 2, struct Sprite *)
#define SPRITE_X_ATTR       _IOW('d', 3, struct Sprite *)
#define SPRITE_Y_ATTR       _IOW('d', 4, struct Sprite *)
#define SPRITE_MEM_ATTR     _IOW('d', 5, struct Sprite *)
#define SPRITE_WIDTH_ATTR   _IOW('d', 6, struct Sprite *)
#define SPRITE_HEIGHT_ATTR  _IOW('d', 7, struct Sprite *)
#define SPRITE_ENABLE_ATTR  _IOW('d', 8, struct Sprite *)

#define SPRITE_TILE_ATTR    _IOW('d', 9, struct Tile *)

#define SPRITE_BG_MODE      _IOW('d', 10, int)
#define SPRITE_ENABLE       _IOW('d', 11, int)

#endif /* SPRITE_ENGINE_H_ */
