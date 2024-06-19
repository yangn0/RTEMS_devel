#!/bin/bash

#aarch64/raspberrypi4b
#aarch64/xilinx_versal_qemu
#xilinx_zynqmp_lp64_qemu
#arm/xilinx_zynq_a9_qemu
cd /home/yangn0/RTEMS_devel/src/rtems-libbsd
# ./waf distclean
./waf configure --prefix=$HOME/RTEMS_devel/rtems/6 \
      --rtems-bsps=arm/xilinx_zynq_a9_qemu \
      --buildset=buildset/default.ini
./waf
./waf install