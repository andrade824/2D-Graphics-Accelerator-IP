#ifndef SNAKE_H_
#define SNAKE_H_

#include <stdint.h>
#include <list>
#include "sprite_engine.h"

using std::list;

class Snake
{
public:
    // Direction used when moving the snake
    enum Dir {UP, DOWN, LEFT, RIGHT};

    // Constructor
    Snake(SpriteEngine & sprite);

    // Set the direction the snake will move
    void SetDir(Dir direction);

    // Get the current direction
    Dir GetDir() const;

    // Move the snake
    void Move();

    // Add an additional body part to the snake
    void ConsumeTarget();

    // Collision detection
    bool IsCollidedWithWall() const;
    bool IsCollidedWithTarget(const Sprite & target) const;
    bool IsCollidedWithSelf() const;

    // Render the snake
    void Render(SpriteEngine & sprite);

private:
    Dir m_curdir;   // Current direction
    list<Sprite> m_body;    // Snake body parts
    bool m_target_consumed; // True if a target was just consumed

    // Constants
    const uint8_t m_width;
    const uint8_t m_height;
};

#endif /* SNAKE_H_ */