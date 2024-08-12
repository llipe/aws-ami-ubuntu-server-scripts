# This script is used to set up an Ubuntu server on AWS EC2 instance.
# It checks if the $HOME environment variable is set, and if not, it sets it to /home/ubuntu.
# Then, it clones a GitHub repository containing scripts for setting up the server.
# Finally, it adds execution permissions to the setup-ubuntu-server.sh, add-new-domain.sh, and add-ssl-for-domain.sh scripts.

# Usage: ./aws-ec2-user-data-script.sh
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