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

echo "Executing SmartPack Boot Script" | tee /dev/kmsg

#
# CPU Input Boost
#
echo 1190400 1497600 > /sys/kernel/cpu_input_boost/ib_freqs
echo 1400 > /sys/kernel/cpu_input_boost/ib_duration_ms
echo 1 > /sys/kernel/cpu_input_boost/enabled

#
# Enable fast charge
#
echo 1 > /sys/kernel/fast_charge/force_fast_charge

#
# Enable Adreno_idler
#
echo 1 > /sys/module/adreno_idler/parameters/adreno_idler_active

#
# Enable intelli_thermal
#
echo 0 > /sys/module/msm_thermal/vdd_restriction/enabled
echo 0 > /sys/module/msm_thermal/core_control/enabled
echo Y > /sys/module/msm_thermal/parameters/enabled

#
# Done!
#
echo "Everything done" | tee /dev/kmsg
