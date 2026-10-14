#!/usr/bin/env python3
# Deterministic edits, not malformed patch hunks. Fail closed on missing anchors.
import sys,re
from pathlib import Path
kind=sys.argv[1]; root=Path(sys.argv[2])

def update(path,what,repl,count=1):
    p=root/path
    s=p.read_text()
    if what not in s: raise SystemExit(f'Unsupported source tree: {path}, anchor {what!r}')
    if s.count(what)!=count: raise SystemExit(f'Ambiguous source anchor {path}: {s.count(what)} hits')
    p.write_text(s.replace(what,repl,count))

if kind == 'linux':
    dtsi='arch/arm/boot/dts/allwinner/suniv-f1c100s.dtsi'
    dts='arch/arm/boot/dts/allwinner/suniv-f1c100s-licheepi-nano.dts'
    p=root/dtsi
    s=p.read_text()
    # Preserve standard pinmux; add an independent XFH-specific 1-bit group.
    anchor='''\t\t\tmmc0_pins: mmc0-pins {'''
    replacement='''\t\t\txfh_mmc0_1bit_pins: xfh-mmc0-1bit-pins {
                pins = "PF1", "PF2", "PF3";
                function = "mmc0";
                drive-strength = <30>;
            };

\t\t\tmmc0_pins: mmc0-pins {'''
    update(dtsi,anchor,replacement)
    update(dts,'bus-width = <4>;','bus-width = <1>;')
    update(dts,'\tbus-width = <1>;','\tbus-width = <1>;\n\tpinctrl-0 = <&xfh_mmc0_1bit_pins>;')
    # Keep the original board DTS in place but replace the flash description.
    update(dts,'compatible = "winbond,w25q128", "jedec,spi-nor";',
           'compatible = "jedec,spi-nor";')
    update(dts,'spi-max-frequency = <40000000>;',
           '''spi-max-frequency = <10000000>;
            partitions {
                compatible = "fixed-partitions";
                #address-cells = <1>;
                #size-cells = <1>;
                partition@0 {
                    label = "factory-nor-readonly";
                    reg = <0x00000000 0x00800000>;
                    read-only;
                };
            };''')
    # Enable UART2 without clobbering the SD or flash pins.
    update(dtsi,'''\t\t\tmmc0_pins: mmc0-pins {''',
           '''\t\t\txfh_uart2_pins: xfh-uart2-pins {
                pins = "PE7", "PE8";
                function = "uart2";
            };

\t\t\tmmc0_pins: mmc0-pins {''')
    with (root/dts).open('a') as f:
        f.write('''
&uart2 { pinctrl-names = "default"; pinctrl-0 = <&xfh_uart2_pins>; status = "okay"; };
&otg_sram { status = "okay"; };
&usb_otg { dr_mode = "host"; status = "okay"; };
&usbphy { status = "okay"; };
''')
    update(dts,'stdout-path = "serial0:115200n8";', 'stdout-path = "serial2:115200n8";')
    update(dts,'\t\tserial0 = &uart0;', '\t\tserial0 = &uart0;\n\t\tserial2 = &uart2;')
    print('XFH Linux source pinmux/read-only NOR/UART2 modification: PASS')
elif kind == 'uboot':
    dtsi='arch/arm/dts/suniv-f1c100s.dtsi'
    dts='arch/arm/dts/suniv-f1c100s-licheepi-nano.dts'
    update(dtsi,'\t\t\tmmc0_pins: mmc0-pins {',
           '''\t\t\txfh_mmc0_1bit_pins: xfh-mmc0-1bit-pins {
                pins = "PF1", "PF2", "PF3";
                function = "mmc0";
            };
\t\t\tmmc0_pins: mmc0-pins {''')
    update(dts,'bus-width = <4>;','bus-width = <1>;\n\tpinctrl-0 = <&xfh_mmc0_1bit_pins>;')
    df='configs/licheepi_nano_defconfig'
    with (root/df).open('a') as f:
        f.write('''
# XFH recovery boot: SD/FAT only; ignore persistent NOR environment.
CONFIG_ENV_IS_NOWHERE=y
CONFIG_USE_BOOTCOMMAND=y
CONFIG_BOOTCOMMAND="mmc dev 0; if fatload mmc 0:1 0x81700000 boot.scr; then source 0x81700000; fi"
CONFIG_CMD_MMC=y
CONFIG_CMD_FAT=y
CONFIG_CMD_BOOTZ=y
CONFIG_SPL_MMC=y
''')
    print('XFH U-Boot source 1-bit SD/boot.cmd modification: PASS')
else:
    raise SystemExit('usage: patch-source.py linux|uboot /source-tree')
