# Change-logs

## 30. November 27, 2018
Release status: stable-v28
Set "ZEN" as the default iosched. Up-to-date with Linage-OS source code.

## 29. November 25, 2018
Release status: stable-v27
Fixed core 2 stick on "Performance" governer. Disabled Kernel Samepage Merging (KSM). SmartPack boot script: update default profile (credits: justjr) and some workaround for Pie ROMs (Thanks to @jprimero15)

## 28. November 14, 2018
Release status: stable-v26
Unified Oreo & Pie kernels. Up-to-date with Linage-OS source code.

## 27. November 08, 2018
Release status: stable-v25
Add options to block more wakelocks. Add brightness control for notification LED. Merge updates from osm0sis's anykernel repo. SmartPack boot script: merge few more updates and disable boeffla sound by default.

## 26. October 26, 2018
Release status: stable-v24
MSMS_Thermal: enabled a bunch of advanced parameters. Fixed the annoying sound issue. SmartPack boot script: Update default profile (credits: justjr@xda-developers.com). Remove undervolting by default. Removed Spectrum support.

## 25. October 09, 2018
Release status: stable-v23
SmartPack boot script: Merged updates profile provided by justjr@xda-developers.com. Up-to-date with Linage-OS source code.

## 24. October 08, 2018
Release status: stable-v22
Removed Intel thermal (finally). Largely updated SmartPack boot script on the basis of the profile provided by justjr@xda-developers.com (Highly advised to reset current Kernel Manager settings)

## 23. September 25, 2018
Release status: stable-v21
Up-to-date with Linage-OS source code. Re-add SmartPack boot script with a lot of useful tweaks.

## 22. September 06, 2018
Release status: beta-v20
Switch toolchain into latest (GCC-8.2.1). Add control over Min Display Backlight. Add OS check to the anykernel script so that it won't be installed on any android version except Android 8.1.0 (Oreo).

## 21. August 13, 2018
Release status: beta-v19
Up-to-date with Linage-OS source code.

## 20. August 6, 2018
Release status: beta-v18
Disabled mpdecision by default. Enabled lazyplug (Required SmartPack-Kernel Manager). Up-to-date with Linage-OS source code.

## 19. August 1, 2018
Release status: beta-v17
Fixed performance tweaks (was broken in an old update). Update UBER toolchain to the latest (8.2).

## 18. July 26, 2018
Release status: beta-v16
Up-to-date with Linage-OS source code. Some minor changes to work best with new Kernel Manager update.

## 17. June 30, 2018
Release status: beta-v15
Update lowest charging rates (from 400 mA) of ac and wl levels. Fixed cpufreq interactive using higher frequencies. Merged recent changes from osm0sis's Anykernel repo. Up-to-date with Linage-OS source code.

*** @ *** @ *** @ *** @ *** @ *** @ *** @ *** @ ***
*Merged kernel version numbering to Nougat branch.*
*** @ *** @ *** @ *** @ *** @ *** @ *** @ *** @ ***

## 16. May 27, 2018
Release status: Oreo-beta-v2.5
Merged recent changes from osm0sis's Anykernel repo. Up-to-date with Linage-OS source code.

## 15. May 16, 2018
Release status: Oreo-beta-v2.4
Added boeffla generic wakelock blocker (v1.1.0).

## 14. May 11, 2018
Release status: Oreo-beta-v2.3
CPU is overclocked up-to 2.84 GHz.

## 13. May 7, 2018
Release status: Oreo-beta-v2.2
Added LED blink/fade support (credits: Lord Boeffla) which is configurable in SP-Kernel Manager. Up-to-date with Linage-OS source code.

## 12. May 2, 2018
Release status: Oreo-beta-v2.1
Added spectrum based performance tweaks and are accessible in SmartPack-Kernel Manager/Spectrum (currently three different tweaks are available and are: Battery, Performance and Balanced). Removed all the changes hard-coded to "init.qcom.rc". Up-to-date with Linage-OS source code.

## 11. April 22, 2018
Release status: Oreo-beta-v2.0
Added Boeffla Sound (as a replacement for Franco sound control). Some fine tuning to interactive. Reduce default AC level to 1800 mA. Up-to-date with Linage-OS source code.

## 10. April 2, 2018
Release status: Oreo-beta-v1.9
Update fast charge into v2.0 (own modifications), which includes i. Enabled Custom Mode by default, ii. Bump USB and Wireless levels up to 1600, iii. Set default AC: 2000; USB:700; Wireless:900, iv. Reduced lower charge current for USB (400) and Wireless (600) and v. Miscellaneous changes. Removed Microphone Gain from KA to avoid conflicts. Removed SmartPack boot script. Up-to-date with Linage-OS source code.

## 9. March 22, 2018
Release status: Oreo-beta-v1.8
Merged recent changes from osm0sis's Anykernel repo. Up-to-date with Linage-OS source code.

## 8. March 06, 2018
Release status: Oreo-beta-v1.7
Up-to-date with Linage-OS source code. Merged recent changes from osm0sis's Anykernel repo.

## 7. Feb 26, 2018
Release status: Oreo-beta-v1.6
Switched toolchain to UBERTC 8.x (latest). Removed Lazyplug touch boost (to avoid conflicts with CPU Input Boost). Merged recent changes from osm0sis's Anykernel repo. Up-to-date with Linage-OS source code.

## 6. Feb 18, 2018
Release status: Oreo-beta-v1.5
Up-to-date with Linage-OS source code.

## 5. Feb 01, 2018
Release status: Oreo-beta-v1.4
Added ondemand plus cpufreq governer. Up-to-date with Linage-OS source code.

## 4. Jan 26, 2018
Release status: Oreo-beta-v1.3
Enabled Lazyplug by default.
Some fine tuning mainly to iosched to improve performance as suggested by Saber.
Up-to-date with Linage-OS source code.

## 3. Jan 19, 2018
Release status: Oreo-beta-v1.2
Added blu_Active cpufreq governer. 
Some fine tunings to Nightmare cpufreq governer.
A lot of patches and improvements in many other places including cpufreq, scheds etc. from upstream Linux. 
Introduced *SmartPack* boot script, which will be used for various purposes (eg: activating cpu_input_boost, adreno_idler, fast_charge, intelli_thermal etc.).
Increased default read ahead size. Up-to-date with Linage-OS source code.

## 2. Jan 15, 2018
Release status: Oreo-beta-v1.1
Fixed simple_ondemand crashing.
Kernel Same-page  Merging (KSM) is now enabled.
Some patches to msm_adreno_tz.
Merged with recent changes from osmosis anykernel repo (which includes some important changes for Oreo).
Up-to-date with Linage-OS source code.

## 1. Jan 10, 2018
Release status: Oreo-beta-v1.0
The very first release for Android 8.1.0.
Please visit xda thread for more details.
