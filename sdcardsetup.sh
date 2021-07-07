#! /bin/bash
#
# Run this script on a computer or from the shell in chromeos
#
# Run "lsblk" and "cgpt show /dev/XXX" to set variables
#
# mnt = Desired mount point
# dev = device (ie /dev/mmcblk0)
# ins = Directory containing this script and the install files
# sgt = Start of sec GPT header from "cgpt show /dev/xxx" minus a little bit. This will change based on SD card size.
#
# Set variables
mnt=/mnt/usb
dev=/dev/sdc
ins=$HOME/Asus-C100P-Chromebook
sgt=30000000
#
## Download Arch Mainline Kernel
wget -O $ins/ArchLinuxARM-armv7-chromebook-latest.tar.gz http://os.archlinuxarm.org/os/ArchLinuxARM-armv7-chromebook-latest.tar.gz
#
# Unmount SD Card
umount -q ${dev}*
#
# Configure sd card
fdisk --wipe always ${dev} <<EEOF
g
w
EEOF
#
# Create partition
cgpt create ${dev}
cgpt add -i 1 -t kernel -b 8192 -s 32768 -l Kernel -S 1 -T 5 -P 10 ${dev}
cgpt add -i 2 -t data -b 40960 -s `expr ${sgt} - 40960` -l Root ${dev}
partx -a ${dev}
mkfs.ext4 ${dev}2
#
# Extract tarball
mkdir ${mnt}
mount ${dev}2 ${mnt}
tar -xf ${ins}/ArchLinuxARM-armv7-chromebook-latest.tar.gz -C ${mnt}
#
## Flash kernel to kernel partition
dd if=${mnt}/boot/vmlinux.kpart of=${dev}1
#
# Copy files
mkdir ${mnt}/root
cp -R ${ins}/* ${mnt}/root
#
Ensure proper file ownership
chown -R root:root ${mnt}/root
#
# Copy wifi drivers
cp ${ins}/firmware/* ${mnt}/lib/firmware/brcm
#
## Unmount
umount ${dev}2
