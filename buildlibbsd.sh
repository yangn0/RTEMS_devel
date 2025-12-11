#!/bin/bash
rtems_version=6

qemu_test=0
rtems_libbsd_path=$HOME/RTEMS_devel/src/rtems-libbsd
rtems_prefix=$HOME/RTEMS_devel/rtems/$rtems_version
export PATH=$HOME/RTEMS_devel/rtems/$rtems_version/bin:$PATH
arch=aarch64
bsp=zynqmp_qemu
# bsp=xilinx_zynq_a9_qemu
# arch=aarch64
# bsp=raspberrypi4b
#xilinx_versal_qemu
#xilinx_zynqmp_lp64_qemu xilinx_zynq_a9_qemu

buildset=everything
# test_name=media01
test_name=ipsec01
# test_name=crypto01
# test_name=unix01
# test_name=syscalls01
# test_name=ttcpshell01

cd $rtems_libbsd_path
# ./waf uninstall
./waf distclean
./waf configure --prefix=$rtems_prefix \
      --rtems-bsps=$arch/$bsp \
      --buildset=buildset/$buildset.ini \
      --optimization 0
      # --enable-auto-regen
./waf
./waf install

if [ "$bsp" = xilinx_zynq_a9_qemu -a $qemu_test == 1 ]; then
# sudo ip tuntap add qtap mode tap user $(whoami)
# sudo ip link set dev qtap up
# sudo ip addr add 169.254.1.1/16 dev qtap
# -S -s
qemu-system-arm  -S -s -serial null -serial mon:stdio -nographic \
  -M xilinx-zynq-a9 -m 256M \
  -net nic,model=cadence_gem \
  -net tap,ifname=qtap,script=no,downscript=no \
  -kernel build/arm-rtems$rtems_version-xilinx_zynq_a9_qemu-$buildset/$test_name.exe
fi

if [ "$bsp" = raspberrypi4b -a $qemu_test == 1 ]; then
cd ~/RTEMS_devel
# app=$HOME/RTEMS_devel/src/rtems-libbsd/build/aarch64-rtems$rtems_version-raspberrypi4b-$buildset/ftpd01.exe
app=$HOME/RTEMS_devel/src/rtems-libbsd/build/aarch64-rtems$rtems_version-raspberrypi4b-$buildset/ttcpshell01.exe
# $arch-rtems$rtems_version-objcopy -O binary $HOME/RTEMS_devel/src/rtems-libbsd/build/aarch64-rtems$rtems_version-raspberrypi4b-$buildset/media01.exe kernel8.img
# $arch-rtems$rtems_version-objcopy -O binary $HOME/RTEMS_devel/src/rtems-libbsd/build/aarch64-rtems$rtems_version-raspberrypi4b-$buildset/telnetd01.exe kernel8.img
$arch-rtems$rtems_version-objcopy -O binary $app kernel8.img
# $arch-rtems$rtems_version-objcopy -O binary $HOME/RTEMS_devel/src/rtems-libbsd/build/aarch64-rtems$rtems_version-raspberrypi4b-$buildset/netshell01.exe kernel8.img
# $arch-rtems$rtems_version-objcopy -O binary $HOME/RTEMS_devel/src/rtems-libbsd/build/aarch64-rtems$rtems_version-raspberrypi4b-$buildset/ping01.exe kernel8.img
# $arch-rtems$rtems_version-objcopy -O binary $HOME/RTEMS_devel/src/rtems-libbsd/build/aarch64-rtems$rtems_version-raspberrypi4b-$buildset/init01.exe kernel8.img
# $arch-rtems$rtems_version-objcopy -O binary $HOME/RTEMS_devel/src/rtems-libbsd/build/aarch64-rtems$rtems_version-raspberrypi4b-$buildset/ipsec01.exe kernel8.img
cp kernel8.img /mnt/c/Users/79230/Desktop/tftp/
# qemu-system-aarch64 -M raspi4b -serial mon:stdio -nographic -kernel /mnt/c/Users/79230/Desktop/tftp/kernel8.img
fi

if [ "$bsp" = zynqmp_qemu -a $qemu_test == 1 ]; then

  if [ "$(uname)"=="Darwin" ]; then
    qemu-system-aarch64 -no-reboot -nographic \
      -serial mon:stdio -machine xlnx-zcu102 -m 4096 \
      -kernel build/aarch64-rtems$rtems_version-zynqmp_qemu-$buildset/$test_name.exe

  elif [ "$(expr substr $(uname -s) 1 5)"=="Linux" ]; then
    # sudo ip tuntap add qtap mode tap user $(whoami)
    # sudo ip link set dev qtap up
    # sudo ip addr add 169.254.1.1/16 dev qtap
    qemu-system-aarch64  -no-reboot -nographic  \
        -serial mon:stdio -machine xlnx-zcu102 -m 4096 \
        -net nic,model=cadence_gem \
        -net tap,ifname=qtap,script=no,downscript=no \
        -kernel build/aarch64-rtems$rtems_version-zynqmp_qemu-$buildset/$test_name.exe
  fi
fi