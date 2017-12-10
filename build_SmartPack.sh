#!/bin/bash

#
# SmartPack-Kernel Build Script
# 
# Author: sunilpaulmathew <sunil.kde@gmail.com>
#

#
# This script is licensed under the terms of the GNU General Public 
# License version 2, as published # by the Free Software Foundation, 
# and may be copied, distributed, and modified under those terms.
#

#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR # PURPOSE. See the
# GNU General Public License for more details.
#

# ***** ***** *Variables to be configured manually* ***** ***** #

TOOLCHAIN="/home/sunil/android-ndk-r15c/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi-"
ARCHITECTURE="arm"

KERNEL_NAME="SmartPack-Kernel"

KERNEL_VARIANT="kltekor"	# only one variant at a time

KERNEL_VERSION="stable-v9"   # leave as such, if no specific version tag

KERNEL_DATE="$(date +"%Y%m%d")"

KERNEL_DEFCONFIG="SmartPack_defconfig"

VARIANT_DEFCONFIG="SmartPack_@$KERNEL_VARIANT@_defconfig"

COMPILE_DTB="y"

NUM_CPUS=""   # number of cpu cores used for build (leave empty for auto detection)

COLOR_RED="\033[0;31m"
COLOR_GREEN="\033[1;32m"
COLOR_NEUTRAL="\033[0m"

# ***** ***** ***** ***** ***THE END*** ***** ***** ***** ***** #

export ARCH=$ARCHITECTURE
export CROSS_COMPILE="${CCACHE} $TOOLCHAIN"

if [ -z "$NUM_CPUS" ]; then
	NUM_CPUS=`grep -c ^processor /proc/cpuinfo`
fi

if [ -z "$KERNEL_VARIANT" ]; then
	echo -e $COLOR_GREEN"\n Please select the variant to build... 'KERNEL_VARIANT' should not be empty...\n"$COLOR_NEUTRAL
else
	if [ -e arch/arm/configs/$VARIANT_DEFCONFIG ]; then
		echo -e $COLOR_GREEN"\n building $KERNEL_NAME for $KERNEL_VARIANT\n"$COLOR_NEUTRAL
		if [ -e output_$KERNEL_VARIANT/.config ]; then
			rm -f output_$KERNEL_VARIANT/.config
			if [ -e output_$KERNEL_VARIANT/arch/arm/boot/zImage ]; then
				rm -f output_$KERNEL_VARIANT/arch/arm/boot/zImage
			fi
		else
			mkdir output_$KERNEL_VARIANT
		fi
		make -C $(pwd) O=output_$KERNEL_VARIANT $KERNEL_DEFCONFIG VARIANT_DEFCONFIG=$VARIANT_DEFCONFIG SELINUX_DEFCONFIG=selinux_defconfig && make -j$NUM_CPUS -C $(pwd) O=output_$KERNEL_VARIANT
		if [ -e output_$KERNEL_VARIANT/arch/arm/boot/zImage ]; then
			echo -e $COLOR_GREEN"\n copying zImage to anykernel directory\n"$COLOR_NEUTRAL
			cp output_$KERNEL_VARIANT/arch/arm/boot/zImage anykernel_SmartPack/
			# compile dtb if required
			if [ "y" == "$COMPILE_DTB" ]; then
				echo -e $COLOR_GREEN"\n compiling device tree blob (dtb)\n"$COLOR_NEUTRAL
				if [ -f output_$KERNEL_VARIANT/arch/arm/boot/dt.img ]; then
					rm -f output_$KERNEL_VARIANT/arch/arm/boot/dt.img
				fi
				chmod 777 tools/dtbToolCM
				tools/dtbToolCM -2 -o output_$KERNEL_VARIANT/arch/arm/boot/dt.img -s 2048 -p output_$KERNEL_VARIANT/scripts/dtc/ output_$KERNEL_VARIANT/arch/arm/boot/
				# removing old dtb (if any)
				if [ -f anykernel_SmartPack/dtb ]; then
					rm -f anykernel_SmartPack/dtb
				fi
				# copying generated dtb to anykernel directory
				if [ -e output_$KERNEL_VARIANT/arch/arm/boot/dt.img ]; then
					mv -f output_$KERNEL_VARIANT/arch/arm/boot/dt.img anykernel_SmartPack/dtb
				fi
			fi
			echo -e $COLOR_GREEN"\n generating recovery flashable zip file\n"$COLOR_NEUTRAL
			cd anykernel_SmartPack/ && zip -r9 $KERNEL_NAME-TW-$KERNEL_VARIANT-$KERNEL_VERSION-$KERNEL_DATE.zip * -x README.md $KERNEL_NAME-TW-$KERNEL_VARIANT-$KERNEL_VERSION-$KERNEL_DATE.zip && cd ..
			echo -e $COLOR_GREEN"\n cleaning...\n"$COLOR_NEUTRAL
			rm anykernel_SmartPack/zImage && mv anykernel_SmartPack/$KERNEL_NAME* release_SmartPack/
			if [ -f anykernel_SmartPack/dtb ]; then
				rm -f anykernel_SmartPack/dtb
			fi
			echo -e $COLOR_GREEN"\n everything done... please visit "release_SmartPack"...\n"$COLOR_NEUTRAL
		else
			if [ -f anykernel_SmartPack/dtb ]; then
				rm -f anykernel_SmartPack/dtb
			fi
			echo -e $COLOR_GREEN"\n Building error... zImage not found...\n"$COLOR_NEUTRAL
		fi
	else
		echo -e $COLOR_GREEN"\n '$KERNEL_VARIANT' is not a supported variant... please check...\n"$COLOR_NEUTRAL
	fi
fi
