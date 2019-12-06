#!/bin/bash
## INSTALL NAGIOS CORE MONITORING SERVICES
apt-get update
apt-get install build-essential unzip openssl libssl-dev apache2 php libapache2-mod-php php-gd libgd-dev -y
wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.4.3.tar.gz -P /tmp
cd /tmp
tar xzf nagios-4.4.3.tar.gz
cd nagios-4.4.3/
./configure --with-httpd-conf=/etc/apache2/sites-enabled
make all
make install-groups-users
usermod -aG nagios www-data
make install
make install-daemoninit
make install-commandmode
make install-config
make install-webconf
a2enmod rewrite cgi
htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
chown www-data:www-data /usr/local/nagios/etc/htpasswd.users
chmod 640 /usr/local/nagios/etc/htpasswd.users
systemctl restart apache2
systemctl enable nagios.service
systemctl start nagios.service
systemctl status nagios.service

## INSTALL NAGIOS PLUGIN

apt-get install -y autoconf automake gcc libc6 libmcrypt-dev make libssl-dev wget bc gawk dc build-essential snmp libnet-snmp-perl gettext
apt-get install -y libpqxx3-dev
apt-get install -y libdbi-dev
apt-get install -y libfreeradius-client-dev
apt-get install -y libldap2-dev
apt-get install -y dnsutils
## apt-get install -y smbclient (install interractive)
apt-get install -y qstat
apt-get install -y fping
## apt-get install -y qmail-tools (error on debian 10)

cd /tmp
wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.2.1.tar.gz
tar zxf nagios-plugins.tar.gz
cd /tmp/nagios-plugins-release-2.2.1/
./tools/setup
./configure
make
make install
