#!/bin/bash

#this script sets up the whole network configuration automatically described in  the network setup section of the Intello docs.

#Please call this script with the following arguments:

#1. IP of your dedicated master server
#2. full path to the private key, e.g. agv
#3. full path to the public key, e.g. agv.pub



user_name="$USER"

if [ "$user_name" = "root" ]; then
  echo "Please start this script as a normal user. Not root"
  exit -1
fi


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

mkdir -p /$HOME/.ssh
cp -v $private_key /$HOME/.ssh/agv
cp -v $public_key /$HOME/.ssh/agv.pub
chmod 700 /$HOME/.ssh
chmod 600 /$HOME/.ssh/*

# sudo mkdir -p /root/.ssh
# sudo cp $private_key /root/.ssh/agv
# sudo cp $public_key /root/.ssh/agv.pub
# sudo chmod 700 /root/.ssh
# sudo chmod 600 /root/.ssh/*
# sudo chown root:root -R /root/.ssh



#sudo echo "eval $(ssh-add)" >> /root/.bashrc
#sudo echo "ssh-add /root/.ssh/agv" >> /root/.bashrc

#helps to use always the same ssh-agent between root and $user. https://serverfault.com/questions/107187/ssh-agent-forwarding-and-sudo-to-another-user
echo "Setting up ssh-agent common env"
sudo -- sh -c " echo \"Defaults    env_keep+=SSH_AUTH_SOCK\" >> /etc/sudoers"

echo "Setting up the network interfaces..."
nonroot_user_name=$USER
sudo -- sh -c "curl https://raw.githubusercontent.com/GESTALT-Robotics/avs_doc/master/configs/interfaces | sed \"s/_user_/$nonroot_user_name/\"  > /tmp/interfaces"
#remove previous intello config if any
sudo -- sh -c  "sed  -e '/#intello-start/,/#intello-end/c\' /etc/network/interfaces > /tmp/ifaces.tmp && mv /tmp/ifaces.tmp /etc/network/interfaces"
#append the fresh intello config to the clean interfaces file
sudo -- sh -c  'cat /tmp/interfaces  >> /etc/network/interfaces'



echo "Setting up the hosts names ..."
#remove previous intello config, if any, from the current hosts files
sudo -- sh -c  "sed  -e '/#intello-start/,/#intello-end/c\' /etc/hosts > /tmp/hosts.tmp && mv /tmp/hosts.tmp /etc/hosts"
sudo -- sh -c "echo \"#intello-start\" >> /etc/hosts" 
sudo -- sh -c "echo \"$master_ip  intello_master\" >> /etc/hosts" 
sudo -- sh -c "echo \"10.0.0.100  ros_master\" >> /etc/hosts"
sudo -- sh -c "echo \"10.0.0.200  robot\" >> /etc/hosts"
sudo -- sh -c "echo \"#intello-end\" >> /etc/hosts" 

echo "Setting up the tunnel start script ..."
sudo -- sh -c "curl -L https://raw.githubusercontent.com/GESTALT-Robotics/avs_doc/master/scripts/start_intello_tunnel > /usr/bin/start_intello_tunnel"
sudo chmod 755 /usr/bin/start_intello_tunnel


#setting UP ntp

echo "Would you like to override the NTP time by the Intello server? [y/n]"
echo "This might lead to inprecise global timing, but is required to synchronize timestamps"
echo "between the robot and application."
printf "[y/n]: "
read use_ntp

echo "Ok. Using NTP."

