#include "sprite_engine.h"
#include "snake.h"

/**
 * @brief Initializes the snake's position and graphics
 * 
 * @param sprite Reference to the sprite engine to update video memory
 */
Snake::Snake(SpriteEngine & sprite)
    : m_curdir(UP), m_body(), m_target_consumed(false), m_width(16), m_height(16)
{
    // First body part is in the middle of the screen
    Sprite body_part {0, 1, 0, m_width, m_height, 320, 240};

    // Set the color of the snake
    sprite.ClearSpriteMem(body_part.mem_slot, 31, 0, 0);

    // Push the body parts onto the list
    m_body.push_back(body_part);
    body_part.y = 256;
    m_body.push_back(body_part);
    body_part.y = 272;
    m_body.push_back(body_part);
}

/**
 * @brief Set the direction the snake will move
 * 
 * @param direction The new direction
 */
void Snake::SetDir(Dir direction)
{
    // Can't reverse direction
    if(!(direction == UP && m_curdir == DOWN) &&
       !(direction == DOWN && m_curdir == UP) &&
       !(direction == LEFT && m_curdir == RIGHT) &&
       !(direction == RIGHT && m_curdir == LEFT))
    {
        m_curdir = direction;
    }
}

/**
 * @brief Get the snake's current direction
 * 
 * @return The snake's current direction
 */
Snake::Dir Snake::GetDir() const
{
    return m_curdir;
}

/**
 * @brief Move the snake in the current direction
 */
void Snake::Move()
{
    Sprite body_part = m_body.front();

    switch(m_curdir)
    {
        case UP: 
            if(body_part.y > 0) 
                body_part.y -= m_height;

            break;

        case DOWN: 
            if(body_part.y < SCREEN_HEIGHT)
                body_part.y += 16;

            break;

        case LEFT: 
            if(body_part.x > 0)
                body_part.x -= m_width;
            
            break;

        case RIGHT: 
            if(body_part.x < SCREEN_WIDTH)
                body_part.x += 16;
            break;
    }

    m_body.push_front(body_part);

    // If we just consumed a target, then don't delete the last body part
    if(!m_target_consumed)
        m_body.pop_back();
    else
        m_target_consumed = false;
}

void Snake::ConsumeTarget()
{
    m_target_consumed = true;
}

/**
 * @brief Check to see if the snake collided with the wall
 * 
 * @return True if the snake collided, false otherwise
 */
bool Snake::IsCollidedWithWall() const
{
    bool collided = false;
    Sprite front = m_body.front();

    if(front.x < 32 || front.x > (SCREEN_WIDTH - 32) ||
       front.y < 32 || front.y > (SCREEN_HEIGHT - 32))
    {
        collided = true;
    }

    return collided;
}

/**
 * @brief Check to see if the snake collided with the target
 * 
 * @return True if the snake collided, false otherwise
 */
bool Snake::IsCollidedWithTarget(const Sprite & target) const
{
    return (target.x == m_body.front().x) && (target.y == m_body.front().y);
}

/**
 * @brief Check to see if the snake collided with itself
 * 
 * @return True if the snake collided, false otherwise
 */
bool Snake::IsCollidedWithSelf() const
{
    bool collided = false;

    // Can't collide with itself if there's only one body part
    if(m_body.size() > 1)
    {
        for(auto it = ++m_body.begin(); it != m_body.end() && !collided; ++it)
        {
            if((it->x == m_body.front().x) && (it->y == m_body.front().y))
                collided = true;
        }
    }

    return collided;
}

/**
 * @brief Render the snake
 * 
 * @param sprite The sprite engine object to update attributes with
 */
void Snake::Render(SpriteEngine & sprite)
{
    int i = 1;
    for(auto it = m_body.begin(); it != m_body.end(); ++it, ++i)
    {
        Sprite temp = *it;
        sprite.UpdateSpriteAttr(i, &temp, SPR_ALL_ATTR);
    }
}