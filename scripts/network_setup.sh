#!/bin/bash

#this script sets up the whole network configuration automatically described in  the network setup section of the Intello docs.

#Please call this script with the following arguments:

#1. IP of your dedicated master server
#2. full path to the private key, e.g. agv
#3. full path to the public key, e.g. agv.pub

#e.g. sudo ./network_setup.sh 192.165.20.22 agv agv.pub

master_ip=$1
private_key=$2
public_key=$3

sudo -s
su root
mkdir -p /root/.ssh
cp $private_key /root/.ssh/agv
cp $public_key /root/.ssh/agv.pub
chmod 700 /root/.ssh
chmod 600 /root/.ssh/*


curl https://raw.github.com/avs_doc/configs/interfaces >> /etc/network/interfaces

echo "$master_ip  master" >> /etc/hosts
echo "10.0.0.100  ros_master" >> /etc/hosts
echo "10.0.0.200  robot" >> /etc/hosts

curl https://raw.github_com/avs_doc/scripts/start_intello_tunnel > /usr/bin/start_intello_tunnel

