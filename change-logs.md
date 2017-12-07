# Change-logs

## 39. Dec 07, 2017
Stable release: v11_r3
Massive code cleaning to improve (hopefully) the battery and performance. Up-to-date with Linage-OS source code.

## 38. Nov 29, 2017
Stable release: v11_r2
Changes: Up-to-date with LOS kernel source code till date. Merged with all the latest patches from osm0sis's AnyKernel2 repo.

## 37. Nov 16, 2017
Stable release: v11_r1
Changes: Switched to latest Linaro-7.2 (gcc-7.2) toolchain. Up-to-date with LOS kernel source code till date.

## 36. Nov 1, 2017
Stable release: v11
Changes: Switched to UBERTC-8.0 (gcc-8) latest toolchain. Up-to-date with LOS kernel source code till date.

## 35. Oct 25, 2017
Maintenance update: v10_r9
Changes: Dynamic FSync is now enabled by default.Up-to-date with LOS kernel source code till date.

## 34. Oct 18, 2017
Stable release: v10_r8
Changes: Switched into Linaro GCC 4.9 toolchain. Updated zzmove cpufreq gov. Added 268 MHz CPU underclocked frequency cycle. Up-to-date with LOS kernel source code till date...

## 33. Oct 11, 2017
Maintenance update: v10_r7
Changes: Nothing other than recent commits in the LOS kernel source code till date...

## 32. October 4, 2017
Stable release: v10_r6
Changes: CPU input boost (credit: sultanxda), which requires almost zero configuration, is added as a replacement of stock cpu boost. f2f is now nearly latest (I added almost all the commits from the mainstream Linux unless those are too difficult to implement. All the commits in the LOS kernel source code till date...

## 31. October 2, 2017
Stable release: v10_r5
Changes: Camera black screen issue in RR (and others if any) should be fixed now. Adreno Idler (credits: arter97) is added. Another ton of commits related with f2f are merged from the mainstream Linux. All the commits in the LOS kernel source code till date...

## 30. September 27, 2017
Stable release: v10_r4
Changes: kltespr and kltedv are now merged togother. Simple GPU Algorithm (credits: faux123) is added. Another ton of commits related with f2f are merged from the mainstream Linux. All the commits in the LOS kernel source code till date...

## 29. September 20, 2017
Stable release: v10_r3
Changes: Another ton of commits related with f2f are merged from the mainstream Linux. All the commits in the LOS kernel source code till date...

## 28. September 14, 2017
Stable release: v10_r2
Changes: A lot of commits related with f2f (and few for tcp and cpufreq) are merged from the mainstream Linux. All the commits in the LOS kernel source code till date...

## 27. September 06, 2017
Stable release: v10_r1
Not much is changed from the last stable release as well as the latest klte test builds except some workaround for the camera black screen issue..

## 26. August 31, 2017Stable release: v10
Changes: Source is fully re-based.

## 25. August 23, 2017
Stable release: v9_r2
Added: Powersuspend; Modified: zzmove and intelliplug (to accommodate powersuspend).

## 24. August 16, 2017
Stable release: v9_r1
Changes: The source is fully re-based (since LOS kernel source is re-based by the development team). All the commits suggested by @Saber is included.

## 23. August 02, 2017
Stable release: v9
Changes: All the commits in the LOS source code till date. Some recent commits in the fastcharge feature are reverted (Now you need to manually enable the feature in Kernel Auditor).

## 22. July 27, 2017
Minor update: v8_r3
zzmove cpufreq gov is updated to the latest version (credits: zanezam)...

## 21. July 20, 2017
Maintenance update: v8_r2
All the commits in the LOS kernel source till date...

## 20. July 13, 2017
Stable release: v8_r1
All the commits in the LOS kernel source till date... Sound control (my fav values) and Fast charge features are now enabled by default.

## 19. July 6, 2017
Stable release: v8
Changes: Linux kernel version is updated to 3.4.113. Few more updates to the sound control (credits: franciscofranco). Activated additional 27 MHz gpu frequency step (credits: Lord Boeffla). New cpu hotplug: intelliplug (credits: Faux123)

## 18. June 27, 2017
Stable release: v7
Changes: Source code is merged with Samsung's latest source (thanks to @haggertk and LOS team). Sound control is updated to fix some issues with speaker sound (now it seems fully working). Toolchain is switched to Google's latest arm-eabi-4.9 r15.

## 17. June 21, 2017
Maintenance update: v6-r1
Changes: Nothing other than the recent LOS commits till today...

## 16. June 13, 2017
Stable release: v6
Faux sound is replaced by sound control (credits: franciscofranco). Fastcharge is now back to kernel as a replacement for charge level interface. New CPU hotplug (MSMS_hotplug) & govs (abyssplug v2 and yankdemand) are added. Linux kernel version update to 3.4.113 is temporarily reverted (now its 3.4.111) due to some issues.

## 15. June 8, 2017
Maintenance update: v5-r1
Nothing other than the recent LOS commits till today...

## 14. June 1, 2017
Major update: v5
The source is fully re-based. Linux kernel is updated to 3.4.113. Additions includes Simple GPU Algorithm, Intelli thermal v2.0 as well as all the commits in the LOS source code till date.
update: I found some issues on simple GPU Algorithm. After several attempts to fix, I decided to disable that feature from my kernel. The present build will be replaced with new one soon (name should be SmartPack_kernel_kltexxx_20170602.zip).

## 13. May 25, 2017
Maintenance update: v4-r2
Nothing other than the recent LOS commits till date.

## 12. May 18, 2017
Stable release: v4-r1
Changes includes the addition of new cpu hotplugs (Alucard and Zen decision) as well as the recent LOS commits.

## 11. May 10, 2017
Stable release: v4
Linux Kernel version is updated to 3.4.111. All the commits in the LOS kernel source code until now.

## 10. May 03, 2017
Stable release: v3
Fast charging feature is now replaced with charge level interface (credits: Lord Boeffla). and all the recent changes in the LOS source code.

## 9. April 19, 2017
Maintenance update: v2-r2
Nothing other than the latest LOS commits.

## 8. April 15, 2017
Maintenance update: v2-r1
Nothing other than the latest LOS commits.
Support to new devices: kltespr and kltedv
No more separate build for kltevzw since LOS officially merge kltevzw with klte.

## 7. March 30, 2017
Stable release: v2
Nothing other than the latest LOS commits.

## 6. March 22, 2017
Stable release: v1
Source is merged with latest LOS commits. The only new feature is KCAL 2. I may not add new features to this kernel unless it is really important. However, depends on the user requirement, I will release new builds which will includes LOS kernel commits.

## 5. March 17, 2017
Merged with latest LOS commits. 
Some fixes for UKSM and now it is accessible through kernel auditor. Updated usb fast charging... and a lot more...

## 4. March 13, 2017
Merged with latest LOS commits. 
Added features includes Ultra Kernel Samepage Merging (UKSM), zzmove, tripndroid abd yankactive cpu freq gov.

## 3. March 07, 2017
Merged with latest LOS commits. 
Added features includes Faux audio support, FRandom, CPU input boost, Dynamic sync control 2.0 etc... 
Thanks to @Thefmaximo and @Legitsu for suggestions.

## 2. March 02, 2017
Support to new devices
kltevzw and klteduos. Thanks to @KazuDante and @Thefmaximo for testing...
New features: CPU voltage control, mako hotplug, a number of TCP congestion algorithms etc...

## 1. Feb 27, 2017
Initial release
