#!/bin/bash
# eMMC stress test for Android based devices (technology circa 2012ish)

i=1

cat /dev/ttyUSB0 | tee log_eMMC.txt & 

  #block until device is online
  ./adb wait-for-device 
  echo "wait-for-device"

  #Wait for 10 s
  sleep 10

  ./adb root
  #collect log
  ./adb logcat &

  #Wait for 10 s
   sleep 10

  
  ./adb shell "echo ondemand > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor"
for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30
do
for j in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30
do
for k in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30
do
  
  echo "Start Iteration Number: $k $i $j"
  echo "eMMC stress test for SMP processors"
  echo "*-*-*-*-*-*-*-*-*-*-*-*-*-*-**-*-*-*"
  #Print memory info
  cat /proc/meminfo

  echo "Turning ON CPU1"
  ./adb shell "echo 1 > /sys/devices/system/cpu/cpu1/online"

  ./adb shell dd if=/dev/block/platform/mmci-omap-hs.1/by-name/recovery of=/dev/null &
  ./adb shell dd if=/dev/zero of=/dev/block/platform/mmci-omap-hs.1/by-name/backup &
  ./adb shell dd if=/dev/zero of=/dev/block/platform/mmci-omap-hs.1/by-name/dfs &
  ./adb shell dd if=/dev/zero of=/dev/block/platform/mmci-omap-hs.1/by-name/dkernel &

  #Wait for 20 s
  sleep 20
  
  echo "Turning OFF CPU1"
  ./adb shell "echo 0 > /sys/devices/system/cpu/cpu1/online"

  sleep 20 
  echo "Turning ON CPU1"
  ./adb shell "echo 1 > /sys/devices/system/cpu/cpu1/online"
  sleep 60
  echo "Finished Iteration Number: $k $i $j"
  echo " "

done
done
done
echo "****** Test completed *****."
