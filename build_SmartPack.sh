#!/bin/bash

COLOR_RED="\033[0;31m"
COLOR_GREEN="\033[1;32m"
COLOR_NEUTRAL="\033[0m"

echo -e $COLOR_GREEN"\n SmartPack-Kernel Build Script\n"$COLOR_NEUTRAL
#
echo -e $COLOR_GREEN"\n (c) sunilpaulmathew@xda-developers.com\n"$COLOR_NEUTRAL

TOOLCHAIN="/home/sunil/arm-linux-androideabi-4.9-linaro/bin/arm-linux-androideabi-"
ARCHITECTURE="arm"

KERNEL_NAME="SmartPack-Kernel"

KERNEL_VERSION="stable-v10_r7"   # leave as such, if no specific version tag

KERNEL_DATE="$(date +"%Y%m%d")"

COMPILE_DTB="y"

NUM_CPUS=""   # number of cpu cores used for build (leave empty for auto detection)

export ARCH=$ARCHITECTURE
export CROSS_COMPILE="${CCACHE} $TOOLCHAIN"

if [ -z "$NUM_CPUS" ]; then
	NUM_CPUS=`grep -c ^processor /proc/cpuinfo`
fi

echo -e $COLOR_GREEN"\n building $KERNEL_NAME for kltekor\n"$COLOR_NEUTRAL

# creating backups
cp scripts/mkcompile_h release_SmartPack/
cp arch/arm/configs/lineage_kltekor_defconfig release_SmartPack/

# updating kernel name

sed -i "s;SmartPack-Kernel;$KERNEL_NAME-kltekor;" scripts/mkcompile_h;

# updating kernel version

sed -i "s;stable;-$KERNEL_VERSION;" arch/arm/configs/lineage_kltekor_defconfig;

if [ -e output_kor/.config ]; then
	rm -f output_kor/.config
	if [ -e output_kor/arch/arm/boot/zImage ]; then
		rm -f output_kor/arch/arm/boot/zImage
	fi
else
mkdir output_kor
fi

make -C $(pwd) O=output_kor lineage_kltekor_defconfig && make -j$NUM_CPUS -C $(pwd) O=output_kor

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
	cd anykernel_SmartPack/ && zip -r9 $KERNEL_NAME-kltekor-$KERNEL_VERSION-$KERNEL_DATE.zip * -x README.md $KERNEL_NAME-kltekor-$KERNEL_VERSION-$KERNEL_DATE.zip && cd ..
	echo -e $COLOR_GREEN"\n cleaning...\n"$COLOR_NEUTRAL
	rm anykernel_SmartPack/zImage && mv anykernel_SmartPack/$KERNEL_NAME* release_SmartPack/
	# restoring backups
	mv release_SmartPack/mkcompile_h scripts/
	mv release_SmartPack/lineage_kltekor_defconfig arch/arm/configs/
	echo -e $COLOR_GREEN"\n everything done... please visit "release_SmartPack"...\n"$COLOR_NEUTRAL
else
	# restoring backups
	mv release_SmartPack/mkcompile_h scripts/
	mv release_SmartPack/lineage_kltekor_defconfig arch/arm/configs/
	echo -e $COLOR_GREEN"\n Building error... zImage not found...\n"$COLOR_NEUTRAL
fi

echo -e $COLOR_GREEN"\n building $KERNEL_NAME for klte\n"$COLOR_NEUTRAL

# creating backups
cp scripts/mkcompile_h release_SmartPack/
cp arch/arm/configs/lineage_klte_defconfig release_SmartPack/

# updating kernel name

sed -i "s;SmartPack-Kernel;$KERNEL_NAME-klte;" scripts/mkcompile_h;

# updating kernel version

sed -i "s;stable;-$KERNEL_VERSION;" arch/arm/configs/lineage_klte_defconfig;

if [ -e output_eur/.config ]; then
	rm -f output_eur/.config
	if [ -e output_eur/arch/arm/boot/zImage ]; then
		rm -f output_eur/arch/arm/boot/zImage
	fi
else
mkdir output_eur
fi

make -C $(pwd) O=output_eur lineage_klte_defconfig && make -j$NUM_CPUS -C $(pwd) O=output_eur

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
	cd anykernel_SmartPack/ && zip -r9 $KERNEL_NAME-klte-$KERNEL_VERSION-$KERNEL_DATE.zip * -x README.md $KERNEL_NAME-klte-$KERNEL_VERSION-$KERNEL_DATE.zip && cd ..
	echo -e $COLOR_GREEN"\n cleaning...\n"$COLOR_NEUTRAL
	rm anykernel_SmartPack/zImage && mv anykernel_SmartPack/$KERNEL_NAME* release_SmartPack/
	# restoring backups
	mv release_SmartPack/mkcompile_h scripts/
	mv release_SmartPack/lineage_klte_defconfig arch/arm/configs/
	echo -e $COLOR_GREEN"\n everything done... please visit "release_SmartPack"...\n"$COLOR_NEUTRAL
else
	# restoring backups
	mv release_SmartPack/mkcompile_h scripts/
	mv release_SmartPack/lineage_klte_defconfig arch/arm/configs/
	echo -e $COLOR_GREEN"\n Building error... zImage not found...\n"$COLOR_NEUTRAL
fi

echo -e $COLOR_GREEN"\n building $KERNEL_NAME for klteduos\n"$COLOR_NEUTRAL

# creating backups
cp scripts/mkcompile_h release_SmartPack/
cp arch/arm/configs/lineage_klteduos_defconfig release_SmartPack/

# updating kernel name

sed -i "s;SmartPack-Kernel;$KERNEL_NAME-klteduos;" scripts/mkcompile_h;

# updating kernel version

sed -i "s;stable;-$KERNEL_VERSION;" arch/arm/configs/lineage_klteduos_defconfig;

if [ -e output_duos/.config ]; then
	rm -f output_duos/.config
	if [ -e output_duos/arch/arm/boot/zImage ]; then
		rm -f output_duos/arch/arm/boot/zImage
	fi
else
mkdir output_duos
fi

make -C $(pwd) O=output_duos lineage_klteduos_defconfig && make -j$NUM_CPUS -C $(pwd) O=output_duos

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
	cd anykernel_SmartPack/ && zip -r9 $KERNEL_NAME-klteduos-$KERNEL_VERSION-$KERNEL_DATE.zip * -x README.md $KERNEL_NAME-klteduos-$KERNEL_VERSION-$KERNEL_DATE.zip && cd ..
	echo -e $COLOR_GREEN"\n cleaning...\n"$COLOR_NEUTRAL
	rm anykernel_SmartPack/zImage && mv anykernel_SmartPack/$KERNEL_NAME* release_SmartPack/
	# restoring backups
	mv release_SmartPack/mkcompile_h scripts/
	mv release_SmartPack/lineage_klteduos_defconfig arch/arm/configs/
	echo -e $COLOR_GREEN"\n everything done... please visit "release_SmartPack"...\n"$COLOR_NEUTRAL
else
	# restoring backups
	mv release_SmartPack/mkcompile_h scripts/
	mv release_SmartPack/lineage_klteduos_defconfig arch/arm/configs/
	echo -e $COLOR_GREEN"\n Building error... zImage not found...\n"$COLOR_NEUTRAL
fi

echo -e $COLOR_GREEN"\n building $KERNEL_NAME for kltespr\n"$COLOR_NEUTRAL

# creating backups
cp scripts/mkcompile_h release_SmartPack/
cp arch/arm/configs/lineage_kltespr_defconfig release_SmartPack/

# updating kernel name

sed -i "s;SmartPack-Kernel;$KERNEL_NAME-kltespr;" scripts/mkcompile_h;

# updating kernel version

sed -i "s;stable;-$KERNEL_VERSION;" arch/arm/configs/lineage_kltespr_defconfig;

if [ -e output_spr/.config ]; then
	rm -f output_spr/.config
	if [ -e output_spr/arch/arm/boot/zImage ]; then
		rm -f output_spr/arch/arm/boot/zImage
	fi
else
mkdir output_spr
fi

make -C $(pwd) O=output_spr lineage_kltespr_defconfig && make -j$NUM_CPUS -C $(pwd) O=output_spr

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
	cd anykernel_SmartPack/ && zip -r9 $KERNEL_NAME-kltespr-$KERNEL_VERSION-$KERNEL_DATE.zip * -x README.md $KERNEL_NAME-kltespr-$KERNEL_VERSION-$KERNEL_DATE.zip && cd ..
	echo -e $COLOR_GREEN"\n cleaning...\n"$COLOR_NEUTRAL
	rm anykernel_SmartPack/zImage && mv anykernel_SmartPack/$KERNEL_NAME* release_SmartPack/
	# restoring backups
	mv release_SmartPack/mkcompile_h scripts/
	mv release_SmartPack/lineage_kltespr_defconfig arch/arm/configs/
	echo -e $COLOR_GREEN"\n everything done... please visit "release_SmartPack"...\n"$COLOR_NEUTRAL
else
	if [ -f anykernel_SmartPack/dtb ]; then
		rm -f anykernel_SmartPack/dtb
	fi
	# restoring backups
	mv release_SmartPack/mkcompile_h scripts/
	mv release_SmartPack/lineage_kltespr_defconfig arch/arm/configs/
	echo -e $COLOR_GREEN"\n Building error... zImage not found...\n"$COLOR_NEUTRAL
fi
