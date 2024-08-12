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
sudo apt install awscli -y

# Install wp-cli for WordPress management
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp
wp --info


# Install PHP 8.3 and PHP-FPM along with required PHP modules for WordPress
sudo apt install php8.3-fpm php8.3-mysql php8.3-curl php8.3-gd php8.3-mbstring php8.3-xml php8.3-xmlrpc php8.3-soap php8.3-intl php8.3-zip -y

# Configure PHP-FPM
sudo sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php/7.4/fpm/php.ini
sudo systemctl restart php7.4-fpm

# Configure Nginx to use PHP-FPM
sudo mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak
sudo tee /etc/nginx/sites-available/default > /dev/null <<EOT
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.php index.html index.htm;

    server_name _;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }
}
EOT

# Restart Nginx
sudo systemctl restart nginx

echo "Nginx, PHP-FPM, awscli and wp-cli installation completed"