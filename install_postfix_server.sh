#!/bin/bash
#
# SERVER INSTALL POSTFIX FOR SMTP RELAY SERVER WITH OVH

function usage (){
        printf "\n"
        printf "Script Usage :\n"
        printf "\t$1 -> EXTERNAL SMTP SERVER (smtp.serviceprovider.net)\n"
        printf "\t$2 -> PORT NUMBER FOR SMTP SERVER (587)\n"
        printf "\t$3 -> SMTP USERNAME (user@domain.net)\n"
        printf "\t$4 -> SMTP PASSWORD (MyPassw0rd)\n"
        printf "\n"
        printf "\tExample               : $0 smtp.serviceprovider.net 587 user@domain.net MyPassw0rd"
        printf "\n"
        exit 1
}

if [ $# -eq 0 ];then usage;fi

## install prerequisites

apt-get update && apt-get upgrade -y
apt-get install mailutils postfix -y

### create pwd file and pwd db
echo "[$1]":$2 $3:$4 > /etc/postfix/sasl/sasl_password
postmap /etc/postfix/sasl/sasl_password
chmod 400 /etc/postfix/sasl/sasl_password

### modify /etc/postfix/main.cf
sed -i 's/^mydestination*=*/#mydestination/g' /etc/postfix/main.cf
sed -i '/^#mydestination/a mydestination = ' /etc/postfix/main.cf

### modify networks parameters to enable smtp relay for rootly_int
sed -i 's/^mynetworks*=*/#mynetworks/g' /etc/postfix/main.cf
sed -i '/^#mynetworks/a mynetworks = 192.168.100.0/24' /etc/postfix/main.cf

### configure postfix for OVH
sed -i 's/relayhost =/relayhost = [$1]:$2/g' /etc/postfix/main.cf

echo "smtp_sasl_auth_enable = yes" >> /etc/postfix/main.cf
echo "smtp_sasl_password_maps = hash:/etc/postfix/sasl/sasl_password" >> /etc/postfix/main.cf
echo "smtp_sasl_security_options = noanonymous" >> /etc/postfix/main.cf

### restart postfix service 
systemctl enable postfix
systemctl start postfix
