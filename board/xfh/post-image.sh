#!/bin/sh
set -eu
ROOT="${BR2_EXTERNAL_XFHRECOVERY_PATH}"
: "${BINARIES_DIR:?}"
: "${HOST_DIR:?}"

# Fails instead of producing an incomplete SD image.
for f in zImage suniv-f1c100s-licheepi-nano.dtb rootfs.ext4 u-boot-sunxi-with-spl.bin; do
    test -s "${BINARIES_DIR}/${f}" || { echo "Missing ${f}" >&2; exit 1; }
done
"${HOST_DIR}/bin/mkimage" -A arm -O linux -T script -C none \
    -n "XFH-50PMB recovery boot script" \
    -d "${ROOT}/board/xfh/boot.cmd" "${BINARIES_DIR}/boot.scr"

# Use Buildroot's included standard wrapper (explicit genimage cfg).
"${BR2_EXTERNAL_XFHRECOVERY_PATH}/board/xfh/run-genimage.sh" \
    "${BINARIES_DIR}" "${HOST_DIR}" "${ROOT}/board/xfh/genimage.cfg"
python3 "${ROOT}/board/xfh/check-image.py" "${BINARIES_DIR}/sdcard.img"
sha256sum "${BINARIES_DIR}/sdcard.img" > "${BINARIES_DIR}/SHA256SUMS.txt"
