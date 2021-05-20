#! /bin/bash
#
# Run this script on a computer or from the shell in chromeos
#
# Run "lsblk" and "cgpt show /dev/XXX" to set variables
#
# MNT = Desired mount point
# DEV = device (ie /dev/mmcblk0)
# INS = Directory containing this script and the install files
# SGT = Start of sec GPT header from "cgpt show /dev/???" minus a little bit. This will change based on SD card size.
#
# Set variables
MNT=/mnt/usb
DEV=/dev/sdc
INS=/home/pi/Asus-C100P-Chromebook
SGT=60500000
#
## Download files
#mkdir ${INS}/downloads
#cd ${INS}/downloads
##
## Veyron Kernel (Outdated)
## curl -LO http://os.archlinuxarm.org/os/ArchLinuxARM-veyron-latest.tar.gz
##
## Mainline kernel
#curl -LO http://os.archlinuxarm.org/os/ArchLinuxARM-armv7-chromebook-latest.tar.gz
#
# DOwnload Wifi drivers
# mkdir ${INS}/firmware
# cd ${INS}/firmware
# You can copy from the chome os directory or download from
# https://github.com/cracket/c100/blob/main/hardware.md
# not sure if I can post this in my repo on github
#
# Unmount SD Card
umount -q ${DEV}*
#
# Configure sd card
fdisk --wipe always ${DEV} <<EEOF
g
w
EEOF
#
# Create partition
cgpt create ${DEV}
cgpt add -i 1 -t kernel -b 8192 -s 32768 -l Kernel -S 1 -T 5 -P 10 ${DEV}
cgpt add -i 2 -t data -b 40960 -s `expr ${SGT} - 40960` -l Root ${DEV}
partx -a ${DEV}
mkfs.ext4 ${DEV}2
#
# Extract tarball
mkdir ${MNT}
mount ${DEV}2 ${MNT}
tar -xf ${INS}/downloads/ArchLinuxARM-armv7-chromebook-latest.tar.gz -C ${MNT}
#
## Flash kernel to kernel partition
dd if=${MNT}/boot/vmlinux.kpart of=${DEV}1
#
# Copy files
cp -R ${INS}/* ${MNT}/root
#
# Copy wifi drivers
cp ${INS}/firmware/* ${MNT}/lib/firmware/brcm
#
## Unmount
umount ${DEV}2
