#!/bin/bash
rtems_version=6

export PATH=$HOME/RTEMS_devel/rtems/$rtems_version/bin:$PATH
rtems_src_path=$HOME/RTEMS_devel/src/rtems
rtems_prefix=$HOME/RTEMS_devel/rtems/$rtems_version
rtems_config_path=$HOME/RTEMS_devel/config.ini

# cd ~/RTEMS_devel/src/rtems/bsps/aarch64/raspberrypi/fdt
# dtc -I dts -O dtb ./bcm2711-rpi-4-b.dts -o bcm2711-rpi-4-b.dtb
# rtems-bin2c bcm2711-rpi-4-b.dtb rpi4b_dtb.c
# rm rpi4b_dtb.h
# rm bcm2711-rpi-4-b.dtb

cd $rtems_src_path
./waf uninstall
./waf distclean
./waf configure --prefix=$rtems_prefix --rtems-config=$rtems_config_path
./waf
./waf install

arch=aarch64
# bsp=xilinx_versal_qemu
bsp=raspberrypi4b
# bsp=a72_lp64_qemu

cd ~/RTEMS_devel
app=~/RTEMS_devel/src/rtems/build/$arch/$bsp/testsuites/samples/hello.exe
# app=~/RTEMS_devel/src/rtems/build/$arch/$bsp/testsuites/sptests/spconsole01.exe
# cp $app /mnt/c/Users/79230/Desktop/test.exe

# $arch-rtems$rtems_version-objcopy -O binary $app kernel8.img
# cp kernel8.img /mnt/c/Users/79230/Desktop/tftp/

# qemu-system-aarch64 -no-reboot -nographic -serial mon:stdio -machine virt,gic-version=3 -cpu cortex-a72 -m 4096 -d trace:pl011_baudrate_change -kernel $app
# qemu-system-aarch64 -no-reboot -nographic -serial mon:stdio  -machine virt,gic-version=3 -cpu cortex-a53 -m 4096 -d trace:pl011_baudrate_change -kernel $app

# qemu-system-aarch64 -no-reboot -nographic -serial mon:stdio -machine xlnx-versal-virt -m 4096 -d trace:pl011_baudrate_change -kernel $app
# qemu-system-aarch64 -no-reboot -nographic -serial mon:stdio -machine xlnx-zcu102 -m 4096 -net nic,model=cadence_gem -net tap,ifname=qtap,script=no,downscript=no -kernel example.exe
# qemu-system-aarch64 -M raspi4b -serial mon:stdio -nographic -kernel kernel8.img