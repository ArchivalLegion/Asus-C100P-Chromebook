#! /bin/bash
#
# First run on new system to update
#
# Connect to wifi
netctl start wlan0-mrrobot
#
## If wifi config file not already created or copied then use wifi-menu
## Remember the config file name for further steps
## wifi-menu
#
# Update pacman
pacman-key --init
pacman-key --populate
pacman -Syu 
#
# Fix boot again after systemd update
rm /usr/lib/systemd/system/systemd-networkd.service
rm /usr/lib/systemd/system/systemd-timesyncd.service
rm /usr/lib/systemd/system/systemd-resolved.service
rm /etc/resolvconf.conf
rm /etc/resolv.conf
touch /etc/resolv.conf
echo "nameserver 127.0.0.1" >> /etc/resolv.conf
echo "nameserver 192.168.1.119" >> /etc/resolv.conf
# Need to change a line in this file (if not aleady done at last step)
read -p "Find ExecStart=systemd-tmpfiles --create --remove --boot --exclude-prefix=/dev"
read -p "Change to ExecStart=echo ''disabled'' --- Press [Enter] to continue ..."
nano /usr/lib/systemd/system/systemd-tmpfiles-setup.service
#
#
reboot
