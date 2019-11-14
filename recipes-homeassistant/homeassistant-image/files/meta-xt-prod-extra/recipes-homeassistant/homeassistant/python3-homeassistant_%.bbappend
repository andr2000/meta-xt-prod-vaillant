# Use git version, not pypi
S = "${WORKDIR}/git"
LIC_FILES_CHKSUM = "file://${S}/LICENSE.md;md5=86d3f3a95c324c9479bd8986968f4327"
PYPI_SRC_URI = "\
    git://github.com/andr2000/home-assistant.git;branch=master;name=ha \
"
SRCREV_ha = "${AUTOREV}"

FILES_${PN} += "\
    ${HOMEASSISTANT_CONFIG_DIR}/appconfig \
"

# Force updating external configuration files
do_install[nostamp] = "1"

do_install_append() {
    install -d ${D}${HOMEASSISTANT_CONFIG_DIR}
    if [ ! -z "${HOMEASSISTANT_APP_SECRETS_DIR}" ]; then
        echo "Using Home Assistant secrets from ${HOMEASSISTANT_APP_SECRETS_DIR}..."
        cp -rf ${HOMEASSISTANT_APP_SECRETS_DIR}/appconfig/. ${D}/${HOMEASSISTANT_CONFIG_DIR}/
    fi
    # remove git leftovers if any
    rm -rf ${D}/${HOMEASSISTANT_CONFIG_DIR}/.git* || true
    chown -R ${HOMEASSISTANT_USER}:${HOMEASSISTANT_USER} ${D}/${HOMEASSISTANT_CONFIG_DIR}/
}

RDEPENDS_${PN} += " \
    ${PYTHON_PN}-av \
    ${PYTHON_PN}-ebusdpy \
    ${PYTHON_PN}-python-telegram-bot \
    ${PYTHON_PN}-restrictedpython \
    ${PYTHON_PN}-aioesphomeapi \
"

# Because we resize data partition on the first boot we need
# to create database folder after that is done.
RDEPENDS_${PN} += "base-files"

pkg_postinst_ontarget_${PN} () {
    # Get database location and create dir
    db_url=`grep db_url ${HOMEASSISTANT_CONFIG_DIR}/configuration.yaml`
    db_path=`echo $db_url | sed -E "s/\s*db_url:\s*'sqlite:\/\/(.*)\/.+'/\1/"`
    mkdir -p "$db_path"
    chown ${HOMEASSISTANT_USER}:${HOMEASSISTANT_USER} "$db_path"
}
