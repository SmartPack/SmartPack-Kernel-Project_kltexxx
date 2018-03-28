#!/system/bin/sh

#
# SmartPack-Kernel Boot Script
# 
# Author: sunilpaulmathew <sunil.kde@gmail.com>
#

#
# This script is licensed under the terms of the GNU General Public 
# License version 2, as published by the Free Software Foundation, 
# and may be copied, distributed, and modified under those terms.
#

#
# This script is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#

if [ "$(grep -c SmartPack-Kernel- /proc/version)" -eq "1" ]; then
	echo "Executing SmartPack Boot Script" | tee /dev/kmsg
	# CPU Input Boost
	echo 1190400 1497600 > /sys/kernel/cpu_input_boost/ib_freqs
	echo 1400 > /sys/kernel/cpu_input_boost/ib_duration_ms
	echo 1 > /sys/kernel/cpu_input_boost/enabled
	# Disable mpdecision & enable Lazyplug
	stop mpdecision
	echo 1 > /sys/module/lazyplug/parameters/lazyplug_active
	# Enable Adreno_idler
	echo 1 > /sys/module/adreno_idler/parameters/adreno_idler_active
	# Done!
	echo "Everything done" | tee /dev/kmsg
fi
