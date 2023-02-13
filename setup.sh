#!/bin/bash

sudo apt update

#install net-tools
sudo apt -y install net-tools

#install chrony
sudo apt -y install chrony

#install rsyslog
sudo apt -y install rsyslog

#install fail2ban
sudo apt -y install fail2ban

#install salt minion
curl -L https://bootstrap.saltstack.com -o install_salt.sh
sudo sh install_salt.sh -P
rm install_salt.sh

#install docker
sudo apt -y install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update

sudo apt -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo groupadd docker

sudo usermod -aG docker $USER


# Doing other configration

echo "*.* action(type=\"omfwd\" target=\"pinot.cs.ucsb.edu\" port=\"514\" protocol=\"udp\")" | sudo tee -a /etc/rsyslog.conf


sudo cp 50-cloud-init.yaml /etc/netplan/
sudo cp minion /etc/salt/

line="@reboot echo \"atopnuc-\"`cat /sys/class/net/enp1s0/address` > /etc/salt/minion_id"
(crontab -u root -l; echo "$line" ) | crontab -u root -

newgrp docker
