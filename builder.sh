#!/bin/bash

KERNEL_DIR=$PWD
ANYKERNEL_DIR=$KERNEL_DIR/AnyKernel2
CCACHEDIR=../CCACHE/cepheus
TOOLCHAINDIR=/pipeline/build/root/toolchain/aarch64-linux-android-4.9/bin
TOOLCHAIN32=/pipeline/build/root/toolchain/arm-linux-androideabi-4.9/bin
DATE=$(date +"%d%m%Y")
KERNEL_NAME="Syberia"
DEVICE="-cepheus-"
VER="-0.1"
TYPE="PIE-EAS"
FINAL_ZIP="$KERNEL_NAME""$DEVICE""$DATE""$TYPE""$VER".zip

rm $ANYKERNEL_DIR/cepheus/Image.gz-dtb
rm $KERNEL_DIR/arch/arm64/boot/Image.gz $KERNEL_DIR/arch/arm64/boot/Image.gz-dtb

export PATH="/pipeline/build/root/toolchain/gclang/clang-r349610b/bin:${TOOLCHAINDIR}:${TOOLCHAIN32}:${PATH}"
export ARCH=arm64
export KBUILD_BUILD_USER="mesziman"
export KBUILD_BUILD_HOST="github"
 export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${TOOLCHAINDIR}/lib"
 export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${TOOLCHAIN32}/lib"
export CC=clang
export CXX=clang++
export CLANG_TRIPLE=aarch64-linux-gnu-
#export CROSS_COMPILE=$TOOLCHAINDIR/bin/aarch64-linux-android-
export CROSS_COMPILE=aarch64-linux-android-
export CROSS_COMPILE_ARM32=arm-linux-androideabi-
#export LD_LIBRARY_PATH=$TOOLCHAINDIR/lib/
export USE_CCACHE=1
export CCACHE_DIR=$CCACHEDIR/.ccache

ls $TOOLCHAIN32

make clean && make mrproper
make O=out -C $KERNEL_DIR cepheus_defconfig
make O=out -C $KERNEL_DIR  -j$( nproc --all ) ARCH=arm64 CC=clang CXX=clang++ CLANG_TRIPLE=aarch64-linux-gnu- \
CROSS_COMPILE=aarch64-linux-android- CROSS_COMPILE_ARM32=arm-linux-androideabi- | tee ${WERCKER_REPORT_ARTIFACTS_DIR}/buildlog.txt
make O=out -C $KERNEL_DIR  -j$( nproc --all ) ARCH=arm64 CC=clang CXX=clang++ CLANG_TRIPLE=aarch64-linux-gnu- \
CROSS_COMPILE=aarch64-linux-android- CROSS_COMPILE_ARM32=arm-linux-androideabi-  Image.gz-dtb  | tee ${WERCKER_REPORT_ARTIFACTS_DIR}/buildloggz.txt
make O=out -C $KERNEL_DIR  -j$( nproc --all ) ARCH=arm64 CC=clang CXX=clang++ CLANG_TRIPLE=aarch64-linux-gnu- \
CROSS_COMPILE=aarch64-linux-android- CROSS_COMPILE_ARM32=arm-linux-androideabi-  dtbs  | tee ${WERCKER_REPORT_ARTIFACTS_DIR}/buildlogtb.txt
find -name "*.gz-dtb" | tee ${WERCKER_REPORT_ARTIFACTS_DIR}/buildlog.txt
ls $KERNEL_DIR/arch/arm64/boot/ | tee ${WERCKER_REPORT_ARTIFACTS_DIR}/buildlog.txt
{
cp $KERNEL_DIR/arch/arm64/boot/Image.gz-dtb $ANYKERNEL_DIR/cepheus
} || {
if [ $? != 0 ]; then
  echo "FAILED BUILD"
fi
}
ls $ANYKERNEL_DIR/cepheus | tee ${WERCKER_REPORT_ARTIFACTS_DIR}/buildlog.txt
cd $ANYKERNEL_DIR/cepheus
zip -r9 $FINAL_ZIP * -x *.zip $FINAL_ZIP
cp ${WERCKER_REPORT_ARTIFACTS_DIR}/buildlog* /pipeline/output/
mv $FINAL_ZIP /pipeline/output/$FINAL_ZIP
cp /pipeline/output/$FINAL_ZIP ${WERCKER_REPORT_ARTIFACTS_DIR}/
