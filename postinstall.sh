#!/bin/bash




#
IPADDR=$(cat /tmp/ipaddr_infra.txt | grep $(hostname) | cut -d';' -f2)
NETMASK=$(cat /tmp/ipaddr_infra.txt | grep $(hostname) | cut -d';' -f3)
GATEWAY=$(cat /tmp/ipaddr_infra.txt | grep $(hostname) | cut -d';' -f4)

sed -i 's/iface enp1s0 inet dhcp/iface enp1s0 inet static/g' /etc/network/interfaces
sed -i '/iface enp1s0 inet static/a address $IPADDR\nnetmask $NETMASK\gateway $GATEWAY' /etc/network/interfaces
systemctl restart networking
