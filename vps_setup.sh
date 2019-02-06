#!/bin/sh
# Run the following command on the linux box to download the script and set up the box (Debian 9)
# sh <(wget -qO- https://raw.githubusercontent.com/voyagersclan/scripts/master/vps_setup.sh)

SUDO_COMMAND=""
INSTALL_COMMAND="$SUDO_COMMAND apt-get install -y"

#$SUDO_COMMAND dpkg --configure -a

# install required packages
$INSTALL_COMMAND curl git screen openjdk-8-jre-headless ruby-full
$SUDO_COMMAND gem install bundler

# install drivesync into /opt/drivesync
cd /opt
$SUDO_COMMAND git clone https://github.com/MStadlmeier/drivesync.git
cd drivesync
$SUDO_COMMAND bundle install

# create user for minecraft service
$SUDO_COMMAND adduser --system --home /opt/minecraft --shell /bin/bash --group minecraft

# configure and run drivesync to sync /opt/minecraft directory
$SUDO_COMMAND su - minecraft -c "mkdir ~/.drivesync"
$SUDO_COMMAND su - minecraft -c "curl https://raw.githubusercontent.com/voyagersclan/scripts/master/drivesync_minecraft.yml > ~/.drivesync/config.yml"
$SUDO_COMMAND su - minecraft -c "ruby /opt/drivesync/drivesync.rb"

# create cronjob for minecraft drivesync
$SUDO_COMMAND echo "0 * * * * minecraft ruby /opt/drivesync/drivesync.rb" > /etc/cron.d/drivesync_minecraft

# grab minecraft service script
$SUDO_COMMAND curl https://raw.githubusercontent.com/agowa338/MinecraftSystemdUnit/master/minecraft%40.service > /etc/systemd/system/minecraft@.service

# start and enable minecraft service
#$SUDO_COMMAND systemctl enable minecraft@vanilla
#$SUDO_COMMAND systemctl start minecraft@vanilla
