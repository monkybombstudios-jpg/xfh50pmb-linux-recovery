# XFH V3 READ-ONLY SPI BACKUP: NO FLASH ERASE OR WRITE
echo XFH V3 boot script running
setenv xfhstage 'Boot script started and SD FAT available'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 00_START.TXT ${filesize}
fi

setenv xfh_ok 1
if sf probe 0:0 1000000; then
setenv xfhstage 'SPI probe returned success'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 01_SPI_OK.TXT ${filesize}
fi

else
setenv xfhstage 'SPI probe failed. Dump not attempted'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 01_SPI_FAIL.TXT ${filesize}
fi

 setenv xfh_ok 0
fi
if test "${xfh_ok}" = "1"; then
 if sf read 0x81000000 0x000000 0x100000; then
  if fatwrite mmc 0:1 0x81000000 XFH_00.BIN 0x100000; then
   if fatload mmc 0:1 0x81800000 XFH_00.BIN; then
    if cmp.b 0x81000000 0x81800000 0x100000; then
setenv xfhstage 'Chunk 0 FLASH to SD to RAM comparison PASS'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 02_OK.TXT ${filesize}
fi

    else
setenv xfhstage 'Chunk 0 byte comparison FAILED'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 02_FAIL.TXT ${filesize}
fi

     setenv xfh_ok 0
    fi
   else
setenv xfhstage 'Chunk 0 SD readback FAILED'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 02_FAIL.TXT ${filesize}
fi

    setenv xfh_ok 0
   fi
  else
setenv xfhstage 'Chunk 0 SD write FAILED'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 02_FAIL.TXT ${filesize}
fi

   setenv xfh_ok 0
  fi
 else
setenv xfhstage 'Chunk 0 SPI read FAILED'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 02_FAIL.TXT ${filesize}
fi

  setenv xfh_ok 0
 fi
fi
if test "${xfh_ok}" = "1"; then
 if sf read 0x81000000 0x100000 0x100000; then
  if fatwrite mmc 0:1 0x81000000 XFH_01.BIN 0x100000; then
   if fatload mmc 0:1 0x81800000 XFH_01.BIN; then
    if cmp.b 0x81000000 0x81800000 0x100000; then
setenv xfhstage 'Chunk 1 FLASH to SD to RAM comparison PASS'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 03_OK.TXT ${filesize}
fi

    else
setenv xfhstage 'Chunk 1 byte comparison FAILED'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 03_FAIL.TXT ${filesize}
fi

     setenv xfh_ok 0
    fi
   else
setenv xfhstage 'Chunk 1 SD readback FAILED'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 03_FAIL.TXT ${filesize}
fi

    setenv xfh_ok 0
   fi
  else
setenv xfhstage 'Chunk 1 SD write FAILED'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 03_FAIL.TXT ${filesize}
fi

   setenv xfh_ok 0
  fi
 else
setenv xfhstage 'Chunk 1 SPI read FAILED'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 03_FAIL.TXT ${filesize}
fi

  setenv xfh_ok 0
 fi
fi
if test "${xfh_ok}" = "1"; then
 if sf read 0x81000000 0x200000 0x100000; then
  if fatwrite mmc 0:1 0x81000000 XFH_02.BIN 0x100000; then
   if fatload mmc 0:1 0x81800000 XFH_02.BIN; then
    if cmp.b 0x81000000 0x81800000 0x100000; then
setenv xfhstage 'Chunk 2 FLASH to SD to RAM comparison PASS'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 04_OK.TXT ${filesize}
fi

    else
setenv xfhstage 'Chunk 2 byte comparison FAILED'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 04_FAIL.TXT ${filesize}
fi

     setenv xfh_ok 0
    fi
   else
setenv xfhstage 'Chunk 2 SD readback FAILED'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 04_FAIL.TXT ${filesize}
fi

    setenv xfh_ok 0
   fi
  else
setenv xfhstage 'Chunk 2 SD write FAILED'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 04_FAIL.TXT ${filesize}
fi

   setenv xfh_ok 0
  fi
 else
setenv xfhstage 'Chunk 2 SPI read FAILED'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 04_FAIL.TXT ${filesize}
fi

  setenv xfh_ok 0
 fi
fi
if test "${xfh_ok}" = "1"; then
 if sf read 0x81000000 0x300000 0x100000; then
  if fatwrite mmc 0:1 0x81000000 XFH_03.BIN 0x100000; then
   if fatload mmc 0:1 0x81800000 XFH_03.BIN; then
    if cmp.b 0x81000000 0x81800000 0x100000; then
setenv xfhstage 'Chunk 3 FLASH to SD to RAM comparison PASS'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 05_OK.TXT ${filesize}
fi

    else
setenv xfhstage 'Chunk 3 byte comparison FAILED'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 05_FAIL.TXT ${filesize}
fi

     setenv xfh_ok 0
    fi
   else
setenv xfhstage 'Chunk 3 SD readback FAILED'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 05_FAIL.TXT ${filesize}
fi

    setenv xfh_ok 0
   fi
  else
setenv xfhstage 'Chunk 3 SD write FAILED'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 05_FAIL.TXT ${filesize}
fi

   setenv xfh_ok 0
  fi
 else
setenv xfhstage 'Chunk 3 SPI read FAILED'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 05_FAIL.TXT ${filesize}
fi

  setenv xfh_ok 0
 fi
fi
if test "${xfh_ok}" = "1"; then
 if sf read 0x81000000 0x400000 0x100000; then
  if fatwrite mmc 0:1 0x81000000 XFH_04.BIN 0x100000; then
   if fatload mmc 0:1 0x81800000 XFH_04.BIN; then
    if cmp.b 0x81000000 0x81800000 0x100000; then
setenv xfhstage 'Chunk 4 FLASH to SD to RAM comparison PASS'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 06_OK.TXT ${filesize}
fi

    else
setenv xfhstage 'Chunk 4 byte comparison FAILED'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 06_FAIL.TXT ${filesize}
fi

     setenv xfh_ok 0
    fi
   else
setenv xfhstage 'Chunk 4 SD readback FAILED'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 06_FAIL.TXT ${filesize}
fi

    setenv xfh_ok 0
   fi
  else
setenv xfhstage 'Chunk 4 SD write FAILED'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 06_FAIL.TXT ${filesize}
fi

   setenv xfh_ok 0
  fi
 else
setenv xfhstage 'Chunk 4 SPI read FAILED'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 06_FAIL.TXT ${filesize}
fi

  setenv xfh_ok 0
 fi
fi
if test "${xfh_ok}" = "1"; then
 if sf read 0x81000000 0x500000 0x100000; then
  if fatwrite mmc 0:1 0x81000000 XFH_05.BIN 0x100000; then
   if fatload mmc 0:1 0x81800000 XFH_05.BIN; then
    if cmp.b 0x81000000 0x81800000 0x100000; then
setenv xfhstage 'Chunk 5 FLASH to SD to RAM comparison PASS'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 07_OK.TXT ${filesize}
fi

    else
setenv xfhstage 'Chunk 5 byte comparison FAILED'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 07_FAIL.TXT ${filesize}
fi

     setenv xfh_ok 0
    fi
   else
setenv xfhstage 'Chunk 5 SD readback FAILED'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 07_FAIL.TXT ${filesize}
fi

    setenv xfh_ok 0
   fi
  else
setenv xfhstage 'Chunk 5 SD write FAILED'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 07_FAIL.TXT ${filesize}
fi

   setenv xfh_ok 0
  fi
 else
setenv xfhstage 'Chunk 5 SPI read FAILED'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 07_FAIL.TXT ${filesize}
fi

  setenv xfh_ok 0
 fi
fi
if test "${xfh_ok}" = "1"; then
 if sf read 0x81000000 0x600000 0x100000; then
  if fatwrite mmc 0:1 0x81000000 XFH_06.BIN 0x100000; then
   if fatload mmc 0:1 0x81800000 XFH_06.BIN; then
    if cmp.b 0x81000000 0x81800000 0x100000; then
setenv xfhstage 'Chunk 6 FLASH to SD to RAM comparison PASS'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 08_OK.TXT ${filesize}
fi

    else
setenv xfhstage 'Chunk 6 byte comparison FAILED'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 08_FAIL.TXT ${filesize}
fi

     setenv xfh_ok 0
    fi
   else
setenv xfhstage 'Chunk 6 SD readback FAILED'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 08_FAIL.TXT ${filesize}
fi

    setenv xfh_ok 0
   fi
  else
setenv xfhstage 'Chunk 6 SD write FAILED'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 08_FAIL.TXT ${filesize}
fi

   setenv xfh_ok 0
  fi
 else
setenv xfhstage 'Chunk 6 SPI read FAILED'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 08_FAIL.TXT ${filesize}
fi

  setenv xfh_ok 0
 fi
fi
if test "${xfh_ok}" = "1"; then
 if sf read 0x81000000 0x700000 0x100000; then
  if fatwrite mmc 0:1 0x81000000 XFH_07.BIN 0x100000; then
   if fatload mmc 0:1 0x81800000 XFH_07.BIN; then
    if cmp.b 0x81000000 0x81800000 0x100000; then
setenv xfhstage 'Chunk 7 FLASH to SD to RAM comparison PASS'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 09_OK.TXT ${filesize}
fi

    else
setenv xfhstage 'Chunk 7 byte comparison FAILED'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 09_FAIL.TXT ${filesize}
fi

     setenv xfh_ok 0
    fi
   else
setenv xfhstage 'Chunk 7 SD readback FAILED'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 09_FAIL.TXT ${filesize}
fi

    setenv xfh_ok 0
   fi
  else
setenv xfhstage 'Chunk 7 SD write FAILED'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 09_FAIL.TXT ${filesize}
fi

   setenv xfh_ok 0
  fi
 else
setenv xfhstage 'Chunk 7 SPI read FAILED'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 09_FAIL.TXT ${filesize}
fi

  setenv xfh_ok 0
 fi
fi
if test "${xfh_ok}" = "1"; then
setenv xfhstage 'All eight chunks copied; perform SHA256 verification on Mac'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 99_DONE.TXT ${filesize}
fi

else
setenv xfhstage 'Incomplete flash extraction; inspect stage markers'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 99_FAIL.TXT ${filesize}
fi

fi
echo V3 finished. Power down before removing SD.
