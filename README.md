# 2D Graphics Accelerator IP

This project is being used as my senior capstone project at the Oregon Institute of Technology.

This hardware/software package is meant to emulate the type of graphical system found in early video
game consoles and to provide users with a base to develop their own video games and arcade hardware.
This design is meant to be utilized within modern programmable SoC systems (currently being tested on a
Zynq-7000 SoC development board). The custom IP component contains modules for both
creating/modifying framebuffers, as well as a display controller that outputs the framebuffer onto a standard
VGA monitor. The Linux software consists of both a custom graphics driver and a user-space library to ease
development of applications that utilize the accelerator.

Features:
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
