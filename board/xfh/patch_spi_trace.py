#!/usr/bin/env python3
"""Patch U-Boot v2023.04 sun4i driver with no-console trace to DRAM.
Requires board/xfh/boot.cmd to zero the trace buffer before probe.
"""
from pathlib import Path
import sys
root=Path(sys.argv[1]); p=root/'drivers/spi/spi-sunxi.c'
s=p.read_text()
if 'XFH V9 TRACE' in s: raise SystemExit('V9 trace already installed')
marker='DECLARE_GLOBAL_DATA_PTR;'
assert s.count(marker)==1
trace='''
/* XFH V9 TRACE: 256 dwords at 0x82010000; safe only after DRAM boot.
 * No console or flash writes. Four words per record: marker,a,b,c.
 * Record 0 holds cursor at 0x82010000, entries begin at +4.
 * The boot script clears the full buffer before probing.
 */
#define XFH_TRACE_BASE 0x82010000UL
#define XFH_TRACE_LIMIT 60U
static void xfh_spi_trace(u32 code, u32 a, u32 b, u32 c)
{
    volatile u32 *buf = (volatile u32 *)XFH_TRACE_BASE;
    u32 n = buf[0];
    if (n >= XFH_TRACE_LIMIT) return;
    buf[1 + n * 4] = code;
    buf[2 + n * 4] = a;
    buf[3 + n * 4] = b;
    buf[4 + n * 4] = c;
    buf[0] = n + 1;
}
'''
s=s.replace(marker,marker+'\n'+trace,1)
def once(old,new):
 global s
 if s.count(old)!=1: raise SystemExit('V9 unsupported driver layout, anchor occurrences '+str(s.count(old))+': '+old[:90])
 s=s.replace(old,new,1)
# Probe: begin and clk_get resolution
once('ret = clk_get_by_name(bus, "ahb", &priv->clk_ahb);','xfh_spi_trace(0x100, plat->base, plat->max_hz, 0);\n\tret = clk_get_by_name(bus, "ahb", &priv->clk_ahb);\n\txfh_spi_trace(0x101, (u32)ret, 0, 0);')
once('ret = clk_get_by_name(bus, "mod", &priv->clk_mod);','ret = clk_get_by_name(bus, "mod", &priv->clk_mod);\n\txfh_spi_trace(0x102, (u32)ret, 0, 0);')
once('ret = reset_get_by_index(bus, 0, &priv->reset);','ret = reset_get_by_index(bus, 0, &priv->reset);\n\txfh_spi_trace(0x103, (u32)ret, 0, 0);')
# Clock enable progression
once('ret = clk_enable(&priv->clk_ahb);','xfh_spi_trace(0x200, enable, 0, 0);\n\tret = clk_enable(&priv->clk_ahb);\n\txfh_spi_trace(0x201, (u32)ret, 0, 0);')
once('ret = clk_enable(&priv->clk_mod);','ret = clk_enable(&priv->clk_mod);\n\txfh_spi_trace(0x202, (u32)ret, 0, 0);')
once('ret = reset_deassert(&priv->reset);','ret = reset_deassert(&priv->reset);\n\t\txfh_spi_trace(0x203, (u32)ret, 0, 0);')
once('clk_disable(&priv->clk_ahb);\n\t\tclk_disable(&priv->clk_mod);','xfh_spi_trace(0x204, 0, 0, 0);\n\t\tclk_disable(&priv->clk_ahb);\n\t\tclk_disable(&priv->clk_mod);')
# Bus operations
once('ret = sun4i_spi_set_clock(dev->parent, true);','xfh_spi_trace(0x300, 0, 0, 0);\n\tret = sun4i_spi_set_clock(dev->parent, true);\n\txfh_spi_trace(0x301, (u32)ret, 0, 0);')
once('sun4i_spi_set_speed_mode(dev->parent);','sun4i_spi_set_speed_mode(dev->parent);\n\txfh_spi_trace(0x302, readl(SPI_REG(priv, SPI_GCR)), readl(SPI_REG(priv, SPI_TCR)), readl(SPI_REG(priv, SPI_CCR)));')
once('sun4i_spi_set_clock(dev->parent, false);','xfh_spi_trace(0x303, 0, 0, 0);\n\tsun4i_spi_set_clock(dev->parent, false);')
# Capture all xfers and results, including RX first bytes, and timeout.
once('priv->tx_buf = dout;\n\tpriv->rx_buf = din;','priv->tx_buf = dout;\n\tpriv->rx_buf = din;\n\txfh_spi_trace(0x400, bitlen, (u32)flags, (u32)slave_plat->cs);')
once('if (ret < 0) {\n\t\t\tprintf("ERROR: sun4i_spi: Timeout transferring data\\n");','if (ret < 0) {\n\t\t\txfh_spi_trace(0x4EE, (u32)ret, readl(SPI_REG(priv, SPI_TCR)), readl(SPI_REG(priv, SPI_FSR)));\n\t\t\tprintf("ERROR: sun4i_spi: Timeout transferring data\\n");')
once('sun4i_spi_drain_fifo(priv, nbytes);','sun4i_spi_drain_fifo(priv, nbytes);\n\t\txfh_spi_trace(0x401, nbytes, readl(SPI_REG(priv, SPI_FSR)), readl(SPI_REG(priv, SPI_TCR)));')
once('if (flags & SPI_XFER_END)\n\t\tsun4i_spi_set_cs(bus, slave_plat->cs, false);','if (flags & SPI_XFER_END)\n\t\tsun4i_spi_set_cs(bus, slave_plat->cs, false);\n\tif (din && bitlen >= 24) {\n\t\tconst u8 *r = din;\n\t\txfh_spi_trace(0x402, ((u32)r[0] << 16) | ((u32)r[1] << 8) | r[2], bitlen, 0);\n\t}')
p.write_text(s)
print('XFH V9 driver trace patch applied',p)
