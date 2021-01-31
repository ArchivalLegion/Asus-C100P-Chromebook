#! /bin/bash
#
# Run on computer to setup SD Card
#
# When nano opens change the line "ExecStart=systemd-tmpfiles --create --remove --boot --exclude-prefix=/dev"
# to "ExecStart=echo "disabled""
#
# Run "lsblk" and "cgpt show /dev/XXX" to set variables
#
# MNT = Desired mount point
# DEV = device (ie /dev/mmcblk0)
# INS = Directory containing this script and the install files
# SGT = Start of sec GPT header from "cgpt show /dev/???" (will change based on SD Card Size)
#
# Set variables
MNT=/mnt/sd 
DEV=/dev/sdc   
INS=/home/harve/Chromebook/ArchLinux
SGT=60500000
#
# Unmount SD Card
umount -q ${DEV}*
### Uncomment the following if new SD card.
###
### Configure sd card
#fdisk --wipe always ${DEV} <<EEOF
#g
#w
#EEOF
###
### Create partition
##cgpt show ${DEV}
cgpt create ${DEV}
cgpt add -i 1 -t kernel -b 8192 -s 32768 -l Kernel -S 1 -T 5 -P 10 ${DEV}
cgpt add -i 2 -t data -b 40960 -s `expr ${SGT} - 40960` -l Root ${DEV}
partx -a ${DEV}
mkfs.ext4 ${DEV}2
###
# 
# Extract tarball
mkdir ${MNT}
mount ${DEV}2 ${MNT}
tar -xf ${INS}/ArchLinuxARM-veyron-latest.tar.gz -C ${MNT}
#
## Flash kernel to kernel partition
dd if=${MNT}/boot/vmlinux.kpart of=${DEV}1
#
# Copy files
# Wireless config
cp ${INS}/conf/wlan0-mrrobot ${MNT}/etc/netctl/wlan0-mrrobot
#cp backgrounds
cp -R ${INS}/backgrounds ${MNT}/usr/share
# put in the install directory for now for copy at later state (alarm directory???)
cp -R ${INS}/conf ${MNT}/home/alarm
cp -R ${INS}/installscripts ${MNT}/home/alarm
cp -R ${INS}/scripts ${MNT}/home/alarm
#
# Wifi fix for firstboot
mv ${MNT}/usr/lib/systemd/system/systemd-networkd.service ${MNT}/usr/lib/systemd/system/systemd-networkd.disabled
mv ${MNT}/usr/lib/systemd/system/systemd-timesyncd.service ${MNT}/usr/lib/systemd/system/systemd-timesyncd.disabled
mv ${MNT}/usr/lib/systemd/system/systemd-resolved.service ${MNT}/usr/lib/systemd/system/systemd-resolved.disabled
rm ${MNT}/etc/resolvconf.conf
rm ${MNT}/etc/resolv.conf
touch ${MNT}/etc/resolv.conf
echo "nameserver 127.0.0.1" >> ${MNT}/etc/resolv.conf
echo "nameserver 192.168.1.119" >> ${MNT}/etc/resolv.conf
# Need to change a line in this file
nano ${MNT}/usr/lib/systemd/system/systemd-tmpfiles-setup.service
# Unmount
umount ${DEV}2
sync

