echo XFHRECOVERY: using MMC0 FAT partition 1
setenv bootargs 'console=ttyS2,115200 console=tty0 root=/dev/mmcblk0p2 rootfstype=ext4 rootwait rw loglevel=7 printk.time=1'
if fatload mmc 0:1 0x81000000 zImage; then
  if fatload mmc 0:1 0x81800000 suniv-f1c100s-licheepi-nano.dtb; then
    echo XFHRECOVERY: launching Linux
    bootz 0x81000000 - 0x81800000
  fi
fi
echo XFHRECOVERY ERROR: no kernel or DTB on FAT partition
