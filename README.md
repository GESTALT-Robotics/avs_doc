# Intello - Autonomous Vehicle System Stack

Intello is a full value stack designed for ROS based physical robots. By simply connecting it to your robot Intello takes charge of
* Mapping
* Web-Based UI for e.g. tasks, jobs management
* Path planning

These are the sources for the docs for the autonomous vehicle system platform Intello.
See here for details: <link to read_the_docs>


## Docs Setup

```sh
pip install sphinx sphinx-autobuild recommonmark sphinx_rtd_theme
```

## Build html pages

```sh
make html
```


## Intello Setup

Receive your keys (private and public key) from Gestalt Robotics and integrate your robot with this one commenad:

```sh
sudo bash -c "$(curl -L https://raw.githubusercontent.com/GESTALT-Robotics/avs_doc/master/scripts/network_setup.sh)"
```

## Connecting to your 

The tunnel enables your robot and the ROS master to communicate on fixed IPs regardeles of your physical internet carrier or location.
```sh
sudo start_intello_tunnel
```

Then start your robot ROS nodes.
See <link to read_the_docs> for details.






