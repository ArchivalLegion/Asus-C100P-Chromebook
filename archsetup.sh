#!/bin/bash
#
##### Variables #####
dns=8.8.8.8
ssid=wifi
# Timezone and Username
tz=America/Vancouver
usr=username
#####################
#
# Network Configuration
rm /etc/hostname
rm /etc/resolvconf.conf
rm /etc/resolv.conf
touch /etc/hostname
echo "ASUSC100P" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1 localhost" >> /etc/hosts
echo "127.0.1.1 ASUSC100P.localdomain ASUSC100P" >> /etc/hosts
touch /etc/resolv.conf
echo "nameserver 127.0.0.1" >> /etc/resolv.conf
echo "nameserver ${DNS}" >> /etc/resolv.conf
#
# Connect to wifi
wifi-menu
#
# Pacman initialize and update
pacman-key --init
pacman-key --populate
pacman -Syu
#
# Install Packages
cli="sudo man imagemagick"
dmde="xorg-xinit xorg-server xorg-xinput xf86-input-synaptics ttf-dejavu ttf-liberation openbox obconf python-xdg lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings xfce4-appfinder xfce4-power-manager xfce4-terminal xfce4-clipman-plugin xfconf xfce4-notifyd xfce4-screensaver xfce4-screenshooter archlinux-wallpaper tint2 gnome-keyring libsecret"
apps="vlc firefox chromium pinta thunderbird libreoffice-still thunar thunar-volman thunar-archive-plugin thunar-media-tags-plugin tumbler emacs mousepad ristretto"
sound="alsa-utils pavucontrol volumeicon pulseaudio pulseaudio-alsa pulseaudio-jack pulseaudio-equalizer"
bluetooth="pulseaudio-bluetooth bluez bluez-utils blueman"
network="ufw smbclient cifs-utils gvfs-smb networkmanager nm-connection-editor network-manager-applet wireless_tools"
printer="cups ghostscript"
other="fcron linux-armv7-headers cmake"
pacman -S ${cli} ${dmde} ${apps} ${sound} ${bluetooth} ${network} ${printer} ${other}
#
# Set Location
read -p "Uncomment location and save (en_CA.UTF-8) --- Press [Enter] to continue ..."
nano /etc/locale.gen
locale-gen
#
# Set time zone
ln -sf /usr/share/zoneinfo/${tz} /etc/localtime
hwclock --systohc
#
# Configure keyboard for chromebook
localectl set-x11-keymap us chromebook
#
# Copy Config Files
cp core/* /
#
# Switch to NetworkManager
netctl stop wlan0-${ssid}
netctl disable wlan0-${ssid}
netctl dieable wlan0
systemctl stop wlan0-${ssid}
systemctl disable wlan0-${ssid}
systemctl disable wlan0
systemctl enable NetworkManager
systemctl start NetworkManager
#
# Unmute audio
amixer -c 0 sset 'Right Speaker Mixer Right DAC' unmute
amixer -c 0 sset 'Left Speaker Mixer Left DAC' unmute
alsactl store
#
# Fix reconnect issue
touch /etc/modprobe.d/blacklist-btsdio.conf
echo "blacklist btsdio" >> /etc/modprobe.d/blacklist-btsdio.conf
#
# Change fcron default editor to nano and enable
echo "export EDITOR=nano" >> /etc/profile
systemctl enable fcron
#
# Enable firewall
sudo ufw enable
#
# Resize archlinux-wallpaper (5120x2880) to height of 800  and convert to png with imagemagick
for image in /usr/share/backgrounds/archlinux/*; do convert "$image" -resize x800 "${image%.*}.png"; done
# Remove jpgs
rm /usr/share/backgrounds/archlinux/*.jpg
# Copy a background to /usr/share/backgrounds/background.png
cp /usr/share/archlinux/backgrounds/landscape.png /usr/share/backgrounds/background.png
#
# Setup LightDM Greeter
read -p "You may want to Add alarm and root to the hidden users in lightdm --- Press [ENTER] to continue ..."
nano /etc/lightdm/users.conf
systemctl enable lightdm
#
# Setup Sudoers
read -p "Allow users of the wheel group sudo access and review  --- Press [ENTER] to continue ..."
visudo
#
# Add user account
useradd -m -G wheel,network,users,video,lp ${usr}
usermod -a -G wheel alarm
#
# Copy user config files
cp /root/home /home/${usr}
#
# Ensure correct ownership of user files
chown -R ${usr}:${usr} /home/${usr}
#
echo "Set password for ${usr} account"
passwd ${usr}
#
echo "Set password for root account"
passwd root
#
# Start display manager
systemctl start lightdm
