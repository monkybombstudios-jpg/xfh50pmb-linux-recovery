# XFH V5 - preserve SPL/MMC path; read-only SPI scan; best effort finish LED
setenv xfhstage 'V5: boot script running'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 00_START.TXT ${filesize}
fi

setenv xfh_found 0
if help sf; then
setenv xfhstage 'V5: sf command present'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 02_SF_Y.TXT ${filesize}
fi

else
setenv xfhstage 'V5: sf command absent'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 02_SF_N.TXT ${filesize}
fi

fi
if help gpio; then
setenv xfhstage 'V5: gpio command present'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 03_GPIO_Y.TXT ${filesize}
fi

else
setenv xfhstage 'V5: gpio command absent'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 03_GPIO_N.TXT ${filesize}
fi

fi
if help dm; then
setenv xfhstage 'V5: dm command present'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 04_DM_Y.TXT ${filesize}
fi

else
setenv xfhstage 'V5: dm command absent'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 04_DM_N.TXT ${filesize}
fi

fi
setenv xfhstage 'V5: SPI scan begins'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 05_SCAN.TXT ${filesize}
fi

setenv xfhstage 'V5: start SPI bus 0 cs 0 speed 500000'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 P00_0500S.TXT ${filesize}
fi

if sf probe 0:0 500000; then
setenv xfhstage 'V5: SPI probe PASS 0:0 500000'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 P00_0500Y.TXT ${filesize}
fi

if test "${xfh_found}" = "0"; then
 setenv xfh_bus 0:0
 setenv xfh_hz 500000
 setenv xfh_found 1
fi
else
setenv xfhstage 'V5: SPI probe FAIL 0:0 500000'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 P00_0500N.TXT ${filesize}
fi

fi
setenv xfhstage 'V5: start SPI bus 0 cs 0 speed 1000000'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 P00_1000S.TXT ${filesize}
fi

if sf probe 0:0 1000000; then
setenv xfhstage 'V5: SPI probe PASS 0:0 1000000'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 P00_1000Y.TXT ${filesize}
fi

if test "${xfh_found}" = "0"; then
 setenv xfh_bus 0:0
 setenv xfh_hz 1000000
 setenv xfh_found 1
fi
else
setenv xfhstage 'V5: SPI probe FAIL 0:0 1000000'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 P00_1000N.TXT ${filesize}
fi

fi
setenv xfhstage 'V5: start SPI bus 0 cs 1 speed 500000'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 P01_0500S.TXT ${filesize}
fi

if sf probe 0:1 500000; then
setenv xfhstage 'V5: SPI probe PASS 0:1 500000'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 P01_0500Y.TXT ${filesize}
fi

if test "${xfh_found}" = "0"; then
 setenv xfh_bus 0:1
 setenv xfh_hz 500000
 setenv xfh_found 1
fi
else
setenv xfhstage 'V5: SPI probe FAIL 0:1 500000'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 P01_0500N.TXT ${filesize}
fi

fi
setenv xfhstage 'V5: start SPI bus 0 cs 1 speed 1000000'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 P01_1000S.TXT ${filesize}
fi

if sf probe 0:1 1000000; then
setenv xfhstage 'V5: SPI probe PASS 0:1 1000000'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 P01_1000Y.TXT ${filesize}
fi

if test "${xfh_found}" = "0"; then
 setenv xfh_bus 0:1
 setenv xfh_hz 1000000
 setenv xfh_found 1
fi
else
setenv xfhstage 'V5: SPI probe FAIL 0:1 1000000'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 P01_1000N.TXT ${filesize}
fi

fi
setenv xfhstage 'V5: start SPI bus 1 cs 0 speed 500000'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 P10_0500S.TXT ${filesize}
fi

if sf probe 1:0 500000; then
setenv xfhstage 'V5: SPI probe PASS 1:0 500000'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 P10_0500Y.TXT ${filesize}
fi

if test "${xfh_found}" = "0"; then
 setenv xfh_bus 1:0
 setenv xfh_hz 500000
 setenv xfh_found 1
fi
else
setenv xfhstage 'V5: SPI probe FAIL 1:0 500000'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 P10_0500N.TXT ${filesize}
fi

fi
setenv xfhstage 'V5: start SPI bus 1 cs 0 speed 1000000'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 P10_1000S.TXT ${filesize}
fi

if sf probe 1:0 1000000; then
setenv xfhstage 'V5: SPI probe PASS 1:0 1000000'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 P10_1000Y.TXT ${filesize}
fi

if test "${xfh_found}" = "0"; then
 setenv xfh_bus 1:0
 setenv xfh_hz 1000000
 setenv xfh_found 1
fi
else
setenv xfhstage 'V5: SPI probe FAIL 1:0 1000000'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 P10_1000N.TXT ${filesize}
fi

fi
setenv xfhstage 'V5: start SPI bus 1 cs 1 speed 500000'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 P11_0500S.TXT ${filesize}
fi

if sf probe 1:1 500000; then
setenv xfhstage 'V5: SPI probe PASS 1:1 500000'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 P11_0500Y.TXT ${filesize}
fi

if test "${xfh_found}" = "0"; then
 setenv xfh_bus 1:1
 setenv xfh_hz 500000
 setenv xfh_found 1
fi
else
setenv xfhstage 'V5: SPI probe FAIL 1:1 500000'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 P11_0500N.TXT ${filesize}
fi

fi
setenv xfhstage 'V5: start SPI bus 1 cs 1 speed 1000000'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 P11_1000S.TXT ${filesize}
fi

if sf probe 1:1 1000000; then
setenv xfhstage 'V5: SPI probe PASS 1:1 1000000'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 P11_1000Y.TXT ${filesize}
fi

if test "${xfh_found}" = "0"; then
 setenv xfh_bus 1:1
 setenv xfh_hz 1000000
 setenv xfh_found 1
fi
else
setenv xfhstage 'V5: SPI probe FAIL 1:1 1000000'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 P11_1000N.TXT ${filesize}
fi

fi
setenv xfhstage 'V5: start SPI bus 2 cs 0 speed 500000'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 P20_0500S.TXT ${filesize}
fi

if sf probe 2:0 500000; then
setenv xfhstage 'V5: SPI probe PASS 2:0 500000'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 P20_0500Y.TXT ${filesize}
fi

if test "${xfh_found}" = "0"; then
 setenv xfh_bus 2:0
 setenv xfh_hz 500000
 setenv xfh_found 1
fi
else
setenv xfhstage 'V5: SPI probe FAIL 2:0 500000'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 P20_0500N.TXT ${filesize}
fi

fi
setenv xfhstage 'V5: start SPI bus 2 cs 0 speed 1000000'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 P20_1000S.TXT ${filesize}
fi

if sf probe 2:0 1000000; then
setenv xfhstage 'V5: SPI probe PASS 2:0 1000000'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 P20_1000Y.TXT ${filesize}
fi

if test "${xfh_found}" = "0"; then
 setenv xfh_bus 2:0
 setenv xfh_hz 1000000
 setenv xfh_found 1
fi
else
setenv xfhstage 'V5: SPI probe FAIL 2:0 1000000'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 P20_1000N.TXT ${filesize}
fi

fi
setenv xfhstage 'V5: start SPI bus 2 cs 1 speed 500000'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 P21_0500S.TXT ${filesize}
fi

if sf probe 2:1 500000; then
setenv xfhstage 'V5: SPI probe PASS 2:1 500000'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 P21_0500Y.TXT ${filesize}
fi

if test "${xfh_found}" = "0"; then
 setenv xfh_bus 2:1
 setenv xfh_hz 500000
 setenv xfh_found 1
fi
else
setenv xfhstage 'V5: SPI probe FAIL 2:1 500000'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 P21_0500N.TXT ${filesize}
fi

fi
setenv xfhstage 'V5: start SPI bus 2 cs 1 speed 1000000'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 P21_1000S.TXT ${filesize}
fi

if sf probe 2:1 1000000; then
setenv xfhstage 'V5: SPI probe PASS 2:1 1000000'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 P21_1000Y.TXT ${filesize}
fi

if test "${xfh_found}" = "0"; then
 setenv xfh_bus 2:1
 setenv xfh_hz 1000000
 setenv xfh_found 1
fi
else
setenv xfhstage 'V5: SPI probe FAIL 2:1 1000000'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 P21_1000N.TXT ${filesize}
fi

fi
setenv xfhstage 'V5: SPI scan finished'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 20_SCAN_END.TXT ${filesize}
fi

if test "${xfh_found}" = "1"; then
setenv xfhstage 'V5: one SPI probe passed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 21_SPI_Y.TXT ${filesize}
fi

if sf probe ${xfh_bus} ${xfh_hz}; then
 if sf read 0x81000000 0x0 0x1000; then
  if fatwrite mmc 0:1 0x81000000 XFH_SAMPLE.BIN 0x1000; then
   if fatload mmc 0:1 0x81800000 XFH_SAMPLE.BIN; then
    if cmp.b 0x81000000 0x81800000 0x1000; then
setenv xfhstage 'V5: 4KB sample saved and compared'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 22_VERIFY_Y.TXT ${filesize}
fi

    else
setenv xfhstage 'V5: 4KB comparison failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 22_VERIFY_N.TXT ${filesize}
fi

    fi
   else
setenv xfhstage 'V5: FAT readback failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 22_FATREAD_N.TXT ${filesize}
fi

   fi
  else
setenv xfhstage 'V5: FAT write failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 22_FATWRITE_N.TXT ${filesize}
fi

  fi
 else
setenv xfhstage 'V5: SPI read failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 22_SPIREAD_N.TXT ${filesize}
fi

 fi
else
setenv xfhstage 'V5: reprobe failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 22_REPROBE_N.TXT ${filesize}
fi

fi
else
setenv xfhstage 'V5: all probes failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 21_SPI_N.TXT ${filesize}
fi

fi
setenv xfhstage 'V5: diagnostic scan done; LED attempt next'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 89_SCAN_DONE.TXT ${filesize}
fi

if help gpio; then
setenv xfhstage 'V5: attempting to switch blue to green'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 90_LED_TRY.TXT ${filesize}
fi

if gpio clear PD20; then
setenv xfhstage 'V5: PD20 cleared'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 91_RED_Y.TXT ${filesize}
fi

else
setenv xfhstage 'V5: PD20 clear failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 91_RED_N.TXT ${filesize}
fi

fi
if gpio clear PE4; then
setenv xfhstage 'V5: PE4 cleared'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 92_BLUE_Y.TXT ${filesize}
fi

else
setenv xfhstage 'V5: PE4 clear failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 92_BLUE_N.TXT ${filesize}
fi

fi
if gpio set PD21; then
setenv xfhstage 'V5: PD21 set; physical LED color unverified'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 93_GREEN_Y.TXT ${filesize}
fi

else
setenv xfhstage 'V5: PD21 set failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 93_GREEN_N.TXT ${filesize}
fi

fi
else
setenv xfhstage 'V5: gpio command absent'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 90_LED_N.TXT ${filesize}
fi

fi
setenv xfhstage 'V5: finished. Power OFF before removing SD'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 99_END.TXT ${filesize}
fi

echo V5 finished. Turn unit OFF before removing SD.
