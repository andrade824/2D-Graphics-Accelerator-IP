#include <linux/module.h>
#include <linux/platform_device.h>
#include <linux/io.h>
#include <linux/miscdevice.h>
#include <linux/dma-mapping.h>
#include <linux/fs.h>
#include <linux/types.h>
#include <linux/uaccess.h>
#include <sprite_engine.h>

/* Total amount of video memory that needs to be allocated */
#define VIDEO_MEM_TOTAL_SIZE 0x342000

/* Framebuffer offsets within video memory (user-space doesn't have access to these) */
#define BUFFER1_OFFSET 0x216000
#define BUFFER2_OFFSET 0x2AC000

/* Register numbers */
#define REG_CONTROL 0
#define REG_BUFFER1_ADDR 1
#define REG_BUFFER2_ADDR 2
#define REG_BG_BUFFER_ADDR 3
#define REG_TILE_ADDR 4
#define REG_SPRITE_ADDR 5
#define REG_BG_MODE 6

/* 
* Helper macros for writing sprite/tile attributes.
*
* Address Decoding works as follows:
* 
* Register Read/Write (0x0-0x1C):
* 00 000000000 xxx 00
*     xxx = Register Number
* 
* Background Attribute Write (0x8000-0xBFE0):
* 10 yyyyxxxxx 00000
*     xxxxx = Tile x-index
*     yyyy = Tile y-index
* 
* Sprite Single Attribute Write (0x4000-0x5FFC):
* 01 0xxxxxxxx yyy 00
*     xxxxxxxx = Sprite Index
*     yyy = Attribute to modify
* 
*   Attributes are decoded as follows for sprite single attribute writes:
*       000: x-coordinate
*       001: y-coordinate
*       010: memory slot
*       011: width
*       100: height
*       101: control bits (enable/disable)
* 
* Sprite Combo Attribute Write (0x4000-0x5FFC):
* 01 1xxxxxxxx 00y 00
*     xxxxxxxx = Sprite Index
*     y = X/Y or Enable/MemSlot/Width/Height write
*/
#define SPR_SINGLE_X(dev,index,x) write_sprite_attr(dev, (1 << 14) | (((index) & 0xFF) << 5), ((x) & 0xFFFF))
#define SPR_SINGLE_Y(dev,index,y) write_sprite_attr(dev, (1 << 14) | (((index) & 0xFF) << 5) | (1 << 2), ((y) & 0xFFFF))
#define SPR_SINGLE_MEM(dev,index,mem) write_sprite_attr(dev, (1 << 14) | (((index) & 0xFF) << 5) | (2 << 2), ((mem) & 0xFF))
#define SPR_SINGLE_WIDTH(dev,index,width) write_sprite_attr(dev, (1 << 14) | (((index) & 0xFF) << 5) | (3 << 2), ((width) & 0xFF))
#define SPR_SINGLE_HEIGHT(dev,index,height) write_sprite_attr(dev, (1 << 14) | (((index) & 0xFF) << 5) | (4 << 2), ((height) & 0xFF))
#define SPR_SINGLE_ENABLE(dev,index,enable) write_sprite_attr(dev, (1 << 14) | (((index) & 0xFF) << 5) | (5 << 2), ((enable) & 0x1))
#define SPR_COMBO_XY(dev,index,x,y) write_sprite_attr(dev, (3 << 13) | (((index) & 0xFF) << 5), ((x) & 0xFFFF) | (((y) & 0xFFFF) << 16))
#define SPR_COMBO_EMWH(dev,index,en,mem,w,h) write_sprite_attr(dev, (3 << 13) | (((index) & 0xFF) << 5) | (1 << 2), ((mem) & 0xFF) | (((w) & 0xFF) << 8) | (((h) & 0xFF) << 16) | (((en) & 0x1) << 24))
#define SPR_WRITE_TILE(dev,x,y,mem) write_sprite_attr(dev, (1 << 15) | (((x) & 0x1F) << 5) | (((y) & 0xF) << 10), mem)

/* An instance of this structure will be created for every Sprite Engine IP in the system */
struct sprite_engine_dev {
    struct platform_device *pdev;
    struct miscdevice miscdev;
    void __iomem *regs;
    void *cpu_handle;          /* Virtual video memory address */
    dma_addr_t dma_handle;     /* Physical video memory address */
};

/* Function Prototypes */
static void write_sprite_reg(struct sprite_engine_dev *dev, u8 reg, u32 val);
static void write_sprite_attr(struct sprite_engine_dev *dev, u32 offset, u32 val);
static void fill_background_solid(u16 *addr, u16 color);
static int sprite_engine_probe(struct platform_device *pdev);
static int sprite_engine_remove(struct platform_device *pdev);
static int sprite_engine_open(struct inode * inode, struct file * file);
static int sprite_engine_mmap(struct file *file, struct vm_area_struct *vma);
static long sprite_engine_ioctl(struct file *file, unsigned int cmd, unsigned long arg);

/* Specify which device tree devices this driver supports */
static struct of_device_id sprite_engine_dt_ids[] = {
    {
        .compatible = "dsa,sprite_engine"
    },
    { /* end of table */ }
};

/* Inform the kernel about the devices this driver supports */
MODULE_DEVICE_TABLE(of, sprite_engine_dt_ids);

/* Data structure that links the probe and remove functions with this driver */
static struct platform_driver sprite_engine_platform = {
    .probe = sprite_engine_probe,
    .remove = sprite_engine_remove,
    .driver = {
        .name = "Sprite Engine Driver",
        .owner = THIS_MODULE,
        .of_match_table = sprite_engine_dt_ids
    }
};

/* The file operations that can be performed on the "sprite" character file*/
static const struct file_operations sprite_engine_fops = {
    .owner = THIS_MODULE,
    .open = sprite_engine_open,
    .mmap = sprite_engine_mmap,
    .unlocked_ioctl = sprite_engine_ioctl
};

/*
* Called when the driver is installed
*/
static int sprite_engine_init(void)
{
    int ret_val = 0;

    // Register our driver with the "Platform Driver" bus
    ret_val = platform_driver_register(&sprite_engine_platform);
    if(ret_val != 0) {
        pr_err("sprite_engine: platform_driver_register returned %d\n", ret_val);
        return ret_val;
    }

    return 0;
}

/*
* Called when the kernel finds a new device that this driver can handle
*/
static int sprite_engine_probe(struct platform_device *pdev)
{
    int ret_val = -EBUSY;
    struct sprite_engine_dev *dev;
    struct resource *r = 0;

    r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
    if(r == NULL) {
        pr_err("sprite_engine: IORESOURCE_MEM (register space) does not exist\n");
        goto bad_exit_return;
    }

    /* Create structure to hold device-specific information (like the registers) */
    dev = devm_kzalloc(&pdev->dev, sizeof(struct sprite_engine_dev), GFP_KERNEL);
    dev->pdev = pdev;

    dev->regs = devm_ioremap_resource(&pdev->dev, r);
    if(IS_ERR(dev->regs))
        goto bad_ioremap;

    /* Allocate video memory */
    dev->cpu_handle = dmam_alloc_coherent(&pdev->dev, VIDEO_MEM_TOTAL_SIZE,
                                           &dev->dma_handle, GFP_KERNEL);

    if(dev->cpu_handle == NULL) {
        pr_err("sprite_engine: Failed to allocate video memory\n");
        ret_val = -ENOMEM;
        goto bad_exit_return;
    }

    /* Set Sprite Engine buffer addresses (so the DMA knows where to transfer to/from) */
    write_sprite_reg(dev, REG_BUFFER1_ADDR, (u32)(dev->dma_handle + BUFFER1_OFFSET));
    write_sprite_reg(dev, REG_BUFFER2_ADDR, (u32)(dev->dma_handle + BUFFER2_OFFSET));
    write_sprite_reg(dev, REG_BG_BUFFER_ADDR, (u32)(dev->dma_handle + BG_BUFFER_OFFSET));
    write_sprite_reg(dev, REG_TILE_ADDR, (u32)(dev->dma_handle + TILE_BUFFER_OFFSET));
    write_sprite_reg(dev, REG_SPRITE_ADDR, (u32)(dev->dma_handle + SPR_BUFFER_OFFSET));

    /* Default to "buffered background" mode */
    write_sprite_reg(dev, REG_BG_MODE, 0);

    /* Initialize the misc device (this is used to create a character file in userspace) */
    dev->miscdev.minor = MISC_DYNAMIC_MINOR;
    dev->miscdev.name = "sprite";
    dev->miscdev.fops = &sprite_engine_fops;

    ret_val = misc_register(&dev->miscdev);
    if(ret_val != 0) {
        pr_info("sprite_engine: Couldn't register misc device :(\n");
        goto bad_exit_return;
    }

    /* Set the background image to solid red by default */
    fill_background_solid((u16*)(dev->cpu_handle + BG_BUFFER_OFFSET), pixel_to_int(31,0,0));

    /* Enable the sprite engine output */
    write_sprite_reg(dev, REG_CONTROL, 1);

    /* 
    * Give a pointer to the instance-specific data to the generic platform_device structure
    * so we can access this data later on (for instance, in the remove function)
    */
    platform_set_drvdata(pdev, (void*)dev);

    pr_info("sprite_engine: Successfully initialized\n");

    return 0;

bad_ioremap:
   ret_val = PTR_ERR(dev->regs); 
bad_exit_return:
    pr_info("sprite_engine: bad probe exit :(\n");
    return ret_val;
}

/*
* Only reason this function is even here is so on kernels v4.0 and earlier,
* the file->private_data field is set correctly to the miscdevice structure.
* On these kernels, it will only get set properly when an "open" function is
* registered.
*
* Kernel v4.1 fixes this (it always sets file->private_data regardless of whether "open" exists).
*/
static int sprite_engine_open(struct inode * inode, struct file * file)
{
    /* Do nothing, everything is handled by miscdevice's open function */
    return 0;
}

/**
* Memory maps the video memory into user-space. This doesn't map the two
* framebuffers into user-space since those are used internally by the graphics
* hardware.
*/
static int sprite_engine_mmap(struct file *file, struct vm_area_struct *vma)
{
    struct sprite_engine_dev *sprite_dev = container_of(file->private_data, struct sprite_engine_dev, miscdev);

    /* Ensure userspace can't access framebuffer video memory (its used internally by the DMA) */
    if(vma->vm_pgoff == 0 && (vma->vm_end - vma->vm_start) <= VIDEO_MEM_USER_SIZE) {
        return dma_common_mmap(&sprite_dev->pdev->dev,
                               vma,
                               sprite_dev->cpu_handle,
                               sprite_dev->dma_handle,
                               VIDEO_MEM_USER_SIZE);
    }

    return -EINVAL;
}

/*
* Handle I/O control commands coming from user-space.
*/
static long sprite_engine_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
{
    struct Sprite spr;
    struct Tile tile;

    struct sprite_engine_dev *sprite_dev = container_of(file->private_data, struct sprite_engine_dev, miscdev);

    switch(cmd)
    {
        case SPRITE_XY_ATTR:
            if(copy_from_user(&spr, (struct Sprite *)arg, sizeof(struct Sprite)))
                return -EACCES;

            SPR_COMBO_XY(sprite_dev, spr.disp_index, spr.x, spr.y);
            break;

        case SPRITE_EMWH_ATTR:
            if(copy_from_user(&spr, (struct Sprite *)arg, sizeof(struct Sprite)))
                return -EACCES;

            if(spr.width > 32)
                spr.width = 32;

            if(spr.height > 32)
                spr.height = 32;

            SPR_COMBO_EMWH(sprite_dev, spr.disp_index, spr.enable, spr.mem_slot, spr.width, spr.height);

            break;

        case SPRITE_X_ATTR:
            if(copy_from_user(&spr, (struct Sprite *)arg, sizeof(struct Sprite)))
                return -EACCES;

            SPR_SINGLE_X(sprite_dev, spr.disp_index, spr.x);
            break;


        case SPRITE_Y_ATTR:
            if(copy_from_user(&spr, (struct Sprite *)arg, sizeof(struct Sprite)))
                return -EACCES;

            SPR_SINGLE_Y(sprite_dev, spr.disp_index, spr.y);
            break;


        case SPRITE_MEM_ATTR:
            if(copy_from_user(&spr, (struct Sprite *)arg, sizeof(struct Sprite)))
                return -EACCES;

            SPR_SINGLE_MEM(sprite_dev, spr.disp_index, spr.mem_slot);
            break;


        case SPRITE_WIDTH_ATTR:
            if(copy_from_user(&spr, (struct Sprite *)arg, sizeof(struct Sprite)))
                return -EACCES;

            if(spr.width > 32)
                spr.width = 32;

            SPR_SINGLE_WIDTH(sprite_dev, spr.disp_index, spr.width);
            break;


        case SPRITE_HEIGHT_ATTR:
            if(copy_from_user(&spr, (struct Sprite *)arg, sizeof(struct Sprite)))
                return -EACCES;

            if(spr.height > 32)
                spr.height = 32;

            SPR_SINGLE_HEIGHT(sprite_dev, spr.disp_index, spr.height);
            break;

        case SPRITE_ENABLE_ATTR:
            if(copy_from_user(&spr, (struct Sprite *)arg, sizeof(struct Sprite)))
                return -EACCES;

            SPR_SINGLE_ENABLE(sprite_dev, spr.disp_index, spr.enable);
            break;

        case SPRITE_TILE_ATTR:
            if(copy_from_user(&tile, (struct Tile *)arg, sizeof(struct Tile)))
                return -EACCES;

            if(tile.x_index >= TILE_COLS)
                tile.x_index = TILE_COLS - 1;

            if(tile.y_index >= TILE_ROWS)
                tile.y_index = TILE_ROWS - 1;

            SPR_WRITE_TILE(sprite_dev, tile.x_index, tile.y_index, tile.mem_slot);
            break;

        case SPRITE_BG_MODE:
            write_sprite_reg(sprite_dev, REG_BG_MODE, arg & 1);
            break;

        case SPRITE_ENABLE:
            write_sprite_reg(sprite_dev, REG_CONTROL, arg & 1);
            break;

        default:
            return -EINVAL;
    }
    
    return 0;
}

/*
* Gets called whenever a device this driver handles is removed.
* This will also get called for each device being handled when 
* the driver gets removed from the system (using the rmmod command).
*/
static int sprite_engine_remove(struct platform_device *pdev)
{
    struct sprite_engine_dev *dev = (struct sprite_engine_dev*)platform_get_drvdata(pdev);

    misc_deregister(&dev->miscdev);

    /* Disable video output */
    write_sprite_reg(dev, REG_CONTROL, 0);

    pr_info("sprite_engine: engine removed\n");

    return 0;
}

/*
* Called when the driver is removed
*/
static void sprite_engine_exit(void)
{
    // Unregister our driver from the "Platform Driver" bus
    // This will cause "sprite_engine_remove" to be called for each connected device
    platform_driver_unregister(&sprite_engine_platform);

    pr_info("sprite_engine: module successfully unregistered\n");
}

/**
* Helper function for writing values into sprite engine registers
*
* @reg The register number to write into
* @val The value to write into the register
*
* @retval none
*/
static void write_sprite_reg(struct sprite_engine_dev *dev, u8 reg, u32 val)
{
    iowrite32(val, dev->regs + (reg << 2));
}

/**
* Helper function for writing values into sprite attributes
*
* @offset The offset from the base address to write into
* @val The value to write
*
* @retval none
*/
static void write_sprite_attr(struct sprite_engine_dev *dev, u32 offset, u32 val)
{
    iowrite32(val, dev->regs + offset);
}

/**
* Fills the buffered background with a solid color. This is
* is used in the probe routine as a simple debug feature (you
* can tell the driver is loaded when the screen shows a certain color).
*
* @addr The address of the buffered background
* @color The color to fill the background with
*
* @retval none
*/
static void fill_background_solid(u16 *addr, u16 color)
{
    int i = 0;

    for(i = 0; i < (WIDTH * HEIGHT); ++i) {
        iowrite16(color, (addr + i));
    }
}

// Tell the kernel which functions are the initialization and exit functions
module_init(sprite_engine_init);
module_exit(sprite_engine_exit);

// Define information about this kernel module
MODULE_LICENSE("GPL");
MODULE_AUTHOR("Devon Andrade <andrade824@gmail.com>");
MODULE_DESCRIPTION("Graphics driver for the Sprite Engine IP");
MODULE_VERSION("1.0");
