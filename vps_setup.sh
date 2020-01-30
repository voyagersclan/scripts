#!/bin/sh
# Run the following command on the linux box to download the script and set up the box (Debian 9)
# sh <(wget -qO- https://raw.githubusercontent.com/voyagersclan/scripts/master/vps_setup.sh)

SUDO_COMMAND=""
INSTALL_COMMAND="$SUDO_COMMAND apt-get install -y"

#$SUDO_COMMAND dpkg --configure -a

# install required packages
$INSTALL_COMMAND curl git screen openjdk-8-jre-headless software-properties-common dirmngr apt-transport-https

# install drive (debian)
$SUDO_COMMAND apt-add-repository 'deb http://shaggytwodope.github.io/repo ./'
$SUDO_COMMAND apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 7086E9CC7EC3233B
$SUDO_COMMAND apt-get update
$INSTALL_COMMAND drive

# create user for minecraft service
$SUDO_COMMAND adduser --system --home /opt/minecraft --shell /bin/bash --group minecraft

# set up minecraft folder sync and pull
$SUDO_COMMAND rm -Rf /opt/.gd 
$SUDO_COMMAND rm -Rf /opt/minecraft
$SUDO_COMMAND mkdir /opt/minecraft
$SUDO_COMMAND drive init /opt
$SUDO_COMMAND chown -R minecraft:minecraft /opt/.gd
$SUDO_COMMAND chown -R minecraft:minecraft /opt/minecraft
$SUDO_COMMAND su minecraft -c "cd /opt/minecraft && drive pull -no-prompt -quiet vanilla.tar "
# extract archives
$SUDO_COMMAND su minecraft -c "cd /opt/minecraft && tar -xvf vanilla.tar"
$SUDO_COMMAND rm /opt/minecraft/*.tar

# create cronjob to sync the server with google drive hourly
$SUDO_COMMAND curl https://raw.githubusercontent.com/voyagersclan/scripts/master/sync_minecraft.sh > /opt/minecraft/sync.sh
$SUDO_COMMAND chown minecraft:minecraft /opt/minecraft/sync.sh
$SUDO_COMMAND chmod u+x /opt/minecraft/sync.sh
$SUDO_COMMAND echo "0 * * * * minecraft sh /opt/minecraft/sync.sh" > /etc/cron.d/sync_minecraft

# grab minecraft service script
$SUDO_COMMAND curl https://raw.githubusercontent.com/voyagersclan/scripts/master/minecraft%40.service > /etc/systemd/system/minecraft@.service

# start and enable minecraft service
#$SUDO_COMMAND systemctl enable minecraft@vanilla
#$SUDO_COMMAND systemctl start minecraft@vanilla
