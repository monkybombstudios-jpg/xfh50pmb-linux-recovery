#!/usr/bin/env python3
import sys,struct,hashlib
p=sys.argv[1]
with open(p,'rb') as f:
    mbr=f.read(512)
    if mbr[510:512] != b'\x55\xaa': raise SystemExit('FAIL: no MBR signature')
    f.seek(8192+4)
    if f.read(8) != b'eGON.BT0': raise SystemExit('FAIL: missing Allwinner SPL')
    parts=[]
    for i in (0,1):
        o=446+i*16
        typ=mbr[o+4]; start,n=struct.unpack_from('<II',mbr,o+8)
        parts.append((typ,start,n))
    if parts[0][0] not in (0x0b,0x0c) or parts[1][0]!=0x83:
        raise SystemExit(f'FAIL: partition types {parts}')
    f.seek(parts[0][1]*512)
    fat=f.read(512)
    if fat[510:512] != b'\x55\xaa': raise SystemExit('FAIL: no FAT boot sector')
    f.seek(parts[1][1]*512 + 1024 + 56)
    if f.read(2) != b'\x53\xef': raise SystemExit('FAIL: no ext4 filesystem')
print('XFH LINUX IMAGE STRUCTURE CHECK: PASS')
print('  SD MBR partitions:',parts)
print('  BootROM image at offset 8192: eGON.BT0')
print('  ext4 root filesystem detected')
