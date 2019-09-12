#!/bin/bash


dpkg --add-architecture i386 && apt-get update && apt-get install -y git ccache automake bc lzop bison gperf build-essential zip curl zlib1g-dev zlib1g-dev:i386 g++-multilib python-networkx libxml2-utils bzip2 libbz2-dev libbz2-1.0 libghc-bzlib-dev squashfs-tools pngcrush schedtool dpkg-dev liblz4-tool make optipng &&
export LOFASZ=$PWD && 
git clone --depth=6 https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 /pipeline/build/root/toolchain/aarch64-linux-android-4.9 &&
cd /pipeline/build/root/toolchain/aarch64-linux-android-4.9 && git reset --hard 22f053ccdfd0d73aafcceff3419a5fe3c01e878b &&
git clone --depth=6 https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9 /pipeline/build/root/toolchain/arm-linux-androideabi-4.9 &&
cd /pipeline/build/root/toolchain/arm-linux-androideabi-4.9 && git reset --hard 42e5864a7d23921858ca8541d52028ff88acb2b6 &&
git clone https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86 /pipeline/build/root/toolchain/gclang &&
git clone https://github.com/PsyMan47/SnapDragonLLVM_6.0 /pipeline/build/root/toolchain/SnapDragonLLVM_6.0
git clone -b 9.0 https://github.com/syberia-project/platform_prebuilts_build-tools /pipeline/build/root/toolchain/asd
git clone -b 9.0 https://github.com/syberia-project/DragonTC /pipeline/build/root/toolchain/dtc
cd $LOFASZ
bash builder.sh
