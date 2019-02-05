#Copy and paste Line 2 on to the linux box to download the entire script and setup the box (Debian 9 64 Bit or higher)
#$SUDO_COMMAND sh <(curl -sL https://raw.githubusercontent.com/voyagersclan/scripts/master/setup_box.sh)

SUDO_COMMAND=""
INSTALL_COMMAND="$SUDO_COMMAND apt-get install -y"

#Run As Root
$SUDO_COMMAND dpkg --configure -a

$INSTALL_COMMAND curl
$INSTALL_COMMAND git

$INSTALL_COMMAND ruby-full
$SUDO_COMMAND gem install bundler

$SUDO_COMMAND git clone https://github.com/MStadlmeier/drivesync.git
$SUDO_COMMAND cd drivesync
$SUDO_COMMAND bundle install
$SUDO_COMMAND ruby drivesync.rb

echo "ruby /root/drivesync/drivesync.rb" > /etc/cron.hourly/updateDrive.sh

chmod 777 /etc/cron.hourly/updateDrive.sh

#Setup will be complete at this point and the files will be syncing to /root/Documents/drive
