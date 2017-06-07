#!/bin/bash
# flash all connected android devices without the use of a special cable and regardless of state.
# must be in the build release directory in order to run
# Written by Steve Osteen 11/30/2011 version 1.2

clear

echo "######### Running multi-flashall #########"

if [ ! -d "mydroid/out/host/linux-x86/bin/" ]; then
	echo "ERROR: You are running this script from the wrong location. Please run it from the build release directory"
	echo "Have a nice day!"
	exit
fi

TmpFile="adb_device_list.txt"
fbtmpFile="fastboot_device_list.txt"

adb devices | grep 'device$' | cut -c 1-16 > $TmpFile || exit 1

if [[ -s $TmpFile ]] ; then
	while read sn
	do 
		echo "found device: $sn"
	done < adb_device_list.txt
else
    mydroid/out/host/linux-x86/bin/fastboot devices | cut -c 1-16 > $fbtmpFile
    if [[ -s $fbtmpFile ]] ; then
        while read num
        do
            echo "found fastbooted device: $num"
        done < fastboot_device_list.txt
        cont=0
        while read fbline
        do
        mydroid/out/host/linux-x86/bin/fastboot flash bootloader images/u-boot.bin
        sleep 1
        mydroid/out/host/linux-x86/bin/fastboot reboot
        sleep 3
        mydroid/out/host/linux-x86/bin/fastboot oem format
        sleep 1
        FBXLOADER="MLO"
        FBSTR=`mydroid/out/host/linux-x86/bin/fastboot getvar secure 2>&1` 
        for fbrecord in $FBSTR ; do
            if [ $fbrecord = "GP" ] ; then
	            echo "=========================="
	            echo "====  CPU is GP type  ===="
	            echo "=========================="
	            FBXLOADER="MLO-GP"
	            break
            fi
        done
        mydroid/out/host/linux-x86/bin/fastboot flash xloader images/$FBXLOADER
        sleep 1
        mydroid/out/host/linux-x86/bin/fastboot flash bootloader images/u-boot.bin
        sleep 1
        mydroid/out/host/linux-x86/bin/fastboot flash recovery images/recovery.img
        sleep 1
        mydroid/out/host/linux-x86/bin/fastboot flash backup images/backup.img
        sleep 1
        mydroid/out/host/linux-x86/bin/fastboot flash boot images/boot.img
        sleep 1
        mydroid/out/host/linux-x86/bin/fastboot flash system images/system.img
        sleep 1
        mydroid/out/host/linux-x86/bin/fastboot flash userdata images/userdata.img
        sleep 1
        mydroid/out/host/linux-x86/bin/fastboot flash cache images/cache.img
        sleep 1
        mydroid/out/host/linux-x86/bin/fastboot flash splash images/splash.img
        sleep 1
        mydroid/out/host/linux-x86/bin/fastboot oem idme bootmode 0x4000
        sleep 1
        mydroid/out/host/linux-x86/bin/fastboot reboot
        let cont=cont+1
        done < fastboot_device_list.txt
        echo "[$cont] Fastbooted device(s) flashed"
        exit
    else
    	echo "ERROR: No devices found:"
        echo "please connect up one or more devices"
        echo "and make sure they are ON with adb or fastboot working"
	    echo "Have a nice day!"	
        exit
    fi
fi

echo "The following device(s) are connected and will be flashed:"
if [[ -s $TmpFile ]]; then
	while read sn
		do 
		echo $sn
	done < adb_device_list.txt
fi
sleep 3
Counter=0

while read line
do 
    echo "Flashing device: "$line
    mydroid/out/host/linux-x86/bin/adb -s $line root
    sleep 5
    mydroid/out/host/linux-x86/bin/adb -s $line shell idme bootmode 0x4002
    sleep 1
    mydroid/out/host/linux-x86/bin/adb -s $line reboot
    sleep 3
    mydroid/out/host/linux-x86/bin/fastboot flash bootloader images/u-boot.bin
    sleep 1
    mydroid/out/host/linux-x86/bin/fastboot reboot
    sleep 3
    mydroid/out/host/linux-x86/bin/fastboot oem format
    sleep 1
    XLOADER="MLO"
    STR=`mydroid/out/host/linux-x86/bin/fastboot getvar secure 2>&1` 
    for record in $STR ; do
        if [ $record = "GP" ] ; then
	        echo "=========================="
	        echo "====  CPU is GP type  ===="
	        echo "=========================="
	        XLOADER="MLO-GP"
	        break
        fi
    done
    mydroid/out/host/linux-x86/bin/fastboot flash xloader images/$XLOADER
    sleep 1
    mydroid/out/host/linux-x86/bin/fastboot flash bootloader images/u-boot.bin
    sleep 1
    mydroid/out/host/linux-x86/bin/fastboot flash recovery images/recovery.img
    sleep 1
    mydroid/out/host/linux-x86/bin/fastboot flash backup images/backup.img
    sleep 1
    mydroid/out/host/linux-x86/bin/fastboot flash boot images/boot.img
    sleep 1
    mydroid/out/host/linux-x86/bin/fastboot flash system images/system.img
    sleep 1
    mydroid/out/host/linux-x86/bin/fastboot flash userdata images/userdata.img
    sleep 1
    mydroid/out/host/linux-x86/bin/fastboot flash cache images/cache.img
    sleep 1
    mydroid/out/host/linux-x86/bin/fastboot flash splash images/splash.img
    sleep 1
    mydroid/out/host/linux-x86/bin/fastboot oem idme bootmode 0x4000
    sleep 1
    mydroid/out/host/linux-x86/bin/fastboot reboot
    echo "Device "$line" sucessfully flashed"
    let Counter=Counter+1
done < adb_device_list.txt
echo "[$Counter] Total device(s) flashed"

exit


