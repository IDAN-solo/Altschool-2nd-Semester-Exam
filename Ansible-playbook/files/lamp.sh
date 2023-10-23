#!bin/bash

#command to prompt the script to throw an error if the script fails
set -e

#< /dev/null is used to make the commands non interactive(skip prompted questions and continue running the script)
sudo apt-get update && sudo apt-get upgrade -y < /dev/null

#install AMP stack

################################################################

#install apache2
sudo apt-get install apache2 -y < /dev/null

#install MySQL
sudo apt-get install mysql-server -y < /dev/null

#install PHP
sudo apt-add-repository -y ppa:ondrej/php < /dev/null
sudo apt-get update < /dev/null
sudo apt-get install libapache2-mod-php php php-xml php-mysql php-gd php-tokenizer php-mbstring php-json php-bcmath php-curl php-common php-zip unzip -y < /dev/null
sudo sed -i 's/cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php/8.2/apache2/php.ini
sudo systemctl restart apache2 < /dev/null

##################################################################

#Clone laravel from github repository and configure apache2

##################################################################

#install laravel's dependencies (git and composer)
sudo apt-get install git -y

#install composer
sudo apt-get install curl -y
curl -sS https://getcomposer.org/installer | php
#move the composer file to an executable path
sudo mv composer.phar /usr/local/bin/composer
composer --version < /dev/null

#configure apache2
cat << EOF > /etc/apache2/sites-available/laravel.conf
<VirtualHost *:80>
    ServerAdmin ireoluwaafowowe79@gmail.com
    ServerName 192.168.0.10
    DocumentRoot /var/www/html/laravel/public

    <Directory /var/www/html/laravel>
       Options Indexes MultiViews FollowSymlinks
       AllowOverride All
       Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

#activate the Apache rewrite module and Laravel virtual host configuration
sudo a2enmod rewrite
sudo a2ensite laravel.conf

#restart the Apache server to apply changes
sudo systemctl restart apache2

################################################################################

#Clone laravel and it's dependencies

################################################################################

mkdir /var/www/html/laravel && cd /var/www/html/laravel
cd /var/www/html && sudo git clone https://github.com/laravel/laravel.git
cd /var/www/html/laravel && composer install --no-dev < /dev/null
echo "Laravel successfully installed from https://github.com/laravel/laravel.git"
#change the owner of the laravel file path to the web server
sudo chown -R www-data:www-data /var/www/html/laravel
#change file permissions for all files in /var/www/html/laravel
sudo chmod -R 775 /var/www/html/laravel
sudo chmod -R 775 /var/www/html/laravel/storage
sudo chmod -R 775 /var/www/html/laravel/bootstrap/cache
echo "Setting file permissions"
ls -la
#generate an encrption key
cd /var/www/html/laravel && sudo cp .env.example .env
php artisan key:generate

#################################################################################

######################################################################

#Configure MySQL: create user and password

######################################################################

#set password, generate random password if no password is provided
echo "Creating MySQL user and database"
PASSWD=$2
if [ -z "$2" ]; then
echo "No password has been provided"
fi

mysql -u root <<MYSQL_SCRIPT
CREATE DATABASE $1;
CREATE USER '$1'@'localhost' IDENTIFIED BY '$PASSWD';
GRANT ALL PRIVILEGES ON $1.* TO '$1'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

echo "MySQL user and database created."
echo "Username: $1"
echo "Database: $1"
echo "Password: $PASSWD"

###########################################################################

###########################################################################

#update the env file
#using the stream editor to search and replace DB_USER and DB_PASSWORD
sudo sed -i 's/DB_DATABASE=laravel/DB_DATABASE=Ire/' /var/www/html/laravel/.env
sudo sed -i 's/DB_USERNAME=root/DB_USERNAME=Ire/' /var/www/html/laravel/.env
sudo sed -i 's/DB_PASSWORD=/DB_PASSWORD=Irexy1/' /var/www/html/laravel/.env

#Php config and migrate
php artisan config:cache
cd /var/www/html/laravel && php artisan migrate

###########################################################################


