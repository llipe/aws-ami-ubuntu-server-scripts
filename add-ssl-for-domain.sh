
# This script adds SSL certificate for a domain using Certbot and Nginx.

# Parameters:
# $1 - The domain name for which SSL certificate needs to be obtained.
# $2 - (Optional) The email address to be used for certificate registration. If not provided, "admin@domain" will be used.

# If email is not provided, it will default to "admin@domain".
# If Certbot is not installed, it will be installed along with the required dependencies.
# The script then uses Certbot to obtain SSL certificate for the specified domain and its www subdomain.

# Usage: add-ssl-for-domain.sh <domain> [email]

# Example:
# add-ssl-for-domain.sh example.com admin@example.com
#!/bin/bash

# Check if email is provided if not use admin@domain
if [ -z "$2" ]; then
  EMAIL="admin@$DOMAIN"
else
  EMAIL=$2
fi

# Obtain SSL certificate
# check if certbot is installed
if ! command -v certbot &> /dev/null
then
    echo "Certbot is not installed. Installing Certbot..."
    sudo apt update
    sudo apt install certbot python3-certbot-nginx -y
fi
sudo certbot --nginx -d $DOMAIN -d www.$DOMAIN --non-interactive --agree-tos -m $EMAIL