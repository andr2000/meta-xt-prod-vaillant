SUMMARY = "Valliant controlling domain"

require ${TOPDIR}/../meta-xt-rpi-common/inc/image-rpi-common.inc

INITRAMFS_FSTYPES = "cpio.xz"

IMAGE_FSTYPES = "${INITRAMFS_FSTYPES} wic wic.bmap"

VAILLANT_SUPPORT = " \
    ebusd \
    mosquitto \
    sqlite3 \
    ufh-controller \
    wpantund \
"

# These packages are removed from the initramfs and installed
# into the overlay
PACKAGE_OVERLAY_ROOTFS_INSTALL += " \
    andr2000-addons \
"

IMAGE_INSTALL += " \
    ${VAILLANT_SUPPORT} \
"

# Allow big rootfs as it may contain /opt + /mnt/{data|secret}
IMAGE_ROOTFS_SIZE = "1048576"
INITRAMFS_MAXSIZE = "1048576"

make_initrd_symlink() {
    ln -sfr  ${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}${IMAGE_NAME_SUFFIX}.cpio.gz ${DEPLOY_DIR_IMAGE}/initrd
}

IMAGE_POSTPROCESS_COMMAND += " make_initrd_symlink; "

# We need initrd file, so wait until after cpio is done
do_image_wic[depends] += "${PN}:do_image_cpio"

# Install cpio.gz image as initrd
IMAGE_BOOT_FILES += " \
   ${IMGDEPLOYDIR}/${IMAGE_NAME}${IMAGE_NAME_SUFFIX}.cpio.xz;initrd \
"

WKS_FILE = "sdimage-vaillant.wks"

# Do not update /etc/fstab
WIC_CREATE_EXTRA_ARGS_append = " --no-fstab-update"

# Main root file system
WIC_CREATE_EXTRA_ARGS_append = " --rootfs-dir rootfs_main=${IMAGE_ROOTFS}"

# Overlay file system
WIC_CREATE_EXTRA_ARGS_append = " --rootfs-dir rootfs_overlay=${IMAGE_ROOTFS}/../rootfs-overlay"

# Secret file system
WIC_CREATE_EXTRA_ARGS_append = " --rootfs-dir rootfs_secret=${IMAGE_ROOTFS}/../rootfs-secret"
