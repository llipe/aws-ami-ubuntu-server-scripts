# aws-ami-ubuntu-server-scripts
Ubuntu Server scripts for setting up a WordPress environment with nginx, PHP, and other necessary configurations.

## How to use
The `aws-ec2-user-data-script.sh` script is used to automate the initial configuration of an EC2 instance on AWS. By launching an instance with this script as the user data, your environment will be automatically set up according to your requirements without manual intervention.

To use the `aws-ec2-user-data-script.sh` script ([link here](aws-ec2-user-data-script.sh)), follow these steps:

1. Launch an EC2 instance on AWS.
2. Provide the `aws-ec2-user-data-script.sh` script as the user data when launching the instance.
3. The script will be executed automatically when the instance starts up.
4. The script will set up your environment, including installing software packages, configuring services, and performing other necessary setup tasks.

For more information on launching EC2 instances and using user data scripts, refer to the [AWS documentation](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html).

```bash
#Reference script

if [ -z "$HOME" ]; then
    export HOME=/home/ubuntu
fi
cd $HOME
git clone https://github.com/llipe/aws-ami-ubuntu-server-scripts.git

# Adds execution permissions to the scripts
sudo chmod +x aws-ami-ubuntu-server-scripts/setup-ubuntu-server.sh
sudo chmod +x aws-ami-ubuntu-server-scripts/add-new-domain.sh
sudo chmod +x aws-ami-ubuntu-server-scripts/add-ssl-for-domain.sh
```

## Available scripts
Here are the available scripts:

- `setup-ubuntu-server.sh`: Sets up an Ubuntu server with nginx, PHP, and other configurations required for WordPress.
- `add-new-domain.sh`: Adds a new domain to your server configuration.
- `add-ssl-for-domain.sh`: Adds an SSL (Secure Sockets Layer) certificate for a domain.

You can find these scripts in the [aws-ami-ubuntu-server-scripts](https://github.com/llipe/aws-ami-ubuntu-server-scripts) repository.

To use any of these scripts, follow the steps mentioned in the previous section.
