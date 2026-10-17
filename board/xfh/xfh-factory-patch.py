#!/usr/bin/env python3
"""Add board-named reference DTS based on the user-supplied 2020 IMAGEWTY FEX.

Runs AFTER the existing XFH 1-bit SD, read-only NOR patch. No guesses about
unverified touchscreen or backlight are enabled by this patch.
"""
import sys,re
from pathlib import Path
kind,root=sys.argv[1],Path(sys.argv[2])
if kind=='linux':
    parent=root/'arch/arm/boot/dts/allwinner'
    old=parent/'suniv-f1c100s-licheepi-nano.dts'
    new=parent/'suniv-f1c100s-xfh50pmb.dts'
    s=old.read_text()
    assert 'model = "Lichee Pi Nano"' in s
    s=s.replace('model = "Lichee Pi Nano"', 'model = "XFH-50pMB reference (2023/2020, unverified 2026)"')
    s=s.replace('compatible = "licheepi,licheepi-nano", "allwinner,suniv-f1c100s";',
                'compatible = "xfh,50pmb-reference", "allwinner,suniv-f1c100s";')
    s+='''\n/* Vendor IMAGEWTY FEX reference (not a verified 2026 board):\n * LCD 800x480, PA4 BL, PE12 PWM, data PD1..11,PD13..17, CLK PD18, DE PD19.\n * LED GPIO PD20/PD21/PE4; NOT LCD HSYNC/VSYNC.\n * Do NOT enable LCD/backlight GPIO until driver/polarity and panel timings\n * are independently validated. This early image remains headless by design.\n */\n'''
    new.write_text(s)
    print('XFH Linux reference DTS created',new)
elif kind=='uboot':
    parent=root/'arch/arm/dts'
    old=parent/'suniv-f1c100s-licheepi-nano.dts'
    new=parent/'suniv-f1c100s-xfh50pmb.dts'
    s=old.read_text()
    assert 'model = "Lichee Pi Nano"' in s
    s=s.replace('model = "Lichee Pi Nano"','model = "XFH-50pMB reference"')
    s=s.replace('compatible = "licheepi,licheepi-nano", "allwinner,suniv-f1c100s";',
                'compatible = "xfh,50pmb-reference", "allwinner,suniv-f1c100s";')
    s=s.replace('spi-max-frequency = <40000000>;', 'spi-max-frequency = <10000000>;')
    # Factory FEX SPI0 PC0-3, preserve SPL.
    if '&spi0 {' not in s: raise SystemExit('Cannot find SPI0 in U-Boot DTS')
    parent_dtsi=(root/'arch/arm/dts/suniv-f1c100s.dtsi').read_text()
    if 'spi0_pc_pins' not in parent_dtsi or 'spi0:' not in parent_dtsi: raise SystemExit('Missing SPI0 controller/pinmux in DTSI')
    new.write_text(s)
    conf=root/'configs/xfh50pmb_defconfig'
    s=(root/'configs/licheepi_nano_defconfig').read_text()
    s=re.sub(r'^CONFIG_DEFAULT_DEVICE_TREE=.*$',
             'CONFIG_DEFAULT_DEVICE_TREE="suniv-f1c100s-xfh50pmb"',s,flags=re.M)
    if 'CONFIG_DEFAULT_DEVICE_TREE=' not in s:
        s+='\nCONFIG_DEFAULT_DEVICE_TREE="suniv-f1c100s-xfh50pmb"\n'
    # NOTE: do NOT assume factory 156MHz SDR clock is safe for a different 2026 board.
    # Keep the upstream boot0 DRAM logic until it is independently confirmed.
    # Read-only SPI flash probe/extraction commands for XFH V3.
    s += "\nCONFIG_CMD_SF=y\nCONFIG_SPI_FLASH=y\nCONFIG_SPI=y\nCONFIG_DM_SPI=y\nCONFIG_SPI_SUNXI=y\nCONFIG_FAT_WRITE=y\nCONFIG_CMD_GPIO=y\nCONFIG_CMD_DM=y\nCONFIG_DM=y\nCONFIG_DM_GPIO=y\n"
    conf.write_text(s)
    import subprocess
    subprocess.run([sys.executable, str(Path(__file__).parent/'patch_spi_trace.py'), str(root)], check=True)
    print('XFH U-Boot board defconfig created',conf)
else:raise SystemExit('usage: xfh-factory-patch.py linux|uboot /source')
