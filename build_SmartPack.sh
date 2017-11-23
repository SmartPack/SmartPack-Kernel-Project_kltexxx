#!/bin/bash

COLOR_RED="\033[0;31m"
COLOR_GREEN="\033[1;32m"
COLOR_NEUTRAL="\033[0m"

echo -e $COLOR_GREEN"\n SmartPack-Kernel Build Script\n"$COLOR_NEUTRAL
#
echo -e $COLOR_GREEN"\n (c) sunilpaulmathew@xda-developers.com\n"$COLOR_NEUTRAL

TOOLCHAIN="/home/sunil/android-ndk-r15c/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi-"
ARCHITECTURE="arm"

KERNEL_NAME="SmartPack-Kernel"

KERNEL_VARIANT="kltekor"	# only one variant at a time

KERNEL_VERSION="stable-v8"   # leave as such, if no specific version tag

KERNEL_DATE="$(date +"%Y%m%d")"

COMPILE_DTB="y"

NUM_CPUS=""   # number of cpu cores used for build (leave empty for auto detection)

export ARCH=$ARCHITECTURE
export CROSS_COMPILE="${CCACHE} $TOOLCHAIN"

if [ -z "$NUM_CPUS" ]; then
	NUM_CPUS=`grep -c ^processor /proc/cpuinfo`
fi

if [ -z "$KERNEL_VARIANT" ]; then
	echo -e $COLOR_GREEN"\n Please select the variant to build... KERNEL_VARIANT should not be empty...\n"$COLOR_NEUTRAL
fi

if [ "klte" == "$KERNEL_VARIANT" ]; then
	echo -e $COLOR_GREEN"\n building $KERNEL_NAME for $KERNEL_VARIANT\n"$COLOR_NEUTRAL
	if [ -e output_eur/.config ]; then
		rm -f output_eur/.config
		if [ -e output_eur/arch/arm/boot/zImage ]; then
			rm -f output_eur/arch/arm/boot/zImage
		fi
	else
		mkdir output_eur
	fi
	make -C $(pwd) O=output_eur msm8974_sec_defconfig VARIANT_DEFCONFIG=msm8974pro_sec_klte_eur_defconfig SELINUX_DEFCONFIG=selinux_defconfig && make -j$NUM_CPUS -C $(pwd) O=output_eur
	if [ -e output_eur/arch/arm/boot/zImage ]; then
		echo -e $COLOR_GREEN"\n copying zImage to anykernel directory\n"$COLOR_NEUTRAL
		cp output_eur/arch/arm/boot/zImage anykernel_SmartPack/
		# compile dtb if required
		if [ "y" == "$COMPILE_DTB" ]; then
			echo -e $COLOR_GREEN"\n compiling device tree blob (dtb)\n"$COLOR_NEUTRAL
			if [ -f output_eur/arch/arm/boot/dt.img ]; then
				rm -f output_eur/arch/arm/boot/dt.img
			fi
			chmod 777 tools/dtbToolCM
			tools/dtbToolCM -2 -o output_eur/arch/arm/boot/dt.img -s 2048 -p output_eur/scripts/dtc/ output_eur/arch/arm/boot/
			# removing old dtb (if any)
			if [ -f anykernel_SmartPack/dtb ]; then
				rm -f anykernel_SmartPack/dtb
			fi
			# copying generated dtb to anykernel directory
			if [ -e output_eur/arch/arm/boot/dt.img ]; then
				mv -f output_eur/arch/arm/boot/dt.img anykernel_SmartPack/dtb
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
fi

if [ "kltekor" == "$KERNEL_VARIANT" ]; then
	echo -e $COLOR_GREEN"\n building $KERNEL_NAME for $KERNEL_VARIANT\n"$COLOR_NEUTRAL
	if [ -e output_kor/.config ]; then
		rm -f output_kor/.config
		if [ -e output_kor/arch/arm/boot/zImage ]; then
			rm -f output_kor/arch/arm/boot/zImage
		fi
	else
		mkdir output_kor
	fi
	make -C $(pwd) O=output_kor msm8974_sec_defconfig VARIANT_DEFCONFIG=msm8974pro_sec_klte_kor_defconfig SELINUX_DEFCONFIG=selinux_defconfig && make -j$NUM_CPUS -C $(pwd) O=output_kor
	if [ -e output_kor/arch/arm/boot/zImage ]; then
		echo -e $COLOR_GREEN"\n copying zImage to anykernel directory\n"$COLOR_NEUTRAL
		cp output_kor/arch/arm/boot/zImage anykernel_SmartPack/
		# compile dtb if required
		if [ "y" == "$COMPILE_DTB" ]; then
			echo -e $COLOR_GREEN"\n compiling device tree blob (dtb)\n"$COLOR_NEUTRAL
			if [ -f output_kor/arch/arm/boot/dt.img ]; then
				rm -f output_kor/arch/arm/boot/dt.img
			fi
			chmod 777 tools/dtbToolCM
			tools/dtbToolCM -2 -o output_kor/arch/arm/boot/dt.img -s 2048 -p output_kor/scripts/dtc/ output_kor/arch/arm/boot/
			# removing old dtb (if any)
			if [ -f anykernel_SmartPack/dtb ]; then
				rm -f anykernel_SmartPack/dtb
			fi
			# copying generated dtb to anykernel directory
			if [ -e output_kor/arch/arm/boot/dt.img ]; then
				mv -f output_kor/arch/arm/boot/dt.img anykernel_SmartPack/dtb
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
fi

if [ "klteduos" == "$KERNEL_VARIANT" ]; then
	echo -e $COLOR_GREEN"\n building $KERNEL_NAME for $KERNEL_VARIANT\n"$COLOR_NEUTRAL
	if [ -e output_duos/.config ]; then
		rm -f output_duos/.config
		if [ -e output_duos/arch/arm/boot/zImage ]; then
			rm -f output_duos/arch/arm/boot/zImage
		fi
	else
		mkdir output_duos
	fi
	make -C $(pwd) O=output_duos msm8974_sec_defconfig VARIANT_DEFCONFIG=msm8974pro_sec_klte_duos_defconfig SELINUX_DEFCONFIG=selinux_defconfig && make -j$NUM_CPUS -C $(pwd) O=output_duos
	if [ -e output_duos/arch/arm/boot/zImage ]; then
		echo -e $COLOR_GREEN"\n copying zImage to anykernel directory\n"$COLOR_NEUTRAL
		cp output_duos/arch/arm/boot/zImage anykernel_SmartPack/
		# compile dtb if required
		if [ "y" == "$COMPILE_DTB" ]; then
			echo -e $COLOR_GREEN"\n compiling device tree blob (dtb)\n"$COLOR_NEUTRAL
			if [ -f output_duos/arch/arm/boot/dt.img ]; then
				rm -f output_duos/arch/arm/boot/dt.img
			fi
			chmod 777 tools/dtbToolCM
			tools/dtbToolCM -2 -o output_duos/arch/arm/boot/dt.img -s 2048 -p output_duos/scripts/dtc/ output_duos/arch/arm/boot/
			# removing old dtb (if any)
			if [ -f anykernel_SmartPack/dtb ]; then
				rm -f anykernel_SmartPack/dtb
			fi
			# copying generated dtb to anykernel directory
			if [ -e output_duos/arch/arm/boot/dt.img ]; then
				mv -f output_duos/arch/arm/boot/dt.img anykernel_SmartPack/dtb
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
fi

if [ "kltespr" == "$KERNEL_VARIANT" ]; then
	echo -e $COLOR_GREEN"\n building $KERNEL_NAME for $KERNEL_VARIANT\n"$COLOR_NEUTRAL
	if [ -e output_spr/.config ]; then
		rm -f output_spr/.config
		if [ -e output_spr/arch/arm/boot/zImage ]; then
			rm -f output_spr/arch/arm/boot/zImage
		fi
	else
		mkdir output_spr
	fi
	make -C $(pwd) O=output_spr msm8974_sec_defconfig VARIANT_DEFCONFIG=msm8974pro_sec_klte_spr_defconfig SELINUX_DEFCONFIG=selinux_defconfig && make -j$NUM_CPUS -C $(pwd) O=output_spr
	if [ -e output_spr/arch/arm/boot/zImage ]; then
		echo -e $COLOR_GREEN"\n copying zImage to anykernel directory\n"$COLOR_NEUTRAL
		cp output_spr/arch/arm/boot/zImage anykernel_SmartPack/
		# compile dtb if required
		if [ "y" == "$COMPILE_DTB" ]; then
			echo -e $COLOR_GREEN"\n compiling device tree blob (dtb)\n"$COLOR_NEUTRAL
			if [ -f output_spr/arch/arm/boot/dt.img ]; then
				rm -f output_spr/arch/arm/boot/dt.img
			fi
			chmod 777 tools/dtbToolCM
			tools/dtbToolCM -2 -o output_spr/arch/arm/boot/dt.img -s 2048 -p output_spr/scripts/dtc/ output_spr/arch/arm/boot/
			# removing old dtb (if any)
			if [ -f anykernel_SmartPack/dtb ]; then
				rm -f anykernel_SmartPack/dtb
			fi
			# copying generated dtb to anykernel directory
			if [ -e output_spr/arch/arm/boot/dt.img ]; then
				mv -f output_spr/arch/arm/boot/dt.img anykernel_SmartPack/dtb
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
fi
