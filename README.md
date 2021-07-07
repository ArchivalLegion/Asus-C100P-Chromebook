# Asus-C100P-Chromebook ArchLinux
My ongoing experience installing arch linux on an end of life chromebook.

When I started this project there wasn't a lot of information out about this Chromebook and many of the implementations required a lot of tinkering and were not beginner friendly. This isn't really the case anymore.

# Quick Install
1. Go to home directory `cd ~/`
2. Clone repo `git clone https://github.com/harvp0wn/Asus-C100P-Chromebook`
3. Enter directory `cd Asus-C100P-Chromebook`
4. Review all scripts
5. Insert a sdcard into your build machine and run sdcard the setup script `sudo bash sdcardsetup.sh`
6. Insert the sd card into the chromebook and boot in developer mode (Ctrl-U)
7. Login into arch (root:root... or alarm:alarm) <-- need to test
8. Run arch setup script `bash archsetup.sh`

# Hardware
- Wifi and Bluetooth: Need to copy proprietary drivers from chromeos partition (/usr/lib/firmware/brcm/)
- Webcam: Should work out of the box now. There is a bug with Firefox so I use chromium for video chats.
- Keyboard: Everything works (/etc/X11/xorg.conf.d/70-synaptics.conf)

# Software
## LightDM Gtk Greeter
- Loads the background image (default: /usr/share/backgrounds/background.png)

## Openbox
### Autostart (/etc/xdg/openbox/autostart)
- Panel: tint2 (~/.config/tint2/tint2rc)
- Volume: volumeicon
- Notifications: xfce4-notifyd 
- Power Management: xfce4-power-manager
- NetworkManager
- Bluetooth: blueman
- Clipboard: parcellite

### Keybindings (/etc/xdg/openbox/rc.xml)
- All Chromebook function keys are configured (Sound, Brightness, Lock, etc)
- Task Manager = Ctrl-Alt-Backspace
- Terminal = Ctrl-Alt-T
- Firefox = Ctrl-Alt-F
- Desktop = Ctrl-Alt-D
- Appfinder = Search Button
- Toggle always on top = Ctrl-Space
- Screenshot = Overview button + Ctrl
- Window Snapping to a Side = Ctrl + Direction Arrow
- Window Snapping to a Corner = Alt + Direction Arrow
### Openbox Menu (/etc/xdg/openbox/menu.xml)

## Samba Client

packages: smbclient cifs-utils gvfs-smb
navigate to smb://server/ in thunar or make a launcher for "thunar smb://server/"
OR Manually Mount
```
sudo mkdir /mnt/mountpoint
mount -t cifs //SERVER/sharename /mnt/mountpoint -o username=username,password=password
```

## Nextcloud

davfs allows opening nextcloud in thunar. nextcloud-client will sync files for offline use.
in thunar navigate to davs://yournextcloudserver.com/remote.php/webdav/ or from the command line
`thunar davs://yournextcloudserver.com/remote.php/webdav/"`
you can also mount nextcloud
```
mkdir /mnt/nextcloud
mount -t davfs https://your_domain/nextcloud/remote.php/dav/files/username/ /path/to/mount
```
Nextcloud-client makes set the default folder location as ~/Nextcloud. The was leading to problems with permission, file searches and backups. If I want to backup my home folder I don't want to backup my offline nextcloud storage aswell... It's already on the cloud ! So I changed the location.
```
mkdir /mnt/Nextcloud-Client-Offline
chown USERNAME:USERNAME Nextcloud-Client-Offline
# Updated in nextcloud-client config
nano ~/.config/Nextcloud/nextcloud.cfg
# Updated the following line:
# 0\Folders\1\localPath=/mnt/Nextcloud-Client-Offline
```
SUCCESS !!!

## Wireless Brother Printer Drivers with CUPS

packages: cups ghostscript
Built drivers directly from:
https://github.com/pdewacht/brlaser
SUCCESS !!!

## Box86 (From AUR)

Installed directly from the AUR to run 32bit x86 programs. 
SUCCESS !!!

## Zoom (Running in Box86)
Manually download the 32bit linux x86 standalone package from zoom.us
extract and run
SUCCESS !!!

## Widevine DRM (From AUR)

packages: widevine-armv7h
https://aur.archlinux.org/packages/widevine-armv7h/
Allows the playback of widevine DRM content (Netflix, Spotify, etc)
For netflix you also have to switch the user agent to chromeos

# Bugs
- Firefox: will not sync passwords --> using bitwarden plugin
- Firefox: No webcam access --> using chromium for video chats