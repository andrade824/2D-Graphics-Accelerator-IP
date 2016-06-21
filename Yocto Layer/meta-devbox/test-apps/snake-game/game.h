#ifndef GAME_H_
#define GAME_H_

#include "sprite_engine.h"
#include "nesctrl.h"
#include "snake.h"

class Game
{
public:
    // Constructor
    Game(int sprite_fd, int nes_fd, void * video_mem);

    // Runs the game
    void Run();

private:
    // Move the target to a new position
    void GetNewTarget();

private:
    int m_score;
    SpriteEngine m_sprite;
    NesController m_nes;
    Snake m_snake;
    Sprite m_target;
};

#endif /* GAME_H_ */