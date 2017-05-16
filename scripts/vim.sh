#!/usr/bin/env bash

echo " "
echo ">>>"
echo ">>> Setting up Vim"
echo ">>>"
echo " "

# Make sure we have a valid github project URL to pull scripts
if [[ -z $1 ]]; then
    github_url="https://raw.githubusercontent.com/kevinreck/VagrantfileScripts/master"
else
    github_url="$1"
fi

# set the vagrant home directory
user_home_dir="/home/vagrant"

# Create directories needed for some .vimrc settings and fonts
mkdir -p $user_home_dir/.vim_undo $user_home_dir/.vim_swap $user_home_dir/.local/share/fonts

# Install Vundle
git clone https://github.com/VundleVim/Vundle.vim.git $user_home_dir/.vim/bundle/Vundle.vim

# Grab .vimrc and set owner
curl --silent -L $github_url/helpers/vimrc > $user_home_dir/.vimrc

# Grab the Powerline fonts
curl --silent -L \
	https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20for%20Powerline%20Nerd%20Font%20Complete.otf \
	> $user_home_dir/.local/share/fonts/"Droid Sans Mono for Powerline Nerd Font Complete.otf"

# make sure everything is own by vagrant
sudo chown -R vagrant:vagrant $user_home_dir

# update the font cache
sudo -H -u vagrant bash -c 'fc-cache -vf $user_home_dir/.local/share/fonts/'

# Install Vundle Bundles
sudo -H -u vagrant bash -c 'vim +PluginInstall  +qall'
