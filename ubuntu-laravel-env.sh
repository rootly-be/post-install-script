# curl https://raw.githubusercontent.com/rootly-be/post-install-script/master/ubuntu-laravel-env.sh -o ubuntu-laravel-env.sh
# chmod +x ubuntu-laravel-env.sh
# sudo ./ubuntu-laravel-env.sh
#
#
#!/bin/bash
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt update
sudo apt install code

sudo apt -y install software-properties-common
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update
sudo apt -y install php8.0 libapache2-mod-php8.0 php-curl php-gd php-xml php-zip php-mbstring php-mysql curl dirmngr apt-transport-https lsb-release ca-certificates

curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt -y install git nodejs unzip docker.io dbus-user-session
sudo usermod -aG docker $USER
newgrp docker

curl -sS https://getcomposer.org/installer -o composer-setup.php
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
rm composer-setup.php

sudo apt install mysql-server -y
sudo mysql_secure_installation

echo "sudo mysql -u root"
echo "CREATE DATABASE jobdrone;"
echo "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Azerty12345';"
echo "FLUSH PRIVILEGES;"
echo "exit"
echo " !!! ADAPT THE .env FILE !!! "
