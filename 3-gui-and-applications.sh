#! /bin/bash
#
# This script should be run from the admin account that was created in the last step
#
#### Variables######
USR=newuser
cd /home/alarm
####################
#
# Disable root login
passwd -l root
#
# Install Xorg components
pacman -S xorg-xinit xorg-server xorg-xinput
#
# Install Applications (Web browser, photo editor, office suite, notepad, videos, image viewer)
pacman -S pinta firefox libreoffice-still xed vlc ristretto thunderbird
#
# Firefox issue #1: Password sync does not work. You can manually import backedup passwords from firefox
# Firefox --> about:config --> signon.management.page.fileImport.enabled = true --> about:logins --> import file
# Firefox issue#2: WebGL must be forced for some websites to run properly
# Firefox --> about:config --> webgl.force-enabled = true
#
# Install Display Manager (LightDM)
pacman -S lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings
cp lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter.conf
read -p "Add alarm root and admin to hidden users in lightdm"
nano /etc/lightdm/users.conf
systemctl enable lightdm
#
### UNCOMMENT TO SELECT YOUR DESKTOP ENVIRONMENT
#
# 1) XFCE
# pacman -S xfce4 xfce4-goodies
#
# 2) MATE 
# pacman -S mate mate-extra
#
# 3) OPENBOX with xfce components (need to add panel plugins to the list)
pacman -S xfce4-panel xfce4-whiskermenu-plugin xfce4-taskmanager xfce4-appfinder xfce4-terminal thunar openbox obconf menumaker ttf-dejavu ttf-liberation feh
# copy openbox configs with keybindings (Ctrl-Alt-Backspace, Ctrl-Alt-T, Ctrl-Alt-F, Ctrl-Alt-D, Search Key, and USR autostart)
cp etc-xdg-openbox-rc.xml /etc/xdg/openbox/rc.xml
cp etc-xdg-openbox-rc.xml /home/${USR}/.config/openbox/rc.xml
cp openbox-autostart /home/${USR}/.config/openbox/autostart
read -p "Update your Wifi information in autostart so you will connect automatically when you login to openbox"
read -p "Press [ENTER] to continue ..."
nano /home/${USR}/.config/openbox/autostart
# update menus
runuser -l ${USR} -c 'mmaker -vf OpenBox3'
mmaker -vf OpenBox3
openbox --reconfigure
#
# Remove packages you do not want
# pacman -R mousepad xfce4-notes-plugin
#
# Fix the ownership of files that were copied into the user directory
chown -R ${USR}:${USR} /home/${USR}
#
# Start display manager
systemctl start lightdm
