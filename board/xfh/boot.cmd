# XFH V10 - EON JEDEC 1C7017 8MiB first 4KiB verification. SPI NOR READ ONLY.
# Working SPL/SD/MMC and guarded V8 CCU init remain unchanged.
setenv xfhstage 'V10 started; no SPI NOR writes'
mw.l 0x82010000 0 0x100
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 00_V10_START.TXT ${filesize}
fi

# V7/V8 observed exact baseline; do not touch mismatched registers.
setenv xfh_ready 0
mw.l 0x81001000 0x00004100 1
mw.l 0x81001004 0x00104100 1
if cmp.l 0x01c20060 0x81001000 1; then
 if cmp.l 0x01c202c0 0x81001000 1; then
  mw.l 0x01c20060 0x00104100 1
  if cmp.l 0x01c20060 0x81001004 1; then
   mw.l 0x01c202c0 0x00104100 1
   if cmp.l 0x01c202c0 0x81001004 1; then
    setenv xfh_ready 1
    setenv xfhstage 'V10 guarded CCU gate/reset readback successful'
    if env export -t 0x82000000 xfhstage; then
     fatwrite mmc 0:1 0x82000000 20_CC_OK.TXT ${filesize}
    fi
   fi
  fi
 fi
fi

if test "${xfh_ready}" = "1"; then
 setenv xfhstage 'V10 EON 1C7017 identification starting'
 if env export -t 0x82000000 xfhstage; then
  fatwrite mmc 0:1 0x82000000 30_PROBE_START.TXT ${filesize}
 fi
 if sf probe 0:0 500000; then
  setenv xfhstage 'V10 SPI flash recognized'
  if env export -t 0x82000000 xfhstage; then
   fatwrite mmc 0:1 0x82000000 31_SPI_Y.TXT ${filesize}
  fi
  # Two separate 4096-byte reads into independent DRAM addresses.
  if sf read 0x81000000 0 0x1000; then
   if sf read 0x81002000 0 0x1000; then
    if cmp.b 0x81000000 0x81002000 0x1000; then
     setenv xfhstage 'V10 both independent 4KiB SPI reads identical'
     if env export -t 0x82000000 xfhstage; then
      fatwrite mmc 0:1 0x82000000 32_MATCH_Y.TXT ${filesize}
     fi
     if fatwrite mmc 0:1 0x81000000 V10_HEAD.BIN 0x1000; then
      if fatload mmc 0:1 0x81800000 V10_HEAD.BIN; then
       if cmp.b 0x81000000 0x81800000 0x1000; then
        setenv xfhstage 'V10 two SPI reads and FAT readback matched exactly'
        if env export -t 0x82000000 xfhstage; then
         fatwrite mmc 0:1 0x82000000 33_VERIFY_Y.TXT ${filesize}
        fi
       else
        setenv xfhstage 'V10 FAT readback comparison FAILED'
        if env export -t 0x82000000 xfhstage; then
         fatwrite mmc 0:1 0x82000000 33_VERIFY_N.TXT ${filesize}
        fi
       fi
      else
       setenv xfhstage 'V10 FAT readback failed'
       if env export -t 0x82000000 xfhstage; then
        fatwrite mmc 0:1 0x82000000 33_VERIFY_N.TXT ${filesize}
       fi
      fi
     else
      setenv xfhstage 'V10 FAT sample save failed'
      if env export -t 0x82000000 xfhstage; then
       fatwrite mmc 0:1 0x82000000 33_VERIFY_N.TXT ${filesize}
      fi
     fi
    else
     setenv xfhstage 'V10 the two flash reads MISMATCH - no sample saved'
     if env export -t 0x82000000 xfhstage; then
      fatwrite mmc 0:1 0x82000000 32_MATCH_N.TXT ${filesize}
     fi
    fi
   else
    setenv xfhstage 'V10 second flash read failed'
    if env export -t 0x82000000 xfhstage; then
     fatwrite mmc 0:1 0x82000000 32_READ2_N.TXT ${filesize}
    fi
   fi
  else
   setenv xfhstage 'V10 first flash read failed'
   if env export -t 0x82000000 xfhstage; then
    fatwrite mmc 0:1 0x82000000 32_READ1_N.TXT ${filesize}
   fi
  fi
 else
  setenv xfhstage 'V10 SPI flash probe still failed; see DRIVER10.BIN'
  if env export -t 0x82000000 xfhstage; then
   fatwrite mmc 0:1 0x82000000 31_SPI_N.TXT ${filesize}
  fi
 fi
else
 setenv xfhstage 'V10 guarded clock/reset baseline mismatch - skipped flash probe'
 if env export -t 0x82000000 xfhstage; then
  fatwrite mmc 0:1 0x82000000 20_CC_SKIP.TXT ${filesize}
 fi
fi

# Driver trace from retained V9 instrumentation.
if fatwrite mmc 0:1 0x82010000 DRIVER10.BIN 0x400; then
 setenv xfhstage 'V10 driver trace saved'
 if env export -t 0x82000000 xfhstage; then
  fatwrite mmc 0:1 0x82000000 80_TRACE_Y.TXT ${filesize}
 fi
fi
setenv xfhstage 'V10 finished; POWER OFF before SD card removal'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 99_V10_END.TXT ${filesize}
fi
echo V10 finished; POWER OFF before SD removal
