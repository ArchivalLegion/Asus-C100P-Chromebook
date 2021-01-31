#! /bin/bash
#
# Run on second boot to configure hardware settings and users
#
# Variables (TimeZone, USeRname, Default script directory)
TZ=America/Vancouver
USR=newuser
#
cd /home/install
#
# Finish wifi fix
read -p "Change the line ExecStart=echo 'disabled'"
read -p "to ExecStart=systemd-tmpfiles --create --remove --boot --exclude-prefix=/dev"
read -p "Press [Enter] to continue ..."
nano /usr/lib/systemd/system/systemd-tmpfiles-setup.service
rm -R /tmp/*
#
# Set time zone
ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime
hwclock --systohc
#
read -p "Uncomment location and save (en_CA.UTF-8) --- Press [Enter] to continue ..."
nano /etc/locale.gen
locale-gen
#
# Configure keyboard for chromebook
localectl set-x11-keymap us chromebook
#
# Network Configuration
rm /etc/hostname
touch /etc/hostname
echo "ASUSC100P" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1 localhost" >> /etc/hosts
echo "127.0.1.1 ASUSC100P.localdomain ASUSC100P" >> /etc/hosts
#
# Webcam setup (permissions and symlink to video0)
cp etc-udev-rules.d-83-webcam.rules /etc/udev/rules.d/83-webcam.rules
#
# Connect to wifi
netctl start wlan0-mrrobot
#
# Install hardware packages
pacman -S alsa-utils xf86-video-armsoc-rockchip veyron-libgl xf86-input-synaptics
#
# Fix audio
amixer -c 0 sset 'Right Speaker Mixer Right DAC' unmute
amixer -c 0 sset 'Left Speaker Mixer Left DAC' unmute
alsactl store
#
# Fix wifi reconnect issue
touch /etc/modprobe.d/blacklist-btsdio.conf
echo "blacklist btsdio" >> /etc/modprobe.d/blacklist-btsdio.conf
#
# Setup touchpad
cp 70-synaptics.conf /etc/X11/xorg.conf.d/70-synaptics.conf
#
# USER ACCOUNTS AND SUDO
pacman -S sudo
#
# add users
useradd -m -G network,users,video ${USR}
useradd -m -G wheel,network,video,users admin
#
# Change visudo default editor to nano
cp editor-nano-visudo /etc/sudoers.d/editor-nano-visudo
#
# Add network group and users group to sudoers
echo "%network ALL = NOPASSWD: /usr/bin/wifi-menu, /usr/bin/netctl start*, /usr/bin/netctl stop*, /usr/bin/netctl list" >> /etc/sudoers
echo "%users ALL = NOPASSWD: /usr/bin/shutdown*, /usr/bin/halt, /usr/bin/poweroff, /usr/bin/reboot" >> /etc/sudoers
#
# Allow sudo access to users in the group wheel without password
read -p "To allow users of wheel group to execute any command with sudo"
read -p "Find #%wheel ALL=(ALL) NOPASSWD: ALL and uncomment  --- Press [ENTER] to continue ..."
visudo
#
echo "Set password for ${USR} account"
passwd ${USR}
#
echo "Set password for admin account"
passwd admin
#
read -p "You will be logged out of root and then login with then admin account"
read -p "Then run the next script --- Press [Enter] to continue ..."
exit
