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
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#

if [ "$(grep -c SmartPack-Kernel- /proc/version)" -eq "1" ]; then
    echo "Apply SmartPack-Kernel default settings..." | tee /dev/kmsg
    # Huge thanks to sultanxda and justjr @ xda-developers.com

    # Tweak Interactive CPU governor
    echo "20000 1190400:60000 1728000:74000 1958400:82000 2265600:120000" > /sys/devices/system/cpu/cpufreq/interactive/above_hispeed_delay
    echo 99 > /sys/devices/system/cpu/cpufreq/interactive/go_hispeed_load
    echo 1190400 > /sys/devices/system/cpu/cpufreq/interactive/hispeed_freq
    echo 40000 > /sys/devices/system/cpu/cpufreq/interactive/io_is_busy
    echo 0 > /sys/devices/system/cpu/cpufreq/interactive/min_sample_time
    echo "98 268800:28 300000:12 422400:34 652800:41 729600:12 883200:52 960000:9 1036800:8 1190400:73 1267200:6 1497600:87 1574400:5 1728000:89 1958400:91 2265600:94" > /sys/devices/system/cpu/cpufreq/interactive/target_loads
    echo 40000 > /sys/devices/system/cpu/cpufreq/interactive/timer_rate
    echo 80000 > /sys/devices/system/cpu/cpufreq/interactive/timer_slack

    # CPU Hotplug
    echo 0 > /sys/kernel/alucard_hotplug/hotplug_enable
    echo 0 > /sys/class/misc/mako_hotplug_control/enabled
    echo 1 > /sys/module/lazyplug/parameters/lazyplug_active
    echo 8 > /sys/module/lazyplug/parameters/nr_run_hysteresis

    # Thermal
    echo 0 > /sys/module/msm_thermal/vdd_restriction/enabled
    echo 0 > /sys/module/msm_thermal/parameters/enabled
    echo 1 > /sys/module/msm_thermal/core_control/enabled
    echo 80 > /sys/module/msm_thermal/parameters/freq_mitig_temp_degc
    echo 90 > /sys/module/msm_thermal/parameters/core_temp_limit_degC
    echo 85 > /sys/module/msm_thermal/parameters/hotplug_temp_degC

    # Disaply and LED
    echo 1 > /sys/class/sec/led/led_fade
    echo 15 > /sys/module/mdss_fb/parameters/backlight_min

    # LMK
    echo 1 > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk
    chmod 666 /sys/module/lowmemorykiller/parameters/minfree
    chown root /sys/module/lowmemorykiller/parameters/minfree
    echo "10240,14336,18432,34816,47104,55296" > /sys/module/lowmemorykiller/parameters/minfree

    # VM
    echo 0 > /proc/sys/vm/oom_dump_tasks
    echo 10 > /proc/sys/vm/dirty_background_ratio
    echo 60 > /proc/sys/vm/swappiness
    echo 100 > /proc/sys/vm/vfs_cache_pressure
    echo 30 > /proc/sys/vm/dirty_ratio
    echo 1 > /proc/sys/vm/page-cluster

    # IO
    echo 1 > /sys/block/mmcblk0/queue/rq_affinity
    echo 0 > /sys/block/mmcblk0/queue/iostats
    echo 1024 > /sys/block/mmcblk0/queue/read_ahead_kb
    echo 1 > /sys/block/mmcblk1/queue/rq_affinity
    echo 0 > /sys/block/mmcblk1/queue/iostats
    echo 2048 > /sys/block/mmcblk1/queue/read_ahead_kb

    # Misc
    echo 256 > /proc/sys/kernel/random/read_wakeup_threshold
    echo 320 > /proc/sys/kernel/random/write_wakeup_threshold
    echo 0 > /sys/kernel/dyn_fsync/Dyn_fsync_active

    # The END
    echo "Everything done..." | tee /dev/kmsg
fi
