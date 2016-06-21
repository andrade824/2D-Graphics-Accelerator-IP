# Ensure the DevBox machine uses the same platform initialization code as the zybo
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

COMPATIBLE_MACHINE_devbox = "devbox" 
