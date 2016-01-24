# 2D Graphics Accelerator IP

This project is being used as my senior capstone project at the Oregon Institute of Technology.

This hardware/software package is meant to emulate the type of graphical system found in early video
game consoles and to provide users with a base to develop their own video games and arcade hardware.
This design is meant to be utilized within modern programmable SoC systems (currently being tested on a
Zynq-7000 SoC development board). The custom IP component contains modules for both
creating/modifying framebuffers, as well as a display controller that outputs the framebuffer onto a standard
VGA monitor. The Linux software consists of both a custom graphics driver and a user-space library to ease
development of applications that utilize the accelerator.

## Features
<ul>
<li>Display controller reads framebuffer from DDR3 memory and outputs to a VGA monitor</li>
<li>Frame creation consists of a sprite engine (similar to Super Nintendo and Gameboy Advance)
<ul>
<li>640x480 resolution at 16-bit color</li>
<li>32 sprites per three sprite layers (96 sprites total)</li>
<li>Separate background layer can either consist of 32x32 pixel tiles or a single static image</li>
</ul>
</li>
<li>Includes custom bitmap DMA (for copying/pasting rectangles within an image)</li>
<li>Custom-built Embedded Linux distribution (using the Buildroot automated build system)
<ul>
<li>Linux graphics driver provides user-space with a simple character file that can be used to
access graphics memory and send commands to the hardware</li>
<li>User-space library abstracts interacting with the driver and provides a simple API for
displaying custom graphics</li>
</ul></li></ul>

## Hardware Components
<b>Display Controller:</b> Contains hardware that will display an image from DDR3 memory onto a standard VGA monitor. This consists of both a simple read-only DMA module and a VGA controller. The read-only DMA takes in the address at which the image to display is being located and will repeatedly grab pixels from memory until it receives the end_of_frame signal telling it to restart from the top again. The data is passed into a dual-clock FIFO to pass between the 100MHz system clock, and the 25MHz pixel clock used by the VGA controller. The VGA controller reads from the FIFO and outputs the pixels to the screen.

<b>Frame Creation Module:</b> This is the hardware that manages the individual sprites and background tiles. The attributes (width, height, x position, y position, enabled/disabled, etc.) for each sprite and background tile are stored within true dual port block RAMs on the device. A separate sprite controller and background controller, when prompted by the engine controller, will start looping through and reading each of the spite/background attributes from block RAM. It will then pass these attributes to a custom-built DMA to load each sprite/background tile into a framebuffer.

There are two buffers (double-buffered): one that gets written to (by the frame creation module) and one that gets read from (by the display controller). Every other frame, the engine controller will swap the two buffers. This ensures that partial images don't get displayed and that screen tearing should be kept to a minimum.

<b>Engine Controller:</b> This module is the liaison between the software and the rest of the hardware system. Commands are issued from software to this module to update attributes and image data. This module also handles swapping between the two framebuffers and triggering the frame creation hardware to update the background and then the sprites (in that order).

## Software Components
<b>Linux Kernel Driver:</b> This driver is responsible for taking requests from user-space (most likely a game application) and issuing commands to the Engine Controller to update the graphics on the screen. It also claims a section of memory to be used strictly as graphics memory. This driver will expose a character file to user-space that can be used for both modifying graphics memory and taking commands to pass to the engine controller (like updating sprite attributes).

The graphics memory can be broken into five sections:
<ol>
  <li>Sprite memory</li>
  <li>Background tile memory (used when background is in "tiled" mode)</li>
  <li>Background framebuffer memory (used when background is a single image)</li>
  <li>Framebuffer 1 (not exposed to user-space, used by the hardware)</li>
  <li>Framebuffer 2 (not exposed to user-space, used by the hardware)</li>
</ol>

The first three sections of graphics memory can be mmap-ed by user-space using the exposed character file. After an application has mmap-ed the character file, it can update any of the sections of memory with its own custom image data. The application can also send Ioctl commands to tell the driver that the application wants to update some of the sprite/background attributes. The driver will then take in these ioctl commands and translate them into commands that are sent to the memory-mapped engine controller module.

Building a complementary framebuffer driver has also been considered, but at this point, it would be a secondary priority.

<b>Linux User-space Library:</b> This C library handles the low-level details of modifying graphics memory and telling the driver what commands to send. In its place, it exposes a simple programming API meant to ease game development. For instance, instead of manually sending ioctls and mmap-ing graphics memory, the user application should be able to call an "update_sprite" function that performs those tasks under the hood.
