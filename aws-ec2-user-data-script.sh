#!/bin/bash
# check if $HOME is set, if not use /home/ubuntu
if [ -z "$HOME" ]; then
  export HOME=/home/ubuntu
fi
cd $HOME
git clone https://github.com/llipe/aws-ami-ubuntu-server-scripts.git