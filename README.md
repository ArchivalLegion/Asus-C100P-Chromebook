# Asus-C100P-Chromebook
This project is designed to install archlinux on an ASUS C100P chromebook and get it to a useable state with as little fiddling as possible. I am a casual linux enthusiast and this is the biggest project I have undertaken. I was able to find some very helpfuls sources online and then put them together into several scripts and config files. Hopefully someone else may find this helpful and hopefully more knowledgeable linux users may be able to help with some of the issues I have been having. I spent a lot of time on the arch wiki.

I really like my C100P and I was extremely disappointed when it stopped recieving updates. After installing archlinux it is faster than ever and has even more features. I believe mort of this can also be adapted to the Asus C201 aswell.

I used a Windows 10 desktop running linux mint in a virtual box to setup my sdcard. However, you can use the chromebook booted in developer mode and open a shell. The main problem I encountered using the chromebook is that it does not have the nano command line text editor. You have to use vim which I could not for the life of me figure out. There are also couple additional steps if doing all on the chromebook. I have noted below.

# How to install:

## Section One – Prepare the device
1 Put the Asus C100P into developer mode. I won’t really be going into detail as this is covered in great detail elsewhere.
2 If using the Chromebook to setup the sdcard then boot into developer mode (Ctrl+D). When it boots connect to wifi and open a guest session (You don’t need to login with google or do any other configuration of Chromeos).
https://www.howtogeek.com/210817/how-to-enable-developer-mode-on-your-chromebook/

## Section Two – Configuring files
1 Download all scripts and files into a new folder
`git clone https://github.com/harvp0wn/Asus-C100P-Chromebook`
2 Run “lsblk”. The location will differ based on the device you are using to setup the sdcard. Note this location (ie /dev/sdb or /dev/mmcblk0).
3 Use the device location above and run “cgpt show /dev/???”. This will change based on sdcard size. Note the start of sec GPT header and then subtract a little bit.
4 Open “sdcardinstall.sh” in a text editor and change the variables if needed. If installing from chromeos change "nano" to "vim" in the final step.
5 Open “1-update-and-fix.sh” in a text editor change the DNS variable to your desired DNS (default is OpenDNS).
6 Open ”2-hardware-and-users-setup.sh” in a test editor and set the timezone, username (default is “newuser”, and SSID of wifi network (should be “wlan0-SSID”).
7 Open “3-gui-and-applications.sh” in a text editor and set the username (default is newuser) and review the script to select your desired desktop environment (default is openbox with some xfce components and feh for backgrounds). You can also change backgrounds in lightdm conf.
8 Make sure the ownership and permissions of the download files are correct.
```
chown root:root *
chmod +x *.sh
```

## Section Three – Writing to SD Card
If using a linux computer; open a root terminal (or use sudo) and run “sh sdcardinstall.sh”. Follow directions, cross fingers.

If using the chromebook; open a terminal by pressing Ctrl+Alt+T then type “shell” and enter. “sudo su” will open root terminal or type sudo before commands. Then run as root “mount -i -o remount,exec /home” This will allow you to execute the sdcardinstall.sh script from the chromebook. Then run as root “sh sdcardinstall.sh”. Follow directions, cross fingers.

https://archlinuxarm.org/platforms/armv7/rockchip/asus-chromebook-flip-c100p

## Section Four – To run on device in archlinux
1) Insert SD card into chromebook if using other computer to setup or reboot if using chromebook. Press “Ctrl+U” at boot screen to boot from external storage.
2) Loing to arch as root (default password is “root”) and run the first script “sh 1-update-and-fix.sh” Follow directions, cross fingers.
3) After reboot login as root and launch the second script “sh 2-hardware-and-users-setup.sh”. Follow directions, cross fingers. Make sure you note the passwords.
4) Once second script is finished logout and login as “admin” using the new password. If you accidentally reboot instead of logging out you will have to reconnect to the internet by running “netctrl start wlan0-SSID” before running third script.
5) Run the third script as admin “3-gui-and-applications.sh”. Cross fingers. Lightdm should start.

https://wiki.archlinux.org/index.php/Installation_guide
https://github.com/nikolas-n/GNU-Linux-on-Asus-C201-Chromebook
https://wiki.debian.org/InstallingDebianOn/Asus/C201

Issues:
- I have not updated to mainline kernel. Too scared haha
- There is a bug in firefox where my passwords will not sync
- I have not yet configured the brightness and volume control buttons on the keyboard.
- The webcam glitchy. In vlc it doesn't load everytime and when it does load it takes a while. 
- The webcam does not work in firefox (specifically for messenger video calls)
- Zoom was not installed. Zoom is a major goal of this project as I use it for work. I am trying to run the 32-bit linux zoom in box86.
- I am using openbox auto start to automatically connect to my home wifi. It seems hacky, there is probably a better way.

Features to implement
- Samba filesharing client for home network shares.
- Wireguard vpn client so I can connect to my vpn when I am not on my home network.
- Install onto internal memory once issues are resolved.
- Some type of usage management software like focus.py. I tend to waste a lot of time on this device.

Thanks for all the people who helped me get this far!

http://kmkeen.com/c100p-tweaks/index.html
https://github.com/keenerd/c100p-tweaks/
