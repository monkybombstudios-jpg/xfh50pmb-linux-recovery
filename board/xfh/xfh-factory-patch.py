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
    new.write_text(s)
    conf=root/'configs/xfh50pmb_defconfig'
    s=(root/'configs/licheepi_nano_defconfig').read_text()
    s=re.sub(r'^CONFIG_DEFAULT_DEVICE_TREE=.*$',
             'CONFIG_DEFAULT_DEVICE_TREE="suniv-f1c100s-xfh50pmb"',s,flags=re.M)
    if 'CONFIG_DEFAULT_DEVICE_TREE=' not in s:
        s+='\nCONFIG_DEFAULT_DEVICE_TREE="suniv-f1c100s-xfh50pmb"\n'
    # NOTE: do NOT assume factory 156MHz SDR clock is safe for a different 2026 board.
    # Keep the upstream boot0 DRAM logic until it is independently confirmed.
    conf.write_text(s)
    print('XFH U-Boot board defconfig created',conf)
else:raise SystemExit('usage: xfh-factory-patch.py linux|uboot /source')
