#!/usr/bin/env bash

echo " "
echo ">>>"
echo ">>> Installing Docker"
echo ">>>"
echo " "

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Setup stable repository
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# update the apt package index
sudo apt-get update

# install Docker CE
sudo apt-get install -qq docker-ce

# Make the vagrant user able to interact with docker without sudo
if [ ! -z "$1" ]; then
   if [ "$1" == "permissions" ]; then
      echo " "
      echo ">>>"
      echo ">>> Adding vagrant user to docker group"
      echo ">>>"
      echo " "

      sudo usermod -a -G docker vagrant

   fi # permissions
fi # arg check

# Start Docker daemon
#sudo service docker start
