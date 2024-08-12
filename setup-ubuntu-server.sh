#!/bin/bash

# This script automates the installation and configuration of Nginx and PHP-FPM on an Ubuntu server.

# Update the system
# - Updates the package lists for upgrades and installs any available updates.
# - Uses the 'apt' command with the 'update' and 'upgrade' options.
sudo apt update
sudo apt upgrade -y

# Set the timezone to America/Santiago
# - Sets the system timezone to 'America/Santiago'.
# - Uses the 'timedatectl' command with the 'set-timezone' option.
sudo timedatectl set-timezone America/Santiago

# Install Nginx
# - Installs the Nginx web server.
# - Uses the 'apt' command with the 'install' option and 'nginx' package name.
sudo apt install nginx -y

# Start and enable Nginx
# - Starts and enables the Nginx service.
# - Uses the 'systemctl' command with the 'start' and 'enable' options and 'nginx' service name.
sudo systemctl start nginx
sudo systemctl enable nginx

# Install AWS CLI
# - Installs the AWS Command Line Interface (CLI).
# - Uses the 'snap' command with the 'install' option and 'aws-cli' package name.
# - Requires further configuration using the 'aws configure' command.
sudo snap install aws-cli --classic

# Install PHP 8.3 and PHP-FPM along with required PHP modules for WordPress
# - Installs PHP 8.3 and PHP-FPM along with the necessary PHP modules for WordPress.
# - Uses the 'apt' command with the 'install' option and multiple package names.
sudo apt install php-fpm php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip -y

# Check /etc/php directory for the PHP version installed and store it in a variable
# - Lists the contents of the '/etc/php' directory and stores the result in the 'PHP_INSTALLED_VERSION' variable.
PHP_INSTALLED_VERSION=$(ls /etc/php)

# Configure PHP-FPM
# - Modifies the 'php.ini' file to set the 'cgi.fix_pathinfo' directive to '0'.
# - Restarts the PHP-FPM service.
sudo sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/$PHP_INSTALLED_VERSION/fpm/php.ini
sudo systemctl restart php$PHP_INSTALLED_VERSION-fpm.service

# Configure Nginx to use PHP-FPM
# - Moves the default Nginx configuration file to a backup location.
# - Creates a new Nginx configuration file with PHP-FPM settings.
# - Restarts the Nginx service.
# Note: The code for configuring Nginx is commented out. Uncomment it to enable the configuration.
# sudo mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak
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
# sudo systemctl restart nginx

# Restart Nginx
# - Restarts the Nginx service.
sudo systemctl restart nginx

# Install wp-cli for WordPress management
# - Downloads the wp-cli.phar file from the official GitHub repository.
# - Sets the execute permission for the wp-cli.phar file.
# - Moves the wp-cli.phar file to the '/usr/local/bin/wp' location.
# - Displays information about the installed wp-cli version.
sudo curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
sudo chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp
wp --info

# Completion message
echo "Nginx, PHP-FPM, awscli and wp-cli installation completed"
