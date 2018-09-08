#!/bin/bash

#this script sets up the whole network configuration automatically described in  the network setup section of the Intello docs.

#Please call this script with the following arguments:

#1. IP of your dedicated master server
#2. full path to the private key, e.g. agv
#3. full path to the public key, e.g. agv.pub


echo "Enter the IP of your deticated Initello master server:"
read master_ip
#check if the server is reachable
echo "Master ip is: $master_ip"
ping -c 1 $master_ip &> /dev/null

if [ "$?" -eq "0" ]; then
  	echo "Master server ping successful!"
else
	echo "Could not reach the master server under $master_ip. Check the IP and try again."
  	exit -1
fi


echo "Enter the full path to the public key. e.g. \"./agv.pub\" (without \"):"
read public_key

if [ -e $public_key ]
then
    echo "File $public_key found."
else
    echo "Did not find the file $public_key. Aborting."
    exit -1
fi


echo "Enter the full path to the private key. e.g. \"./agv\" (without \"):"
read private_key

if [ -e $private_key ]
then
    echo "File $private_key found."
else
    echo "Did not find the file $private_key. Aborting."
    exit -1
fi


echo "Copying the keys into /root/.ssh ..."

sudo mkdir -p /root/.ssh
sudo cp $private_key /root/.ssh/agv
sudo cp $public_key /root/.ssh/agv.pub
sudo chmod 700 /root/.ssh
sudo chmod 600 /root/.ssh/*
sudo chown root:root -R /root/.ssh


echo "Setting up the network interfaces..."
sudo -- sh -c "curl https://raw.githubusercontent.com/GESTALT-Robotics/avs_doc/master/configs/interfaces >> /etc/network/interfaces"

echo "Setting up the hosts names ..."
sudo -- sh -c "echo \"$master_ip  master\" >> /etc/hosts" 
sudo -- sh -c "echo \"10.0.0.100  ros_master\" >> /etc/hosts"
sudo -- sh -c "echo \"10.0.0.200  robot\" >> /etc/hosts"

echo "Setting up the tunnel start script ..."
sudo -- sh -c "curl https://raw.githubusercontent.com/GESTALT-Robotics/avs_doc/master/scripts/start_intello_tunnel > /usr/bin/start_intello_tunnel"

