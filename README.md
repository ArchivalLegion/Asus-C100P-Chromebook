# Asus-C100P-Chromebook
This project is designed to install archlinux on an ASUS C100P chromebook and get it to a useable state. I am a casual linux enthusiast and this is the biggest project I have undertaken. I was able to find some very helpfuls sources online and then put them together into several scripts and config files. Hopefully someone else may find this helpful.

I really like my C100P and I was extremely disappointed when it stopped recieving updates. After installing archlinux it is faster than ever and retains most of the usability that it had before.

How to use:
1) Download all scripts and files into a folder. Take note of the folder location
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
