# XFH-50PMB Linux rescue — CI build package, not a prebuilt image

This is a **real Linux source/build project**, rather than another SPL-only probe.
It is tailored to the 2023 XFH hardware configuration but still needs testing
on the user's **different 2026 head-unit revision**.

**This archive does NOT contain a compiled Linux SD image.** No Linux source,
ARM kernel compiler, or armv5 userspace toolchain is available in the chat
runtime, and it has no access to fetch those sources. The GitHub Actions workflow
performs that full build on a Linux runner and publishes the actual `sdcard.img`.

## Intended boot path
- BootROM -> SD SPL/U-Boot 2023.04
- U-Boot FAT boot script -> Linux 6.6.143 kernel & XFH 1-bit SD device tree
- Kernel -> ext4 rootfs -> init `/usr/sbin/xfh-diag`
- Writes `BOOT_REPORT.TXT` and `KERNEL_LOG.TXT` to FAT SD partition
- **No automatic internal flash backup**; there is an optional manual read-only
  script only for the later stage, after verifying logs and MTD layout.

## Hardware safety
- NAND/SPI NOR is never erased or programmed by our scripts.
- Linux DT declares `read-only` for the sole 8MiB factory NOR partition.
- No framebuffer required for the first report.
- LED colors are not treated as conclusive evidence of Linux boot.
- The 2023 reference flash is not the user's 2026 firmware. Never flash it.
- Do not run the optional `xfh-backup-readonly` script yet.

## Cloud build steps (no Mac compilation / no source downloads to Mac)
1. Create an empty **private** GitHub repository.
2. Unzip this package on the Mac. Upload its contents to the repo,
   including `.github/workflows/build-recovery.yml` (hidden folder).
3. Open GitHub **Actions** -> **Build XFH Linux Rescue SD Image** -> **Run workflow**.
4. Wait for a full green build, download the artifact `XFH_LINUX_RESCUE_SD_IMAGE`.
5. Send us its `sdcard.img` and `SHA256SUMS.txt` to verify before flashing.

## Success criterion
After flashing to SD and inserting into the fully powered-off head unit, Linux
must create `BOOT_REPORT.TXT` in the FAT partition. If absent, Linux userspace
has not been proven to boot. We should inspect CI build logs and U-Boot output
rather than guessing that the LED color implies success.

## Why 1-bit SD matters
The 2023 XFH FEX lists **only PF1 DAT0, PF2 CLK and PF3 CMD**. A generic
Lichee Pi Nano Linux DT assigns the six pins PF0–PF5 and sets bus-width 4.
This project creates `xfh_mmc0_1bit_pins` and sets bus-width 1 in both Linux
and U-Boot. It also prevents port conflicts with PF4 (front-panel LED).

## Known risks
- Current head-unit revision could use different LCD/panel/SD wiring.
- Factory U-Boot DRAM training has not been reproduced/verified for the 2026 board.
- Linux kernel support/config symbols should be confirmed by the CI build logs.
- Static image checks prove format, **not** runtime bootability.
- U-Boot MMC access previously failed in the custom probes, so this new Linux
  chain is an experiment with standard drivers, not a promised boot.

No GUI in this first stage. The goal is a verified log from a real Linux boot.
