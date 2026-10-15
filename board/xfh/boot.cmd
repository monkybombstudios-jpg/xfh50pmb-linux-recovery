# XFH V4 MULTI-ROUTE SPI DIAGNOSTICS - never write internal flash
# No Linux boot: U-Boot writes FAT SD TXT markers
# Leave LEDs disabled unless confirmed GPIO wiring and polarity.
echo XFH V4 diagnostics started
setenv xfhstage 'V4 boot script executed from SD'
if env export -t 0x82000000 xfhstage; then
  fatwrite mmc 0:1 0x82000000 00_START.TXT ${filesize}
fi

setenv xfh_found 0
setenv xfh_fail 0
setenv xfh_led_enable 0
# LED GPIOs in older reference FEX: PD20 red, PD21 green, PE4 blue;
# U-Boot gpio names/polarity are NOT confirmed for this 2026 unit.
# Set xfh_led_enable=1 below only after verifying names and electrical safety.
# GPIO handling currently deliberately disabled.
setenv xfhstage 'V4 SPI probe matrix begins'
if env export -t 0x82000000 xfhstage; then
  fatwrite mmc 0:1 0x82000000 01_SPI_BEGIN.TXT ${filesize}
fi

setenv xfhstage 'Start SPI bus 0 cs 0 500000 Hz'
if env export -t 0x82000000 xfhstage; then
  fatwrite mmc 0:1 0x82000000 P00_0500S.TXT ${filesize}
fi

if sf probe 0:0 500000; then
  setenv xfhstage 'OK SPI bus 0 cs 0 500000 Hz'
  if env export -t 0x82000000 xfhstage; then
    fatwrite mmc 0:1 0x82000000 P00_0500Y.TXT ${filesize}
  fi

  setenv xfh_found 1
  setenv xfh_bus 0:0
  setenv xfh_hz 500000
else
  setenv xfhstage 'FAIL SPI bus 0 cs 0 500000 Hz'
  if env export -t 0x82000000 xfhstage; then
    fatwrite mmc 0:1 0x82000000 P00_0500N.TXT ${filesize}
  fi

fi
setenv xfhstage 'Start SPI bus 0 cs 0 1000000 Hz'
if env export -t 0x82000000 xfhstage; then
  fatwrite mmc 0:1 0x82000000 P00_1000S.TXT ${filesize}
fi

if sf probe 0:0 1000000; then
  setenv xfhstage 'OK SPI bus 0 cs 0 1000000 Hz'
  if env export -t 0x82000000 xfhstage; then
    fatwrite mmc 0:1 0x82000000 P00_1000Y.TXT ${filesize}
  fi

  setenv xfh_found 1
  setenv xfh_bus 0:0
  setenv xfh_hz 1000000
else
  setenv xfhstage 'FAIL SPI bus 0 cs 0 1000000 Hz'
  if env export -t 0x82000000 xfhstage; then
    fatwrite mmc 0:1 0x82000000 P00_1000N.TXT ${filesize}
  fi

fi
setenv xfhstage 'Start SPI bus 0 cs 0 5000000 Hz'
if env export -t 0x82000000 xfhstage; then
  fatwrite mmc 0:1 0x82000000 P00_5000S.TXT ${filesize}
fi

if sf probe 0:0 5000000; then
  setenv xfhstage 'OK SPI bus 0 cs 0 5000000 Hz'
  if env export -t 0x82000000 xfhstage; then
    fatwrite mmc 0:1 0x82000000 P00_5000Y.TXT ${filesize}
  fi

  setenv xfh_found 1
  setenv xfh_bus 0:0
  setenv xfh_hz 5000000
else
  setenv xfhstage 'FAIL SPI bus 0 cs 0 5000000 Hz'
  if env export -t 0x82000000 xfhstage; then
    fatwrite mmc 0:1 0x82000000 P00_5000N.TXT ${filesize}
  fi

fi
setenv xfhstage 'Start SPI bus 0 cs 1 500000 Hz'
if env export -t 0x82000000 xfhstage; then
  fatwrite mmc 0:1 0x82000000 P01_0500S.TXT ${filesize}
fi

if sf probe 0:1 500000; then
  setenv xfhstage 'OK SPI bus 0 cs 1 500000 Hz'
  if env export -t 0x82000000 xfhstage; then
    fatwrite mmc 0:1 0x82000000 P01_0500Y.TXT ${filesize}
  fi

  setenv xfh_found 1
  setenv xfh_bus 0:1
  setenv xfh_hz 500000
else
  setenv xfhstage 'FAIL SPI bus 0 cs 1 500000 Hz'
  if env export -t 0x82000000 xfhstage; then
    fatwrite mmc 0:1 0x82000000 P01_0500N.TXT ${filesize}
  fi

fi
setenv xfhstage 'Start SPI bus 0 cs 1 1000000 Hz'
if env export -t 0x82000000 xfhstage; then
  fatwrite mmc 0:1 0x82000000 P01_1000S.TXT ${filesize}
fi

if sf probe 0:1 1000000; then
  setenv xfhstage 'OK SPI bus 0 cs 1 1000000 Hz'
  if env export -t 0x82000000 xfhstage; then
    fatwrite mmc 0:1 0x82000000 P01_1000Y.TXT ${filesize}
  fi

  setenv xfh_found 1
  setenv xfh_bus 0:1
  setenv xfh_hz 1000000
else
  setenv xfhstage 'FAIL SPI bus 0 cs 1 1000000 Hz'
  if env export -t 0x82000000 xfhstage; then
    fatwrite mmc 0:1 0x82000000 P01_1000N.TXT ${filesize}
  fi

fi
setenv xfhstage 'Start SPI bus 0 cs 1 5000000 Hz'
if env export -t 0x82000000 xfhstage; then
  fatwrite mmc 0:1 0x82000000 P01_5000S.TXT ${filesize}
fi

if sf probe 0:1 5000000; then
  setenv xfhstage 'OK SPI bus 0 cs 1 5000000 Hz'
  if env export -t 0x82000000 xfhstage; then
    fatwrite mmc 0:1 0x82000000 P01_5000Y.TXT ${filesize}
  fi

  setenv xfh_found 1
  setenv xfh_bus 0:1
  setenv xfh_hz 5000000
else
  setenv xfhstage 'FAIL SPI bus 0 cs 1 5000000 Hz'
  if env export -t 0x82000000 xfhstage; then
    fatwrite mmc 0:1 0x82000000 P01_5000N.TXT ${filesize}
  fi

fi
setenv xfhstage 'Start SPI bus 1 cs 0 500000 Hz'
if env export -t 0x82000000 xfhstage; then
  fatwrite mmc 0:1 0x82000000 P10_0500S.TXT ${filesize}
fi

if sf probe 1:0 500000; then
  setenv xfhstage 'OK SPI bus 1 cs 0 500000 Hz'
  if env export -t 0x82000000 xfhstage; then
    fatwrite mmc 0:1 0x82000000 P10_0500Y.TXT ${filesize}
  fi

  setenv xfh_found 1
  setenv xfh_bus 1:0
  setenv xfh_hz 500000
else
  setenv xfhstage 'FAIL SPI bus 1 cs 0 500000 Hz'
  if env export -t 0x82000000 xfhstage; then
    fatwrite mmc 0:1 0x82000000 P10_0500N.TXT ${filesize}
  fi

fi
setenv xfhstage 'Start SPI bus 1 cs 0 1000000 Hz'
if env export -t 0x82000000 xfhstage; then
  fatwrite mmc 0:1 0x82000000 P10_1000S.TXT ${filesize}
fi

if sf probe 1:0 1000000; then
  setenv xfhstage 'OK SPI bus 1 cs 0 1000000 Hz'
  if env export -t 0x82000000 xfhstage; then
    fatwrite mmc 0:1 0x82000000 P10_1000Y.TXT ${filesize}
  fi

  setenv xfh_found 1
  setenv xfh_bus 1:0
  setenv xfh_hz 1000000
else
  setenv xfhstage 'FAIL SPI bus 1 cs 0 1000000 Hz'
  if env export -t 0x82000000 xfhstage; then
    fatwrite mmc 0:1 0x82000000 P10_1000N.TXT ${filesize}
  fi

fi
setenv xfhstage 'Start SPI bus 1 cs 0 5000000 Hz'
if env export -t 0x82000000 xfhstage; then
  fatwrite mmc 0:1 0x82000000 P10_5000S.TXT ${filesize}
fi

if sf probe 1:0 5000000; then
  setenv xfhstage 'OK SPI bus 1 cs 0 5000000 Hz'
  if env export -t 0x82000000 xfhstage; then
    fatwrite mmc 0:1 0x82000000 P10_5000Y.TXT ${filesize}
  fi

  setenv xfh_found 1
  setenv xfh_bus 1:0
  setenv xfh_hz 5000000
else
  setenv xfhstage 'FAIL SPI bus 1 cs 0 5000000 Hz'
  if env export -t 0x82000000 xfhstage; then
    fatwrite mmc 0:1 0x82000000 P10_5000N.TXT ${filesize}
  fi

fi
setenv xfhstage 'Start SPI bus 1 cs 1 500000 Hz'
if env export -t 0x82000000 xfhstage; then
  fatwrite mmc 0:1 0x82000000 P11_0500S.TXT ${filesize}
fi

if sf probe 1:1 500000; then
  setenv xfhstage 'OK SPI bus 1 cs 1 500000 Hz'
  if env export -t 0x82000000 xfhstage; then
    fatwrite mmc 0:1 0x82000000 P11_0500Y.TXT ${filesize}
  fi

  setenv xfh_found 1
  setenv xfh_bus 1:1
  setenv xfh_hz 500000
else
  setenv xfhstage 'FAIL SPI bus 1 cs 1 500000 Hz'
  if env export -t 0x82000000 xfhstage; then
    fatwrite mmc 0:1 0x82000000 P11_0500N.TXT ${filesize}
  fi

fi
setenv xfhstage 'Start SPI bus 1 cs 1 1000000 Hz'
if env export -t 0x82000000 xfhstage; then
  fatwrite mmc 0:1 0x82000000 P11_1000S.TXT ${filesize}
fi

if sf probe 1:1 1000000; then
  setenv xfhstage 'OK SPI bus 1 cs 1 1000000 Hz'
  if env export -t 0x82000000 xfhstage; then
    fatwrite mmc 0:1 0x82000000 P11_1000Y.TXT ${filesize}
  fi

  setenv xfh_found 1
  setenv xfh_bus 1:1
  setenv xfh_hz 1000000
else
  setenv xfhstage 'FAIL SPI bus 1 cs 1 1000000 Hz'
  if env export -t 0x82000000 xfhstage; then
    fatwrite mmc 0:1 0x82000000 P11_1000N.TXT ${filesize}
  fi

fi
setenv xfhstage 'Start SPI bus 1 cs 1 5000000 Hz'
if env export -t 0x82000000 xfhstage; then
  fatwrite mmc 0:1 0x82000000 P11_5000S.TXT ${filesize}
fi

if sf probe 1:1 5000000; then
  setenv xfhstage 'OK SPI bus 1 cs 1 5000000 Hz'
  if env export -t 0x82000000 xfhstage; then
    fatwrite mmc 0:1 0x82000000 P11_5000Y.TXT ${filesize}
  fi

  setenv xfh_found 1
  setenv xfh_bus 1:1
  setenv xfh_hz 5000000
else
  setenv xfhstage 'FAIL SPI bus 1 cs 1 5000000 Hz'
  if env export -t 0x82000000 xfhstage; then
    fatwrite mmc 0:1 0x82000000 P11_5000N.TXT ${filesize}
  fi

fi
setenv xfhstage 'Start SPI bus 2 cs 0 500000 Hz'
if env export -t 0x82000000 xfhstage; then
  fatwrite mmc 0:1 0x82000000 P20_0500S.TXT ${filesize}
fi

if sf probe 2:0 500000; then
  setenv xfhstage 'OK SPI bus 2 cs 0 500000 Hz'
  if env export -t 0x82000000 xfhstage; then
    fatwrite mmc 0:1 0x82000000 P20_0500Y.TXT ${filesize}
  fi

  setenv xfh_found 1
  setenv xfh_bus 2:0
  setenv xfh_hz 500000
else
  setenv xfhstage 'FAIL SPI bus 2 cs 0 500000 Hz'
  if env export -t 0x82000000 xfhstage; then
    fatwrite mmc 0:1 0x82000000 P20_0500N.TXT ${filesize}
  fi

fi
setenv xfhstage 'Start SPI bus 2 cs 0 1000000 Hz'
if env export -t 0x82000000 xfhstage; then
  fatwrite mmc 0:1 0x82000000 P20_1000S.TXT ${filesize}
fi

if sf probe 2:0 1000000; then
  setenv xfhstage 'OK SPI bus 2 cs 0 1000000 Hz'
  if env export -t 0x82000000 xfhstage; then
    fatwrite mmc 0:1 0x82000000 P20_1000Y.TXT ${filesize}
  fi

  setenv xfh_found 1
  setenv xfh_bus 2:0
  setenv xfh_hz 1000000
else
  setenv xfhstage 'FAIL SPI bus 2 cs 0 1000000 Hz'
  if env export -t 0x82000000 xfhstage; then
    fatwrite mmc 0:1 0x82000000 P20_1000N.TXT ${filesize}
  fi

fi
setenv xfhstage 'Start SPI bus 2 cs 0 5000000 Hz'
if env export -t 0x82000000 xfhstage; then
  fatwrite mmc 0:1 0x82000000 P20_5000S.TXT ${filesize}
fi

if sf probe 2:0 5000000; then
  setenv xfhstage 'OK SPI bus 2 cs 0 5000000 Hz'
  if env export -t 0x82000000 xfhstage; then
    fatwrite mmc 0:1 0x82000000 P20_5000Y.TXT ${filesize}
  fi

  setenv xfh_found 1
  setenv xfh_bus 2:0
  setenv xfh_hz 5000000
else
  setenv xfhstage 'FAIL SPI bus 2 cs 0 5000000 Hz'
  if env export -t 0x82000000 xfhstage; then
    fatwrite mmc 0:1 0x82000000 P20_5000N.TXT ${filesize}
  fi

fi
setenv xfhstage 'Start SPI bus 2 cs 1 500000 Hz'
if env export -t 0x82000000 xfhstage; then
  fatwrite mmc 0:1 0x82000000 P21_0500S.TXT ${filesize}
fi

if sf probe 2:1 500000; then
  setenv xfhstage 'OK SPI bus 2 cs 1 500000 Hz'
  if env export -t 0x82000000 xfhstage; then
    fatwrite mmc 0:1 0x82000000 P21_0500Y.TXT ${filesize}
  fi

  setenv xfh_found 1
  setenv xfh_bus 2:1
  setenv xfh_hz 500000
else
  setenv xfhstage 'FAIL SPI bus 2 cs 1 500000 Hz'
  if env export -t 0x82000000 xfhstage; then
    fatwrite mmc 0:1 0x82000000 P21_0500N.TXT ${filesize}
  fi

fi
setenv xfhstage 'Start SPI bus 2 cs 1 1000000 Hz'
if env export -t 0x82000000 xfhstage; then
  fatwrite mmc 0:1 0x82000000 P21_1000S.TXT ${filesize}
fi

if sf probe 2:1 1000000; then
  setenv xfhstage 'OK SPI bus 2 cs 1 1000000 Hz'
  if env export -t 0x82000000 xfhstage; then
    fatwrite mmc 0:1 0x82000000 P21_1000Y.TXT ${filesize}
  fi

  setenv xfh_found 1
  setenv xfh_bus 2:1
  setenv xfh_hz 1000000
else
  setenv xfhstage 'FAIL SPI bus 2 cs 1 1000000 Hz'
  if env export -t 0x82000000 xfhstage; then
    fatwrite mmc 0:1 0x82000000 P21_1000N.TXT ${filesize}
  fi

fi
setenv xfhstage 'Start SPI bus 2 cs 1 5000000 Hz'
if env export -t 0x82000000 xfhstage; then
  fatwrite mmc 0:1 0x82000000 P21_5000S.TXT ${filesize}
fi

if sf probe 2:1 5000000; then
  setenv xfhstage 'OK SPI bus 2 cs 1 5000000 Hz'
  if env export -t 0x82000000 xfhstage; then
    fatwrite mmc 0:1 0x82000000 P21_5000Y.TXT ${filesize}
  fi

  setenv xfh_found 1
  setenv xfh_bus 2:1
  setenv xfh_hz 5000000
else
  setenv xfhstage 'FAIL SPI bus 2 cs 1 5000000 Hz'
  if env export -t 0x82000000 xfhstage; then
    fatwrite mmc 0:1 0x82000000 P21_5000N.TXT ${filesize}
  fi

fi
setenv xfhstage 'V4 SPI scan completed'
if env export -t 0x82000000 xfhstage; then
  fatwrite mmc 0:1 0x82000000 20_SCAN_END.TXT ${filesize}
fi

if test "${xfh_found}" = "1"; then
  setenv xfhstage 'At least one SPI probe succeeded'
  if env export -t 0x82000000 xfhstage; then
    fatwrite mmc 0:1 0x82000000 21_FLASH_FOUND.TXT ${filesize}
  fi

  if sf probe ${xfh_bus} ${xfh_hz}; then
    if sf read 0x81000000 0x0 0x1000; then
      if fatwrite mmc 0:1 0x81000000 SPI_FIRST_4K.BIN 0x1000; then
        setenv xfhstage 'SPI first 4096 bytes saved to SD'
        if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 22_READ_OK.TXT ${filesize}
        fi

      else
        setenv xfhstage 'SPI sample read OK; SD write failed'
        if env export -t 0x82000000 xfhstage; then
          fatwrite mmc 0:1 0x82000000 22_SD_FAIL.TXT ${filesize}
        fi

      fi
    else
      setenv xfhstage 'SPI probe OK but 4096 byte read failed'
      if env export -t 0x82000000 xfhstage; then
        fatwrite mmc 0:1 0x82000000 22_READ_FAIL.TXT ${filesize}
      fi

    fi
  else
    setenv xfhstage 'SPI reprobe failed after scan'
    if env export -t 0x82000000 xfhstage; then
      fatwrite mmc 0:1 0x82000000 22_REPROBE_FAIL.TXT ${filesize}
    fi

  fi
else
  setenv xfhstage 'All SPI probe candidates failed'
  if env export -t 0x82000000 xfhstage; then
    fatwrite mmc 0:1 0x82000000 21_FLASH_MISSING.TXT ${filesize}
  fi

fi
setenv xfhstage 'V4 diagnostics completed; inspect marker files'
if env export -t 0x82000000 xfhstage; then
  fatwrite mmc 0:1 0x82000000 99_END.TXT ${filesize}
fi

echo XFH V4 finished. Power off before removing SD.
# End of script. Flash contents are NEVER written to SPI.
