#!/bin/bash

#
# Copyright © 2017, Rohan Taneja @ xda-developers
#
# This is a build script for building Daredevil Kernel builds
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
#

clear

VAR="Beta"
BUILD_DATE=$(date +"%Y%m%d")
TREE=$PWD
IMAGE=$TREE/arch/arm64/boot/Image.gz-dtb
mkdir output
OUTPUTDIR=$TREE/output

# shell script colors
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
defcol='\033[0m'

# fixed settings
export ARCH=arm64
export SUBARCH=arm64
export CONFIG_NO_ERROR_ON_MISMATCH=y
export CROSS_COMPILE=aarch64-linux-android-
JOBS=-j$(nproc)

# Make changes as per the user
export PATH=/home/rohantaneja/aarch64-linux-android-4.9/bin:$PATH
export KBUILD_BUILD_USER="rohantaneja"
export KBUILD_BUILD_HOST="daredevil"
DEVICE="kungfu"
CONFIG="daredevil_defconfig"

#export CONFIG_DEBUG_SECTION_MISMATCH=y

# Function declaration
dd_clean() {
                rm -rf $IMAGE
                make clean mrproper
                rm -rf $OUTPUTDIR/*
                   }

dd_compile() {
                echo "$red *******************************"
                echo "$green*    Compilation in Progress    *"
                echo "$blue *******************************$defcol"
                BUILD_BEGIN=$(date +"%s")
                make $CONFIG
                make $JOBS
                BUILD_TIME=$(date +"%H%M")
                if ![ -e "$IMAGE" ]; then
                echo "$red Error 404: Kernel not compiled."
                echo "Fix the compilation errors! $defcol"
                exit 1; fi;
                BUILD_END=$(date +"%s")
                DIFF=$(($BUILD_END - $BUILD_BEGIN))
                echo "$yellow Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
                cp -i $IMAGE $OUTPUTDIR/Image.gz-dtb
                    }

# Script Menu

while true;

clear

echo "$red                Welcome$green to$blue Daredevil$yellow Build Script$defcol"
echo "Make a choice to proceed further"
echo "$red(1) Clean kernel source tree"
echo "$green(2) Compile Daredevil-Test build"
echo "$yellow(3) Exit the script$defcol"

read -p "Enter your choice (1-3):" ch

do
case "$ch" in
1) dd_clean
;;
2) dd_compile
;;
3) exit 1
;;
esac
done
