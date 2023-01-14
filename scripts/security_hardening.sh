#!/bin/bash

# Please run script as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Install lynis security audit program
apt-get install -y lynis

# libpam-tmpdir                                         [ Not Installed ]
apt-get install -y libpam-tmpdir

# apt-listbugs                                            [ Not Installed ]
# No equivalent software package for ubuntu available

# fail2ban                                                [ Installed with jail.conf ]
# Create "local" copy to prevent overwrite on update
cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.local

# Set a password on GRUB boot loader to prevent altering boot configuration (e.g. boot in single user mode without password) [BOOT-5122] 
# SSH login preferred. 

# If not required, consider explicit disabling of core dump in /etc/security/limits.conf file [KRNL-5820] 
mkdir /etc/systemd/coredump.conf.d/
touch /etc/systemd/coredump.conf.d/custom.conf
echo -e '[Coredump]\n\nStorage=none\nProcessSizeMax=0' >> /etc/systemd/coredump.conf.d/custom.conf
systemctl daemon-reload
systemctl daemon-reexec

# Please add it for all users
echo 'ulimit -S -c 0' >> ~/.bash_profile

# Check PAM configuration, add rounds if applicable and expire passwords to encrypt with new values [AUTH-9229] 
# no password change rounds

# Configure password hashing rounds in /etc/login.defs [AUTH-9230] 

# Install a PAM module for password strength testing like pam_cracklib or pam_passwdqc [AUTH-9262] 
apt-get install -y libpam-pwquality

perl -i -0pe 's/# here are the per-package modules (the "Primary" block)\n/password	requisite			pam_pwquality.so retry=3 minlen=9 reject_username enforce_for_root\n/' /etc/pam.d/common-password

# When possible set expire dates for all password protected accounts [AUTH-9282]
# Manual setting for password change should be done. No regular password change rounds are planned.

# Look at the locked accounts and consider removing them [AUTH-9284] 
# No action

# Configure minimum password age in /etc/login.defs [AUTH-9286] 
# No action

# Default umask in /etc/login.defs could be more strict like 027 [AUTH-9328] 
sed -i 's/UMASK\t\t022/UMASK\t\t027/g' /etc/login.defs

# To decrease the impact of a full /home file system, place /home on a separate partition [FILE-6310]
# Home directory has no important files.

# To decrease the impact of a full /tmp file system, place /tmp on a separate partition [FILE-6310]
# partition change might be considered. needs to be performed separately.

# Disable drivers like USB storage when not used, to prevent unauthorized storage or data theft [USB-1000]
# Is used.

# Check DNS configuration for the dns domain name [NAME-4028]
# Needs to be checked individualy.

# Install debsums utility for the verification of packages with known good database. [PKGS-7370]
apt install -y debsums

# Install package apt-show-versions for patch management purposes
apt install -y apt-show-versions

# Determine if protocol 'dccp' is really needed on this system [NETW-3200]
# Determine if protocol 'sctp' is really needed on this system [NETW-3200]
# Determine if protocol 'rds' is really needed on this system [NETW-3200]
# Determine if protocol 'tipc' is really needed on this system [NETW-3200]
touch /etc/modprobe.d/blacklist.conf
echo 'blacklist dccp' >> /etc/modprobe.d/blacklist.conf
echo 'blacklist sctp' >> /etc/modprobe.d/blacklist.conf
echo 'blacklist rds' >> /etc/modprobe.d/blacklist.conf
echo 'blacklist tipc' >> /etc/modprobe.d/blacklist.conf
echo 'install dccp /bin/false' >> /etc/modprobe.d/blacklist.conf
echo 'install sctp /bin/false' >> /etc/modprobe.d/blacklist.conf
echo 'install rds /bin/false' >> /etc/modprobe.d/blacklist.conf
echo 'install tipc /bin/false' >> /etc/modprobe.d/blacklist.conf
update-initramfs -u

# You are advised to hide the mail_name (option: smtpd_banner) from your postfix configuration. Use postconf -e or change your main.cf file (/etc/postfix/main.cf) [MAIL-8818]
sed -i 's/smtpd_banner =.*/smtpd_banner = \$myhostname ESMTP/g' /etc/postfix/main.cf
systemctl restart postfix

# Check iptables rules to see which rules are currently not used [FIRE-4513] 
# please check with ufw status

# Disable weak protocol in nginx configuration [HTTP-6710]
# Already done.

# Change the HTTPS and SSL settings for enhanced protection of sensitive data and privacy [HTTP-6710]
# Already done.

# Check your nginx access log for proper functioning [HTTP-6712] 
# Already done. exceptions are ok from my opinion.

# Consider hardening SSH configuration [SSH-7408]
# I let it activated for now. Applications can use SSH connection for communication.

# Consider hardening SSH configuration [SSH-7408]
# 	AllowAgentForwarding (set YES to NO) --> Ignored

# Use the 'rename-command CONFIG' setting for Redis [DBS-1886]
# depricated. Instead Access lists should be used. Needs to be further analyzed.

# Enable logging to an external logging host for archiving purposes and additional protection [LOGG-2154]
# saving log data with restic should be a solution.

# Add a legal banner to /etc/issue, to warn unauthorized users [BANN-7126] 
echo -e 'BANANA SERVER INC. Unauthorized access will be tracked and punished. \n \l' > /etc/issue
echo 'BANANA SERVER INC. Unauthorized access will be tracked and punished.' > /etc/issue.net

# Enable process accounting [ACCT-9622]
# Not yet installed.

# Enable sysstat to collect accounting (no results) [ACCT-9626]
# Not yet installed.

# Enable auditd to collect audit information [ACCT-9628]
# Not yet installed.

# Install a file integrity tool to monitor changes to critical and sensitive files [FINT-4350] 
# Maybe we can check AIDE and install it.

# Determine if automation tools are present for system management [TOOL-5002]
# Not necessary from my point of view.

# Consider restricting file permissions [FILE-7524]
# Needs to be checked individually.

# One or more sysctl values differ from the scan profile and could be tweaked [KRNL-6000]
# Needs to be checked.

# Harden compilers like restricting access to root user only [HRDN-7222]
# Maybe removing compilers might be an options.

echo 'Recommend reboot after this changes.'

