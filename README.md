# Asus-C100P-Chromebook
My ongoing experience installing arch linux on an end of life chromebook

## 20/05/2021
I had a major breakthrough with installing the mainline kernel. Everything is running much smoother now. Thank you cracket !

1) Make an sdcard using sdcardsetup.sh
2) Boot the SD card and login as root
3) Run archcoreinstall.sh

# Features:

## Samba Client

packages: smbclient cifs-utils gvfs-smb
navigate to smb://server/ in thunar or make a launcher for "thunar smb://server/"
OR Manually Mount
sudo mkdir /mnt/mountpoint
mount -t cifs //SERVER/sharename /mnt/mountpoint -o username=username,password=password

## Wireguard Client

packages: wireguard-tools
Copy wireguard config file to /etc/wireguard/
Option 1: wg-quick
To start/stop "wg-quick up/down archbook"
For status "wg"
Option 2: Netctl
Setup a netctl profile using /etc/netctl/examples/wireguard and move to etc/wireguard/wg0
To start/stop "netctl start/stop wg0"
To load at boot enable the netctl profile "netctl enable wg0"

## Nextcloud

packages: davfs2 nextcloud-client
nextcloud-client will sync files for offline use
navigate to davs://yournextcloudserver.com/remote.php/webdav/ or make a launcher "thunar davs://yournextcloudserver.com/remote.php/webdav/"
OR Manually Mount
davfs allows mounting nextcloud but requires internet access
mkdir /mnt/nextcloud
mount -t davfs https://your_domain/nextcloud/remote.php/dav/files/username/ /path/to/mount

## LightDM

The lightdm background is used in openbox sessions. Therefore I do not run a background program with openbox. to manually change the background run lightdm-gtk-greeter-settings

## Desktop Environments

The script will install and configure an openbox session. Xfce and Lxqt are there to try but are not configured.
Openbox Keybindings: Ctrl-Alt-Backspace = task manager, Ctrl-Alt-T = terminal, Ctrl-Alt-F = Firefox, Ctrl-Alt-D = Desktop, Search Button = Appfinder, Ctrl-Space = Toggle always on top, Overview button + Ctrl = Screenshoot
Menumaker is set to make menus during install to update run"
mmaker -vf -s console,kde,xfce,gnome --no-debian --no-legacy openbox3
openbox --reconfigure

# What hasn't been tested

- Wireguard
- Bluetooth
- Headphone jack

# Issues to fix and future projects

- make shortcuts for restart, suspend/sleep, logoff, and power off, etc
- Automatically connect with wireguard when not on home network
- Install zoom (box86) --> Successful ! Will post
- remove xfce4 lock background
- I want to use lightdm to lock the screen (dm-tool lock).
  I have modified xflock4 to use lightdm as the primary lock
  option. However, when the lid is closed, xfce4-screensaver
  is still used to lock the screen.
- clean up unneeded packages and remove xfce and lxqt
- Install on main partition


# Bugs

- Firefox will not sync passwords --> using bitwarden plugin
- Firefox will not use webcam video --> installed chromium
- Webcam image needs to be mirrored. I followed the guide on the archwiki but not luck. Zoom will allow webcam mirroring but there is no option in chromium.

https://wiki.archlinux.org/title/Webcam_setup

`LD_PRELOAD=/usr/lib/libv4l/v4l2convert.so /usr/bin/firefox`

Did not work
```
sudo pacman -S linux-armv7-headers v4l-utils v4l2loopback-dkms ffmpeg
# Installing linux-headers was important. I moved to the core script
sudo modprobe v4l2loopback
v4l2-ctl --list-devices
Dummy video device (0x0000) (platform:v4l2loopback-000):
	/dev/video5
ffmpeg -f v4l2 -i /dev/video1 -vf "vflip" -f v4l2 /dev/video5
--> Did not work. Webcam would turn on but I could not access /dev/video5 video feed
```
