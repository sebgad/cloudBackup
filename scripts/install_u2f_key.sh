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

read -p "Please input username who suppose to use yubikey for authentification?" USERNAME
# as user, please insert yubikey
mkdir -p $USERNAME/.config/Yubico

# write first key to key file, please press key button
pamu2fcfg -P > $USERNAME/.config/Yubico/u2f_keys # switch "-P" is optional. You do not need to press the key when logging if this switch is set.

# Optional: append keys with 
# pamu2fcfg -P >> ~/.config/Yubico/u2f_keys 

# Make key system wide available
sudo mkdir -p /root/.config/Yubico
sudo cp $USERNAME/.config/Yubico/u2f_keys /root/.config/Yubico/

# Change to root
cp /root/.config/Yubico/u2f_keys /root/.config/Yubico/u2f_keys_root

# replace user with root in file
sed -i 's/.*:/root:/g' /root/.config/Yubico/u2f_keys_root

# Check output file
echo "check output file. Should have the format root:Key"
cat /root/.config/Yubico/u2f_keys_root

# add yubikey authentification for command sudo
echo "add yubikey authentification for command sudo. Please check /etc/pam.d/sudo afterwards."
perl -i -0pe 's/@include common-auth\n/auth    sufficient      pam_u2f.so      authfile=\/root\/.config\/Yubico\/u2f_keys userpresence=0\n/@include common-auth\n/' /etc/pam.d/sudo 

# add yubikey authentification for command su
echo "add yubikey authentification for command su. Please check /etc/pam.d/su afterwards."
perl -i -0pe 's/auth       sufficient pam_rootok.so\n/auth       sufficient pam_rootok.so\nauth    sufficient      pam_u2f.so      authfile=\/root\/.config\/Yubico\/u2f_keys_root userpresence=0\n/' /etc/pam.d/su

# add yubikey authentification for login over TTY
echo "add yubikey authentification for command su. Please check /etc/pam.d/login afterwards."
perl -i -0pe 's/@include common-auth\n/auth    sufficient      pam_u2f.so      authfile=\/root\/.config\/Yubico\/u2f_keys userpresence=0\n@include common-auth\n/' /etc/pam.d/login

# print Out a random passwort of the length 64
echo "Please use a strong root password. For example this one:"
< /dev/urandom tr -cd "[:print:]" | head -c 64; echo


echo "please reboot"

