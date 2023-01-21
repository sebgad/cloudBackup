!#/bin/bash

# Please run script as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Add yubico PPA
# https://support.yubico.com/hc/en-us/articles/360016649039-Enabling-the-Yubico-PPA-on-Ubuntu
add-apt-repository ppa:yubico/stable -y && apt-get update

# Install udev tool and rules for yubikey / libpam for user authentification
apt install -y libu2f-udev libpam-u2f
curl -o /etc/udev/rules.d/70-u2f.rules https://raw.githubusercontent.com/Yubico/libfido2/main/udev/70-u2f.rules

# Reload udev rules
udevadm control --reload-rules && udevadm trigger

echo "write first public key file, please press key button"
mkdir -p /etc/Yubico
touch /etc/Yubico/u2f_keys

read -p "Please input usernames (space sep) who should use key for login." USERNAMES

for username in $USERNAMES;
do
	pamu2fcfg -P --username=$username >> /etc/Yubico/u2f_keys # switch "-P" is optional. You do not need to press the key when logging if this switch is set.
	
done

echo "Optional step: append additional (hardware keys)"
echo "use command pamu2fcfg -P --username=USER >> /etc/Yubico/u2f_keys"

# Make backup in case something went wrong
mkdir /root/pam_backup

# add yubikey authentification for command sudo
cp /etc/pam.d/sudo /root/pam_backup
echo "add yubikey authentification for command sudo. Please check /etc/pam.d/sudo afterwards."
perl -i -0pe 's/@include common-auth\n/auth    sufficient      pam_u2f.so      authfile=\/etc\/Yubico\/u2f_keys userpresence=0\n/@include common-auth\n/' /etc/pam.d/sudo

# add yubikey authentification for command sudo-i
cp /etc/pam.d/sudo-i /root/pam_backup
echo "add yubikey authentification for command sudo. Please check /etc/pam.d/sudo afterwards."
perl -i -0pe 's/@include common-auth\n/auth    sufficient      pam_u2f.so      authfile=\/etc\/Yubico\/u2f_keys userpresence=0\n/@include common-auth\n/' /etc/pam.d/sudo-i

# add yubikey authentification for command su
cp /etc/pam.d/su /root/pam_backup
echo "add yubikey authentification for command su. Please check /etc/pam.d/su afterwards."
perl -i -0pe 's/auth       sufficient pam_rootok.so\n/auth       sufficient pam_rootok.so\nauth    sufficient      pam_u2f.so      authfile=\/etc\/Yubico\/u2f_keys userpresence=0\n/' /etc/pam.d/su

# add yubikey authentification for login over TTY
cp /etc/pam.d/login /root/pam_backup
echo "add yubikey authentification for command su. Please check /etc/pam.d/login afterwards."
perl -i -0pe 's/@include common-auth\n/auth    sufficient      pam_u2f.so      authfile=\/etc\/Yubico\/u2f_keys_root userpresence=0\n@include common-auth\n/' /etc/pam.d/login


echo "backups for /etc/pam.d/sudo /etc/pam.d/su /etc/pam.d/login were copied to /root/pam_backup, in case something went wrong."

# print Out a random passwort of the length 64
echo "Please use a strong root password. For example this one:"
< /dev/urandom tr -cd "[:print:]" | head -c 64; echo

echo "please check login. Changes should already be effective."

