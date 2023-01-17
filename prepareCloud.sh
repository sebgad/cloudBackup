#!/bin/bash

# Please run script as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

mkdir -p /root/bin

cp -R src/root/bin/* /root/bin

ln -s /root/bin/sendCloudBackupLog /usr/local/bin/sendCloudBackupLog
ln -s /root/bin/startBackupDrive /usr/local/bin/startBackupDrive
ln -s /root/bin/startMultipleBackups /usr/local/bin/startMultipleBackups
ln -s /root/bin/stopBackupDrive /usr/local/bin/stopBackupDrive
ln -s /root/bin/backupCloudSystem /usr/local/bin/backupCloudSystem
ln -s /root/bin/doCloudLogRotation /usr/local/bin/doCloudLogRotation

# touch logs
mkdir -p /var/log/cloudbackup
touch /var/log/cloudbackup/cloudbackup_main.daily.log
touch /var/log/cloudbackup/cloudbackup_main.log
touch /var/log/cloudbackup/cloudbackup_redund.daily.log
touch /var/log/cloudbackup/cloudbackup_redund.log

scripts/create_user.sh
scrits/install_u2f_key.sh
scripts/security_hardening.sh
scripts/ssh_alternative_port.sh

# SSHD config files
cp -R src/etc/ssh/sshd_config.d/* /etc/ssh/sshd_config.d/

# fail2ban installation and config files
apt-get install -y fail2ban
cp -R src/etc/fail2ban/filter.d/* /etc/fail2ban/filter.d/
cp -R src/etc/fail2ban/jail.d/* /etc/fail2ban/jail.d
cp src/etc/fail2ban/jail.local /etc/fail2ban/jail.local

# Use root password for sudo command
touch /etc/sudoers.d/10-rootpw
echo "Defaults rootpw" >> /etc/sudoers.d/10-rootpw


