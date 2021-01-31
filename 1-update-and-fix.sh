#! /bin/bash
#
# When the system boots for the first time login to the root account (password root) and run this script.
# It will connect to the internet, update, and then run a fix for the next boot.
#
# Connect to wifi
netctl start wlan0-<SSID>
### If you did not copy a config file then use wifi-menu to generate one
### wifi-menu
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
#
# Change these to your prefered DNS server
# I personally use a pihole on my local network but I put the OpenDNS server below
touch /etc/resolv.conf
echo "nameserver 127.0.0.1" >> /etc/resolv.conf
echo "nameserver 208.67.222.222" >> /etc/resolv.conf
#
#
# Need to change a line in this file (if not aleady done at last step)
read -p "Find ExecStart=systemd-tmpfiles --create --remove --boot --exclude-prefix=/dev"
read -p "Change to ExecStart=echo ''disabled'' --- Press [Enter] to continue ..."
nano /usr/lib/systemd/system/systemd-tmpfiles-setup.service
#
reboot
