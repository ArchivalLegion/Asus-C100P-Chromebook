# Asus-C100P-Chromebook
This project is designed to install archlinux on an ASUS C100P chromebook and get it to a useable state. It is my first project like this and I am somewhat of a casual linux enthusiast. Hopefully someone else may find this helpful. I really like my C100P and I was really disappointed when I learned google would no longer be updating it. With this information I was able to put a little bit more life into it.

INSTALL
1) Review all scripts (some have variables that you may want to change)
2) Preparing the SD Card for a linux computer or the ChromeOS partition of the chrombook *** WILL BE POSTING a script SOON ***
3) Boot into arch, login as root (default password root) and run the first script. Pacman will be initialized and updated and a systemd fix will run. The system will reboot when finished.
4) Login as root again and run the sceond script
5) Login as the newly created admin account and run the third script
Viola! You have arch linux with some basic apps on your chromebook !

The next steps of the project are:
- Install a Samba filesharing client
- Install Wireguard vpn client for when I am not on my home network
- Install Zoom for video calls and work
- Get webcam working in messenger in firefox
- Finish configuring the keyboard for volume and brightness control
- Install onto internal memory

Thanks for all the people who helped me get this far. I've listed some really good resources below
https://archlinuxarm.org/platforms/armv7/rockchip/asus-chromebook-flip-c100p
https://wiki.archlinux.org/index.php/Installation_guide
https://github.com/nikolas-n/GNU-Linux-on-Asus-C201-Chromebook
http://kmkeen.com/c100p-tweaks/index.html
https://github.com/keenerd/c100p-tweaks/
https://wiki.debian.org/InstallingDebianOn/Asus/C201
