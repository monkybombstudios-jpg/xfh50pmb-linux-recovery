#!/usr/bin/env python3
"""Add a read-compatible 8 MiB EON EN25QH64 JEDEC 1c7017 ID to U-Boot 2023.04.
No SPI flash write/erase code altered. Fail closed if unsupported source tree.
"""
from pathlib import Path
import sys
r=Path(sys.argv[1]); p=r/'drivers/mtd/spi/spi-nor-ids.c'
s=p.read_text()
anchor='	{ INFO("en25qh128",  0x1c7018, 0, 64 * 1024,  256, 0) },'
new='	{ INFO("en25qh64-xfh", 0x1c7017, 0, 64 * 1024,  128, 0) }, /* XFH observed 2026 JEDEC */'
if s.count(anchor)!=1: raise SystemExit('STOP: expected EON vendor ID table anchor missing/ambiguous')
if '0x1c7017' in s: raise SystemExit('STOP: ID already present in this U-Boot version; inspect duplicate')
p.write_text(s.replace(anchor,new+'\n'+anchor,1))
print('XFH: EON 1c7017 read-compatible 8 MiB device entry installed')
