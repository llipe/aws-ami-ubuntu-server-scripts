#!/bin/bash

# check if $HOME is set, if not use /home/ubuntu
if [ -z "$HOME" ]; then
    export HOME=/home/ubuntu
fi
cd $HOME
git clone https://github.com/llipe/aws-ami-ubuntu-server-scripts.git

# Adds execution permissions to the scripts
sudo chmod +x aws-ami-ubuntu-server-scripts/setup-ubuntu-server.sh
sudo chmod +x aws-ami-ubuntu-server-scripts/add-new-domain.sh
sudo chmod +x aws-ami-ubuntu-server-scripts/add-ssl-for-domain.sh

# Server setup
./aws-ami-ubuntu-server-scripts/setup-ubuntu-server.sh

# TODO: Disable default nginx site
sudo rm /etc/nginx/sites-enabled/default
sudo systemctl reload nginx.service