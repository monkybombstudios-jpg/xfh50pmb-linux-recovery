#!/usr/bin/env python3
import struct,sys
from pathlib import Path
p=Path(sys.argv[1] if len(sys.argv)>1 else 'DRIVER9.BIN')
b=p.read_bytes();assert len(b)==1024,(len(b),'expected 1024 bytes')
w=struct.unpack('<256I',b)
labels={0x100:'SPI driver probe entered',0x101:'AHB clock lookup rc',0x102:'MOD clock lookup rc',0x103:'reset lookup rc',0x200:'clock enable entered',0x201:'AHB clock enable rc',0x202:'MOD clock enable rc',0x203:'reset deassert rc',0x204:'clock disable and reset asserted',0x300:'claim bus entered',0x301:'claim clock enable rc',0x302:'controller state: GCR/TCR/CCR',0x303:'release bus',0x400:'SPI xfer entered: bitlen/flags/cs',0x401:'transfer chunk complete: nbytes/FSR/TCR',0x402:'RX first three bytes/bitlen',0x4ee:'transfer timeout errno/TCR/FSR'}
n=w[0];print('events',n)
if n>60: raise SystemExit('INVALID trace count')
for i in range(n):
 code,a,bb,c=w[1+4*i:5+4*i]
 print(f'{i:02} {code:03x} {labels.get(code,"unknown"):38} {a:08x} {bb:08x} {c:08x}')
