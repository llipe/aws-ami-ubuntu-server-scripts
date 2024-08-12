#!/bin/bash

# This script is used to add a new domain to an Ubuntu server running Nginx and PHP-FPM.
# It creates directories for the domain, sets permissions, configures Nginx, enables the site, and restarts Nginx.

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
sudo tee /etc/nginx/sites-available/$DOMAIN > /dev/null <<EOT
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
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.3-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }
}

server {
    listen 443 ssl;
    listen [::]:443 ssl;

    root /home/ubuntu/$DOMAIN/public;
    index index.php index.html index.htm;

    server_name $DOMAIN www.$DOMAIN;

    access_log /home/ubuntu/$DOMAIN/log/access.log;
    error_log /home/ubuntu/$DOMAIN/log/error.log;

    ssl_certificate /etc/letsencrypt/live/$DOMAIN/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$DOMAIN/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.3-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }
}
EOT

# Enable the new site for the domain
sudo ln -s /etc/nginx/sites-available/$DOMAIN /etc/nginx/sites-enabled/

# Restart Nginx
sudo systemctl restart nginx

# Obtain SSL certificate
# check if certbot is installed
if ! command -v certbot &> /dev/null
then
    echo "Certbot is not installed. Installing Certbot..."
    sudo apt update
    sudo apt install certbot python3-certbot-nginx -y
fi
sudo certbot --nginx -d $DOMAIN -d www.$DOMAIN --non-interactive --agree-tos -m your-email@example.com

# Configure log rotation
# Check if logrotate is installed
if ! command -v logrotate &> /dev/null
then
    echo "Logrotate is not installed. Installing Logrotate..."
    sudo apt update
    sudo apt install logrotate -y
fi
sudo tee /etc/logrotate.d/$DOMAIN > /dev/null <<EOT
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

# Reload Nginx to apply the new configuration
sudo systemctl reload nginx
echo "Nginx and PHP-FPM installation with HTTPS and log rotation completed for $DOMAIN!"