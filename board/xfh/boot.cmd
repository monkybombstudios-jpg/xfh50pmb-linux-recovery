# XFH V7: read-only MMIO snapshots with driver operation between; no gpio writes, no sf write/erase.
setenv xfhstage 'V7 diagnostic script entered; before snapshots'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 00_V7_START.TXT ${filesize}
fi

# Read 1024 bytes from 0x01c20000; never writes to MMIO.
if cp.l 0x01c20000 0x81000000 100; then
 if fatwrite mmc 0:1 0x81000000 B_CC.BIN 400; then
setenv xfhstage 'B_CC snapshot saved'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 B_CC_Y.TXT ${filesize}
fi

 else
setenv xfhstage 'B_CC FAT write failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 B_CC_N.TXT ${filesize}
fi

 fi
else
setenv xfhstage 'B_CC MMIO read failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 B_CC_N.TXT ${filesize}
fi

fi

# Read 1024 bytes from 0x01c20800; never writes to MMIO.
if cp.l 0x01c20800 0x81000000 100; then
 if fatwrite mmc 0:1 0x81000000 B_GPIO.BIN 400; then
setenv xfhstage 'B_GPIO snapshot saved'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 B_GPIO_Y.TXT ${filesize}
fi

 else
setenv xfhstage 'B_GPIO FAT write failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 B_GPIO_N.TXT ${filesize}
fi

 fi
else
setenv xfhstage 'B_GPIO MMIO read failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 B_GPIO_N.TXT ${filesize}
fi

fi

# Read 256 bytes from 0x01c05000; never writes to MMIO.
if cp.l 0x01c05000 0x81000000 40; then
 if fatwrite mmc 0:1 0x81000000 B_SPI.BIN 100; then
setenv xfhstage 'B_SPI snapshot saved'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 B_SPI_Y.TXT ${filesize}
fi

 else
setenv xfhstage 'B_SPI FAT write failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 B_SPI_N.TXT ${filesize}
fi

 fi
else
setenv xfhstage 'B_SPI MMIO read failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 B_SPI_N.TXT ${filesize}
fi

fi

# Read-only sf probe; PC0..PC3 may be reconfigured by built-in driver.
setenv xfhstage 'V7 SPI probe starting'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 10_SPI_BEGIN.TXT ${filesize}
fi

if sf probe 0:0 500000; then
setenv xfhstage 'V7 SPI flash successfully probed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 11_SPI_Y.TXT ${filesize}
fi

if sf read 0x81000000 0 0x1000; then
 if fatwrite mmc 0:1 0x81000000 V7_HEAD.BIN 0x1000; then
setenv xfhstage 'V7 flash 4KB sample saved'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 12_READ_Y.TXT ${filesize}
fi

 else
setenv xfhstage 'V7 FAT save failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 12_READ_N.TXT ${filesize}
fi

 fi
else
setenv xfhstage 'V7 sf read failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 12_READ_N.TXT ${filesize}
fi

fi
else
setenv xfhstage 'V7 SPI flash probe failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 11_SPI_N.TXT ${filesize}
fi

fi
# Read 1024 bytes from 0x01c20000; never writes to MMIO.
if cp.l 0x01c20000 0x81000000 100; then
 if fatwrite mmc 0:1 0x81000000 A_CC.BIN 400; then
setenv xfhstage 'A_CC snapshot saved'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 A_CC_Y.TXT ${filesize}
fi

 else
setenv xfhstage 'A_CC FAT write failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 A_CC_N.TXT ${filesize}
fi

 fi
else
setenv xfhstage 'A_CC MMIO read failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 A_CC_N.TXT ${filesize}
fi

fi

# Read 1024 bytes from 0x01c20800; never writes to MMIO.
if cp.l 0x01c20800 0x81000000 100; then
 if fatwrite mmc 0:1 0x81000000 A_GPIO.BIN 400; then
setenv xfhstage 'A_GPIO snapshot saved'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 A_GPIO_Y.TXT ${filesize}
fi

 else
setenv xfhstage 'A_GPIO FAT write failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 A_GPIO_N.TXT ${filesize}
fi

 fi
else
setenv xfhstage 'A_GPIO MMIO read failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 A_GPIO_N.TXT ${filesize}
fi

fi

# Read 256 bytes from 0x01c05000; never writes to MMIO.
if cp.l 0x01c05000 0x81000000 40; then
 if fatwrite mmc 0:1 0x81000000 A_SPI.BIN 100; then
setenv xfhstage 'A_SPI snapshot saved'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 A_SPI_Y.TXT ${filesize}
fi

 else
setenv xfhstage 'A_SPI FAT write failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 A_SPI_N.TXT ${filesize}
fi

 fi
else
setenv xfhstage 'A_SPI MMIO read failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 A_SPI_N.TXT ${filesize}
fi

fi

setenv xfhstage 'V7 complete; no LED GPIO toggles; power OFF before SD removal'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 99_V7_END.TXT ${filesize}
fi

echo V7 complete; turn power OFF before SD removal
