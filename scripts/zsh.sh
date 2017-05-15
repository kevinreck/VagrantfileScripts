#!/usr/bin/env bash

# Make sure we have a valid github project URL to pull scripts
if [[ -z $1 ]]; then
    github_url="https://raw.githubusercontent.com/kevinreck/VagrantfileScripts/master"
else
    github_url="$1"
fi

echo " "
echo ">>>"
echo ">>> Setting up ZSH Shell (oh-my-zsh)"
echo ">>>"
echo " "

# Install zsh shell
sudo apt-get install -qq \
    zsh

#install the oh-my-zsh
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
sudo chsh -s $(which zsh) vagrant

