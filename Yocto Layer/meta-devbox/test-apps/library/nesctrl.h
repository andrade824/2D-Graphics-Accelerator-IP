#ifndef NESCTRL_H_
#define NESCTRL_H_

#include <stdint.h>

class NesController
{
public:
    // Constructor
    NesController(int nes_fd);

    // Update the button state (read from character file)
    void Update();

    // Returns true if the button is being pressed down
    bool A() const;
    bool B() const;
    bool Up() const;
    bool Down() const;
    bool Left() const;
    bool Right() const;
    bool Start() const;
    bool Select() const;

private:
    int m_nes_fd;
    uint8_t m_btns;
};

#endif /* NESCTRL_H_ */
 