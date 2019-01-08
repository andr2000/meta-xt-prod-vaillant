FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

FILES_${PN} += " \
    ${VAILLANT_MNT_SECRET}/ssh \
"

do_install_append() {
    # This folder will contain ssh keys
    install -d ${D}${VAILLANT_MNT_SECRET}/ssh

    sed -i "s#VAILLANT_MNT_SECRET#${VAILLANT_MNT_SECRET}#g" ${D}${sysconfdir}/ssh/sshd_config
}
