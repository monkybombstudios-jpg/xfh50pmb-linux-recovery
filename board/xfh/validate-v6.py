#!/usr/bin/env python3
from pathlib import Path
import sys,subprocess
base=Path(sys.argv[1] if len(sys.argv)>1 else 'output')
report=base/'HARDWARE_BUILD_REPORT.txt'
rows=[]; bad=[]
def check(k,v):
 rows.append(f'{k}: {"PASS" if v else "FAIL"}')
 if not v: bad.append(k)
try:
 confs=list(base.glob('build/uboot-*/.config'))
 if len(confs)!=1: raise RuntimeError(f'Expected one compiled U-Boot .config, found {len(confs)}')
 uroot=confs[0].parent
 lines=set(confs[0].read_text().splitlines())
 for name in ['CONFIG_CMD_SF','CONFIG_SPI_FLASH','CONFIG_SPI','CONFIG_DM_SPI','CONFIG_SPI_SUNXI','CONFIG_FAT_WRITE','CONFIG_CMD_GPIO','CONFIG_DM']:
  check(name,name+'=y' in lines)
 check('U_BOOT_BIN',(uroot/'u-boot.bin').is_file())
 dtbs=list(uroot.rglob('suniv-f1c100s-xfh50pmb.dtb'))
 if not dtbs: dtbs=list(uroot.rglob('u-boot.dtb'))
 check('DTB_FOUND',bool(dtbs))
 if dtbs:
  q=subprocess.run(['dtc','-I','dtb','-O','dts',str(dtbs[0])],capture_output=True,text=True)
  check('DTB_DECODE',q.returncode==0)
  if q.returncode==0:
   # DT name is an exact hardware probe, presence alone does not prove node enabled.
   check('SPI0_NODE','spi@1c05000' in q.stdout or 'spi@01c05000' in q.stdout)
except Exception as e:
 rows.append('ERROR: '+repr(e));bad.append('exception')
rows.append('RESULT: '+'FAIL '+','.join(bad) if bad else 'RESULT: PASS')
report.write_text('\n'.join(rows)+'\n')
print(report.read_text())
if bad: raise SystemExit('V6 U-Boot compiled hardware support incomplete')
