 # Yocto Layer

 This yocto layer contains drivers for both the graphics hardware and NES controller, as well as example Linux applications demonstrating them.Pattern

## Folder Structure
<b>conf</b>: Contains the device tree source for this IP to work correctly on the Zybo development kit. Also contains the devbox.conf and layer.conf files that define the layer and machine (and how this layer "overlays" the meta-xilinx layer's Zybo machine).

<b>recipes-bsp</b>: Platform initialization files that aren't used in this layer but are required by meta-xilinx to compile correctly.

<b>recipes-kernel</b>: Includes drivers for both the graphics hardware and NES controller, as well as kernel configuration fragments to enable both of those drivers (it also enables Contiguous Memory Allocation, which is a feature required by the graphics driver).

<b>test-apps</b>: Houses the C++ libraries used to make development of games and appliactions easier as well as a few demo applications and a full version of the classic snake game.

## Building

Follow standard Yocto installation instructions to get a basic Poky build up and running. The Yocto Quick Start guide is a great place to start: <a href="http://www.yoctoproject.org/docs/2.0/yocto-project-qs/yocto-project-qs.html">http://www.yoctoproject.org/docs/2.0/yocto-project-qs/yocto-project-qs.html</a>.

Once your standard Poky build is working correctly clone the meta-xilinx layer into your installation (this can be found on github at <a href="https://github.com/Xilinx/meta-xilinx">https://github.com/Xilinx/meta-xilinx</a>).

Then download and install the meta-devbox layer found in this repository.

Lastly, consult the Build Configuration Files folder to determine how your bblayers.conf and local.conf files should be organized (the local.conf includes extra packages that are needed to run the example applications located in meta-devbox).

Once all of that is finished, you should be able to perform a "bitbake core-image-minimal" and have the kernel image, device tree binary, u-boot executable, and root filesystem dumped into the output directory (<build directory>/tmp/deploy/images/devbox/).