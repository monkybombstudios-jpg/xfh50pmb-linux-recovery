# XFH separate read-only hardware diagnostic for U-Boot's interactive shell.
# This is NOT an automatic boot script. Load manually after confirming U-Boot prompt.
# No flash writes, no blind SDRAM probing, and no unverified GPIO changes.
echo XFH HARDWARE DIAGNOSTICS START
version
bdinfo
help cpu
help gpio
gpio status -a
printenv
fdt addr
fdt print /memory
echo XFH HARDWARE DIAGNOSTICS END
