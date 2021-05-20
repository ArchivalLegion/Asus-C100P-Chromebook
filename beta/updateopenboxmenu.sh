#! /bin/bash
#
# Use this script after installing or removnig programs to update the openbox menu
#
read -p "This script will automatically add or remove progams from the openbox menu"
read -p "Press [Enter] to continue ..."
#
# Update user account
runuser -l  harve -c 'mmaker -vf OpenBox3'
#
# Update current (root) account
mmaker -vf OpenBox3
openbox --reconfigure

