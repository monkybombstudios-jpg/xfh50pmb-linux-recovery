# XFH V6 read-only. SPL, DRAM and MMC config unchanged.
setenv xfhstage 'V6 executing from MMC'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 00_START.TXT ${filesize}
fi

setenv xfh_found 0
setenv xfhstage 'Probing factory SPI0 CS0 PC0 PC1 PC2 PC3'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 01_PROBE.TXT ${filesize}
fi

if sf probe 0:0 500000; then
setenv xfhstage 'SPI0 CS0 probe succeeded'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 02_SPI_Y.TXT ${filesize}
fi

setenv xfh_found 1
else
setenv xfhstage 'SPI0 CS0 probe failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 02_SPI_N.TXT ${filesize}
fi

fi
if test "${xfh_found}" = "1"; then
 if sf read 0x81000000 0 0x1000; then
  if fatwrite mmc 0:1 0x81000000 XFH_HEAD.BIN 0x1000; then
   if fatload mmc 0:1 0x81800000 XFH_HEAD.BIN; then
    if cmp.b 0x81000000 0x81800000 0x1000; then
setenv xfhstage '4096-byte read saved and compared'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 03_READ_Y.TXT ${filesize}
fi

    else
setenv xfhstage 'Mismatch after SD readback'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 03_COMPARE_N.TXT ${filesize}
fi

    fi
   else
setenv xfhstage 'SD readback failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 03_SDREAD_N.TXT ${filesize}
fi

   fi
  else
setenv xfhstage 'SD write failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 03_SDWRITE_N.TXT ${filesize}
fi

  fi
 else
setenv xfhstage 'SPI read failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 03_SPIREAD_N.TXT ${filesize}
fi

 fi
fi
setenv xfhstage 'V6 scan finished; LED follows'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 89_SCAN_END.TXT ${filesize}
fi

# GPIO names from vendor FEX. GPIO driver and physical polarity unverified.
if gpio clear PD20; then
setenv xfhstage 'PD20 clear accepted'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 90_RED_Y.TXT ${filesize}
fi

else
setenv xfhstage 'PD20 clear failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 90_RED_N.TXT ${filesize}
fi

fi
if gpio clear PE4; then
setenv xfhstage 'PE4 clear accepted'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 91_BLUE_Y.TXT ${filesize}
fi

else
setenv xfhstage 'PE4 clear failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 91_BLUE_N.TXT ${filesize}
fi

fi
if gpio set PD21; then
setenv xfhstage 'PD21 set accepted; color not verified'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 92_GREEN_Y.TXT ${filesize}
fi

else
setenv xfhstage 'PD21 set failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 92_GREEN_N.TXT ${filesize}
fi

fi
setenv xfhstage 'V6 finished; POWER OFF before removing SD'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 99_END.TXT ${filesize}
fi

echo V6 finished: power OFF before removing SD
