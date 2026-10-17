# XFH V9: driver instrumented, SPI0 read-only, normal SPL and SD path unchanged.
# 0x82010000 trace buffer is populated from U-Boot spi-sunxi.c after U-Boot DRAM init.
setenv xfhstage 'V9 entered; driver trace buffer initialized'
mw.l 0x82010000 0 0x100
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 00_V9_START.TXT ${filesize}
fi

# Baseline snapshot
if cp.l 0x01c20000 0x81000000 100; then
 fatwrite mmc 0:1 0x81000000 B_CC.BIN 0x400
fi
if cp.l 0x01c20800 0x81000000 100; then
 fatwrite mmc 0:1 0x81000000 B_GPIO.BIN 0x400
fi
if cp.l 0x01c05000 0x81000000 40; then
 fatwrite mmc 0:1 0x81000000 B_SPI.BIN 0x100
fi

# V8 proved 0x00004100 as the baseline on the user's hardware.
# Do not change CCU unless BOTH gate and reset match the observed baseline.
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
    setenv xfhstage 'V9 verified manual SPI0 gate/reset release'
    if env export -t 0x82000000 xfhstage; then
     fatwrite mmc 0:1 0x82000000 20_CC_OK.TXT ${filesize}
    fi
   fi
  fi
 fi
fi
if test "${xfh_ready}" = "0"; then
 setenv xfhstage 'V9 baseline mismatch/readback failure: probe skipped'
 if env export -t 0x82000000 xfhstage; then
  fatwrite mmc 0:1 0x82000000 20_CC_SKIP.TXT ${filesize}
 fi
fi

if cp.l 0x01c20000 0x81000000 100; then
 fatwrite mmc 0:1 0x81000000 C_CC.BIN 0x400
fi
if cp.l 0x01c05000 0x81000000 40; then
 fatwrite mmc 0:1 0x81000000 C_SPI.BIN 0x100
fi

if test "${xfh_ready}" = "1"; then
 setenv xfhstage 'V9 sf probe 0:0 500000 running with instrumented driver'
 if env export -t 0x82000000 xfhstage; then
  fatwrite mmc 0:1 0x82000000 30_SPI_START.TXT ${filesize}
 fi
 if sf probe 0:0 500000; then
  setenv xfhstage 'V9 sf probe SUCCESS'
  if env export -t 0x82000000 xfhstage; then
   fatwrite mmc 0:1 0x82000000 31_SPI_Y.TXT ${filesize}
  fi
  if sf read 0x81000000 0 0x1000; then
   if fatwrite mmc 0:1 0x81000000 V9_HEAD.BIN 0x1000; then
    if fatload mmc 0:1 0x81800000 V9_HEAD.BIN; then
     if cmp.b 0x81000000 0x81800000 0x1000; then
      setenv xfhstage 'V9 read-only 4KB flash sample SD verified'
      if env export -t 0x82000000 xfhstage; then
       fatwrite mmc 0:1 0x82000000 32_READ_Y.TXT ${filesize}
      fi
     fi
    fi
   fi
  fi
 else
  setenv xfhstage 'V9 SPI flash probe FAIL; see DRIVER9.BIN'
  if env export -t 0x82000000 xfhstage; then
   fatwrite mmc 0:1 0x82000000 31_SPI_N.TXT ${filesize}
  fi
 fi
fi

# Trace saved even on failed SPI probe. First word = number of 4-word events.
if fatwrite mmc 0:1 0x82010000 DRIVER9.BIN 0x400; then
 setenv xfhstage 'V9 instrumented driver trace saved'
 if env export -t 0x82000000 xfhstage; then
  fatwrite mmc 0:1 0x82000000 80_TRACE_Y.TXT ${filesize}
 fi
else
 setenv xfhstage 'V9 instrumented driver trace FAT save failed'
 if env export -t 0x82000000 xfhstage; then
  fatwrite mmc 0:1 0x82000000 80_TRACE_N.TXT ${filesize}
 fi
fi

if cp.l 0x01c20000 0x81000000 100; then
 fatwrite mmc 0:1 0x81000000 A_CC.BIN 0x400
fi
if cp.l 0x01c20800 0x81000000 100; then
 fatwrite mmc 0:1 0x81000000 A_GPIO.BIN 0x400
fi
if cp.l 0x01c05000 0x81000000 40; then
 fatwrite mmc 0:1 0x81000000 A_SPI.BIN 0x100
fi
setenv xfhstage 'V9 finished; POWER OFF before removing SD'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 99_V9_END.TXT ${filesize}
fi
echo V9 complete. Power OFF before SD removal.
