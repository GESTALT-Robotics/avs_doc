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

echo "Copying the keys into /root/.ssh ..."

sudo mkdir -p /root/.ssh
sudo cp $private_key /root/.ssh/agv
sudo cp $public_key /root/.ssh/agv.pub
sudo chmod 700 /root/.ssh
sudo chmod 600 /root/.ssh/*
sudo chown root:root -R /root/.ssh


echo "Setting up the network interfaces..."
sudo curl https://raw.githubusercontent.com/GESTALT-Robotics/avs_doc/master/configs/interfaces >> /etc/network/interfaces

echo "Setting up the hosts names ..."
sudo echo "$master_ip  master" >> /etc/hosts
sudo echo "10.0.0.100  ros_master" >> /etc/hosts
sudo echo "10.0.0.200  robot" >> /etc/hosts

echo "Setting up the tunnel start script ..."
sudo curl https://raw.githubusercontent.com/GESTALT-Robotics/avs_doc/master/scripts/start_intello_tunnel > /usr/bin/start_intello_tunnel

