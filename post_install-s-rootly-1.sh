## POST-INSTALL DEBIAN SERVER
## ROOTLY
## gregorymichel gregorymichel@rootly.be or info@rootly.be
##
## NEED 4 PARAMETERS    $1 -> HOSTNAME (s-rootly-1)
##                      $2 -> NETWORK DEVICE NAME (enp4s0)
##                      $3 -> VLAN ID (4000)
##                      $4 -> VLAN IP ADDRESS (192.168.1.10)
##
## example ./post_install-s-rootly-1.sh s-rootly-1 enp4s0 4000 192.168.1.10
##

#!/bin/bash

function usage (){
        printf "\n"
        printf "Script Usage :\n"
        printf "\t$1 -> HOSTNAME (s-rootly-1)\n"
        printf "\t$2 -> NETWORK DEVICE NAME (enp4s0)\n"
        printf "\t$3 -> VLAN ID (4000)\n"
        printf "\t$4 -> VLAN IP ADDRESS (192.168.1.10)\n"
        printf "\n"
        printf "\tExample               : $0 s-rootly-1 enp4s0 4000 192.168.1.10"
        printf "\n"
        exit 1
}

if [ $# -eq 0 ];then usage;fi

#### HOSTNAME CONFIGURATION
NEW_HOSTNAME=$1 && CURRENT_HOSTNAME=$(hostname) && sed -i "s/$CURRENT_HOSTNAME/$NEW_HOSTNAME/g" /etc/hosts && hostnamectl set-hostname $NEW_HOSTNAME
#### HOSTNAME CONFIGURATION

#### UPGRADE SERVER
apt-get update && apt-get upgrade -y
#### UPGRADE SERVER

#### CONFIGURE TIME/ZONE
ln -fs /usr/share/zoneinfo/Europe/Brussels /etc/localtime
apt-get install tzdata -y
dpkg-reconfigure --frontend noninteractive tzdata
#### CONFIGURE TIME/ZONE

#### USERS CREATION
## CREATE USER gregorymichel AND SET A TEMP PASSWORD
useradd -u 1000 -m -d /home/gregorymichel -s /bin/bash gregorymichel
echo -e "Azerty12345\nAzerty12345" | passwd gregorymichel
passwd -e gregorymichel
#### USERS CREATION

#### SSH CONFIGURATION
## CHANGE SSH PORT TO 38751 AND DENIED SSH CONNECTION FROM ROOT USER
sed -i 's/#Port 22/Port 38752/g' /etc/ssh/sshd_config
sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
sed -i 's/#ClientAliveInterval 0/ClientAliveInterval 120/g' /etc/ssh/sshd_config
sed -i 's/#ClientAliveCountMax 3/ClientAliveCountMax 30/g' /etc/ssh/sshd_config
## ACTIVATE X11
apt-get install xauth -y
sed -i '/^#.*X11UseLocalhost*/s/^#//' /etc/ssh/sshd_config
sed -i 's/^X11UseLocalhost yes/X11UseLocalhost no/g' /etc/ssh/sshd_config
systemctl restart sshd
## CREATE RSA KEY
ssh-keygen -t rsa -f ~/.ssh/id_rsa -N ""
#### SSH CONFIGURATION

#### INSTALL VARIA TOOLS
apt-get install sudo wget fail2ban nginx -y
#### INSTALL VARIA TOOLS

#### ENABLE AND START INSTALLED SERVICES
systemctl enable fail2ban
systemctl start fail2ban
#### ENABLE AND START INSTALLED SERVICES

#### INSTALL AND CONFIGURE KVM/LIBVIRT
## INSTALL KVM - LIBVIRT - VIRT_MANAGER
apt-get -y install qemu-kvm libvirt-daemon  bridge-utils virtinst libvirt-daemon-system
apt-get -y install virt-top libguestfs-tools libosinfo-bin  qemu-system virt-manager
usermod -a -G libvirt gregorymichel
usermod -a -G libvirt-qemu gregorymichel
#### INSTALL AND CONFIGURE KVM/LIBVIRT

#### CONFIGURE rootly_VLAN1 vswitch
echo "" >> /etc/network/interfaces
echo "auto $2.$3" >> /etc/network/interfaces
echo "iface $2.$3 inet static" >> /etc/network/interfaces
echo "  address $4" >> /etc/network/interfaces
echo "  netmask 255.255.255.0" >> /etc/network/interfaces
echo "  vlan-raw-device $2" >> /etc/network/interfaces
echo "  mtu 1400" >> /etc/network/interfaces
systemctl restart networking.service
#### CONFIGURE rootly_VLAN1 vswitch
