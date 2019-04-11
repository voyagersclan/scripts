#!/bin/sh

COREDNS_BIN="https://github.com/coredns/coredns/releases/download/v1.4.0/coredns_1.4.0_linux_amd64.tgz"
COREDNS_SERVICE="https://raw.githubusercontent.com/coredns/deployment/master/systemd/coredns.service"
COREFILE="https://raw.githubusercontent.com/voyagersclan/scripts/master/bedrock/Corefile"

# download and extract coredns binary
wget $COREDNS_BIN -O coredns.tgz
sudo tar -xvzf coredns.tgz -C /usr/bin
# set permissions 
sudo chown root:root /usr/bin/coredns

# download coredns service
sudo wget $COREDNS_SERVICE -P /etc/systemd/system

# create user for coredns service
sudo adduser --system --disabled-password --disabled-login --home /var/lib/coredns --group coredns

# grab our coredns config
sudo wget $COREFILE -P /etc/coredns

# start and enable coredns service
sudo systemctl enable coredns
sudo systemctl start coredns
