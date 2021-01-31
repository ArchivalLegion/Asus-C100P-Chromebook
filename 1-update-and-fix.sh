#! /bin/bash
#
# When the system boots for the first time login to the root account (password root) and run this script.
# It will connect to the internet, update, and then run a fix for the next boot.
#
##### Variables #####
DNS=208.67.222.222
#####################
#
# Connect to wifi
wifi-menu
#
# Pacman initialize and update
pacman-key --init
pacman-key --populate
pacman -Syu 
#
# Fix boot again
rm /usr/lib/systemd/system/systemd-networkd.service
rm /usr/lib/systemd/system/systemd-timesyncd.service
rm /usr/lib/systemd/system/systemd-resolved.service
rm /etc/resolvconf.conf
rm /etc/resolv.conf
touch /etc/resolv.conf
echo "nameserver 127.0.0.1" >> /etc/resolv.conf
echo "nameserver ${DNS}" >> /etc/resolv.conf
#
# Need to change a line in this file (if not aleady done at last step)
read -p "Find ExecStart=systemd-tmpfiles --create --remove --boot --exclude-prefix=/dev"
read -p "Change to ExecStart=echo ''disabled'' --- Press [Enter] to continue ..."
nano /usr/lib/systemd/system/systemd-tmpfiles-setup.service
#
reboot
