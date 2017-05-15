#!/usr/bin/env bash

# Make sure we have a valid github project URL to pull scripts
if [[ -z $1 ]]; then
    github_url="https://raw.githubusercontent.com/kevinreck/VagrantfileScripts/master"
else
    github_url="$1"
fi

sudo apt-get install -qq --no-install-recommends ubuntu-desktop
sudo apt-get install -qq \
   gnome-panel \
   gnome-terminal firefox \
   unity-lens-applications

# Enable the Auto Login
sudo mkdir /etc/lightdm/lightdm.conf.d

sudo bash -c 'cat << EOF > /etc/lightdm/lightdm.conf.d/50-myconfig.conf
[SeatDefaults]
autologin-user=vagrant
EOF'

# Start and then restart manager
sudo service lightdm restart
sleep 10
sudo service lightdm restart

# Create our "FirstTime" script to run
tee ~/vagrantFirstTime.sh <<EOF
gsettings set com.canonical.Unity.Launcher favorites \
   "\$(gsettings get com.canonical.Unity.Launcher favorites | \
   sed "s/'application:\/\/gnome-terminal.desktop' *, *//g" | sed -e "s/]$/, 'application:\/\/gnome-terminal.desktop']/")"
   
EOF


# Create our upstart Script to run
tee ~/.config/upstart/RunLoginScript.conf <<EOF
description "Vagrant Login Script"
start on desktop-start

script
if [ -e ~/vagrantFirstTime.sh ]; then
  sh ~/vagrantFirstTime.sh && \
  mv -f ~/vagrantFirstTime.sh ~/vagrantFirstTime.sh.\$(date +"%Y%m%d%H%M")
fi
end script
EOF





