#include <stdio.h>
#include <unistd.h>
#include "nesctrl.h" 

/**
 * @brief Constructor
 * 
 * @param nes_fd File descriptor for the nes controller's character file
 */
NesController::NesController(int nes_fd) : m_nes_fd(nes_fd), m_btns(0)
{ }

/**
 * @brief Update the current state of the buttons (re-read from hardware)
 */
void NesController::Update()
{
    int ret = 0;

    ret = read(m_nes_fd, (void*)&m_btns, sizeof(m_btns));

    // Buttons are active-low, invert so 1 = pressed, 0 = not pressed
    m_btns = ~m_btns;

    if (ret < 0)
        perror("Failed to read controller state");
}

/**
 * @brief Return true if the button is being pressed down
 */
bool NesController::A() const
{
    return (m_btns & 0x80);
}

bool NesController::B() const
{
    return (m_btns & 0x40);
}

bool NesController::Up() const
{
    return (m_btns & 0x08);
}

bool NesController::Down() const
{
    return (m_btns & 0x04);
}

bool NesController::Left() const
{
    return (m_btns & 0x02);
}

bool NesController::Right() const
{
    return (m_btns & 0x01);
}

bool NesController::Start() const
{
    return (m_btns & 0x10);
}

bool NesController::Select() const
{
    return (m_btns & 0x20);
}