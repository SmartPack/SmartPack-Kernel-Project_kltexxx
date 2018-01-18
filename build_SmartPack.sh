#!/bin/bash

#
# SmartPack-Kernel Build Script
# 
# Author: sunilpaulmathew <sunil.kde@gmail.com>
#

#
# This script is licensed under the terms of the GNU General Public 
# License version 2, as published by the Free Software Foundation, 
# and may be copied, distributed, and modified under those terms.
#

#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#

#
# ***** ***** ***** ..How to use this script… ***** ***** ***** #
#
# For those who want to build this kernel using this script…
#
# Please note: this script is by-default designed to build all 
# the supported variants one after another.
#

# 1. Properly locate Stock, UBER & Linaro toolchains (Line# 42, 44 & 46)
# 2. Select the preferred toolchain for building (Line# 48)
# 3. Open Terminal, ‘cd’ to the Kernel ‘root’ folder and run ‘. build_variant-SmartPack.sh’
# 4. The output (anykernel zip) file will be generated in the ‘release_SmartPack’ folder
# 5. Enjoy your new Kernel

#
# ***** ***** *Variables to be configured manually* ***** ***** #

# Toolchains

GOOGLE="/home/sunil/android-ndk-r15c/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi-"

UBERTC="/home/sunil/UBERTC-arm-eabi-8.0/bin/arm-linux-androideabi-"

LINARO="/home/sunil/arm-linux-androideabi-7.x-linaro/bin/arm-linaro-linux-androideabi-"

TOOLCHAIN="linaro"	# Leave empty for using Google’s stock toolchain

ARCHITECTURE="arm"

KERNEL_NAME="SmartPack-Kernel"

KERNEL_VERSION="stable-v12"   # leave as such, if no specific version tag

KERNEL_DATE="$(date +"%Y%m%d")"

COMPILE_DTB="y"

NUM_CPUS=""   # number of cpu cores used for build (leave empty for auto detection)

# ***** ***** ***** ***** ***THE END*** ***** ***** ***** ***** #

COLOR_RED="\033[0;31m"
COLOR_GREEN="\033[1;32m"
COLOR_NEUTRAL="\033[0m"

export ARCH=$ARCHITECTURE

if [ -z "$TOOLCHAIN" ]; then
	echo -e $COLOR_GREEN"\n Toolchain: Google's stock gcc-4.9.x\n"$COLOR_NEUTRAL
	export CROSS_COMPILE="${CCACHE} $GOOGLE"
else
	if [ "ubertc" == "$TOOLCHAIN" ]; then
	echo -e $COLOR_GREEN"\n Toolchain: UBERTC-8.x\n"$COLOR_NEUTRAL
		export CROSS_COMPILE="${CCACHE} $UBERTC"
	else
		if [ "linaro" == "$TOOLCHAIN" ]; then
		echo -e $COLOR_GREEN"\n Toolchain: Linaro-7.x\n"$COLOR_NEUTRAL
			export CROSS_COMPILE="${CCACHE} $LINARO"
		fi
	fi
fi

if [ -z "$NUM_CPUS" ]; then
	NUM_CPUS=`grep -c ^processor /proc/cpuinfo`
fi

echo -e $COLOR_GREEN"\n building $KERNEL_NAME v. $KERNEL_VERSION for kltekor\n"$COLOR_NEUTRAL

# creating backups
cp scripts/mkcompile_h release_SmartPack/

# updating kernel name

sed -i "s;SmartPack-Kernel;$KERNEL_NAME-kltekor;" scripts/mkcompile_h;

if [ -e output_kltekor/.config ]; then
	rm -f output_kltekor/.config
	if [ -e output_kltekor/arch/arm/boot/zImage ]; then
		rm -f output_kltekor/arch/arm/boot/zImage
	fi
else
mkdir output_kltekor
fi

make -C $(pwd) O=output_kltekor SmartPack_@kltekor@_defconfig

# updating kernel version
sed -i "s;stable;-$KERNEL_VERSION;" output_kltekor/.config;

make -j$NUM_CPUS -C $(pwd) O=output_kltekor

if [ -e output_kltekor/arch/arm/boot/zImage ]; then
	echo -e $COLOR_GREEN"\n copying zImage to anykernel directory\n"$COLOR_NEUTRAL
	cp output_kltekor/arch/arm/boot/zImage anykernel_SmartPack/
	# compile dtb if required
	if [ "y" == "$COMPILE_DTB" ]; then
		echo -e $COLOR_GREEN"\n compiling device tree blob (dtb)\n"$COLOR_NEUTRAL
		if [ -f output_kltekor/arch/arm/boot/dt.img ]; then
			rm -f output_kltekor/arch/arm/boot/dt.img
		fi
		chmod 777 tools/dtbToolCM
		tools/dtbToolCM -2 -o output_kltekor/arch/arm/boot/dt.img -s 2048 -p output_kltekor/scripts/dtc/ output_kltekor/arch/arm/boot/
		# removing old dtb (if any)
		if [ -f anykernel_SmartPack/dtb ]; then
			rm -f anykernel_SmartPack/dtb
		fi
		# copying generated dtb to anykernel directory
		if [ -e output_kltekor/arch/arm/boot/dt.img ]; then
			mv -f output_kltekor/arch/arm/boot/dt.img anykernel_SmartPack/dtb
		fi
	fi
	echo -e $COLOR_GREEN"\n generating recovery flashable zip file\n"$COLOR_NEUTRAL
	cd anykernel_SmartPack/ && zip -r9 $KERNEL_NAME-kltekor-$KERNEL_VERSION-$KERNEL_DATE.zip * -x README.md $KERNEL_NAME-kltekor-$KERNEL_VERSION-$KERNEL_DATE.zip && cd ..
	echo -e $COLOR_GREEN"\n cleaning...\n"$COLOR_NEUTRAL
	rm anykernel_SmartPack/zImage && mv anykernel_SmartPack/$KERNEL_NAME* release_SmartPack/
	# restoring backups
	mv release_SmartPack/mkcompile_h scripts/
	echo -e $COLOR_GREEN"\n building SmarPack-Kernel for kltekor is finished...\n"$COLOR_NEUTRAL
else
	# restoring backups
	mv release_SmartPack/mkcompile_h scripts/
	echo -e $COLOR_GREEN"\n Building error... zImage not found...\n"$COLOR_NEUTRAL
fi

echo -e $COLOR_GREEN"\n building $KERNEL_NAME v. $KERNEL_VERSION for klte\n"$COLOR_NEUTRAL

# creating backups
cp scripts/mkcompile_h release_SmartPack/

# updating kernel name

sed -i "s;SmartPack-Kernel;$KERNEL_NAME-klte;" scripts/mkcompile_h;

if [ -e output_klte/.config ]; then
	rm -f output_klte/.config
	if [ -e output_klte/arch/arm/boot/zImage ]; then
		rm -f output_klte/arch/arm/boot/zImage
	fi
else
mkdir output_klte
fi

make -C $(pwd) O=output_klte SmartPack_@klte@_defconfig

# updating kernel version
sed -i "s;stable;-$KERNEL_VERSION;" output_klte/.config;

make -j$NUM_CPUS -C $(pwd) O=output_klte

if [ -e output_klte/arch/arm/boot/zImage ]; then
	echo -e $COLOR_GREEN"\n copying zImage to anykernel directory\n"$COLOR_NEUTRAL
	cp output_klte/arch/arm/boot/zImage anykernel_SmartPack/
	# compile dtb if required
	if [ "y" == "$COMPILE_DTB" ]; then
		echo -e $COLOR_GREEN"\n compiling device tree blob (dtb)\n"$COLOR_NEUTRAL
		if [ -f output_klte/arch/arm/boot/dt.img ]; then
			rm -f output_klte/arch/arm/boot/dt.img
		fi
		chmod 777 tools/dtbToolCM
		tools/dtbToolCM -2 -o output_klte/arch/arm/boot/dt.img -s 2048 -p output_klte/scripts/dtc/ output_klte/arch/arm/boot/
		# removing old dtb (if any)
		if [ -f anykernel_SmartPack/dtb ]; then
			rm -f anykernel_SmartPack/dtb
		fi
		# copying generated dtb to anykernel directory
		if [ -e output_klte/arch/arm/boot/dt.img ]; then
			mv -f output_klte/arch/arm/boot/dt.img anykernel_SmartPack/dtb
		fi
	fi
	echo -e $COLOR_GREEN"\n generating recovery flashable zip file\n"$COLOR_NEUTRAL
	cd anykernel_SmartPack/ && zip -r9 $KERNEL_NAME-klte-$KERNEL_VERSION-$KERNEL_DATE.zip * -x README.md $KERNEL_NAME-klte-$KERNEL_VERSION-$KERNEL_DATE.zip && cd ..
	echo -e $COLOR_GREEN"\n cleaning...\n"$COLOR_NEUTRAL
	rm anykernel_SmartPack/zImage && mv anykernel_SmartPack/$KERNEL_NAME* release_SmartPack/
	# restoring backups
	mv release_SmartPack/mkcompile_h scripts/
	echo -e $COLOR_GREEN"\n building SmarPack-Kernel for klte is finished...\n"$COLOR_NEUTRAL
else
	# restoring backups
	mv release_SmartPack/mkcompile_h scripts/
	echo -e $COLOR_GREEN"\n Building error... zImage not found...\n"$COLOR_NEUTRAL
fi

echo -e $COLOR_GREEN"\n building $KERNEL_NAME v. $KERNEL_VERSION for klteduos\n"$COLOR_NEUTRAL

# creating backups
cp scripts/mkcompile_h release_SmartPack/

# updating kernel name

sed -i "s;SmartPack-Kernel;$KERNEL_NAME-klteduos;" scripts/mkcompile_h;

if [ -e output_klteduos/.config ]; then
	rm -f output_klteduos/.config
	if [ -e output_klteduos/arch/arm/boot/zImage ]; then
		rm -f output_klteduos/arch/arm/boot/zImage
	fi
else
mkdir output_klteduos
fi

make -C $(pwd) O=output_klteduos SmartPack_@klteduos@_defconfig

# updating kernel version
sed -i "s;stable;-$KERNEL_VERSION;" output_klteduos/.config;

make -j$NUM_CPUS -C $(pwd) O=output_klteduos

if [ -e output_klteduos/arch/arm/boot/zImage ]; then
	echo -e $COLOR_GREEN"\n copying zImage to anykernel directory\n"$COLOR_NEUTRAL
	cp output_klteduos/arch/arm/boot/zImage anykernel_SmartPack/
	# compile dtb if required
	if [ "y" == "$COMPILE_DTB" ]; then
		echo -e $COLOR_GREEN"\n compiling device tree blob (dtb)\n"$COLOR_NEUTRAL
		if [ -f output_klteduos/arch/arm/boot/dt.img ]; then
			rm -f output_klteduos/arch/arm/boot/dt.img
		fi
		chmod 777 tools/dtbToolCM
		tools/dtbToolCM -2 -o output_klteduos/arch/arm/boot/dt.img -s 2048 -p output_klteduos/scripts/dtc/ output_klteduos/arch/arm/boot/
		# removing old dtb (if any)
		if [ -f anykernel_SmartPack/dtb ]; then
			rm -f anykernel_SmartPack/dtb
		fi
		# copying generated dtb to anykernel directory
		if [ -e output_klteduos/arch/arm/boot/dt.img ]; then
			mv -f output_klteduos/arch/arm/boot/dt.img anykernel_SmartPack/dtb
		fi
	fi
	echo -e $COLOR_GREEN"\n generating recovery flashable zip file\n"$COLOR_NEUTRAL
	cd anykernel_SmartPack/ && zip -r9 $KERNEL_NAME-klteduos-$KERNEL_VERSION-$KERNEL_DATE.zip * -x README.md $KERNEL_NAME-klteduos-$KERNEL_VERSION-$KERNEL_DATE.zip && cd ..
	echo -e $COLOR_GREEN"\n cleaning...\n"$COLOR_NEUTRAL
	rm anykernel_SmartPack/zImage && mv anykernel_SmartPack/$KERNEL_NAME* release_SmartPack/
	# restoring backups
	mv release_SmartPack/mkcompile_h scripts/
	echo -e $COLOR_GREEN"\n building SmarPack-Kernel for klteduos is finished...\n"$COLOR_NEUTRAL
else
	# restoring backups
	mv release_SmartPack/mkcompile_h scripts/
	echo -e $COLOR_GREEN"\n Building error... zImage not found...\n"$COLOR_NEUTRAL
fi

echo -e $COLOR_GREEN"\n building $KERNEL_NAME v. $KERNEL_VERSION for kltespr\n"$COLOR_NEUTRAL

# creating backups
cp scripts/mkcompile_h release_SmartPack/

# updating kernel name

sed -i "s;SmartPack-Kernel;$KERNEL_NAME-kltespr;" scripts/mkcompile_h;

if [ -e output_kltespr/.config ]; then
	rm -f output_kltespr/.config
	if [ -e output_kltespr/arch/arm/boot/zImage ]; then
		rm -f output_kltespr/arch/arm/boot/zImage
	fi
else
mkdir output_kltespr
fi

make -C $(pwd) O=output_kltespr SmartPack_@kltespr@_defconfig

# updating kernel version
sed -i "s;stable;-$KERNEL_VERSION;" output_kltespr/.config;

make -j$NUM_CPUS -C $(pwd) O=output_kltespr

if [ -e output_kltespr/arch/arm/boot/zImage ]; then
	echo -e $COLOR_GREEN"\n copying zImage to anykernel directory\n"$COLOR_NEUTRAL
	cp output_kltespr/arch/arm/boot/zImage anykernel_SmartPack/
	# compile dtb if required
	if [ "y" == "$COMPILE_DTB" ]; then
		echo -e $COLOR_GREEN"\n compiling device tree blob (dtb)\n"$COLOR_NEUTRAL
		if [ -f output_kltespr/arch/arm/boot/dt.img ]; then
			rm -f output_kltespr/arch/arm/boot/dt.img
		fi
		chmod 777 tools/dtbToolCM
		tools/dtbToolCM -2 -o output_kltespr/arch/arm/boot/dt.img -s 2048 -p output_kltespr/scripts/dtc/ output_kltespr/arch/arm/boot/
		# removing old dtb (if any)
		if [ -f anykernel_SmartPack/dtb ]; then
			rm -f anykernel_SmartPack/dtb
		fi
		# copying generated dtb to anykernel directory
		if [ -e output_kltespr/arch/arm/boot/dt.img ]; then
			mv -f output_kltespr/arch/arm/boot/dt.img anykernel_SmartPack/dtb
		fi
	fi
	echo -e $COLOR_GREEN"\n generating recovery flashable zip file\n"$COLOR_NEUTRAL
	cd anykernel_SmartPack/ && zip -r9 $KERNEL_NAME-kltespr-$KERNEL_VERSION-$KERNEL_DATE.zip * -x README.md $KERNEL_NAME-kltespr-$KERNEL_VERSION-$KERNEL_DATE.zip && cd ..
	echo -e $COLOR_GREEN"\n cleaning...\n"$COLOR_NEUTRAL
	rm anykernel_SmartPack/zImage && mv anykernel_SmartPack/$KERNEL_NAME* release_SmartPack/
	if [ -f anykernel_SmartPack/dtb ]; then
		rm -f anykernel_SmartPack/dtb
	fi
	# restoring backups
	mv release_SmartPack/mkcompile_h scripts/
	echo -e $COLOR_GREEN"\n building SmarPack-Kernel for kltespr is finished...\n"$COLOR_NEUTRAL
	echo -e $COLOR_GREEN"\n everything done... please visit "release_SmartPack"...\n"$COLOR_NEUTRAL
else
	if [ -f anykernel_SmartPack/dtb ]; then
		rm -f anykernel_SmartPack/dtb
	fi
	# restoring backups
	mv release_SmartPack/mkcompile_h scripts/
	echo -e $COLOR_GREEN"\n Building error... zImage not found...\n"$COLOR_NEUTRAL
fi
