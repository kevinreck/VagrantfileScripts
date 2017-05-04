#!/usr/bin/env bash

# Make sure we have a valid github project URL to pull scripts
if [[ -z $1 ]]; then
    github_url="https://raw.githubusercontent.com/fideloper/Vaprobash/master"
else
    github_url="$1"
fi

if [[ -z $2 ]]; then
    server_timezone="America/Chicago"
else
    server_timezone="$2"
fi

echo " "
echo ">>>"
echo ">>> Setting Timezone & Locale to $server_timezone & en_US.UTF-8"
echo ">>>"
echo " "

sudo ln -sf /usr/share/zoneinfo/$server_timezone /etc/localtime
echo $server_timezone | sudo tee /etc/timezone
sudo apt-get install -qq language-pack-en
sudo locale-gen en_US
sudo update-locale LANG=en_US.UTF-8 LC_CTYPE=en_US.UTF-8

echo " "
echo ">>>"
echo ">>> Installing Base Packages"
echo ">>>"
echo " "

# Update
sudo apt-get update

# Upgrade
#sudo apt-get -qq upgrade

# Install base packages
# -qq implies -y --force-yes
sudo apt-get install -qq \
    curl \
    unzip \
    git-core \
    ack-grep \
    software-properties-common \
    build-essential \
    cachefilesd \
    apt-transport-https \
    ca-certificates \
    zsh \
    fontconfig \
    open-vm-tools

# Enable cachefilesd
echo "RUN=yes" > /etc/default/cachefilesd

# Add the terminal to gnome side menu
#sudo su - vagrant -c "xdg-desktop-menu install --novendor /usr/share/applications/gnome-terminal.desktop"
