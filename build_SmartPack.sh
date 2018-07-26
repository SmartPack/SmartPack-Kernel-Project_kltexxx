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

# 1. Properly locate Stock, UBER & Linaro toolchains (Line# 40, 42 & 44)
# 2. Select the preferred toolchain for building (Line# 46)
# 3. Set the 'KERNEL_VARIANT' (Line# 52)
# 4. To build all the supported variants, set 'KERNEL_VARIANT' to "all"
# 5. Open Terminal, ‘cd’ to the Kernel ‘root’ folder and run ‘. build_variant-SmartPack.sh’
# 6. The output (anykernel zip) file will be generated in the ‘release_SmartPack’ folder
# 7. Enjoy your new Kernel

#
# ***** ***** *Variables to be configured manually* ***** ***** #

# Toolchains

GOOGLE="/home/sunil/android-ndk-r15c/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi-"

UBERTC="/home/sunil/UBERTC-arm-eabi-8.0/bin/arm-linux-androideabi-"

LINARO="/home/sunil/arm-linux-androideabi-7.x-linaro/bin/arm-linaro-linux-androideabi-"

TOOLCHAIN="ubertc"	# Leave empty for using Google’s stock toolchain

ARCHITECTURE="arm"

KERNEL_NAME="SmartPack-Kernel"

KERNEL_VARIANT="kltekor"	# options: klte, kltekor, kltedv, klteduos, kltekdi & all (build all the variants)

KERNEL_VERSION="beta-v16"   # leave as such, if no specific version tag

KERNEL_DEFCONFIG="SmartPack_@$KERNEL_VARIANT@_defconfig"

KERNEL_DATE="$(date +"%Y%m%d")"

BUILD_DIR="output_$KERNEL_VARIANT"

KERNEL_IMAGE="$BUILD_DIR/arch/arm/boot/zImage"

COMPILE_DTB="y"

DTB="$BUILD_DIR/arch/arm/boot/dt.img"

ANYKERNEL_DIR="anykernel_SmartPack"

RELEASE_DIR="release_SmartPack"

PREPARE_RELEASE=""

NUM_CPUS=""   # number of cpu cores used for build (leave empty for auto detection)

# ***** ***** ***** ***** ***THE END*** ***** ***** ***** ***** #

COLOR_RED="\033[0;31m"
COLOR_GREEN="\033[1;32m"
COLOR_NEUTRAL="\033[0m"

export ARCH=$ARCHITECTURE

if [ -z "$TOOLCHAIN" ]; then
	echo -e $COLOR_GREEN"\n Initializing Google's stock toolchain...n"$COLOR_NEUTRAL
	export CROSS_COMPILE="${CCACHE} $GOOGLE"
elif [ "ubertc" == "$TOOLCHAIN" ]; then
	echo -e $COLOR_GREEN"\n Initializing UBERTC-8.x...\n"$COLOR_NEUTRAL
	export CROSS_COMPILE="${CCACHE} $UBERTC"
elif [ "linaro" == "$TOOLCHAIN" ]; then
	echo -e $COLOR_GREEN"\n Initializing Linaro-7.x toolchain...\n"$COLOR_NEUTRAL
	export CROSS_COMPILE="${CCACHE} $LINARO"
fi

if [ -z "$NUM_CPUS" ]; then
	NUM_CPUS=`grep -c ^processor /proc/cpuinfo`
fi

# Initialize building...
if [ -z "$KERNEL_VARIANT" ]; then
	echo -e $COLOR_GREEN"\n Please select the variant to build... 'KERNEL_VARIANT' should not be empty...\n"$COLOR_NEUTRAL
elif [ -e arch/arm/configs/$KERNEL_DEFCONFIG ]; then
	if [ -e $BUILD_DIR ]; then
		if [ -e $BUILD_DIR/.config ]; then
			rm -f $BUILD_DIR/.config
			if [ -e $KERNEL_IMAGE ]; then
				rm -f $KERNEL_IMAGE
			fi
		fi
	else
		mkdir $BUILD_DIR
	fi
	echo -e $COLOR_GREEN"\n building $KERNEL_NAME $KERNEL_VERSION for $KERNEL_VARIANT\n"$COLOR_NEUTRAL
	make -C $(pwd) O=$BUILD_DIR $KERNEL_DEFCONFIG
	# updating kernel version
	sed -i "s;lineageos;$KERNEL_VERSION;" $BUILD_DIR/.config;
	make -j$NUM_CPUS -C $(pwd) O=$BUILD_DIR
	if [ -e $KERNEL_IMAGE ]; then
		echo -e $COLOR_GREEN"\n copying zImage to anykernel directory\n"$COLOR_NEUTRAL
		cp $KERNEL_IMAGE $ANYKERNEL_DIR
		# compile dtb if required
		if [ "y" == "$COMPILE_DTB" ]; then
			echo -e $COLOR_GREEN"\n compiling device tree blob (dtb)\n"$COLOR_NEUTRAL
			if [ -f $DTB ]; then
				rm -f $DTB
			fi
			chmod 777 tools/dtbToolCM
			tools/dtbToolCM -2 -o $DTB -s 2048 -p output_$KERNEL_VARIANT/scripts/dtc/ output_$KERNEL_VARIANT/arch/arm/boot/
			# removing old dtb (if any)
			if [ -f $ANYKERNEL_DIR/dtb ]; then
				rm -f $ANYKERNEL_DIR/dtb
			fi
			# copying generated dtb to anykernel directory
			if [ -e $DTB ]; then
				mv -f $DTB $ANYKERNEL_DIR/dtb
			fi
		fi
		# adding version tag to ramdisk in order to access from the Kernel Manager
		echo $KERNEL_VERSION > $ANYKERNEL_DIR/ramdisk/version
		echo -e $COLOR_GREEN"\n generating recovery flashable zip file\n"$COLOR_NEUTRAL
		cd $ANYKERNEL_DIR && zip -r9 $KERNEL_NAME-$KERNEL_VARIANT-$KERNEL_VERSION-$KERNEL_DATE.zip * -x README.md $KERNEL_NAME-$KERNEL_VARIANT-$KERNEL_VERSION-$KERNEL_DATE.zip && cd ..
		echo -e $COLOR_GREEN"\n cleaning...\n"$COLOR_NEUTRAL
		# check and create release folder.
		if [ ! -d "$RELEASE_DIR" ]; then
			mkdir $RELEASE_DIR
		fi
		rm $ANYKERNEL_DIR/zImage && mv $ANYKERNEL_DIR/$KERNEL_NAME* $RELEASE_DIR
		if [ -f $ANYKERNEL_DIR/dtb ]; then
			rm -f $ANYKERNEL_DIR/dtb
		fi
		if [ -f $ANYKERNEL_DIR/ramdisk/version ]; then
			rm -f $ANYKERNEL_DIR/ramdisk/version
		fi
		if [ "y" == "$PREPARE_RELEASE" ]; then
			echo -e $COLOR_GREEN"\n Preparing for kernel release\n"$COLOR_NEUTRAL
			cp $RELEASE_DIR/$KERNEL_NAME-$KERNEL_VARIANT-$KERNEL_VERSION-$KERNEL_DATE.zip kernel-release/$KERNEL_NAME-$KERNEL_VARIANT.zip
		fi
		echo -e $COLOR_GREEN"\n Building for $KERNEL_VARIANT finished... please visit '$RELEASE_DIR'...\n"$COLOR_NEUTRAL
	else
		if [ -f $ANYKERNEL_DIR/dtb ]; then
			rm -f $ANYKERNEL_DIR/dtb
		fi
		echo -e $COLOR_RED"\n Building for $KERNEL_VARIANT failed. Please fix the issues and try again...\n"$COLOR_NEUTRAL
	fi
elif [ "all" == "$KERNEL_VARIANT" ]; then
	echo -e $COLOR_GREEN"\n building $KERNEL_NAME $KERNEL_VERSION for all the supported variants...\n"$COLOR_NEUTRAL
	# kltekor
	if [ -e output_kltekor/ ]; then
		if [ -e output_kltekor/.config ]; then
			rm -f output_kltekor/.config
			if [ -e output_kltekor/arch/arm/boot/zImage ]; then
				rm -f output_kltekor/arch/arm/boot/zImage
			fi
		fi
	else
		mkdir output_kltekor
	fi
	echo -e $COLOR_GREEN"\n building $KERNEL_NAME for kltekor\n"$COLOR_NEUTRAL
	make -C $(pwd) O=output_kltekor SmartPack_@kltekor@_defconfig
	# updating kernel version
	sed -i "s;lineageos;$KERNEL_VERSION;" output_kltekor/.config;
	make -j$NUM_CPUS -C $(pwd) O=output_kltekor
	if [ -e output_kltekor/arch/arm/boot/zImage ]; then
		echo -e $COLOR_GREEN"\n copying zImage to anykernel directory\n"$COLOR_NEUTRAL
		cp output_kltekor/arch/arm/boot/zImage $ANYKERNEL_DIR
		# compile dtb if required
		if [ "y" == "$COMPILE_DTB" ]; then
			echo -e $COLOR_GREEN"\n compiling device tree blob (dtb)\n"$COLOR_NEUTRAL
			if [ -f output_kltekor/arch/arm/boot/dt.img ]; then
				rm -f output_kltekor/arch/arm/boot/dt.img
			fi
			chmod 777 tools/dtbToolCM
			tools/dtbToolCM -2 -o output_kltekor/arch/arm/boot/dt.img -s 2048 -p output_kltekor/scripts/dtc/ output_kltekor/arch/arm/boot/
			# removing old dtb (if any)
			if [ -f $ANYKERNEL_DIR/dtb ]; then
				rm -f $ANYKERNEL_DIR/dtb
			fi
			# copying generated dtb to anykernel directory
			if [ -e output_kltekor/arch/arm/boot/dt.img ]; then
				mv -f output_kltekor/arch/arm/boot/dt.img $ANYKERNEL_DIR/dtb
			fi
		fi
		# adding version tag to ramdisk in order to access from the Kernel Manager
		echo $KERNEL_VERSION > $ANYKERNEL_DIR/ramdisk/version
		echo -e $COLOR_GREEN"\n generating recovery flashable zip file\n"$COLOR_NEUTRAL
		cd $ANYKERNEL_DIR && zip -r9 $KERNEL_NAME-kltekor-$KERNEL_VERSION-$KERNEL_DATE.zip * -x README.md $KERNEL_NAME-kltekor-$KERNEL_VERSION-$KERNEL_DATE.zip && cd ..
		echo -e $COLOR_GREEN"\n cleaning...\n"$COLOR_NEUTRAL
		# check and create release folder...
		if [ ! -d "$RELEASE_DIR" ]; then
			mkdir $RELEASE_DIR
		fi
		rm $ANYKERNEL_DIR/zImage && mv $ANYKERNEL_DIR/$KERNEL_NAME* $RELEASE_DIR
		if [ -f $ANYKERNEL_DIR/dtb ]; then
			rm -f $ANYKERNEL_DIR/dtb
		fi
		if [ -f $ANYKERNEL_DIR/ramdisk/version ]; then
			rm -f $ANYKERNEL_DIR/ramdisk/version
		fi
		echo -e $COLOR_GREEN"\n Preparing for kernel release\n"$COLOR_NEUTRAL
		cp $RELEASE_DIR/$KERNEL_NAME-kltekor-$KERNEL_VERSION-$KERNEL_DATE.zip kernel-release/$KERNEL_NAME-kltekor.zip
	else
		if [ -f $ANYKERNEL_DIR/dtb ]; then
			rm -f $ANYKERNEL_DIR/dtb
		fi
		echo -e $COLOR_RED"\n Building for kltekor failed. Please fix the issues and try again...\n"$COLOR_NEUTRAL
	fi
	# klte
	if [ -e output_klte/ ]; then
		if [ -e output_klte/.config ]; then
			rm -f output_klte/.config
			if [ -e output_klte/arch/arm/boot/zImage ]; then
				rm -f output_klte/arch/arm/boot/zImage
			fi
		fi
	else
		mkdir output_klte
	fi
	echo -e $COLOR_GREEN"\n building $KERNEL_NAME for klte\n"$COLOR_NEUTRAL
	make -C $(pwd) O=output_klte SmartPack_@klte@_defconfig
	# updating kernel version
	sed -i "s;lineageos;$KERNEL_VERSION;" output_klte/.config;
	make -j$NUM_CPUS -C $(pwd) O=output_klte
	if [ -e output_klte/arch/arm/boot/zImage ]; then
		echo -e $COLOR_GREEN"\n copying zImage to anykernel directory\n"$COLOR_NEUTRAL
		cp output_klte/arch/arm/boot/zImage $ANYKERNEL_DIR/
		# compile dtb if required
		if [ "y" == "$COMPILE_DTB" ]; then
			echo -e $COLOR_GREEN"\n compiling device tree blob (dtb)\n"$COLOR_NEUTRAL
			if [ -f output_klte/arch/arm/boot/dt.img ]; then
				rm -f output_klte/arch/arm/boot/dt.img
			fi
			chmod 777 tools/dtbToolCM
			tools/dtbToolCM -2 -o output_klte/arch/arm/boot/dt.img -s 2048 -p output_klte/scripts/dtc/ output_klte/arch/arm/boot/
			# removing old dtb (if any)
			if [ -f $ANYKERNEL_DIR/dtb ]; then
				rm -f $ANYKERNEL_DIR/dtb
			fi
			# copying generated dtb to anykernel directory
			if [ -e output_klte/arch/arm/boot/dt.img ]; then
				mv -f output_klte/arch/arm/boot/dt.img $ANYKERNEL_DIR/dtb
			fi
		fi
		# adding version tag to ramdisk in order to access from the Kernel Manager
		echo $KERNEL_VERSION > $ANYKERNEL_DIR/ramdisk/version
		echo -e $COLOR_GREEN"\n generating recovery flashable zip file\n"$COLOR_NEUTRAL
		cd $ANYKERNEL_DIR && zip -r9 $KERNEL_NAME-klte-$KERNEL_VERSION-$KERNEL_DATE.zip * -x README.md $KERNEL_NAME-klte-$KERNEL_VERSION-$KERNEL_DATE.zip && cd ..
		echo -e $COLOR_GREEN"\n cleaning...\n"$COLOR_NEUTRAL
		rm $ANYKERNEL_DIR/zImage && mv $ANYKERNEL_DIR/$KERNEL_NAME* $RELEASE_DIR
		if [ -f $ANYKERNEL_DIR/dtb ]; then
			rm -f $ANYKERNEL_DIR/dtb
		fi
		echo -e $COLOR_GREEN"\n Preparing for kernel release\n"$COLOR_NEUTRAL
		cp $RELEASE_DIR/$KERNEL_NAME-klte-$KERNEL_VERSION-$KERNEL_DATE.zip kernel-release/$KERNEL_NAME-klte.zip
	else
		if [ -f $ANYKERNEL_DIR/dtb ]; then
			rm -f $ANYKERNEL_DIR/dtb
		fi
		if [ -f $ANYKERNEL_DIR/ramdisk/version ]; then
			rm -f $ANYKERNEL_DIR/ramdisk/version
		fi
		echo -e $COLOR_RED"\n Building for klte failed. Please fix the issues and try again...\n"$COLOR_NEUTRAL
	fi
	# kltedv
	if [ -e output_kltedv/ ]; then
		if [ -e output_kltedv/.config ]; then
			rm -f output_kltedv/.config
			if [ -e output_kltedv/arch/arm/boot/zImage ]; then
				rm -f output_kltedv/arch/arm/boot/zImage
			fi
		fi
	else
		mkdir output_kltedv
	fi
	echo -e $COLOR_GREEN"\n building $KERNEL_NAME for kltedv\n"$COLOR_NEUTRAL
	make -C $(pwd) O=output_kltedv SmartPack_@kltedv@_defconfig
	# updating kernel version
	sed -i "s;lineageos;$KERNEL_VERSION;" output_kltedv/.config;
	make -j$NUM_CPUS -C $(pwd) O=output_kltedv
	if [ -e output_kltedv/arch/arm/boot/zImage ]; then
		echo -e $COLOR_GREEN"\n copying zImage to anykernel directory\n"$COLOR_NEUTRAL
		cp output_kltedv/arch/arm/boot/zImage $ANYKERNEL_DIR/
		# compile dtb if required
		if [ "y" == "$COMPILE_DTB" ]; then
			echo -e $COLOR_GREEN"\n compiling device tree blob (dtb)\n"$COLOR_NEUTRAL
			if [ -f output_kltedv/arch/arm/boot/dt.img ]; then
				rm -f output_kltedv/arch/arm/boot/dt.img
			fi
			chmod 777 tools/dtbToolCM
			tools/dtbToolCM -2 -o output_kltedv/arch/arm/boot/dt.img -s 2048 -p output_kltedv/scripts/dtc/ output_kltedv/arch/arm/boot/
			# removing old dtb (if any)
			if [ -f $ANYKERNEL_DIR/dtb ]; then
				rm -f $ANYKERNEL_DIR/dtb
			fi
			# copying generated dtb to anykernel directory
			if [ -e output_kltedv/arch/arm/boot/dt.img ]; then
				mv -f output_kltedv/arch/arm/boot/dt.img $ANYKERNEL_DIR/dtb
			fi
		fi
		# adding version tag to ramdisk in order to access from the Kernel Manager
		echo $KERNEL_VERSION > $ANYKERNEL_DIR/ramdisk/version
		echo -e $COLOR_GREEN"\n generating recovery flashable zip file\n"$COLOR_NEUTRAL
		cd $ANYKERNEL_DIR && zip -r9 $KERNEL_NAME-kltedv-$KERNEL_VERSION-$KERNEL_DATE.zip * -x README.md $KERNEL_NAME-kltedv-$KERNEL_VERSION-$KERNEL_DATE.zip && cd ..
		echo -e $COLOR_GREEN"\n cleaning...\n"$COLOR_NEUTRAL
		rm $ANYKERNEL_DIR/zImage && mv $ANYKERNEL_DIR/$KERNEL_NAME* $RELEASE_DIR
		if [ -f $ANYKERNEL_DIR/dtb ]; then
			rm -f $ANYKERNEL_DIR/dtb
		fi
		echo -e $COLOR_GREEN"\n Preparing for kernel release\n"$COLOR_NEUTRAL
		cp $RELEASE_DIR/$KERNEL_NAME-kltedv-$KERNEL_VERSION-$KERNEL_DATE.zip kernel-release/$KERNEL_NAME-kltedv.zip
	else
		if [ -f $ANYKERNEL_DIR/dtb ]; then
			rm -f $ANYKERNEL_DIR/dtb
		fi
		if [ -f $ANYKERNEL_DIR/ramdisk/version ]; then
			rm -f $ANYKERNEL_DIR/ramdisk/version
		fi
		echo -e $COLOR_RED"\n Building for kltedv failed. Please fix the issues and try again...\n"$COLOR_NEUTRAL
	fi
	# klteduos
	if [ -e output_klteduos/ ]; then
		if [ -e output_klteduos/.config ]; then
			rm -f output_klteduos/.config
			if [ -e output_klteduos/arch/arm/boot/zImage ]; then
				rm -f output_klteduos/arch/arm/boot/zImage
			fi
		fi
	else
		mkdir output_klteduos
	fi
	echo -e $COLOR_GREEN"\n building $KERNEL_NAME for klteduos\n"$COLOR_NEUTRAL
	make -C $(pwd) O=output_klteduos SmartPack_@klteduos@_defconfig
	# updating kernel version
	sed -i "s;lineageos;$KERNEL_VERSION;" output_klteduos/.config;
	make -j$NUM_CPUS -C $(pwd) O=output_klteduos
	if [ -e output_klteduos/arch/arm/boot/zImage ]; then
		echo -e $COLOR_GREEN"\n copying zImage to anykernel directory\n"$COLOR_NEUTRAL
		cp output_klteduos/arch/arm/boot/zImage $ANYKERNEL_DIR/
		# compile dtb if required
		if [ "y" == "$COMPILE_DTB" ]; then
			echo -e $COLOR_GREEN"\n compiling device tree blob (dtb)\n"$COLOR_NEUTRAL
			if [ -f output_klteduos/arch/arm/boot/dt.img ]; then
				rm -f output_klteduos/arch/arm/boot/dt.img
			fi
			chmod 777 tools/dtbToolCM
			tools/dtbToolCM -2 -o output_klteduos/arch/arm/boot/dt.img -s 2048 -p output_klteduos/scripts/dtc/ output_klteduos/arch/arm/boot/
			# removing old dtb (if any)
			if [ -f $ANYKERNEL_DIR/dtb ]; then
				rm -f $ANYKERNEL_DIR/dtb
			fi
			# copying generated dtb to anykernel directory
			if [ -e output_klteduos/arch/arm/boot/dt.img ]; then
				mv -f output_klteduos/arch/arm/boot/dt.img $ANYKERNEL_DIR/dtb
			fi
		fi
		# adding version tag to ramdisk in order to access from the Kernel Manager
		echo $KERNEL_VERSION > $ANYKERNEL_DIR/ramdisk/version
		echo -e $COLOR_GREEN"\n generating recovery flashable zip file\n"$COLOR_NEUTRAL
		cd $ANYKERNEL_DIR && zip -r9 $KERNEL_NAME-klteduos-$KERNEL_VERSION-$KERNEL_DATE.zip * -x README.md $KERNEL_NAME-klteduos-$KERNEL_VERSION-$KERNEL_DATE.zip && cd ..
		echo -e $COLOR_GREEN"\n cleaning...\n"$COLOR_NEUTRAL
		rm $ANYKERNEL_DIR/zImage && mv $ANYKERNEL_DIR/$KERNEL_NAME* $RELEASE_DIR
		if [ -f $ANYKERNEL_DIR/dtb ]; then
			rm -f $ANYKERNEL_DIR/dtb
		fi
		echo -e $COLOR_GREEN"\n Preparing for kernel release\n"$COLOR_NEUTRAL
		cp $RELEASE_DIR/$KERNEL_NAME-klteduos-$KERNEL_VERSION-$KERNEL_DATE.zip kernel-release/$KERNEL_NAME-klteduos.zip
	else
		if [ -f $ANYKERNEL_DIR/dtb ]; then
			rm -f $ANYKERNEL_DIR/dtb
		fi
		if [ -f $ANYKERNEL_DIR/ramdisk/version ]; then
			rm -f $ANYKERNEL_DIR/ramdisk/version
		fi
		echo -e $COLOR_RED"\n Building for klteduos failed. Please fix the issues and try again...\n"$COLOR_NEUTRAL
	fi
	# kltekdi
	if [ -e output_kltekdi/ ]; then
		if [ -e output_kltekdi/.config ]; then
			rm -f output_kltekdi/.config
			if [ -e output_kltekdi/arch/arm/boot/zImage ]; then
				rm -f output_kltekdi/arch/arm/boot/zImage
			fi
		fi
	else
		mkdir output_kltekdi
	fi
	echo -e $COLOR_GREEN"\n building $KERNEL_NAME for kltekdi\n"$COLOR_NEUTRAL
	make -C $(pwd) O=output_kltekdi SmartPack_@kltekdi@_defconfig
	# updating kernel version
	sed -i "s;lineageos;$KERNEL_VERSION;" output_kltekdi/.config;
	make -j$NUM_CPUS -C $(pwd) O=output_kltekdi
	if [ -e output_kltekdi/arch/arm/boot/zImage ]; then
		echo -e $COLOR_GREEN"\n copying zImage to anykernel directory\n"$COLOR_NEUTRAL
		cp output_kltekdi/arch/arm/boot/zImage $ANYKERNEL_DIR/
		# compile dtb if required
		if [ "y" == "$COMPILE_DTB" ]; then
			echo -e $COLOR_GREEN"\n compiling device tree blob (dtb)\n"$COLOR_NEUTRAL
			if [ -f output_kltekdi/arch/arm/boot/dt.img ]; then
				rm -f output_kltekdi/arch/arm/boot/dt.img
			fi
			chmod 777 tools/dtbToolCM
			tools/dtbToolCM -2 -o output_kltekdi/arch/arm/boot/dt.img -s 2048 -p output_kltekdi/scripts/dtc/ output_kltekdi/arch/arm/boot/
			# removing old dtb (if any)
			if [ -f $ANYKERNEL_DIR/dtb ]; then
				rm -f $ANYKERNEL_DIR/dtb
			fi
			# copying generated dtb to anykernel directory
			if [ -e output_kltekdi/arch/arm/boot/dt.img ]; then
				mv -f output_kltekdi/arch/arm/boot/dt.img $ANYKERNEL_DIR/dtb
			fi
		fi
		# adding version tag to ramdisk in order to access from the Kernel Manager
		echo $KERNEL_VERSION > $ANYKERNEL_DIR/ramdisk/version
		echo -e $COLOR_GREEN"\n generating recovery flashable zip file\n"$COLOR_NEUTRAL
		cd $ANYKERNEL_DIR && zip -r9 $KERNEL_NAME-kltekdi-$KERNEL_VERSION-$KERNEL_DATE.zip * -x README.md $KERNEL_NAME-kltekdi-$KERNEL_VERSION-$KERNEL_DATE.zip && cd ..
		echo -e $COLOR_GREEN"\n cleaning...\n"$COLOR_NEUTRAL
		rm $ANYKERNEL_DIR/zImage && mv $ANYKERNEL_DIR/$KERNEL_NAME* $RELEASE_DIR
		if [ -f $ANYKERNEL_DIR/dtb ]; then
			rm -f $ANYKERNEL_DIR/dtb
		fi
		if [ -f $ANYKERNEL_DIR/ramdisk/version ]; then
			rm -f $ANYKERNEL_DIR/ramdisk/version
		fi
		echo -e $COLOR_GREEN"\n Preparing for kernel release\n"$COLOR_NEUTRAL
		cp $RELEASE_DIR/$KERNEL_NAME-kltekdi-$KERNEL_VERSION-$KERNEL_DATE.zip kernel-release/$KERNEL_NAME-kltekdi.zip
		echo -e $COLOR_GREEN"\n everything done... please visit '$RELEASE_DIR'...\n"$COLOR_NEUTRAL
	else
		if [ -f $ANYKERNEL_DIR/dtb ]; then
			rm -f $ANYKERNEL_DIR/dtb
		fi
		if [ -f $ANYKERNEL_DIR/ramdisk/version ]; then
			rm -f $ANYKERNEL_DIR/ramdisk/version
		fi
		echo -e $COLOR_RED"\n Building for kltekdi failed. Please fix the issues and try again...\n"$COLOR_NEUTRAL
	fi
else
	echo -e $COLOR_GREEN"\n '$KERNEL_VARIANT' is not a supported variant... please check...\n"$COLOR_NEUTRAL
fi
