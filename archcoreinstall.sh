#! /bin/bash
#
##### Variables #####
DNS=8.8.8.8
SSID=wifissid
# Timezone and Username
TZ=America/Vancouver
USR=username
#####################
#
# Change to directory with install files
cd /root
#
# Connect to wifi
wifi-menu
#
# Pacman initialize and update
pacman-key --init
pacman-key --populate
pacman -Syu
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
# Install Packages
pacman --needed -S alsa-utils xf86-input-synaptics linux-armv7-headers sudo fcron ufw xorg-xinit xorg-server xorg-xinput openbox tint2 volumeicon obconf menumaker ttf-dejavu ttf-liberation vlc firefox chromium pinta thunderbird libreoffice-still smbclient cifs-utils gvfs-smb davfs nextcloud-client lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings xfce4 xfce4-goodies lxqt pavucontrol wireguard-tools archlinux-wallpaper imagemagick
#
# Remove packages
pacman -R pcmanfm-qt qterminal parole lximage-qt screengrab xfburn obconf-qt lxqt-archiver lxqt-about

# Set Location
read -p "Uncomment location and save (en_CA.UTF-8) --- Press [Enter] to continue ..."
nano /etc/locale.gen
locale-gen
#
# Set time zone
ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime
hwclock --systohc
#
# Configure keyboard for chromebook
localectl set-x11-keymap us chromebook
#
# Setup wifi to automatically connect
# Disable existing netctl profiles
netctl stop wlan0-${SSID}
netctl disable wlan0-${SSID}
# Add priority to config file
echo "Priority=10" >> /etc/netctl/wlan0-${SSID}
# Enable netctl-auto
systemctl enable netctl-auto@wlan0
netctl-auto enable-all
#
# Fix audio
amixer -c 0 sset 'Right Speaker Mixer Right DAC' unmute
amixer -c 0 sset 'Left Speaker Mixer Left DAC' unmute
alsactl store
#
# Fix reconnect issue
touch /etc/modprobe.d/blacklist-btsdio.conf
echo "blacklist btsdio" >> /etc/modprobe.d/blacklist-btsdio.conf
#
# Openbox global files
cp etc-xdg-openbox-rc.xml /etc/xdg/openbox/rc.xml
cp etc-xdg-openbox-autostart /etc/xdg/openbox/autostart
mmaker -vf -s console,kde,xfce,gnome --no-debian --no-legacy openbox3
cp /root/.config/openbox/menu.xml /etc/xdg/openbox/menu.xml
#
# Webcam setup (permissions and symlink to video0) - Not needed for mainline kernel
# cp etc-udev-rules.d-83-webcam.rules /etc/udev/rules.d/83-webcam.rules
#
# Change visudo default editor to nano
cp editor-nano-visudo /etc/sudoers.d/editor-nano-visudo
#
# Change fcron default editor to nano and enable
echo "export EDITOR=nano" >> /etc/profile
systemctl enable fcron
#
# Setup firewall - SSH on local network only
sudo ufw limit from 192.168.1.0/24 to any port 22
sudo ufw enable
#
# Resize archlinux-wallpaper (5120x2880) to height of 800 with imagemagick
for file in /usr/share/backgrounds/archlinux/*; do convert $file -resize x800 $file; done
#
# Resize xfce wallpapers (1600x1200) to width of 1200 with imagemagick
for file in /usr/share/backgrounds/xfce/*; do convert $file -resize 1200 $file; done
#
# Setup LightDM Greeter
cp lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter.conf
read -p "Add alarm and root to hidden users in lightdm"
nano /etc/lightdm/users.conf
systemctl enable lightdm
#
# Copy wireguard config files
# cp etc-wireguard-archbook.conf /etc/wireguard/archbook.conf
# cp etc-netctl-wg0 /etc/wireguard/wg0
#
# Add network group and users group to sudoers
cp etc-sudoers-d-01-mysudoers /etc/sudoers.d/01-mysudoers
#
# Allow sudo access to users in the group wheel without password
read -p "To allow users of wheel group to execute any command with sudo"
read -p "Find #%wheel ALL=(ALL) NOPASSWD: ALL and uncomment  --- Press [ENTER] to continue ..."
visudo
#
# add new user and add alarm to wheel group
useradd -m -G network,users,video ${USR}
usermod -a -G wheel,network,video,users alarm
#
# Copy user config files
mkdir /home/${USR}/.config/volumeicon
cp config-volumeicon-volumeicon /home/${USR}/.config/volumeicon/volumeicon
mkdir /home/${USR}/.config/tint2
cp config-tint2-tint2rc /home/${USR}/.config/tint2/tint2rc
mkdir -p /home/${USR}/.config/xfce4/xfconf/xfce-perchannel-xml
cp config-xfce4-xfconf-xfce-perchannel-xml-xfce4-notifyd.xml /home/${USR}/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-notifyd.xml
cp config-xfce4-xfconf-xfce-perchannel-xml-xfce4-power-manager.xml /home/${USR}/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml
#
# Ensure correct ownership of user files
chown -R ${USR}:${USR} /home/${USR}
#
echo "Set password for ${USR} account"
passwd ${USR}
#
echo "Set password for alarm account"
passwd alarm
#
# Disable root login
passwd -l root
#
# Start display manager
systemctl start lightdm
