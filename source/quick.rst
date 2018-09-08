Quick setup
############################


Network setup
=================

Prepare your robot for ROS. Make sure it connects via a tunnel to the master server, publishes the laser scan, odometry and the required transforms (`TFs <http://wiki.ros.org/tf>`_). The following instructions assume you are under Ubuntu 16.04 LTS or newer.
If you prefer to setup your network automatically by just one command line, call

.. code-block:: Bash

    sudo bash -c "$(curl -L https://raw.githubusercontent.com/GESTALT-Robotics/avs_doc/master/scripts/network_setup.sh)"


Connecting to master server 
-----------------------------

You will need a dedicated machine (the master) available. To get one, please contat info@gestalt-robotics.com.
The connection is established by a vpn tunnel to your dedicated instance in the cloud. This

Tunnel setup
^^^^^^^^^^^^^^^^^^

1. Get the IP of the master server (later referenced by ``<IP_OF_YOUR_INTELLO_MASTER>``) and your private access keys, e.g. ``agv`` and ``agv.pub`` from your GESTALT-Robotics friends.

2. Copy both keys to your root directory and adjust the access rights:

.. comment: any language supportedy by http://pygments.org/ can be used

.. code-block:: Bash

    sudo -s
    su root
    mkdir -p /root/.ssh
    cp agv /root/.ssh
    cp agv.pub /root/.ssh
    chmod 700 /root/.ssh
    chmod 600 /root/.ssh/*


3. Register the master server for convinience inside ``/etc/hosts``, add these lines:

.. code-block:: python

    <IP_OF_YOUR_INTELLO_MASTER>  master
    10.0.0.100  ros_master
    10.0.0.200  robot


4. Setup a tunnel interface 

Open ``/etc/network/interfaces`` and add

.. code-block:: python
    
    iface tun0 inet static
        pre-up ssh -f -w 0:0 master 'ifdown tun0; ifup tun0'
        pre-up sleep 5
        address 10.0.0.200
        pointopoint 10.0.0.100
        netmask 255.255.255.255
        up ip route add 10.0.0.0/24 via 10.0.0.200
        down ip route del 10.0.0.0/24 via 10.0.0.200


5. Now copy these lines into a helper script ``/usr/bin/start_intello_tunnel`` When you execute this script, the connection to the Intello master server will be established and you are ready to go:

.. code-block:: Bash

    #!/bin/bash
    #place theses lines into /usr/bin/start_intello_tunnel
    sudo -s
    su root

    cd /root/.ssh
    echo "Adding key to ssh-agent"
    eval $(ssh-agent)
    ssh-add agv

    echo "Connecting to Intello master server
    ifup tun0


6. Validate

If everything went fine, you will be able to ping ``10.0.0.100`` after you have called ``start_intello_tunnel``:

.. code-block:: python

    start_intello_tunnel
    ping 10.0.0.100



ROS setup
==============

Tell ROS about the network configuration and add these lines to ``~/.bashrc``:

.. code-block:: python

    export ROS_MASTER_URI=http://ros_master:11311
    export ROS_IP=10.0.0.200
    export ROS_HOSTNAME=robot


Verify and make sure you see the ``/rosout`` topic on the robot machine:

.. code-block:: python
    
    rostopic list


Published information
-------------------------

Start your ros nodes on the robot.
Verify, that you publish  following topics:

* /scan of Type ``sensor_msgs/LaserScan``. Verify this by calling ``rostopic info /scan``

* /odom of type ``nav_msgs/Odometry`` The topic must contain the pose computed from the wheel encoders. The covariance is optional. Verify this by calling ``rostopic info /odom``. Though, it is important, that the TF frame is set to ``odom``.

* TF: Make sure, your ``robot_state_publisher`` publishes the TFs for the frames ``base_link`` in ``odom``, ``base_laser_link`` in ``base_link`` and ``base_footprint`` in ``base_link``.


.. image:: _static//images/frames_doc_avs.png

Verify your TFs by calling ``rosrun tf view_frames`` and then ``evince frames.pdf`` (or any other PDF viewer to see the generated frames.pdf file).



