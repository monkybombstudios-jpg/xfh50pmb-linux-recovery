# XFH V12 LED: same V12 READ-ONLY 8 MiB recovery with completion LED attempt.
# Retains V10 CCU baseline, SPI driver, JEDEC ID and working SD boot chain.
# No sf erase, sf write, protect, or any flash programming commands.
setenv xfh_complete 0
mw.l 0x82010000 0 0x100
setenv xfhstage 'V12 started 8MiB read-only SPI flash recovery'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 00_V11_START.TXT ${filesize}
fi
setenv xfh_ready 0
mw.l 0x81080000 0x00004100 1
mw.l 0x81080004 0x00104100 1
if cmp.l 0x01c20060 0x81080000 1; then
 if cmp.l 0x01c202c0 0x81080000 1; then
  mw.l 0x01c20060 0x00104100 1
  if cmp.l 0x01c20060 0x81080004 1; then
   mw.l 0x01c202c0 0x00104100 1
   if cmp.l 0x01c202c0 0x81080004 1; then
    setenv xfh_ready 1
    setenv xfhstage 'V12 guarded SPI clock/reset successful'
    if env export -t 0x82000000 xfhstage; then
     fatwrite mmc 0:1 0x82000000 20_CC_OK.TXT ${filesize}
    fi
   fi
  fi
 fi
fi
if test "${xfh_ready}" = "0"; then
 setenv xfhstage 'V12 CCU baseline mismatch, skipped'
 if env export -t 0x82000000 xfhstage; then
  fatwrite mmc 0:1 0x82000000 20_CC_SKIP.TXT ${filesize}
 fi
fi
if test "${xfh_ready}" = "1"; then
 setenv xfhstage 'V12 EON flash probe starting'
 if env export -t 0x82000000 xfhstage; then
  fatwrite mmc 0:1 0x82000000 30_PROBE_START.TXT ${filesize}
 fi
 if sf probe 0:0 500000; then
  setenv xfhstage 'V12 flash recognized; beginning 8MiB verification'
  if env export -t 0x82000000 xfhstage; then
   fatwrite mmc 0:1 0x82000000 31_SPI_Y.TXT ${filesize}
  fi
  setenv xfh_ok 1
  # Chunk 00: flash offset 0x000000, length 0x40000, output F00.BIN
  if test "${xfh_ok}" = "1"; then
   if sf read 0x81000000 0x000000 0x40000; then
    if sf read 0x81100000 0x000000 0x40000; then
     if cmp.b 0x81000000 0x81100000 0x40000; then
      if fatwrite mmc 0:1 0x81000000 F00.BIN 0x40000; then
       if fatload mmc 0:1 0x81200000 F00.BIN; then
        if cmp.b 0x81000000 0x81200000 0x40000; then
         setenv xfhstage 'V12 chunk 00 of 32 double-read and FAT verified'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 P00_Y.TXT ${filesize}
         fi
        else
         setenv xfh_ok 0
         setenv xfhstage 'V12 chunk 00 FAT comparison FAILED'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 E00_N.TXT ${filesize}
         fi
        fi
       else
        setenv xfh_ok 0
        setenv xfhstage 'V12 chunk 00 FAT reload FAILED'
        if env export -t 0x82000000 xfhstage; then
         fatwrite mmc 0:1 0x82000000 E00_N.TXT ${filesize}
        fi
       fi
      else
       setenv xfh_ok 0
       setenv xfhstage 'V12 chunk 00 FAT save FAILED'
       if env export -t 0x82000000 xfhstage; then
        fatwrite mmc 0:1 0x82000000 E00_N.TXT ${filesize}
       fi
      fi
     else
      setenv xfh_ok 0
      setenv xfhstage 'V12 chunk 00 two SPI reads mismatch'
      if env export -t 0x82000000 xfhstage; then
       fatwrite mmc 0:1 0x82000000 E00_N.TXT ${filesize}
      fi
     fi
    else
     setenv xfh_ok 0
     setenv xfhstage 'V12 chunk 00 second SPI read FAILED'
     if env export -t 0x82000000 xfhstage; then
      fatwrite mmc 0:1 0x82000000 E00_N.TXT ${filesize}
     fi
    fi
   else
    setenv xfh_ok 0
    setenv xfhstage 'V12 chunk 00 first SPI read FAILED'
    if env export -t 0x82000000 xfhstage; then
     fatwrite mmc 0:1 0x82000000 E00_N.TXT ${filesize}
    fi
   fi
  fi
  # Chunk 01: flash offset 0x040000, length 0x40000, output F01.BIN
  if test "${xfh_ok}" = "1"; then
   if sf read 0x81000000 0x040000 0x40000; then
    if sf read 0x81100000 0x040000 0x40000; then
     if cmp.b 0x81000000 0x81100000 0x40000; then
      if fatwrite mmc 0:1 0x81000000 F01.BIN 0x40000; then
       if fatload mmc 0:1 0x81200000 F01.BIN; then
        if cmp.b 0x81000000 0x81200000 0x40000; then
         setenv xfhstage 'V12 chunk 01 of 32 double-read and FAT verified'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 P01_Y.TXT ${filesize}
         fi
        else
         setenv xfh_ok 0
         setenv xfhstage 'V12 chunk 01 FAT comparison FAILED'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 E01_N.TXT ${filesize}
         fi
        fi
       else
        setenv xfh_ok 0
        setenv xfhstage 'V12 chunk 01 FAT reload FAILED'
        if env export -t 0x82000000 xfhstage; then
         fatwrite mmc 0:1 0x82000000 E01_N.TXT ${filesize}
        fi
       fi
      else
       setenv xfh_ok 0
       setenv xfhstage 'V12 chunk 01 FAT save FAILED'
       if env export -t 0x82000000 xfhstage; then
        fatwrite mmc 0:1 0x82000000 E01_N.TXT ${filesize}
       fi
      fi
     else
      setenv xfh_ok 0
      setenv xfhstage 'V12 chunk 01 two SPI reads mismatch'
      if env export -t 0x82000000 xfhstage; then
       fatwrite mmc 0:1 0x82000000 E01_N.TXT ${filesize}
      fi
     fi
    else
     setenv xfh_ok 0
     setenv xfhstage 'V12 chunk 01 second SPI read FAILED'
     if env export -t 0x82000000 xfhstage; then
      fatwrite mmc 0:1 0x82000000 E01_N.TXT ${filesize}
     fi
    fi
   else
    setenv xfh_ok 0
    setenv xfhstage 'V12 chunk 01 first SPI read FAILED'
    if env export -t 0x82000000 xfhstage; then
     fatwrite mmc 0:1 0x82000000 E01_N.TXT ${filesize}
    fi
   fi
  fi
  # Chunk 02: flash offset 0x080000, length 0x40000, output F02.BIN
  if test "${xfh_ok}" = "1"; then
   if sf read 0x81000000 0x080000 0x40000; then
    if sf read 0x81100000 0x080000 0x40000; then
     if cmp.b 0x81000000 0x81100000 0x40000; then
      if fatwrite mmc 0:1 0x81000000 F02.BIN 0x40000; then
       if fatload mmc 0:1 0x81200000 F02.BIN; then
        if cmp.b 0x81000000 0x81200000 0x40000; then
         setenv xfhstage 'V12 chunk 02 of 32 double-read and FAT verified'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 P02_Y.TXT ${filesize}
         fi
        else
         setenv xfh_ok 0
         setenv xfhstage 'V12 chunk 02 FAT comparison FAILED'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 E02_N.TXT ${filesize}
         fi
        fi
       else
        setenv xfh_ok 0
        setenv xfhstage 'V12 chunk 02 FAT reload FAILED'
        if env export -t 0x82000000 xfhstage; then
         fatwrite mmc 0:1 0x82000000 E02_N.TXT ${filesize}
        fi
       fi
      else
       setenv xfh_ok 0
       setenv xfhstage 'V12 chunk 02 FAT save FAILED'
       if env export -t 0x82000000 xfhstage; then
        fatwrite mmc 0:1 0x82000000 E02_N.TXT ${filesize}
       fi
      fi
     else
      setenv xfh_ok 0
      setenv xfhstage 'V12 chunk 02 two SPI reads mismatch'
      if env export -t 0x82000000 xfhstage; then
       fatwrite mmc 0:1 0x82000000 E02_N.TXT ${filesize}
      fi
     fi
    else
     setenv xfh_ok 0
     setenv xfhstage 'V12 chunk 02 second SPI read FAILED'
     if env export -t 0x82000000 xfhstage; then
      fatwrite mmc 0:1 0x82000000 E02_N.TXT ${filesize}
     fi
    fi
   else
    setenv xfh_ok 0
    setenv xfhstage 'V12 chunk 02 first SPI read FAILED'
    if env export -t 0x82000000 xfhstage; then
     fatwrite mmc 0:1 0x82000000 E02_N.TXT ${filesize}
    fi
   fi
  fi
  # Chunk 03: flash offset 0x0C0000, length 0x40000, output F03.BIN
  if test "${xfh_ok}" = "1"; then
   if sf read 0x81000000 0x0C0000 0x40000; then
    if sf read 0x81100000 0x0C0000 0x40000; then
     if cmp.b 0x81000000 0x81100000 0x40000; then
      if fatwrite mmc 0:1 0x81000000 F03.BIN 0x40000; then
       if fatload mmc 0:1 0x81200000 F03.BIN; then
        if cmp.b 0x81000000 0x81200000 0x40000; then
         setenv xfhstage 'V12 chunk 03 of 32 double-read and FAT verified'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 P03_Y.TXT ${filesize}
         fi
        else
         setenv xfh_ok 0
         setenv xfhstage 'V12 chunk 03 FAT comparison FAILED'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 E03_N.TXT ${filesize}
         fi
        fi
       else
        setenv xfh_ok 0
        setenv xfhstage 'V12 chunk 03 FAT reload FAILED'
        if env export -t 0x82000000 xfhstage; then
         fatwrite mmc 0:1 0x82000000 E03_N.TXT ${filesize}
        fi
       fi
      else
       setenv xfh_ok 0
       setenv xfhstage 'V12 chunk 03 FAT save FAILED'
       if env export -t 0x82000000 xfhstage; then
        fatwrite mmc 0:1 0x82000000 E03_N.TXT ${filesize}
       fi
      fi
     else
      setenv xfh_ok 0
      setenv xfhstage 'V12 chunk 03 two SPI reads mismatch'
      if env export -t 0x82000000 xfhstage; then
       fatwrite mmc 0:1 0x82000000 E03_N.TXT ${filesize}
      fi
     fi
    else
     setenv xfh_ok 0
     setenv xfhstage 'V12 chunk 03 second SPI read FAILED'
     if env export -t 0x82000000 xfhstage; then
      fatwrite mmc 0:1 0x82000000 E03_N.TXT ${filesize}
     fi
    fi
   else
    setenv xfh_ok 0
    setenv xfhstage 'V12 chunk 03 first SPI read FAILED'
    if env export -t 0x82000000 xfhstage; then
     fatwrite mmc 0:1 0x82000000 E03_N.TXT ${filesize}
    fi
   fi
  fi
  # Chunk 04: flash offset 0x100000, length 0x40000, output F04.BIN
  if test "${xfh_ok}" = "1"; then
   if sf read 0x81000000 0x100000 0x40000; then
    if sf read 0x81100000 0x100000 0x40000; then
     if cmp.b 0x81000000 0x81100000 0x40000; then
      if fatwrite mmc 0:1 0x81000000 F04.BIN 0x40000; then
       if fatload mmc 0:1 0x81200000 F04.BIN; then
        if cmp.b 0x81000000 0x81200000 0x40000; then
         setenv xfhstage 'V12 chunk 04 of 32 double-read and FAT verified'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 P04_Y.TXT ${filesize}
         fi
        else
         setenv xfh_ok 0
         setenv xfhstage 'V12 chunk 04 FAT comparison FAILED'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 E04_N.TXT ${filesize}
         fi
        fi
       else
        setenv xfh_ok 0
        setenv xfhstage 'V12 chunk 04 FAT reload FAILED'
        if env export -t 0x82000000 xfhstage; then
         fatwrite mmc 0:1 0x82000000 E04_N.TXT ${filesize}
        fi
       fi
      else
       setenv xfh_ok 0
       setenv xfhstage 'V12 chunk 04 FAT save FAILED'
       if env export -t 0x82000000 xfhstage; then
        fatwrite mmc 0:1 0x82000000 E04_N.TXT ${filesize}
       fi
      fi
     else
      setenv xfh_ok 0
      setenv xfhstage 'V12 chunk 04 two SPI reads mismatch'
      if env export -t 0x82000000 xfhstage; then
       fatwrite mmc 0:1 0x82000000 E04_N.TXT ${filesize}
      fi
     fi
    else
     setenv xfh_ok 0
     setenv xfhstage 'V12 chunk 04 second SPI read FAILED'
     if env export -t 0x82000000 xfhstage; then
      fatwrite mmc 0:1 0x82000000 E04_N.TXT ${filesize}
     fi
    fi
   else
    setenv xfh_ok 0
    setenv xfhstage 'V12 chunk 04 first SPI read FAILED'
    if env export -t 0x82000000 xfhstage; then
     fatwrite mmc 0:1 0x82000000 E04_N.TXT ${filesize}
    fi
   fi
  fi
  # Chunk 05: flash offset 0x140000, length 0x40000, output F05.BIN
  if test "${xfh_ok}" = "1"; then
   if sf read 0x81000000 0x140000 0x40000; then
    if sf read 0x81100000 0x140000 0x40000; then
     if cmp.b 0x81000000 0x81100000 0x40000; then
      if fatwrite mmc 0:1 0x81000000 F05.BIN 0x40000; then
       if fatload mmc 0:1 0x81200000 F05.BIN; then
        if cmp.b 0x81000000 0x81200000 0x40000; then
         setenv xfhstage 'V12 chunk 05 of 32 double-read and FAT verified'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 P05_Y.TXT ${filesize}
         fi
        else
         setenv xfh_ok 0
         setenv xfhstage 'V12 chunk 05 FAT comparison FAILED'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 E05_N.TXT ${filesize}
         fi
        fi
       else
        setenv xfh_ok 0
        setenv xfhstage 'V12 chunk 05 FAT reload FAILED'
        if env export -t 0x82000000 xfhstage; then
         fatwrite mmc 0:1 0x82000000 E05_N.TXT ${filesize}
        fi
       fi
      else
       setenv xfh_ok 0
       setenv xfhstage 'V12 chunk 05 FAT save FAILED'
       if env export -t 0x82000000 xfhstage; then
        fatwrite mmc 0:1 0x82000000 E05_N.TXT ${filesize}
       fi
      fi
     else
      setenv xfh_ok 0
      setenv xfhstage 'V12 chunk 05 two SPI reads mismatch'
      if env export -t 0x82000000 xfhstage; then
       fatwrite mmc 0:1 0x82000000 E05_N.TXT ${filesize}
      fi
     fi
    else
     setenv xfh_ok 0
     setenv xfhstage 'V12 chunk 05 second SPI read FAILED'
     if env export -t 0x82000000 xfhstage; then
      fatwrite mmc 0:1 0x82000000 E05_N.TXT ${filesize}
     fi
    fi
   else
    setenv xfh_ok 0
    setenv xfhstage 'V12 chunk 05 first SPI read FAILED'
    if env export -t 0x82000000 xfhstage; then
     fatwrite mmc 0:1 0x82000000 E05_N.TXT ${filesize}
    fi
   fi
  fi
  # Chunk 06: flash offset 0x180000, length 0x40000, output F06.BIN
  if test "${xfh_ok}" = "1"; then
   if sf read 0x81000000 0x180000 0x40000; then
    if sf read 0x81100000 0x180000 0x40000; then
     if cmp.b 0x81000000 0x81100000 0x40000; then
      if fatwrite mmc 0:1 0x81000000 F06.BIN 0x40000; then
       if fatload mmc 0:1 0x81200000 F06.BIN; then
        if cmp.b 0x81000000 0x81200000 0x40000; then
         setenv xfhstage 'V12 chunk 06 of 32 double-read and FAT verified'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 P06_Y.TXT ${filesize}
         fi
        else
         setenv xfh_ok 0
         setenv xfhstage 'V12 chunk 06 FAT comparison FAILED'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 E06_N.TXT ${filesize}
         fi
        fi
       else
        setenv xfh_ok 0
        setenv xfhstage 'V12 chunk 06 FAT reload FAILED'
        if env export -t 0x82000000 xfhstage; then
         fatwrite mmc 0:1 0x82000000 E06_N.TXT ${filesize}
        fi
       fi
      else
       setenv xfh_ok 0
       setenv xfhstage 'V12 chunk 06 FAT save FAILED'
       if env export -t 0x82000000 xfhstage; then
        fatwrite mmc 0:1 0x82000000 E06_N.TXT ${filesize}
       fi
      fi
     else
      setenv xfh_ok 0
      setenv xfhstage 'V12 chunk 06 two SPI reads mismatch'
      if env export -t 0x82000000 xfhstage; then
       fatwrite mmc 0:1 0x82000000 E06_N.TXT ${filesize}
      fi
     fi
    else
     setenv xfh_ok 0
     setenv xfhstage 'V12 chunk 06 second SPI read FAILED'
     if env export -t 0x82000000 xfhstage; then
      fatwrite mmc 0:1 0x82000000 E06_N.TXT ${filesize}
     fi
    fi
   else
    setenv xfh_ok 0
    setenv xfhstage 'V12 chunk 06 first SPI read FAILED'
    if env export -t 0x82000000 xfhstage; then
     fatwrite mmc 0:1 0x82000000 E06_N.TXT ${filesize}
    fi
   fi
  fi
  # Chunk 07: flash offset 0x1C0000, length 0x40000, output F07.BIN
  if test "${xfh_ok}" = "1"; then
   if sf read 0x81000000 0x1C0000 0x40000; then
    if sf read 0x81100000 0x1C0000 0x40000; then
     if cmp.b 0x81000000 0x81100000 0x40000; then
      if fatwrite mmc 0:1 0x81000000 F07.BIN 0x40000; then
       if fatload mmc 0:1 0x81200000 F07.BIN; then
        if cmp.b 0x81000000 0x81200000 0x40000; then
         setenv xfhstage 'V12 chunk 07 of 32 double-read and FAT verified'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 P07_Y.TXT ${filesize}
         fi
        else
         setenv xfh_ok 0
         setenv xfhstage 'V12 chunk 07 FAT comparison FAILED'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 E07_N.TXT ${filesize}
         fi
        fi
       else
        setenv xfh_ok 0
        setenv xfhstage 'V12 chunk 07 FAT reload FAILED'
        if env export -t 0x82000000 xfhstage; then
         fatwrite mmc 0:1 0x82000000 E07_N.TXT ${filesize}
        fi
       fi
      else
       setenv xfh_ok 0
       setenv xfhstage 'V12 chunk 07 FAT save FAILED'
       if env export -t 0x82000000 xfhstage; then
        fatwrite mmc 0:1 0x82000000 E07_N.TXT ${filesize}
       fi
      fi
     else
      setenv xfh_ok 0
      setenv xfhstage 'V12 chunk 07 two SPI reads mismatch'
      if env export -t 0x82000000 xfhstage; then
       fatwrite mmc 0:1 0x82000000 E07_N.TXT ${filesize}
      fi
     fi
    else
     setenv xfh_ok 0
     setenv xfhstage 'V12 chunk 07 second SPI read FAILED'
     if env export -t 0x82000000 xfhstage; then
      fatwrite mmc 0:1 0x82000000 E07_N.TXT ${filesize}
     fi
    fi
   else
    setenv xfh_ok 0
    setenv xfhstage 'V12 chunk 07 first SPI read FAILED'
    if env export -t 0x82000000 xfhstage; then
     fatwrite mmc 0:1 0x82000000 E07_N.TXT ${filesize}
    fi
   fi
  fi
  # Chunk 08: flash offset 0x200000, length 0x40000, output F08.BIN
  if test "${xfh_ok}" = "1"; then
   if sf read 0x81000000 0x200000 0x40000; then
    if sf read 0x81100000 0x200000 0x40000; then
     if cmp.b 0x81000000 0x81100000 0x40000; then
      if fatwrite mmc 0:1 0x81000000 F08.BIN 0x40000; then
       if fatload mmc 0:1 0x81200000 F08.BIN; then
        if cmp.b 0x81000000 0x81200000 0x40000; then
         setenv xfhstage 'V12 chunk 08 of 32 double-read and FAT verified'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 P08_Y.TXT ${filesize}
         fi
        else
         setenv xfh_ok 0
         setenv xfhstage 'V12 chunk 08 FAT comparison FAILED'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 E08_N.TXT ${filesize}
         fi
        fi
       else
        setenv xfh_ok 0
        setenv xfhstage 'V12 chunk 08 FAT reload FAILED'
        if env export -t 0x82000000 xfhstage; then
         fatwrite mmc 0:1 0x82000000 E08_N.TXT ${filesize}
        fi
       fi
      else
       setenv xfh_ok 0
       setenv xfhstage 'V12 chunk 08 FAT save FAILED'
       if env export -t 0x82000000 xfhstage; then
        fatwrite mmc 0:1 0x82000000 E08_N.TXT ${filesize}
       fi
      fi
     else
      setenv xfh_ok 0
      setenv xfhstage 'V12 chunk 08 two SPI reads mismatch'
      if env export -t 0x82000000 xfhstage; then
       fatwrite mmc 0:1 0x82000000 E08_N.TXT ${filesize}
      fi
     fi
    else
     setenv xfh_ok 0
     setenv xfhstage 'V12 chunk 08 second SPI read FAILED'
     if env export -t 0x82000000 xfhstage; then
      fatwrite mmc 0:1 0x82000000 E08_N.TXT ${filesize}
     fi
    fi
   else
    setenv xfh_ok 0
    setenv xfhstage 'V12 chunk 08 first SPI read FAILED'
    if env export -t 0x82000000 xfhstage; then
     fatwrite mmc 0:1 0x82000000 E08_N.TXT ${filesize}
    fi
   fi
  fi
  # Chunk 09: flash offset 0x240000, length 0x40000, output F09.BIN
  if test "${xfh_ok}" = "1"; then
   if sf read 0x81000000 0x240000 0x40000; then
    if sf read 0x81100000 0x240000 0x40000; then
     if cmp.b 0x81000000 0x81100000 0x40000; then
      if fatwrite mmc 0:1 0x81000000 F09.BIN 0x40000; then
       if fatload mmc 0:1 0x81200000 F09.BIN; then
        if cmp.b 0x81000000 0x81200000 0x40000; then
         setenv xfhstage 'V12 chunk 09 of 32 double-read and FAT verified'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 P09_Y.TXT ${filesize}
         fi
        else
         setenv xfh_ok 0
         setenv xfhstage 'V12 chunk 09 FAT comparison FAILED'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 E09_N.TXT ${filesize}
         fi
        fi
       else
        setenv xfh_ok 0
        setenv xfhstage 'V12 chunk 09 FAT reload FAILED'
        if env export -t 0x82000000 xfhstage; then
         fatwrite mmc 0:1 0x82000000 E09_N.TXT ${filesize}
        fi
       fi
      else
       setenv xfh_ok 0
       setenv xfhstage 'V12 chunk 09 FAT save FAILED'
       if env export -t 0x82000000 xfhstage; then
        fatwrite mmc 0:1 0x82000000 E09_N.TXT ${filesize}
       fi
      fi
     else
      setenv xfh_ok 0
      setenv xfhstage 'V12 chunk 09 two SPI reads mismatch'
      if env export -t 0x82000000 xfhstage; then
       fatwrite mmc 0:1 0x82000000 E09_N.TXT ${filesize}
      fi
     fi
    else
     setenv xfh_ok 0
     setenv xfhstage 'V12 chunk 09 second SPI read FAILED'
     if env export -t 0x82000000 xfhstage; then
      fatwrite mmc 0:1 0x82000000 E09_N.TXT ${filesize}
     fi
    fi
   else
    setenv xfh_ok 0
    setenv xfhstage 'V12 chunk 09 first SPI read FAILED'
    if env export -t 0x82000000 xfhstage; then
     fatwrite mmc 0:1 0x82000000 E09_N.TXT ${filesize}
    fi
   fi
  fi
  # Chunk 10: flash offset 0x280000, length 0x40000, output F10.BIN
  if test "${xfh_ok}" = "1"; then
   if sf read 0x81000000 0x280000 0x40000; then
    if sf read 0x81100000 0x280000 0x40000; then
     if cmp.b 0x81000000 0x81100000 0x40000; then
      if fatwrite mmc 0:1 0x81000000 F10.BIN 0x40000; then
       if fatload mmc 0:1 0x81200000 F10.BIN; then
        if cmp.b 0x81000000 0x81200000 0x40000; then
         setenv xfhstage 'V12 chunk 10 of 32 double-read and FAT verified'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 P10_Y.TXT ${filesize}
         fi
        else
         setenv xfh_ok 0
         setenv xfhstage 'V12 chunk 10 FAT comparison FAILED'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 E10_N.TXT ${filesize}
         fi
        fi
       else
        setenv xfh_ok 0
        setenv xfhstage 'V12 chunk 10 FAT reload FAILED'
        if env export -t 0x82000000 xfhstage; then
         fatwrite mmc 0:1 0x82000000 E10_N.TXT ${filesize}
        fi
       fi
      else
       setenv xfh_ok 0
       setenv xfhstage 'V12 chunk 10 FAT save FAILED'
       if env export -t 0x82000000 xfhstage; then
        fatwrite mmc 0:1 0x82000000 E10_N.TXT ${filesize}
       fi
      fi
     else
      setenv xfh_ok 0
      setenv xfhstage 'V12 chunk 10 two SPI reads mismatch'
      if env export -t 0x82000000 xfhstage; then
       fatwrite mmc 0:1 0x82000000 E10_N.TXT ${filesize}
      fi
     fi
    else
     setenv xfh_ok 0
     setenv xfhstage 'V12 chunk 10 second SPI read FAILED'
     if env export -t 0x82000000 xfhstage; then
      fatwrite mmc 0:1 0x82000000 E10_N.TXT ${filesize}
     fi
    fi
   else
    setenv xfh_ok 0
    setenv xfhstage 'V12 chunk 10 first SPI read FAILED'
    if env export -t 0x82000000 xfhstage; then
     fatwrite mmc 0:1 0x82000000 E10_N.TXT ${filesize}
    fi
   fi
  fi
  # Chunk 11: flash offset 0x2C0000, length 0x40000, output F11.BIN
  if test "${xfh_ok}" = "1"; then
   if sf read 0x81000000 0x2C0000 0x40000; then
    if sf read 0x81100000 0x2C0000 0x40000; then
     if cmp.b 0x81000000 0x81100000 0x40000; then
      if fatwrite mmc 0:1 0x81000000 F11.BIN 0x40000; then
       if fatload mmc 0:1 0x81200000 F11.BIN; then
        if cmp.b 0x81000000 0x81200000 0x40000; then
         setenv xfhstage 'V12 chunk 11 of 32 double-read and FAT verified'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 P11_Y.TXT ${filesize}
         fi
        else
         setenv xfh_ok 0
         setenv xfhstage 'V12 chunk 11 FAT comparison FAILED'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 E11_N.TXT ${filesize}
         fi
        fi
       else
        setenv xfh_ok 0
        setenv xfhstage 'V12 chunk 11 FAT reload FAILED'
        if env export -t 0x82000000 xfhstage; then
         fatwrite mmc 0:1 0x82000000 E11_N.TXT ${filesize}
        fi
       fi
      else
       setenv xfh_ok 0
       setenv xfhstage 'V12 chunk 11 FAT save FAILED'
       if env export -t 0x82000000 xfhstage; then
        fatwrite mmc 0:1 0x82000000 E11_N.TXT ${filesize}
       fi
      fi
     else
      setenv xfh_ok 0
      setenv xfhstage 'V12 chunk 11 two SPI reads mismatch'
      if env export -t 0x82000000 xfhstage; then
       fatwrite mmc 0:1 0x82000000 E11_N.TXT ${filesize}
      fi
     fi
    else
     setenv xfh_ok 0
     setenv xfhstage 'V12 chunk 11 second SPI read FAILED'
     if env export -t 0x82000000 xfhstage; then
      fatwrite mmc 0:1 0x82000000 E11_N.TXT ${filesize}
     fi
    fi
   else
    setenv xfh_ok 0
    setenv xfhstage 'V12 chunk 11 first SPI read FAILED'
    if env export -t 0x82000000 xfhstage; then
     fatwrite mmc 0:1 0x82000000 E11_N.TXT ${filesize}
    fi
   fi
  fi
  # Chunk 12: flash offset 0x300000, length 0x40000, output F12.BIN
  if test "${xfh_ok}" = "1"; then
   if sf read 0x81000000 0x300000 0x40000; then
    if sf read 0x81100000 0x300000 0x40000; then
     if cmp.b 0x81000000 0x81100000 0x40000; then
      if fatwrite mmc 0:1 0x81000000 F12.BIN 0x40000; then
       if fatload mmc 0:1 0x81200000 F12.BIN; then
        if cmp.b 0x81000000 0x81200000 0x40000; then
         setenv xfhstage 'V12 chunk 12 of 32 double-read and FAT verified'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 P12_Y.TXT ${filesize}
         fi
        else
         setenv xfh_ok 0
         setenv xfhstage 'V12 chunk 12 FAT comparison FAILED'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 E12_N.TXT ${filesize}
         fi
        fi
       else
        setenv xfh_ok 0
        setenv xfhstage 'V12 chunk 12 FAT reload FAILED'
        if env export -t 0x82000000 xfhstage; then
         fatwrite mmc 0:1 0x82000000 E12_N.TXT ${filesize}
        fi
       fi
      else
       setenv xfh_ok 0
       setenv xfhstage 'V12 chunk 12 FAT save FAILED'
       if env export -t 0x82000000 xfhstage; then
        fatwrite mmc 0:1 0x82000000 E12_N.TXT ${filesize}
       fi
      fi
     else
      setenv xfh_ok 0
      setenv xfhstage 'V12 chunk 12 two SPI reads mismatch'
      if env export -t 0x82000000 xfhstage; then
       fatwrite mmc 0:1 0x82000000 E12_N.TXT ${filesize}
      fi
     fi
    else
     setenv xfh_ok 0
     setenv xfhstage 'V12 chunk 12 second SPI read FAILED'
     if env export -t 0x82000000 xfhstage; then
      fatwrite mmc 0:1 0x82000000 E12_N.TXT ${filesize}
     fi
    fi
   else
    setenv xfh_ok 0
    setenv xfhstage 'V12 chunk 12 first SPI read FAILED'
    if env export -t 0x82000000 xfhstage; then
     fatwrite mmc 0:1 0x82000000 E12_N.TXT ${filesize}
    fi
   fi
  fi
  # Chunk 13: flash offset 0x340000, length 0x40000, output F13.BIN
  if test "${xfh_ok}" = "1"; then
   if sf read 0x81000000 0x340000 0x40000; then
    if sf read 0x81100000 0x340000 0x40000; then
     if cmp.b 0x81000000 0x81100000 0x40000; then
      if fatwrite mmc 0:1 0x81000000 F13.BIN 0x40000; then
       if fatload mmc 0:1 0x81200000 F13.BIN; then
        if cmp.b 0x81000000 0x81200000 0x40000; then
         setenv xfhstage 'V12 chunk 13 of 32 double-read and FAT verified'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 P13_Y.TXT ${filesize}
         fi
        else
         setenv xfh_ok 0
         setenv xfhstage 'V12 chunk 13 FAT comparison FAILED'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 E13_N.TXT ${filesize}
         fi
        fi
       else
        setenv xfh_ok 0
        setenv xfhstage 'V12 chunk 13 FAT reload FAILED'
        if env export -t 0x82000000 xfhstage; then
         fatwrite mmc 0:1 0x82000000 E13_N.TXT ${filesize}
        fi
       fi
      else
       setenv xfh_ok 0
       setenv xfhstage 'V12 chunk 13 FAT save FAILED'
       if env export -t 0x82000000 xfhstage; then
        fatwrite mmc 0:1 0x82000000 E13_N.TXT ${filesize}
       fi
      fi
     else
      setenv xfh_ok 0
      setenv xfhstage 'V12 chunk 13 two SPI reads mismatch'
      if env export -t 0x82000000 xfhstage; then
       fatwrite mmc 0:1 0x82000000 E13_N.TXT ${filesize}
      fi
     fi
    else
     setenv xfh_ok 0
     setenv xfhstage 'V12 chunk 13 second SPI read FAILED'
     if env export -t 0x82000000 xfhstage; then
      fatwrite mmc 0:1 0x82000000 E13_N.TXT ${filesize}
     fi
    fi
   else
    setenv xfh_ok 0
    setenv xfhstage 'V12 chunk 13 first SPI read FAILED'
    if env export -t 0x82000000 xfhstage; then
     fatwrite mmc 0:1 0x82000000 E13_N.TXT ${filesize}
    fi
   fi
  fi
  # Chunk 14: flash offset 0x380000, length 0x40000, output F14.BIN
  if test "${xfh_ok}" = "1"; then
   if sf read 0x81000000 0x380000 0x40000; then
    if sf read 0x81100000 0x380000 0x40000; then
     if cmp.b 0x81000000 0x81100000 0x40000; then
      if fatwrite mmc 0:1 0x81000000 F14.BIN 0x40000; then
       if fatload mmc 0:1 0x81200000 F14.BIN; then
        if cmp.b 0x81000000 0x81200000 0x40000; then
         setenv xfhstage 'V12 chunk 14 of 32 double-read and FAT verified'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 P14_Y.TXT ${filesize}
         fi
        else
         setenv xfh_ok 0
         setenv xfhstage 'V12 chunk 14 FAT comparison FAILED'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 E14_N.TXT ${filesize}
         fi
        fi
       else
        setenv xfh_ok 0
        setenv xfhstage 'V12 chunk 14 FAT reload FAILED'
        if env export -t 0x82000000 xfhstage; then
         fatwrite mmc 0:1 0x82000000 E14_N.TXT ${filesize}
        fi
       fi
      else
       setenv xfh_ok 0
       setenv xfhstage 'V12 chunk 14 FAT save FAILED'
       if env export -t 0x82000000 xfhstage; then
        fatwrite mmc 0:1 0x82000000 E14_N.TXT ${filesize}
       fi
      fi
     else
      setenv xfh_ok 0
      setenv xfhstage 'V12 chunk 14 two SPI reads mismatch'
      if env export -t 0x82000000 xfhstage; then
       fatwrite mmc 0:1 0x82000000 E14_N.TXT ${filesize}
      fi
     fi
    else
     setenv xfh_ok 0
     setenv xfhstage 'V12 chunk 14 second SPI read FAILED'
     if env export -t 0x82000000 xfhstage; then
      fatwrite mmc 0:1 0x82000000 E14_N.TXT ${filesize}
     fi
    fi
   else
    setenv xfh_ok 0
    setenv xfhstage 'V12 chunk 14 first SPI read FAILED'
    if env export -t 0x82000000 xfhstage; then
     fatwrite mmc 0:1 0x82000000 E14_N.TXT ${filesize}
    fi
   fi
  fi
  # Chunk 15: flash offset 0x3C0000, length 0x40000, output F15.BIN
  if test "${xfh_ok}" = "1"; then
   if sf read 0x81000000 0x3C0000 0x40000; then
    if sf read 0x81100000 0x3C0000 0x40000; then
     if cmp.b 0x81000000 0x81100000 0x40000; then
      if fatwrite mmc 0:1 0x81000000 F15.BIN 0x40000; then
       if fatload mmc 0:1 0x81200000 F15.BIN; then
        if cmp.b 0x81000000 0x81200000 0x40000; then
         setenv xfhstage 'V12 chunk 15 of 32 double-read and FAT verified'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 P15_Y.TXT ${filesize}
         fi
        else
         setenv xfh_ok 0
         setenv xfhstage 'V12 chunk 15 FAT comparison FAILED'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 E15_N.TXT ${filesize}
         fi
        fi
       else
        setenv xfh_ok 0
        setenv xfhstage 'V12 chunk 15 FAT reload FAILED'
        if env export -t 0x82000000 xfhstage; then
         fatwrite mmc 0:1 0x82000000 E15_N.TXT ${filesize}
        fi
       fi
      else
       setenv xfh_ok 0
       setenv xfhstage 'V12 chunk 15 FAT save FAILED'
       if env export -t 0x82000000 xfhstage; then
        fatwrite mmc 0:1 0x82000000 E15_N.TXT ${filesize}
       fi
      fi
     else
      setenv xfh_ok 0
      setenv xfhstage 'V12 chunk 15 two SPI reads mismatch'
      if env export -t 0x82000000 xfhstage; then
       fatwrite mmc 0:1 0x82000000 E15_N.TXT ${filesize}
      fi
     fi
    else
     setenv xfh_ok 0
     setenv xfhstage 'V12 chunk 15 second SPI read FAILED'
     if env export -t 0x82000000 xfhstage; then
      fatwrite mmc 0:1 0x82000000 E15_N.TXT ${filesize}
     fi
    fi
   else
    setenv xfh_ok 0
    setenv xfhstage 'V12 chunk 15 first SPI read FAILED'
    if env export -t 0x82000000 xfhstage; then
     fatwrite mmc 0:1 0x82000000 E15_N.TXT ${filesize}
    fi
   fi
  fi
  # Chunk 16: flash offset 0x400000, length 0x40000, output F16.BIN
  if test "${xfh_ok}" = "1"; then
   if sf read 0x81000000 0x400000 0x40000; then
    if sf read 0x81100000 0x400000 0x40000; then
     if cmp.b 0x81000000 0x81100000 0x40000; then
      if fatwrite mmc 0:1 0x81000000 F16.BIN 0x40000; then
       if fatload mmc 0:1 0x81200000 F16.BIN; then
        if cmp.b 0x81000000 0x81200000 0x40000; then
         setenv xfhstage 'V12 chunk 16 of 32 double-read and FAT verified'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 P16_Y.TXT ${filesize}
         fi
        else
         setenv xfh_ok 0
         setenv xfhstage 'V12 chunk 16 FAT comparison FAILED'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 E16_N.TXT ${filesize}
         fi
        fi
       else
        setenv xfh_ok 0
        setenv xfhstage 'V12 chunk 16 FAT reload FAILED'
        if env export -t 0x82000000 xfhstage; then
         fatwrite mmc 0:1 0x82000000 E16_N.TXT ${filesize}
        fi
       fi
      else
       setenv xfh_ok 0
       setenv xfhstage 'V12 chunk 16 FAT save FAILED'
       if env export -t 0x82000000 xfhstage; then
        fatwrite mmc 0:1 0x82000000 E16_N.TXT ${filesize}
       fi
      fi
     else
      setenv xfh_ok 0
      setenv xfhstage 'V12 chunk 16 two SPI reads mismatch'
      if env export -t 0x82000000 xfhstage; then
       fatwrite mmc 0:1 0x82000000 E16_N.TXT ${filesize}
      fi
     fi
    else
     setenv xfh_ok 0
     setenv xfhstage 'V12 chunk 16 second SPI read FAILED'
     if env export -t 0x82000000 xfhstage; then
      fatwrite mmc 0:1 0x82000000 E16_N.TXT ${filesize}
     fi
    fi
   else
    setenv xfh_ok 0
    setenv xfhstage 'V12 chunk 16 first SPI read FAILED'
    if env export -t 0x82000000 xfhstage; then
     fatwrite mmc 0:1 0x82000000 E16_N.TXT ${filesize}
    fi
   fi
  fi
  # Chunk 17: flash offset 0x440000, length 0x40000, output F17.BIN
  if test "${xfh_ok}" = "1"; then
   if sf read 0x81000000 0x440000 0x40000; then
    if sf read 0x81100000 0x440000 0x40000; then
     if cmp.b 0x81000000 0x81100000 0x40000; then
      if fatwrite mmc 0:1 0x81000000 F17.BIN 0x40000; then
       if fatload mmc 0:1 0x81200000 F17.BIN; then
        if cmp.b 0x81000000 0x81200000 0x40000; then
         setenv xfhstage 'V12 chunk 17 of 32 double-read and FAT verified'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 P17_Y.TXT ${filesize}
         fi
        else
         setenv xfh_ok 0
         setenv xfhstage 'V12 chunk 17 FAT comparison FAILED'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 E17_N.TXT ${filesize}
         fi
        fi
       else
        setenv xfh_ok 0
        setenv xfhstage 'V12 chunk 17 FAT reload FAILED'
        if env export -t 0x82000000 xfhstage; then
         fatwrite mmc 0:1 0x82000000 E17_N.TXT ${filesize}
        fi
       fi
      else
       setenv xfh_ok 0
       setenv xfhstage 'V12 chunk 17 FAT save FAILED'
       if env export -t 0x82000000 xfhstage; then
        fatwrite mmc 0:1 0x82000000 E17_N.TXT ${filesize}
       fi
      fi
     else
      setenv xfh_ok 0
      setenv xfhstage 'V12 chunk 17 two SPI reads mismatch'
      if env export -t 0x82000000 xfhstage; then
       fatwrite mmc 0:1 0x82000000 E17_N.TXT ${filesize}
      fi
     fi
    else
     setenv xfh_ok 0
     setenv xfhstage 'V12 chunk 17 second SPI read FAILED'
     if env export -t 0x82000000 xfhstage; then
      fatwrite mmc 0:1 0x82000000 E17_N.TXT ${filesize}
     fi
    fi
   else
    setenv xfh_ok 0
    setenv xfhstage 'V12 chunk 17 first SPI read FAILED'
    if env export -t 0x82000000 xfhstage; then
     fatwrite mmc 0:1 0x82000000 E17_N.TXT ${filesize}
    fi
   fi
  fi
  # Chunk 18: flash offset 0x480000, length 0x40000, output F18.BIN
  if test "${xfh_ok}" = "1"; then
   if sf read 0x81000000 0x480000 0x40000; then
    if sf read 0x81100000 0x480000 0x40000; then
     if cmp.b 0x81000000 0x81100000 0x40000; then
      if fatwrite mmc 0:1 0x81000000 F18.BIN 0x40000; then
       if fatload mmc 0:1 0x81200000 F18.BIN; then
        if cmp.b 0x81000000 0x81200000 0x40000; then
         setenv xfhstage 'V12 chunk 18 of 32 double-read and FAT verified'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 P18_Y.TXT ${filesize}
         fi
        else
         setenv xfh_ok 0
         setenv xfhstage 'V12 chunk 18 FAT comparison FAILED'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 E18_N.TXT ${filesize}
         fi
        fi
       else
        setenv xfh_ok 0
        setenv xfhstage 'V12 chunk 18 FAT reload FAILED'
        if env export -t 0x82000000 xfhstage; then
         fatwrite mmc 0:1 0x82000000 E18_N.TXT ${filesize}
        fi
       fi
      else
       setenv xfh_ok 0
       setenv xfhstage 'V12 chunk 18 FAT save FAILED'
       if env export -t 0x82000000 xfhstage; then
        fatwrite mmc 0:1 0x82000000 E18_N.TXT ${filesize}
       fi
      fi
     else
      setenv xfh_ok 0
      setenv xfhstage 'V12 chunk 18 two SPI reads mismatch'
      if env export -t 0x82000000 xfhstage; then
       fatwrite mmc 0:1 0x82000000 E18_N.TXT ${filesize}
      fi
     fi
    else
     setenv xfh_ok 0
     setenv xfhstage 'V12 chunk 18 second SPI read FAILED'
     if env export -t 0x82000000 xfhstage; then
      fatwrite mmc 0:1 0x82000000 E18_N.TXT ${filesize}
     fi
    fi
   else
    setenv xfh_ok 0
    setenv xfhstage 'V12 chunk 18 first SPI read FAILED'
    if env export -t 0x82000000 xfhstage; then
     fatwrite mmc 0:1 0x82000000 E18_N.TXT ${filesize}
    fi
   fi
  fi
  # Chunk 19: flash offset 0x4C0000, length 0x40000, output F19.BIN
  if test "${xfh_ok}" = "1"; then
   if sf read 0x81000000 0x4C0000 0x40000; then
    if sf read 0x81100000 0x4C0000 0x40000; then
     if cmp.b 0x81000000 0x81100000 0x40000; then
      if fatwrite mmc 0:1 0x81000000 F19.BIN 0x40000; then
       if fatload mmc 0:1 0x81200000 F19.BIN; then
        if cmp.b 0x81000000 0x81200000 0x40000; then
         setenv xfhstage 'V12 chunk 19 of 32 double-read and FAT verified'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 P19_Y.TXT ${filesize}
         fi
        else
         setenv xfh_ok 0
         setenv xfhstage 'V12 chunk 19 FAT comparison FAILED'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 E19_N.TXT ${filesize}
         fi
        fi
       else
        setenv xfh_ok 0
        setenv xfhstage 'V12 chunk 19 FAT reload FAILED'
        if env export -t 0x82000000 xfhstage; then
         fatwrite mmc 0:1 0x82000000 E19_N.TXT ${filesize}
        fi
       fi
      else
       setenv xfh_ok 0
       setenv xfhstage 'V12 chunk 19 FAT save FAILED'
       if env export -t 0x82000000 xfhstage; then
        fatwrite mmc 0:1 0x82000000 E19_N.TXT ${filesize}
       fi
      fi
     else
      setenv xfh_ok 0
      setenv xfhstage 'V12 chunk 19 two SPI reads mismatch'
      if env export -t 0x82000000 xfhstage; then
       fatwrite mmc 0:1 0x82000000 E19_N.TXT ${filesize}
      fi
     fi
    else
     setenv xfh_ok 0
     setenv xfhstage 'V12 chunk 19 second SPI read FAILED'
     if env export -t 0x82000000 xfhstage; then
      fatwrite mmc 0:1 0x82000000 E19_N.TXT ${filesize}
     fi
    fi
   else
    setenv xfh_ok 0
    setenv xfhstage 'V12 chunk 19 first SPI read FAILED'
    if env export -t 0x82000000 xfhstage; then
     fatwrite mmc 0:1 0x82000000 E19_N.TXT ${filesize}
    fi
   fi
  fi
  # Chunk 20: flash offset 0x500000, length 0x40000, output F20.BIN
  if test "${xfh_ok}" = "1"; then
   if sf read 0x81000000 0x500000 0x40000; then
    if sf read 0x81100000 0x500000 0x40000; then
     if cmp.b 0x81000000 0x81100000 0x40000; then
      if fatwrite mmc 0:1 0x81000000 F20.BIN 0x40000; then
       if fatload mmc 0:1 0x81200000 F20.BIN; then
        if cmp.b 0x81000000 0x81200000 0x40000; then
         setenv xfhstage 'V12 chunk 20 of 32 double-read and FAT verified'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 P20_Y.TXT ${filesize}
         fi
        else
         setenv xfh_ok 0
         setenv xfhstage 'V12 chunk 20 FAT comparison FAILED'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 E20_N.TXT ${filesize}
         fi
        fi
       else
        setenv xfh_ok 0
        setenv xfhstage 'V12 chunk 20 FAT reload FAILED'
        if env export -t 0x82000000 xfhstage; then
         fatwrite mmc 0:1 0x82000000 E20_N.TXT ${filesize}
        fi
       fi
      else
       setenv xfh_ok 0
       setenv xfhstage 'V12 chunk 20 FAT save FAILED'
       if env export -t 0x82000000 xfhstage; then
        fatwrite mmc 0:1 0x82000000 E20_N.TXT ${filesize}
       fi
      fi
     else
      setenv xfh_ok 0
      setenv xfhstage 'V12 chunk 20 two SPI reads mismatch'
      if env export -t 0x82000000 xfhstage; then
       fatwrite mmc 0:1 0x82000000 E20_N.TXT ${filesize}
      fi
     fi
    else
     setenv xfh_ok 0
     setenv xfhstage 'V12 chunk 20 second SPI read FAILED'
     if env export -t 0x82000000 xfhstage; then
      fatwrite mmc 0:1 0x82000000 E20_N.TXT ${filesize}
     fi
    fi
   else
    setenv xfh_ok 0
    setenv xfhstage 'V12 chunk 20 first SPI read FAILED'
    if env export -t 0x82000000 xfhstage; then
     fatwrite mmc 0:1 0x82000000 E20_N.TXT ${filesize}
    fi
   fi
  fi
  # Chunk 21: flash offset 0x540000, length 0x40000, output F21.BIN
  if test "${xfh_ok}" = "1"; then
   if sf read 0x81000000 0x540000 0x40000; then
    if sf read 0x81100000 0x540000 0x40000; then
     if cmp.b 0x81000000 0x81100000 0x40000; then
      if fatwrite mmc 0:1 0x81000000 F21.BIN 0x40000; then
       if fatload mmc 0:1 0x81200000 F21.BIN; then
        if cmp.b 0x81000000 0x81200000 0x40000; then
         setenv xfhstage 'V12 chunk 21 of 32 double-read and FAT verified'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 P21_Y.TXT ${filesize}
         fi
        else
         setenv xfh_ok 0
         setenv xfhstage 'V12 chunk 21 FAT comparison FAILED'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 E21_N.TXT ${filesize}
         fi
        fi
       else
        setenv xfh_ok 0
        setenv xfhstage 'V12 chunk 21 FAT reload FAILED'
        if env export -t 0x82000000 xfhstage; then
         fatwrite mmc 0:1 0x82000000 E21_N.TXT ${filesize}
        fi
       fi
      else
       setenv xfh_ok 0
       setenv xfhstage 'V12 chunk 21 FAT save FAILED'
       if env export -t 0x82000000 xfhstage; then
        fatwrite mmc 0:1 0x82000000 E21_N.TXT ${filesize}
       fi
      fi
     else
      setenv xfh_ok 0
      setenv xfhstage 'V12 chunk 21 two SPI reads mismatch'
      if env export -t 0x82000000 xfhstage; then
       fatwrite mmc 0:1 0x82000000 E21_N.TXT ${filesize}
      fi
     fi
    else
     setenv xfh_ok 0
     setenv xfhstage 'V12 chunk 21 second SPI read FAILED'
     if env export -t 0x82000000 xfhstage; then
      fatwrite mmc 0:1 0x82000000 E21_N.TXT ${filesize}
     fi
    fi
   else
    setenv xfh_ok 0
    setenv xfhstage 'V12 chunk 21 first SPI read FAILED'
    if env export -t 0x82000000 xfhstage; then
     fatwrite mmc 0:1 0x82000000 E21_N.TXT ${filesize}
    fi
   fi
  fi
  # Chunk 22: flash offset 0x580000, length 0x40000, output F22.BIN
  if test "${xfh_ok}" = "1"; then
   if sf read 0x81000000 0x580000 0x40000; then
    if sf read 0x81100000 0x580000 0x40000; then
     if cmp.b 0x81000000 0x81100000 0x40000; then
      if fatwrite mmc 0:1 0x81000000 F22.BIN 0x40000; then
       if fatload mmc 0:1 0x81200000 F22.BIN; then
        if cmp.b 0x81000000 0x81200000 0x40000; then
         setenv xfhstage 'V12 chunk 22 of 32 double-read and FAT verified'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 P22_Y.TXT ${filesize}
         fi
        else
         setenv xfh_ok 0
         setenv xfhstage 'V12 chunk 22 FAT comparison FAILED'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 E22_N.TXT ${filesize}
         fi
        fi
       else
        setenv xfh_ok 0
        setenv xfhstage 'V12 chunk 22 FAT reload FAILED'
        if env export -t 0x82000000 xfhstage; then
         fatwrite mmc 0:1 0x82000000 E22_N.TXT ${filesize}
        fi
       fi
      else
       setenv xfh_ok 0
       setenv xfhstage 'V12 chunk 22 FAT save FAILED'
       if env export -t 0x82000000 xfhstage; then
        fatwrite mmc 0:1 0x82000000 E22_N.TXT ${filesize}
       fi
      fi
     else
      setenv xfh_ok 0
      setenv xfhstage 'V12 chunk 22 two SPI reads mismatch'
      if env export -t 0x82000000 xfhstage; then
       fatwrite mmc 0:1 0x82000000 E22_N.TXT ${filesize}
      fi
     fi
    else
     setenv xfh_ok 0
     setenv xfhstage 'V12 chunk 22 second SPI read FAILED'
     if env export -t 0x82000000 xfhstage; then
      fatwrite mmc 0:1 0x82000000 E22_N.TXT ${filesize}
     fi
    fi
   else
    setenv xfh_ok 0
    setenv xfhstage 'V12 chunk 22 first SPI read FAILED'
    if env export -t 0x82000000 xfhstage; then
     fatwrite mmc 0:1 0x82000000 E22_N.TXT ${filesize}
    fi
   fi
  fi
  # Chunk 23: flash offset 0x5C0000, length 0x40000, output F23.BIN
  if test "${xfh_ok}" = "1"; then
   if sf read 0x81000000 0x5C0000 0x40000; then
    if sf read 0x81100000 0x5C0000 0x40000; then
     if cmp.b 0x81000000 0x81100000 0x40000; then
      if fatwrite mmc 0:1 0x81000000 F23.BIN 0x40000; then
       if fatload mmc 0:1 0x81200000 F23.BIN; then
        if cmp.b 0x81000000 0x81200000 0x40000; then
         setenv xfhstage 'V12 chunk 23 of 32 double-read and FAT verified'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 P23_Y.TXT ${filesize}
         fi
        else
         setenv xfh_ok 0
         setenv xfhstage 'V12 chunk 23 FAT comparison FAILED'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 E23_N.TXT ${filesize}
         fi
        fi
       else
        setenv xfh_ok 0
        setenv xfhstage 'V12 chunk 23 FAT reload FAILED'
        if env export -t 0x82000000 xfhstage; then
         fatwrite mmc 0:1 0x82000000 E23_N.TXT ${filesize}
        fi
       fi
      else
       setenv xfh_ok 0
       setenv xfhstage 'V12 chunk 23 FAT save FAILED'
       if env export -t 0x82000000 xfhstage; then
        fatwrite mmc 0:1 0x82000000 E23_N.TXT ${filesize}
       fi
      fi
     else
      setenv xfh_ok 0
      setenv xfhstage 'V12 chunk 23 two SPI reads mismatch'
      if env export -t 0x82000000 xfhstage; then
       fatwrite mmc 0:1 0x82000000 E23_N.TXT ${filesize}
      fi
     fi
    else
     setenv xfh_ok 0
     setenv xfhstage 'V12 chunk 23 second SPI read FAILED'
     if env export -t 0x82000000 xfhstage; then
      fatwrite mmc 0:1 0x82000000 E23_N.TXT ${filesize}
     fi
    fi
   else
    setenv xfh_ok 0
    setenv xfhstage 'V12 chunk 23 first SPI read FAILED'
    if env export -t 0x82000000 xfhstage; then
     fatwrite mmc 0:1 0x82000000 E23_N.TXT ${filesize}
    fi
   fi
  fi
  # Chunk 24: flash offset 0x600000, length 0x40000, output F24.BIN
  if test "${xfh_ok}" = "1"; then
   if sf read 0x81000000 0x600000 0x40000; then
    if sf read 0x81100000 0x600000 0x40000; then
     if cmp.b 0x81000000 0x81100000 0x40000; then
      if fatwrite mmc 0:1 0x81000000 F24.BIN 0x40000; then
       if fatload mmc 0:1 0x81200000 F24.BIN; then
        if cmp.b 0x81000000 0x81200000 0x40000; then
         setenv xfhstage 'V12 chunk 24 of 32 double-read and FAT verified'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 P24_Y.TXT ${filesize}
         fi
        else
         setenv xfh_ok 0
         setenv xfhstage 'V12 chunk 24 FAT comparison FAILED'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 E24_N.TXT ${filesize}
         fi
        fi
       else
        setenv xfh_ok 0
        setenv xfhstage 'V12 chunk 24 FAT reload FAILED'
        if env export -t 0x82000000 xfhstage; then
         fatwrite mmc 0:1 0x82000000 E24_N.TXT ${filesize}
        fi
       fi
      else
       setenv xfh_ok 0
       setenv xfhstage 'V12 chunk 24 FAT save FAILED'
       if env export -t 0x82000000 xfhstage; then
        fatwrite mmc 0:1 0x82000000 E24_N.TXT ${filesize}
       fi
      fi
     else
      setenv xfh_ok 0
      setenv xfhstage 'V12 chunk 24 two SPI reads mismatch'
      if env export -t 0x82000000 xfhstage; then
       fatwrite mmc 0:1 0x82000000 E24_N.TXT ${filesize}
      fi
     fi
    else
     setenv xfh_ok 0
     setenv xfhstage 'V12 chunk 24 second SPI read FAILED'
     if env export -t 0x82000000 xfhstage; then
      fatwrite mmc 0:1 0x82000000 E24_N.TXT ${filesize}
     fi
    fi
   else
    setenv xfh_ok 0
    setenv xfhstage 'V12 chunk 24 first SPI read FAILED'
    if env export -t 0x82000000 xfhstage; then
     fatwrite mmc 0:1 0x82000000 E24_N.TXT ${filesize}
    fi
   fi
  fi
  # Chunk 25: flash offset 0x640000, length 0x40000, output F25.BIN
  if test "${xfh_ok}" = "1"; then
   if sf read 0x81000000 0x640000 0x40000; then
    if sf read 0x81100000 0x640000 0x40000; then
     if cmp.b 0x81000000 0x81100000 0x40000; then
      if fatwrite mmc 0:1 0x81000000 F25.BIN 0x40000; then
       if fatload mmc 0:1 0x81200000 F25.BIN; then
        if cmp.b 0x81000000 0x81200000 0x40000; then
         setenv xfhstage 'V12 chunk 25 of 32 double-read and FAT verified'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 P25_Y.TXT ${filesize}
         fi
        else
         setenv xfh_ok 0
         setenv xfhstage 'V12 chunk 25 FAT comparison FAILED'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 E25_N.TXT ${filesize}
         fi
        fi
       else
        setenv xfh_ok 0
        setenv xfhstage 'V12 chunk 25 FAT reload FAILED'
        if env export -t 0x82000000 xfhstage; then
         fatwrite mmc 0:1 0x82000000 E25_N.TXT ${filesize}
        fi
       fi
      else
       setenv xfh_ok 0
       setenv xfhstage 'V12 chunk 25 FAT save FAILED'
       if env export -t 0x82000000 xfhstage; then
        fatwrite mmc 0:1 0x82000000 E25_N.TXT ${filesize}
       fi
      fi
     else
      setenv xfh_ok 0
      setenv xfhstage 'V12 chunk 25 two SPI reads mismatch'
      if env export -t 0x82000000 xfhstage; then
       fatwrite mmc 0:1 0x82000000 E25_N.TXT ${filesize}
      fi
     fi
    else
     setenv xfh_ok 0
     setenv xfhstage 'V12 chunk 25 second SPI read FAILED'
     if env export -t 0x82000000 xfhstage; then
      fatwrite mmc 0:1 0x82000000 E25_N.TXT ${filesize}
     fi
    fi
   else
    setenv xfh_ok 0
    setenv xfhstage 'V12 chunk 25 first SPI read FAILED'
    if env export -t 0x82000000 xfhstage; then
     fatwrite mmc 0:1 0x82000000 E25_N.TXT ${filesize}
    fi
   fi
  fi
  # Chunk 26: flash offset 0x680000, length 0x40000, output F26.BIN
  if test "${xfh_ok}" = "1"; then
   if sf read 0x81000000 0x680000 0x40000; then
    if sf read 0x81100000 0x680000 0x40000; then
     if cmp.b 0x81000000 0x81100000 0x40000; then
      if fatwrite mmc 0:1 0x81000000 F26.BIN 0x40000; then
       if fatload mmc 0:1 0x81200000 F26.BIN; then
        if cmp.b 0x81000000 0x81200000 0x40000; then
         setenv xfhstage 'V12 chunk 26 of 32 double-read and FAT verified'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 P26_Y.TXT ${filesize}
         fi
        else
         setenv xfh_ok 0
         setenv xfhstage 'V12 chunk 26 FAT comparison FAILED'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 E26_N.TXT ${filesize}
         fi
        fi
       else
        setenv xfh_ok 0
        setenv xfhstage 'V12 chunk 26 FAT reload FAILED'
        if env export -t 0x82000000 xfhstage; then
         fatwrite mmc 0:1 0x82000000 E26_N.TXT ${filesize}
        fi
       fi
      else
       setenv xfh_ok 0
       setenv xfhstage 'V12 chunk 26 FAT save FAILED'
       if env export -t 0x82000000 xfhstage; then
        fatwrite mmc 0:1 0x82000000 E26_N.TXT ${filesize}
       fi
      fi
     else
      setenv xfh_ok 0
      setenv xfhstage 'V12 chunk 26 two SPI reads mismatch'
      if env export -t 0x82000000 xfhstage; then
       fatwrite mmc 0:1 0x82000000 E26_N.TXT ${filesize}
      fi
     fi
    else
     setenv xfh_ok 0
     setenv xfhstage 'V12 chunk 26 second SPI read FAILED'
     if env export -t 0x82000000 xfhstage; then
      fatwrite mmc 0:1 0x82000000 E26_N.TXT ${filesize}
     fi
    fi
   else
    setenv xfh_ok 0
    setenv xfhstage 'V12 chunk 26 first SPI read FAILED'
    if env export -t 0x82000000 xfhstage; then
     fatwrite mmc 0:1 0x82000000 E26_N.TXT ${filesize}
    fi
   fi
  fi
  # Chunk 27: flash offset 0x6C0000, length 0x40000, output F27.BIN
  if test "${xfh_ok}" = "1"; then
   if sf read 0x81000000 0x6C0000 0x40000; then
    if sf read 0x81100000 0x6C0000 0x40000; then
     if cmp.b 0x81000000 0x81100000 0x40000; then
      if fatwrite mmc 0:1 0x81000000 F27.BIN 0x40000; then
       if fatload mmc 0:1 0x81200000 F27.BIN; then
        if cmp.b 0x81000000 0x81200000 0x40000; then
         setenv xfhstage 'V12 chunk 27 of 32 double-read and FAT verified'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 P27_Y.TXT ${filesize}
         fi
        else
         setenv xfh_ok 0
         setenv xfhstage 'V12 chunk 27 FAT comparison FAILED'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 E27_N.TXT ${filesize}
         fi
        fi
       else
        setenv xfh_ok 0
        setenv xfhstage 'V12 chunk 27 FAT reload FAILED'
        if env export -t 0x82000000 xfhstage; then
         fatwrite mmc 0:1 0x82000000 E27_N.TXT ${filesize}
        fi
       fi
      else
       setenv xfh_ok 0
       setenv xfhstage 'V12 chunk 27 FAT save FAILED'
       if env export -t 0x82000000 xfhstage; then
        fatwrite mmc 0:1 0x82000000 E27_N.TXT ${filesize}
       fi
      fi
     else
      setenv xfh_ok 0
      setenv xfhstage 'V12 chunk 27 two SPI reads mismatch'
      if env export -t 0x82000000 xfhstage; then
       fatwrite mmc 0:1 0x82000000 E27_N.TXT ${filesize}
      fi
     fi
    else
     setenv xfh_ok 0
     setenv xfhstage 'V12 chunk 27 second SPI read FAILED'
     if env export -t 0x82000000 xfhstage; then
      fatwrite mmc 0:1 0x82000000 E27_N.TXT ${filesize}
     fi
    fi
   else
    setenv xfh_ok 0
    setenv xfhstage 'V12 chunk 27 first SPI read FAILED'
    if env export -t 0x82000000 xfhstage; then
     fatwrite mmc 0:1 0x82000000 E27_N.TXT ${filesize}
    fi
   fi
  fi
  # Chunk 28: flash offset 0x700000, length 0x40000, output F28.BIN
  if test "${xfh_ok}" = "1"; then
   if sf read 0x81000000 0x700000 0x40000; then
    if sf read 0x81100000 0x700000 0x40000; then
     if cmp.b 0x81000000 0x81100000 0x40000; then
      if fatwrite mmc 0:1 0x81000000 F28.BIN 0x40000; then
       if fatload mmc 0:1 0x81200000 F28.BIN; then
        if cmp.b 0x81000000 0x81200000 0x40000; then
         setenv xfhstage 'V12 chunk 28 of 32 double-read and FAT verified'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 P28_Y.TXT ${filesize}
         fi
        else
         setenv xfh_ok 0
         setenv xfhstage 'V12 chunk 28 FAT comparison FAILED'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 E28_N.TXT ${filesize}
         fi
        fi
       else
        setenv xfh_ok 0
        setenv xfhstage 'V12 chunk 28 FAT reload FAILED'
        if env export -t 0x82000000 xfhstage; then
         fatwrite mmc 0:1 0x82000000 E28_N.TXT ${filesize}
        fi
       fi
      else
       setenv xfh_ok 0
       setenv xfhstage 'V12 chunk 28 FAT save FAILED'
       if env export -t 0x82000000 xfhstage; then
        fatwrite mmc 0:1 0x82000000 E28_N.TXT ${filesize}
       fi
      fi
     else
      setenv xfh_ok 0
      setenv xfhstage 'V12 chunk 28 two SPI reads mismatch'
      if env export -t 0x82000000 xfhstage; then
       fatwrite mmc 0:1 0x82000000 E28_N.TXT ${filesize}
      fi
     fi
    else
     setenv xfh_ok 0
     setenv xfhstage 'V12 chunk 28 second SPI read FAILED'
     if env export -t 0x82000000 xfhstage; then
      fatwrite mmc 0:1 0x82000000 E28_N.TXT ${filesize}
     fi
    fi
   else
    setenv xfh_ok 0
    setenv xfhstage 'V12 chunk 28 first SPI read FAILED'
    if env export -t 0x82000000 xfhstage; then
     fatwrite mmc 0:1 0x82000000 E28_N.TXT ${filesize}
    fi
   fi
  fi
  # Chunk 29: flash offset 0x740000, length 0x40000, output F29.BIN
  if test "${xfh_ok}" = "1"; then
   if sf read 0x81000000 0x740000 0x40000; then
    if sf read 0x81100000 0x740000 0x40000; then
     if cmp.b 0x81000000 0x81100000 0x40000; then
      if fatwrite mmc 0:1 0x81000000 F29.BIN 0x40000; then
       if fatload mmc 0:1 0x81200000 F29.BIN; then
        if cmp.b 0x81000000 0x81200000 0x40000; then
         setenv xfhstage 'V12 chunk 29 of 32 double-read and FAT verified'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 P29_Y.TXT ${filesize}
         fi
        else
         setenv xfh_ok 0
         setenv xfhstage 'V12 chunk 29 FAT comparison FAILED'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 E29_N.TXT ${filesize}
         fi
        fi
       else
        setenv xfh_ok 0
        setenv xfhstage 'V12 chunk 29 FAT reload FAILED'
        if env export -t 0x82000000 xfhstage; then
         fatwrite mmc 0:1 0x82000000 E29_N.TXT ${filesize}
        fi
       fi
      else
       setenv xfh_ok 0
       setenv xfhstage 'V12 chunk 29 FAT save FAILED'
       if env export -t 0x82000000 xfhstage; then
        fatwrite mmc 0:1 0x82000000 E29_N.TXT ${filesize}
       fi
      fi
     else
      setenv xfh_ok 0
      setenv xfhstage 'V12 chunk 29 two SPI reads mismatch'
      if env export -t 0x82000000 xfhstage; then
       fatwrite mmc 0:1 0x82000000 E29_N.TXT ${filesize}
      fi
     fi
    else
     setenv xfh_ok 0
     setenv xfhstage 'V12 chunk 29 second SPI read FAILED'
     if env export -t 0x82000000 xfhstage; then
      fatwrite mmc 0:1 0x82000000 E29_N.TXT ${filesize}
     fi
    fi
   else
    setenv xfh_ok 0
    setenv xfhstage 'V12 chunk 29 first SPI read FAILED'
    if env export -t 0x82000000 xfhstage; then
     fatwrite mmc 0:1 0x82000000 E29_N.TXT ${filesize}
    fi
   fi
  fi
  # Chunk 30: flash offset 0x780000, length 0x40000, output F30.BIN
  if test "${xfh_ok}" = "1"; then
   if sf read 0x81000000 0x780000 0x40000; then
    if sf read 0x81100000 0x780000 0x40000; then
     if cmp.b 0x81000000 0x81100000 0x40000; then
      if fatwrite mmc 0:1 0x81000000 F30.BIN 0x40000; then
       if fatload mmc 0:1 0x81200000 F30.BIN; then
        if cmp.b 0x81000000 0x81200000 0x40000; then
         setenv xfhstage 'V12 chunk 30 of 32 double-read and FAT verified'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 P30_Y.TXT ${filesize}
         fi
        else
         setenv xfh_ok 0
         setenv xfhstage 'V12 chunk 30 FAT comparison FAILED'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 E30_N.TXT ${filesize}
         fi
        fi
       else
        setenv xfh_ok 0
        setenv xfhstage 'V12 chunk 30 FAT reload FAILED'
        if env export -t 0x82000000 xfhstage; then
         fatwrite mmc 0:1 0x82000000 E30_N.TXT ${filesize}
        fi
       fi
      else
       setenv xfh_ok 0
       setenv xfhstage 'V12 chunk 30 FAT save FAILED'
       if env export -t 0x82000000 xfhstage; then
        fatwrite mmc 0:1 0x82000000 E30_N.TXT ${filesize}
       fi
      fi
     else
      setenv xfh_ok 0
      setenv xfhstage 'V12 chunk 30 two SPI reads mismatch'
      if env export -t 0x82000000 xfhstage; then
       fatwrite mmc 0:1 0x82000000 E30_N.TXT ${filesize}
      fi
     fi
    else
     setenv xfh_ok 0
     setenv xfhstage 'V12 chunk 30 second SPI read FAILED'
     if env export -t 0x82000000 xfhstage; then
      fatwrite mmc 0:1 0x82000000 E30_N.TXT ${filesize}
     fi
    fi
   else
    setenv xfh_ok 0
    setenv xfhstage 'V12 chunk 30 first SPI read FAILED'
    if env export -t 0x82000000 xfhstage; then
     fatwrite mmc 0:1 0x82000000 E30_N.TXT ${filesize}
    fi
   fi
  fi
  # Chunk 31: flash offset 0x7C0000, length 0x40000, output F31.BIN
  if test "${xfh_ok}" = "1"; then
   if sf read 0x81000000 0x7C0000 0x40000; then
    if sf read 0x81100000 0x7C0000 0x40000; then
     if cmp.b 0x81000000 0x81100000 0x40000; then
      if fatwrite mmc 0:1 0x81000000 F31.BIN 0x40000; then
       if fatload mmc 0:1 0x81200000 F31.BIN; then
        if cmp.b 0x81000000 0x81200000 0x40000; then
         setenv xfhstage 'V12 chunk 31 of 32 double-read and FAT verified'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 P31_Y.TXT ${filesize}
         fi
        else
         setenv xfh_ok 0
         setenv xfhstage 'V12 chunk 31 FAT comparison FAILED'
         if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 E31_N.TXT ${filesize}
         fi
        fi
       else
        setenv xfh_ok 0
        setenv xfhstage 'V12 chunk 31 FAT reload FAILED'
        if env export -t 0x82000000 xfhstage; then
         fatwrite mmc 0:1 0x82000000 E31_N.TXT ${filesize}
        fi
       fi
      else
       setenv xfh_ok 0
       setenv xfhstage 'V12 chunk 31 FAT save FAILED'
       if env export -t 0x82000000 xfhstage; then
        fatwrite mmc 0:1 0x82000000 E31_N.TXT ${filesize}
       fi
      fi
     else
      setenv xfh_ok 0
      setenv xfhstage 'V12 chunk 31 two SPI reads mismatch'
      if env export -t 0x82000000 xfhstage; then
       fatwrite mmc 0:1 0x82000000 E31_N.TXT ${filesize}
      fi
     fi
    else
     setenv xfh_ok 0
     setenv xfhstage 'V12 chunk 31 second SPI read FAILED'
     if env export -t 0x82000000 xfhstage; then
      fatwrite mmc 0:1 0x82000000 E31_N.TXT ${filesize}
     fi
    fi
   else
    setenv xfh_ok 0
    setenv xfhstage 'V12 chunk 31 first SPI read FAILED'
    if env export -t 0x82000000 xfhstage; then
     fatwrite mmc 0:1 0x82000000 E31_N.TXT ${filesize}
    fi
   fi
  fi
  if test "${xfh_ok}" = "1"; then
   setenv xfhstage 'V12 all 32 chunks verified. Assemble offline and hash.'
   if env export -t 0x82000000 xfhstage; then
    if fatwrite mmc 0:1 0x82000000 90_ALL_Y.TXT ${filesize}; then
     setenv xfh_complete 1
    fi
   fi
  else
   setenv xfhstage 'V12 stopped after failed chunk; incomplete backup'
   if env export -t 0x82000000 xfhstage; then
    fatwrite mmc 0:1 0x82000000 90_ALL_N.TXT ${filesize}
   fi
  fi
 else
  setenv xfhstage 'V12 SPI flash identification FAILED'
  if env export -t 0x82000000 xfhstage; then
   fatwrite mmc 0:1 0x82000000 31_SPI_N.TXT ${filesize}
  fi
 fi
fi
if fatwrite mmc 0:1 0x82010000 DRIVER12.BIN 0x400; then
 setenv xfhstage 'V12 driver diagnostics saved'
 if env export -t 0x82000000 xfhstage; then
  fatwrite mmc 0:1 0x82000000 80_TRACE_Y.TXT ${filesize}
 fi
fi
setenv xfhstage 'V12 finished; power OFF before removing SD'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 99_V12_END.TXT ${filesize}
fi
echo V12 complete; POWER OFF before SD removal
# Best-effort status LED experiment based on *older reference FEX*, not physically
# proven on this 2026 board. V6 commands succeeded but LED remained blue.
# Never interpret an LED color as proof that all 32 chunks were recovered.
if test "${xfh_complete}" = "1"; then
 setenv xfhstage 'V12 all 32 chunks verified; attempting reference GREEN PD21 LED'
 if env export -t 0x82000000 xfhstage; then
  fatwrite mmc 0:1 0x82000000 91_LED_GREEN_ATTEMPT.TXT ${filesize}
 fi
 gpio clear PD20
 gpio clear PE4
 gpio set PD21
else
 setenv xfhstage 'V12 recovery incomplete; attempting reference RED PD20 LED'
 if env export -t 0x82000000 xfhstage; then
  fatwrite mmc 0:1 0x82000000 91_LED_RED_ATTEMPT.TXT ${filesize}
 fi
 gpio clear PD21
 gpio clear PE4
 gpio set PD20
fi
# Remain in U-Boot shell. GPIO output level persists unless something else changes it.
echo V12 completion LED attempted (unverified board pinout). Check SD markers.
