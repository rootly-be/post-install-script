#!/bin/bash
## INSTALL PLUGIN FIRST
apt install -y autoconf automake gcc libc6 libmcrypt-dev make libssl-dev wget bc gawk dc build-essential snmp libnet-snmp-perl gettext
mkdir /opt/nagios && cd /opt/nagios
cd /tmp
wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.2.1.tar.gz
tar zxf nagios-plugins.tar.gz
cd /tmp/nagios-plugins-release-2.2.1/
./tools/setup
./configure
make
make install

## INSTALL CLIENT NRPE

cd /opt/nagios/
wget --no-check-certificate -O nrpe.tar.gz https://github.com/NagiosEnterprises/nrpe/archive/nrpe-3.2.0.tar.gz
tar xzf nrpe.tar.gz && cd nrpe-nrpe-3.2.0
./configure --enable-command-args
make all
make install-groups-users
make install && make install-config

echo >> /etc/services
echo '# Nagios services' >> /etc/services
echo 'nrpe    5666/tcp' >> /etc/services
make install-init && systemctl enable nrpe.service
sed -i 's/allowed_hosts=127.0.0.1,::1/allowed_hosts=192.168.100.17/g' /usr/local/nagios/etc/nrpe.cfg
sed -i 's/dont_blame_nrpe=0/dont_blame_nrpe=1/g' /usr/local/nagios/etc/nrpe.cfg
systemctl start nrpe.service
systemctl enable nrpe.service
