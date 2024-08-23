#!/bin/bash

# Check if domain name is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <domain>"
    exit 1
fi

DOMAIN=$1

# Check /etc/php directory for the PHP version installed and store it in a variable
PHP_INSTALLED_VERSION=$(ls /etc/php)

# Create directories for the domain
sudo mkdir -p /home/ubuntu/$DOMAIN/public
sudo mkdir -p /home/ubuntu/$DOMAIN/log

# Set permissions
sudo chown -R www-data:www-data /home/ubuntu/$DOMAIN/public
sudo chown -R www-data:www-data /home/ubuntu/$DOMAIN/log

# Configure Nginx for the domain
sudo tee /etc/nginx/sites-available/$DOMAIN >/dev/null <<EOT
server {
    listen 80;
    listen [::]:80;

    root /home/ubuntu/$DOMAIN/public;
    index index.php index.html index.htm;

    server_name $DOMAIN www.$DOMAIN;

    access_log /home/ubuntu/$DOMAIN/log/access.log;
    error_log /home/ubuntu/$DOMAIN/log/error.log;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/var/run/php/php$PHP_INSTALLED_VERSION-fpm.sock;
        include fastcgi.conf;
    }
}
EOT

# Enable the new site for the domain
sudo ln -s /etc/nginx/sites-available/$DOMAIN /etc/nginx/sites-enabled/

# Configure log rotation
# Check if logrotate is installed
if ! command -v logrotate &>/dev/null; then
    echo "Logrotate is not installed. Installing Logrotate..."
    sudo apt update
    sudo apt install logrotate -y
fi
sudo tee /etc/logrotate.d/$DOMAIN >/dev/null <<EOT
/home/ubuntu/$DOMAIN/log/*.log {
    daily
    missingok
    rotate 14
    compress
    delaycompress
    notifempty
    create 0640 www-data www-data
    sharedscripts
    postrotate
        systemctl reload nginx > /dev/null
    endscript
}
EOT

# Restart Nginx
sudo systemctl restart nginx.service

echo "Nginx and PHP-FPM installation with HTTP and log rotation completed for $DOMAIN!"
