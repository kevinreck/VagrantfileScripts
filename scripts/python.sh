#!/usr/bin/env bash


echo " "
echo ">>>"
echo ">>> Setting up Python"
echo ">>>"
echo " "

# Install python required tools
sudo apt-get install -qq \
    libmemcached-dev \
    zlib1g-dev \
    libssl-dev \
    build-essential \
    libatlas-base-dev \
    gfortran \
    tdsodbc \
    unixodbc \
    python-pip

# Install the python libraries
sudo pip install virtualenv

# Upgrade pip
sudo pip install --upgrade pip
