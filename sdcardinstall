#! /bin/bash
#
# Run this script on a computer or from the chromeos shell
#
# Run "lsblk" and "cgpt show /dev/XXX" to set variables
#
# MNT = Desired mount point
# DEV = device (ie /dev/mmcblk0)
# INS = Directory containing this script and the install files
# SGT = Start of sec GPT header from "cgpt show /dev/???" minus a little bit. This will change based on SD card size.
#
# Set variables
MNT=/mnt/sd 
DEV=/dev/sdc   
INS=/home/user/ArchLinux
SGT=60500000
#
# Confirmation
echo "Desired mount point"
echo ${MNT}
echo "Device location found using lsblk"
echo ${DEV}
echo "Directory where this script and install files are located"
echo ${INS}
echo "Start of sec GPT header from "cgpt show /dev/${DEV}" minus a little bit. 
echo "This will change based on SD card size."
echo ${SGT}
echo "You should also review the scripts that will be copied to the device."
echo "It will be easier to set them up now"
echo "-------------------------------------------------------------------------"
read -p "Did you review the scripts and set the variables?"
read -p "Press [Ctrl] + [C] to exit OR [ENTER] to continue"
#
# Download files (Veyron Kernel)
mkdir ${INS}/downloads
cd ${INS}/downloads
curl -LO http://os.archlinuxarm.org/os/ArchLinuxARM-veyron-latest.tar.gz
# Uncomment for mainline kernel and change "Extract tarball" section os script (Untested)
# curl -LO http://os.archlinuxarm.org/os/ArchLinuxARM-armv7-chromebook-latest.tar.gz
# curl -LO http://mirror.archlinuxarm.org/armv7h/alarm/firmware-veyron-1.0-1-armv7h.pkg.tar.xz
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
tar -xf ${INS}/downloads/ArchLinuxARM-veyron-latest.tar.gz -C ${MNT}
#
## Flash kernel to kernel partition
dd if=${MNT}/boot/vmlinux.kpart of=${DEV}1
#
# Copy files
#
# Wifi fix for firstboot
mv ${MNT}/usr/lib/systemd/system/systemd-networkd.service ${MNT}/usr/lib/systemd/system/systemd-networkd.disabled
mv ${MNT}/usr/lib/systemd/system/systemd-timesyncd.service ${MNT}/usr/lib/systemd/system/systemd-timesyncd.disabled
mv ${MNT}/usr/lib/systemd/system/systemd-resolved.service ${MNT}/usr/lib/systemd/system/systemd-resolved.disabled
rm ${MNT}/etc/resolvconf.conf
rm ${MNT}/etc/resolv.conf
touch ${MNT}/etc/resolv.conf
echo "nameserver 127.0.0.1" >> ${MNT}/etc/resolv.conf
# Used OpenDNS server - this will be replaced after running the first script
echo "nameserver 208.67.222.222" >> ${MNT}/etc/resolv.conf
# Need to change a line in this file
nano ${MNT}/usr/lib/systemd/system/systemd-tmpfiles-setup.service
# Unmount
umount ${DEV}2
sync

