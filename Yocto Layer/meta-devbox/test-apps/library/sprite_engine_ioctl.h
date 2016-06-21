#ifndef SPRITE_ENGINE_IOCTL_H_
#define SPRITE_ENGINE_IOCTL_H_ 

#include "sprite_engine.h"

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

#endif /* SPRITE_ENGINE_IOCTL_H_ */
 