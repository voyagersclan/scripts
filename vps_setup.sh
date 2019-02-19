#!/bin/sh
# Run the following command on the linux box to download the script and set up the box (Debian 9)
# sh <(wget -qO- https://raw.githubusercontent.com/voyagersclan/scripts/master/vps_setup.sh)

SUDO_COMMAND=""
INSTALL_COMMAND="$SUDO_COMMAND apt-get install -y"

MINECRAFT_USER="minecraft"
MINECRAFT_DIR="/opt/minecraft"

#$SUDO_COMMAND dpkg --configure -a

# install required packages
$INSTALL_COMMAND curl git screen openjdk-8-jre-headless software-properties-common

# install and set up drive (debian)
$SUDO_COMMAND apt-add-repository 'deb http://shaggytwodope.github.io/repo ./'
$SUDO_COMMAND apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 7086E9CC7EC3233B
$SUDO_COMMAND apt-get update
$INSTALL_COMMAND drive
drive init /opt

# create user for minecraft service
$SUDO_COMMAND adduser --system --home ${MINECRAFT_DIR} --shell /bin/bash --group ${MINECRAFT_USER}

# pull server files from google drive
cd $MINECRAFT_DIR
drive pull

# create cronjob to sync the server with google drive hourly
$SUDO_COMMAND curl https://raw.githubusercontent.com/voyagersclan/scripts/master/sync_minecraft.sh > /etc/cron.hourly/sync_minecraft.sh

# grab minecraft service script
$SUDO_COMMAND curl https://raw.githubusercontent.com/agowa338/MinecraftSystemdUnit/master/minecraft%40.service > /etc/systemd/system/minecraft@.service

# start and enable minecraft service
#$SUDO_COMMAND systemctl enable minecraft@vanilla
#$SUDO_COMMAND systemctl start minecraft@vanilla
