#include <linux/module.h>
#include <linux/platform_device.h>
#include <linux/io.h>
#include <linux/miscdevice.h>
#include <linux/fs.h>
#include <linux/types.h>
#include <linux/uaccess.h>

// Prototypes
static int nesctrl_probe(struct platform_device *pdev);
static int nesctrl_remove(struct platform_device *pdev);
static int nesctrl_open(struct inode * inode, struct file * file);
static ssize_t nesctrl_read(struct file *file, char *buffer, size_t len, loff_t *offset);

// An instance of this structure will be created for every NES Controller IP in the system
struct nesctrl_dev {
    struct miscdevice miscdev;
    void __iomem *regs;
};

// Specify which device tree devices this driver supports
static struct of_device_id nesctrl_dt_ids[] = {
    {
        .compatible = "dsa,nes_controller"
    },
    { /* end of table */ }
};

// Inform the kernel about the devices this driver supports
MODULE_DEVICE_TABLE(of, nesctrl_dt_ids);

// Data structure that links the probe and remove functions with our driver
static struct platform_driver nesctrl_platform = {
    .probe = nesctrl_probe,
    .remove = nesctrl_remove,
    .driver = {
        .name = "NES Controller Driver",
        .owner = THIS_MODULE,
        .of_match_table = nesctrl_dt_ids
    }
};

// The file operations that can be performed on the nesctrl character file
static const struct file_operations nesctrl_fops = {
    .owner = THIS_MODULE,
    .open = nesctrl_open,
    .read = nesctrl_read
};

/*
* Called when the driver is installed
*/
static int nesctrl_init(void)
{
    int ret_val = 0;

    // Register our driver with the "Platform Driver" bus
    ret_val = platform_driver_register(&nesctrl_platform);
    if(ret_val != 0) {
        pr_err("nesctrl: platform_driver_register returned %d\n", ret_val);
        return ret_val;
    }

    pr_info("nesctrl: successfully initialized!\n");

    return 0;
}

/*
* Called whenever the kernel finds a new device that this driver can handle
*/
static int nesctrl_probe(struct platform_device *pdev)
{
    int ret_val = -EBUSY;
    struct nesctrl_dev *dev;
    struct resource *r = 0;

    r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
    if(r == NULL) {
        pr_err("nes_probe: IORESOURCE_MEM (register space) does not exist\n");
        goto bad_exit_return;
    }

    // Create structure to hold device-specific information (like the registers)
    dev = devm_kzalloc(&pdev->dev, sizeof(struct nesctrl_dev), GFP_KERNEL);

    // Both request and ioremap a memory region
    // This makes sure nobody else can grab this memory region
    // as well as moving it into our address space so we can actually use it
    dev->regs = devm_ioremap_resource(&pdev->dev, r);
    if(IS_ERR(dev->regs))
        goto bad_ioremap;

    // Initialize the misc device (this is used to create a character file in userspace)
    dev->miscdev.minor = MISC_DYNAMIC_MINOR;
    dev->miscdev.name = "nes";
    dev->miscdev.fops = &nesctrl_fops;

    ret_val = misc_register(&dev->miscdev);
    if(ret_val != 0) {
        pr_info("nes_probe: Couldn't register misc device :(\n");
        goto bad_exit_return;
    }

    // Give a pointer to the instance-specific data to the generic platform_device structure
    // so we can access this data later on (for instance, in the remove function)
    platform_set_drvdata(pdev, (void*)dev);

    pr_info("nesctrl: Controller registered\n");

    return 0;

bad_ioremap:
   ret_val = PTR_ERR(dev->regs); 
bad_exit_return:
    pr_info("nes_probe: bad exit :(\n");
    return ret_val;
}

/*
* Only reason this function is even here is so on kernels v4.0 and earlier,
* the file->private_data field is set correctly to the miscdevice structure.
* On these kernels, it will only get set properly when an "open" function is
* registered.
*
* v4.1 fixes this (it always sets file->private_data regardless of whether "open" exists).
*/
static int nesctrl_open(struct inode * inode, struct file * file)
{
    /* Do nothing, everything is handled by miscdevice's open function */
    return 0;
}

/*
* This function gets called whenever a read operation occurs on one of the character files
*/
static ssize_t nesctrl_read(struct file *file, char *buffer, size_t len, loff_t *offset)
{
    int success = 0;
    u8 button_val = 0;

    /* 
    * Get the nesctrl_dev structure out of the miscdevice structure.
    *
    * Remember, the Misc subsystem has a default "open" function that will set
    * "file"s private data to the appropriate miscdevice structure. We then use the
    * container_of macro to get the structure that miscdevice is stored inside of (which
    * is the nesctrl_dev structure).
    * 
    * For more info on how container_of works, check out:
    * http://linuxwell.com/2012/11/10/magical-container_of-macro/
    */
    struct nesctrl_dev *dev = container_of(file->private_data, struct nesctrl_dev, miscdev);

    // Give the user the current value
    button_val = ioread8(dev->regs);

    //pr_info("nesctrl: button_val = %x", button_val);

    if(sizeof(button_val) <= len) {
        success = copy_to_user(buffer, &button_val, sizeof(button_val));

        if(success != 0) {
            pr_info("nesctrl: failed to copy data to userspace\n");
            return -EFAULT; // Bad address error value. It's likely that "buffer" doesn't point to a good address
        }
    } else {
        pr_info("nesctrl: sizeof(button_val) is greater than length of buffer\n");
        return -EINVAL;
    }

    return 0; // "0" indicates End of File, aka, it tells the user process to stop reading
}

/*
* Gets called whenever a device this driver handles is removed.
* This will also get called for each device being handled when 
* the driver gets removed from the system (using the rmmod command).
*/
static int nesctrl_remove(struct platform_device *pdev)
{
    // Grab the instance-specific information out of the platform device
    struct nesctrl_dev *dev = (struct nesctrl_dev*)platform_get_drvdata(pdev);

    // Unregister the character file (remove it from /dev)
    misc_deregister(&dev->miscdev);

    pr_info("nesctrl: Controller removed\n");

    return 0;
}

// Called when the driver is removed
static void nesctrl_exit(void)
{
    // Unregister our driver from the "Platform Driver" bus
    // This will cause "nesctrl_remove" to be called for each connected device
    platform_driver_unregister(&nesctrl_platform);

    pr_info("nesctrl: module successfully unregistered\n");
}

// Tell the kernel which functions are the initialization and exit functions
module_init(nesctrl_init);
module_exit(nesctrl_exit);

// Define information about this kernel module
MODULE_LICENSE("GPL");
MODULE_AUTHOR("Devon Andrade <andrade824@gmail.com>");
MODULE_DESCRIPTION("Exposes a character device to user space that lets users read button values from a NES Controller");
MODULE_VERSION("1.0");
