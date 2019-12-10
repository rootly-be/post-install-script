#!/bin/bash
#
# CLIENT - INSTALL POSTFIX AND MAILUTILS TO SEND MAIL CONFIG THROUGH s-rootly-smtppro
#
function usage (){
        printf "\n"
        printf "Script Usage :\n"
        printf "\t$1 -> SMTP-SERVER\n"
        printf "\n"
        printf "\tExample               : $0 s-rootly-smtppro1a"
        printf "\n"
        exit 1
}

if [ $# -eq 0 ];then usage;fi

## install prerequisite
apt-get update && apt-get upgrade -y
apt-get install mailutils postfix -y

### configure postfix for OVH
sed -i 's/relayhost =/relayhost = $1/g' /etc/postfix/main.cf

### restart postfix service 
systemctl enable postfix
systemctl start postfix
