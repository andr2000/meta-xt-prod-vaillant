FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "\
    file://0001-Add-ttyebus-driver-for-Raspberry-Pi-Zero-W.patch \
    file://0001-Changed-IRQ-for-V4.19.42.patch \
    file://defconfig \
"

CMDLINE = "dwc_otg.lpm_enable=0"

# FIXME: for some reason this module doesn't work when built in
KERNEL_MODULE_AUTOLOAD += "ttyebusm"
