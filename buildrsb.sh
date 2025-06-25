#!/bin/bash
sudo apt install build-essential g++ gdb unzip pax bison flex texinfo \
python3-dev python-is-python3 libncurses-dev zlib1g-dev \
ninja-build pkg-config python git

cd $HOME/RTEMS_devel/src/rtems-source-builder/rtems

../source-builder/sb-set-builder --prefix=$HOME/RTEMS_devel/rtems/7 7/rtems-aarch64
