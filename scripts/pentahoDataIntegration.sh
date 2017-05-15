#!/usr/bin/env bash

# Make sure we have a valid github project URL to pull scripts
if [[ -z $1 ]]; then
    github_url="https://raw.githubusercontent.com/kevinreck/VagrantfileScripts/master"
else
    github_url="$1"
fi

PENTAHO_HOME_DEFAULT=/opt/pentaho

PENTAHO_DI_RELEASE_VERSION=7.0 
PENTAHO_DI_SUB_VERSION=7.0.0.0-25
PENTAHO_HOME=$PENTAHO_HOME_DEFAULT
KETTLE_INSTALL_DIR=$PENTAHO_HOME_DEFAULT/data-integration
#KETTLE_HOME=$PENTAHO_HOME_DEFAULT
PENTAHO_JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

echo " "
echo ">>>"
echo ">>> Setting up Pentaho Data Integration ( $PENTAHO_DI_SUB_VERSION )"
echo ">>>     - downloading pentaho will take awhile"
echo ">>>"
echo " "

# Make sure we have Java, libwebkit and install script dependencies
sudo apt-get install -qq \
    openjdk-8-jre\
    libwebkitgtk-1.0.0 

# set the vagrant home directory
user_home_dir="/home/vagrant"

# Create directory
mkdir -p $KETTLE_INSTALL_DIR

echo " "
echo ">>>"
echo ">>>  Downloading pentaho will take awhile ( ~700MB )"
echo ">>>         [ progress is being suppressed ]        "
echo ">>>         [          please wait         ]        "
echo ">>>"
echo " "

# Download and Install Pentaho Data Integration
curl -s -S -L \
    http://cytranet.dl.sourceforge.net/project/pentaho/Data%20Integration/$PENTAHO_DI_RELEASE_VERSION/pdi-ce-$PENTAHO_DI_SUB_VERSION.zip \
    > /tmp/pdi-ce-$PENTAHO_DI_SUB_VERSION.zip && \
    unzip -q /tmp/pdi-ce-$PENTAHO_DI_SUB_VERSION.zip -d $PENTAHO_HOME && \
    rm -rf /tmp/*

echo " "
echo ">>>"
echo ">>> Downloading Pentaho - complete"
echo ">>>"
echo " "

# Download the SQL JDBC Driver
curl -s -S -L https://download.microsoft.com/download/0/2/A/02AAE597-3865-456C-AE7F-613F99F850A8/enu/sqljdbc_6.0.8112.100_enu.tar.gz \
    | tar -xz -C /tmp && \
    find /tmp/sqljdbc_6.0 -name 'sqljdbc41.jar' -exec mv {} $KETTLE_INSTALL_DIR/libswt/linux/x86_64 \; && \
    find /tmp/sqljdbc_6.0 -name 'sqljdbc42.jar' -exec mv {} $KETTLE_INSTALL_DIR/lib/ \; && \
    rm -rf /tmp/*

# Download the Redshift driver
curl -s -S -L \
    https://s3.amazonaws.com/redshift-downloads/drivers/RedshiftJDBC4-1.2.1.1001.jar > \
    $KETTLE_INSTALL_DIR/lib/RedshiftJDBC4-1.2.1.1001.jar


# Add Pentaho to our users path so we can run (spoon.sh/kitchen.sh/pan.sh)
sudo bash -c 'cat << EOF > /etc/profile.d/pentaho-data-integration.sh
PATH=\$PATH:/opt/pentaho/data-integration
EOF'

# Create our Icon
sudo bash -c 'cat << EOF > /usr/share/applications/pentaho.data.integration.desktop
[Desktop Entry]
Version=7.0.0.0-25
Type=Application
Terminal=false
Categories=GNOME;GTK;ETL
Name=Pentaho Data Integration
Icon=/opt/pentaho/data-integration/spoon.ico
Exec=/opt/pentaho/data-integration/spoon.sh
EOF'

tee ~/vagrantFirstTime.sh <<EOF
gsettings set com.canonical.Unity.Launcher favorites \
   "$(gsettings get com.canonical.Unity.Launcher favorites | \
   sed "s/'application:\/\/pentaho.data.integration.desktop' *, *//g" | sed -e "s/]$/, 'application:\/\/pentaho.data.integration.desktop']/")"
   
EOF


