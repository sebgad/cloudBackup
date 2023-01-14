#!/bin/bash

# Please run script as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Additional user for remote access only and dedicated backupdrive
read -p "Please input username: " USERNAME
read -sp "Please input password: " PASSWORD
echo

# Create user
adduser --gecos "" --disabled-password $USERNAME
chpasswd <<<"$USERNAME:$PASSWORD"

echo "Create group 'sshuser' to restrict ssh access to dedicated user"
groupadd sshuser

echo "add user $USERNAME to group sshuser"
usermod -a -G $USERNAME

read -p "Please input additional users to add in the group sshuser: (space seperation for more then one user)" ADDUSERS
for add_user in $ADDUSERS;
do
	echo 'Add user $add_user to sshuser'
	usermod -a -G $ADD_USER
done

# Create Backupfolder for dedicated user
echo -p "Please input location of backup folder: " BACKUP_FOLDER

# Create backupfolder
mkdir -p $BACKUP_FOLDER
chown $USERNAME -R $BACKUP_FOLDER

# mount drive permanently to backup folder of dedicated user
echo
blkid -o list
echo 
read -p "Please input UUID to add /etc/fstab entry" UUID_HDD

# Add entry in fstab
echo "UUID=$UUID_HDD	$BACKUP_FOLDER	ext4	defaults,noauto,users	0	1" >> /etc/fstab
systemctl daemon-reload

# Create ssh authorized key file, if not exist
touch /home/$USERNAME/.ssh/authorized_key

read -p "Please input your public key for ssh authentification" PUBLIC_KEY

# Add public key to file
echo $PUBLIC_KEY >> /home/$USERNAME/.ssh/authorized_keys

# Please activate port forwarding of port 22/tcp in your fritzbox
# 	Menu: Internet -> Freigaben -> Portfreigaben
#	Only Ipv4 port 22/tcp is necessary, because noip only support name resolution to ipv4 address.
echo 'Please activate port forwarding for SSH in your fritzbox (see comments in this file)'
