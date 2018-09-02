Quick setup
============================


Local setup
-----------------

Prepare your robot for ROS. Make sure it publishes the laser scan, odometry and the required transforms (TFs).
Before connecting the robot to a remote instance, you need to make sure everything works as expected with local connection.

Local network properties 
^^^^^^^^^^^^^^^^^^^^^^^^^^

You will need a machine (the master) to be in the same network as your robot (client).
Lets assume your master has the IP ``192.168.1.40`` and the robot ``192.168.1.41``.
Now add the following lines to the file ``/etc/hosts`` on the **server and on the robot**:

.. code-block:: python

	192.168.1.40	master
	192.168.1.41	robot

Verify the settings by calling on both machines

.. code-block:: python

	ping master
	ping robot

Add also these lines **on the master** machine to ``~/.bashrc``:

.. code-block:: python

	export ROS_MASTER_URI=http://master:11311
	export ROS_IP=192.168.1.40
	export ROS_HOSTNAME=master

and **on the robot** in ``~/.bashrc``

.. code-block:: python

	export ROS_MASTER_URI=http://master:11311
	export ROS_IP=192.168.1.41
	export ROS_HOSTNAME=robot

Verify the correct ROS connection by starting the ``roscore`` on the master.
Make sure you see the ``/rosout`` topic on both sides, the master and the robot:

.. code-block:: python
	
	rostopic list


Published information
^^^^^^^^^^^^^^^^^^^^^^^^^

Start the ``roscore`` on the master machine and start your ros nodes on the robot.
Verify, that the following topics are availble:

* /scan of Type ``sensor_msgs/LaserScan``. Verify this by calling ``rostopic info /scan``

* /odom of type ``nav_msgs/Odometry`` The topic must contain the pose. The covariance is optional. Verify this by calling ``rostopic info /odom``

* TF: Make sure, your ``robot_state_publisher`` publishes the TFs for the frames ``base_link`` in ``odom``, ``base_laser_link`` in ``base_link`` and ``base_footprint`` in ``base_link``.


.. figure:: _static//images/frames_doc_avs.png
	:scale: 50%
	:alt: Example frames published to /TF

	Example illustration of published transforms to the ``/TF`` topic.

Verify your TFs by calling ``rosrun tf view_frames`` and then ``evince frames.pdf`` (or any other PDF viewer to see the generated frames.pdf file).


Tunnel
-----------------

Setup a tunnel connection to your instance via

``sudo ssh -f -w 0:0 root@<your_instance_ip> true``

The tunnel is required for the roscore to be able to establish new connection to your robot. 

Diagnose
------------------