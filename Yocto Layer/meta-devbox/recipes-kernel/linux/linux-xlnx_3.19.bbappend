FILESEXTRAPATHS_prepend := "${THISDIR}/config:"

SRC_URI_append += " \
                file://devbox-common;type=kmeta;destsuffix=devbox-common \
                "

# Enable Contiguous Memory Allocation (required by the sprite engine driver) and the various IP drivers
KERNEL_FEATURES_append_devbox += "features/cma/cma.scc"
KERNEL_FEATURES_append_devbox += "features/nesctrl/nesctrl.scc"
KERNEL_FEATURES_append_devbox += "features/sprite-engine/sprite-engine.scc"

# Make sure the following drivers autoload when the system boots up
module_autoload_nesctrl = "nesctrl"
module_autoload_sprite-engine = "sprite-engine"

PR = "r5"