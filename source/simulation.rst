Simulation
######################

In order to support smooth integration of your physical robot into the Intello stack
you are encouraged to use the Gazebo based simulator.
We provide a docker image, which starte a simulation in a simple corridor environment.
Use it to inspect all the required TFs and the datatypes expected by Intello.

Setup
=================
Go to the repository root directory <link> and call

.. code-block:: Bash

	docker build -f simulator/Dockerfile -network host -t intello_simulator .

