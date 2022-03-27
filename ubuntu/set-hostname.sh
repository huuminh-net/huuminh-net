#!/bin/bash

if [ "$(id -u)" != "0" ] ; then
	echo "Sorry, you are not root."
	exit 2
fi

NEW_HOSTNAME=$(dialog --title "CHANGE HOSTNAME" --inputbox "Enter new hostname:" 8 40)


if [ ! -n "$NEW_HOSTNAME" ] ; then
	echo 'Missing argument: new_hostname'
	exit 1
fi


CUR_HOSTNAME=$(cat /etc/hostname)


# Display the current hostname
echo "The current hostname is $CUR_HOSTNAME"

# Change the hostname
hostnamectl set-hostname $NEW_HOSTNAME
hostname $NEW_HOSTNAME

# Change hostname in /etc/hosts & /etc/hostname
sudo sed -i "s/$CUR_HOSTNAME/$NEW_HOSTNAME/g" /etc/hosts
sudo sed -i "s/$CUR_HOSTNAME/$NEW_HOSTNAME/g" /etc/hostname
sudo sed -i "s/preserve_hostname: false/preserve_hostname: true/g" /etc/cloud/cloud.cfg
# Display new hostname
echo "New server hostname is $NEW_HOSTNAME"


sleep 5

CURRENT_DIR=$(pwd)
rm -f "$CURRENT_DIR/set-hostname.sh"

reboot