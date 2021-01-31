#! /bin/bash
#
# You need to add a variable for the directory with the install files that will be copied
#
# Finish users setup
read -p "Run this script as the newly created admin acount with sudo access"
read -p "The next step will disable root login"
read -p "Press [Ctrl] + [C] to exit script OR [Enter] to continue ..."
passwd -l root
#
# Install applications and desktop components
pacman -S xfce4-panel xfce4-whiskermenu-plugin xfce4-taskmanager xfce4-appfinder xfce4-terminal ristretto vlc guvcview pinta firefox libreoffice-still xed thunar 
#
### Below was initiall used but there is way too much stuff. Figure out what you were actually using out of this
### Install GUI and software figure out what xfce4 software you want
###pacman -S xfce4 xfce4-goodies
### Remove mousepad since xed is better... maybe look at what you actually use from xfce4-goodies and xfce4 since your using openbox anyways
###pacman -R mousepad xfce4-notes-plugin
#
#LIGHTDM SETUP
pacman -S lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings fcron feh
cp lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter.conf
# Add alarm and root to hidden users in lightdm conf
read -p "Add alarm root and admin to hidden users in lightdm"
nano /etc/lightdm/users.conf
# enable lightdm and reboot
systemctl enable lightdm
#
# Background switching
# Set cron que to one item
systemctl enable fcron
fcron -q 1
# copy cron file /etc/crontab
EDITOR=nano fcrontab -e
# copy user cron file for feh updates
# figure out how to change default editor as this may be a peta later on
#
# OPENBOX SETUP
pacman -S openbox obconf menumaker ttf-dejavu ttf-liberation xorg-xinit xorg-server xorg-xinput 
# copy openbox config for system (rc.xml for ctrl-alt-T, ctrl-alt-backspace, ctrl-alt-f)
cp etc-xdg-openbox-rc.xml /etc/xdg/openbox/rc.xml
# copy openbox config for user
cp -R openbox /home/harve/.config/
# cpoy file to cron for background switcher
# Update user account menu
runuser -l  harve -c 'mmaker -vf OpenBox3'
# Update current (root) account menu
mmaker -vf OpenBox3
openbox --reconfigure
reboot
