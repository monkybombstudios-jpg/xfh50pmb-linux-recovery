# XFH V8: narrowly gated SPI0 CCU clock/reset experiment, vendor-reference hardware; no SPI NOR writes.
# Keep the working SPL/SD/DRAM chain unchanged. No LED toggling.
setenv xfhstage 'V8 entered; recording initial hardware state'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 00_V8_START.TXT ${filesize}
fi

# B: CC, read-only snapshot.
if cp.l 0x01c20000 0x81000000 100; then
 if fatwrite mmc 0:1 0x81000000 B_CC.BIN 400; then
setenv xfhstage 'B_CC snapshot saved'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 B_CC_Y.TXT ${filesize}
fi
 else
setenv xfhstage 'B_CC FAT save failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 B_CC_N.TXT ${filesize}
fi
 fi
else
setenv xfhstage 'B_CC MMIO snapshot failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 B_CC_N.TXT ${filesize}
fi
fi

# B: GPIO, read-only snapshot.
if cp.l 0x01c20800 0x81000000 100; then
 if fatwrite mmc 0:1 0x81000000 B_GPIO.BIN 400; then
setenv xfhstage 'B_GPIO snapshot saved'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 B_GPIO_Y.TXT ${filesize}
fi
 else
setenv xfhstage 'B_GPIO FAT save failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 B_GPIO_N.TXT ${filesize}
fi
 fi
else
setenv xfhstage 'B_GPIO MMIO snapshot failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 B_GPIO_N.TXT ${filesize}
fi
fi

# B: SPI, read-only snapshot.
if cp.l 0x01c05000 0x81000000 40; then
 if fatwrite mmc 0:1 0x81000000 B_SPI.BIN 100; then
setenv xfhstage 'B_SPI snapshot saved'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 B_SPI_Y.TXT ${filesize}
fi
 else
setenv xfhstage 'B_SPI FAT save failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 B_SPI_N.TXT ${filesize}
fi
 fi
else
setenv xfhstage 'B_SPI MMIO snapshot failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 B_SPI_N.TXT ${filesize}
fi
fi

# Only change register if exact V7 baseline remains; compare register directly with expected value in RAM.
mw.l 0x81001000 0x00004100 1
mw.l 0x81001004 0x00104100 1
setenv xfh_clock_ready 0
if cmp.l 0x01c20060 0x81001000 1; then
 if cmp.l 0x01c202c0 0x81001000 1; then
setenv xfhstage 'V8 CCU clock/reset both match V7 baseline'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 20_BASE_OK.TXT ${filesize}
fi

  mw.l 0x01c20060 0x00104100 1
  if cmp.l 0x01c20060 0x81001004 1; then
setenv xfhstage 'V8 clock gate 20 enabled and read back'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 21_GATE_OK.TXT ${filesize}
fi

   mw.l 0x01c202c0 0x00104100 1
   if cmp.l 0x01c202c0 0x81001004 1; then
setenv xfhstage 'V8 SPI0 reset release bit 20 enabled and read back'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 22_RESET_OK.TXT ${filesize}
fi

    setenv xfh_clock_ready 1
   else
setenv xfhstage 'V8 reset write readback failed; no SPI probe'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 22_RESET_N.TXT ${filesize}
fi

   fi
  else
setenv xfhstage 'V8 clock gate write readback failed; no SPI probe'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 21_GATE_N.TXT ${filesize}
fi

  fi
 else
setenv xfhstage 'V8 RESET baseline mismatch, no CCU write/probe'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 20_BASE_N.TXT ${filesize}
fi

 fi
else
setenv xfhstage 'V8 GATE baseline mismatch, no CCU write/probe'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 20_BASE_N.TXT ${filesize}
fi

fi
# Capture clock and pin state after CCU manipulation and before probe.
# C: CC, read-only snapshot.
if cp.l 0x01c20000 0x81000000 100; then
 if fatwrite mmc 0:1 0x81000000 C_CC.BIN 400; then
setenv xfhstage 'C_CC snapshot saved'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 C_CC_Y.TXT ${filesize}
fi
 else
setenv xfhstage 'C_CC FAT save failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 C_CC_N.TXT ${filesize}
fi
 fi
else
setenv xfhstage 'C_CC MMIO snapshot failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 C_CC_N.TXT ${filesize}
fi
fi

# C: SPI, read-only snapshot.
if cp.l 0x01c05000 0x81000000 40; then
 if fatwrite mmc 0:1 0x81000000 C_SPI.BIN 100; then
setenv xfhstage 'C_SPI snapshot saved'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 C_SPI_Y.TXT ${filesize}
fi
 else
setenv xfhstage 'C_SPI FAT save failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 C_SPI_N.TXT ${filesize}
fi
 fi
else
setenv xfhstage 'C_SPI MMIO snapshot failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 C_SPI_N.TXT ${filesize}
fi
fi

if test "${xfh_clock_ready}" = "1"; then
setenv xfhstage 'V8: clock reset verified, SPI0 CS0 at 500kHz read-only probe'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 30_PROBE_START.TXT ${filesize}
fi

 if sf probe 0:0 500000; then
setenv xfhstage 'V8: SPI0 probe succeeded'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 31_SPI_Y.TXT ${filesize}
fi

  if sf read 0x81000000 0 0x1000; then
   if fatwrite mmc 0:1 0x81000000 V8_HEAD.BIN 0x1000; then
    if fatload mmc 0:1 0x81800000 V8_HEAD.BIN; then
     if cmp.b 0x81000000 0x81800000 0x1000; then
setenv xfhstage 'V8: read-only 4096-byte sample SD verified'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 32_READ_Y.TXT ${filesize}
fi

     else
setenv xfhstage 'V8: SD compare failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 32_READ_N.TXT ${filesize}
fi

     fi
    else
setenv xfhstage 'V8: SD reload failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 32_READ_N.TXT ${filesize}
fi

    fi
   else
setenv xfhstage 'V8: SD write failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 32_READ_N.TXT ${filesize}
fi

   fi
  else
setenv xfhstage 'V8: SPI flash read failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 32_READ_N.TXT ${filesize}
fi

  fi
 else
setenv xfhstage 'V8: SPI0 probe failed with gate/reset released'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 31_SPI_N.TXT ${filesize}
fi

 fi
else
setenv xfhstage 'V8: baseline/readback safety prevented SPI probe'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 30_PROBE_SKIP.TXT ${filesize}
fi

fi
# A: CC, read-only snapshot.
if cp.l 0x01c20000 0x81000000 100; then
 if fatwrite mmc 0:1 0x81000000 A_CC.BIN 400; then
setenv xfhstage 'A_CC snapshot saved'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 A_CC_Y.TXT ${filesize}
fi
 else
setenv xfhstage 'A_CC FAT save failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 A_CC_N.TXT ${filesize}
fi
 fi
else
setenv xfhstage 'A_CC MMIO snapshot failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 A_CC_N.TXT ${filesize}
fi
fi

# A: GPIO, read-only snapshot.
if cp.l 0x01c20800 0x81000000 100; then
 if fatwrite mmc 0:1 0x81000000 A_GPIO.BIN 400; then
setenv xfhstage 'A_GPIO snapshot saved'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 A_GPIO_Y.TXT ${filesize}
fi
 else
setenv xfhstage 'A_GPIO FAT save failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 A_GPIO_N.TXT ${filesize}
fi
 fi
else
setenv xfhstage 'A_GPIO MMIO snapshot failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 A_GPIO_N.TXT ${filesize}
fi
fi

# A: SPI, read-only snapshot.
if cp.l 0x01c05000 0x81000000 40; then
 if fatwrite mmc 0:1 0x81000000 A_SPI.BIN 100; then
setenv xfhstage 'A_SPI snapshot saved'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 A_SPI_Y.TXT ${filesize}
fi
 else
setenv xfhstage 'A_SPI FAT save failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 A_SPI_N.TXT ${filesize}
fi
 fi
else
setenv xfhstage 'A_SPI MMIO snapshot failed'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 A_SPI_N.TXT ${filesize}
fi
fi

setenv xfhstage 'V8 ended; switch POWER OFF before removing SD'
if env export -t 0x82000000 xfhstage; then
 fatwrite mmc 0:1 0x82000000 99_V8_END.TXT ${filesize}
fi

echo V8 completed; power OFF before removing SD
