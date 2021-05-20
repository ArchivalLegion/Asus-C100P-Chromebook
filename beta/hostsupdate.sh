#! /bin/bash
#
# Update linux hosts
#
cd /home/admin/scripts
#
# download StephenBlack's blocklist list from github mirror
curl -O http://sbc.io/hosts/alternates/porn/hosts
#
# copy to /etc/hosts
cp hosts /etc/hosts
#
## Add to fcron to automate weekly
## Update hosts and export to chromeos partition weekly
## 0 0 * * SAT /bin/sudo sh /home/admin/scripts/hostsupdate.sh

