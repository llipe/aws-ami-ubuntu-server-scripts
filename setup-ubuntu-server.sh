#!/bin/bash

# This script automates the installation and configuration of Nginx and PHP-FPM on an Ubuntu server.

# Update the system
sudo apt update
sudo apt upgrade -y

# Set the timezone to America/Santiago
sudo timedatectl set-timezone America/Santiago

# Install Nginx
sudo apt install nginx -y

# Start and enable Nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Install AWS CLI
#TODO: aws configure is requiered and you need to provide your AWS Access Key ID, AWS Secret Access Key, Default region name, and Default output format
sudo snap install aws-cli --classic

# Install PHP 8.3 and PHP-FPM along with required PHP modules for WordPress
sudo apt install php-fpm php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip -y

# Check /etc/php directory for the PHP version installed and store it in a variable
PHP_INSTALLED_VERSION=$(ls /etc/php)

# Configure PHP-FPM
sudo sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/$PHP_INSTALLED_VERSION/fpm/php.ini
sudo systemctl restart php$PHP_INSTALLED_VERSION-fpm.service

# Configure Nginx to use PHP-FPM
# sudo mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak
# sudo tee /etc/nginx/sites-available/default > /dev/null <<EOT
# server {
#     listen 80 default_server;
#     listen [::]:80 default_server;

#     root /var/www/html;
#     index index.php index.html index.htm;

#     server_name _;

#     location / {
#         try_files \$uri \$uri/ =404;
#     }

#     location ~ \.php$ {
#         include snippets/fastcgi-php.conf;
#         fastcgi_pass unix:/var/run/php/php-fpm.sock;
#         fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
#         include fastcgi_params;
#     }
# }
# EOT

# Restart Nginx
sudo systemctl restart nginx

# Install wp-cli for WordPress management
sudo curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
sudo chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp
wp --info

echo "Nginx, PHP-FPM, awscli and wp-cli installation completed"