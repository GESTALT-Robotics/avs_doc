# This relies on an auto generated Dockerfile for gazebo:libgazebo9
# generated from docker_images/create_gzclient_image.Dockerfile.em


#!!!!!!!!!!!!!!!!!!!
# Make sure you set the environment variable
# CONFIG_NAME
# before building this.

#uses ubuntu 16.04
FROM ros:kinetic

RUN apt-get update && apt-get install -y wget

RUN bash -c "echo \"deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main\" > /etc/apt/sources.list.d/gazebo-stable.list"

#setup keys
RUN wget http://packages.osrfoundation.org/gazebo.key -O - | apt-key add -

# install gazebo packages
RUN apt-get update 



RUN apt-get install -y curl \
	build-essential \
    ros-kinetic-desktop-full \ 
    git \
    ros-kinetic-gazebo* \
    ros-kinetic-robot-state-publisher \
    ros-kinetic-turtlebot3-description \
    ros-kinetic-catkin \
    ros-kinetic-rosbridge-suite \
	librosconsole-bridge-dev

WORKDIR /root
ENV CATKIN_WS /root/catkin_ws/

RUN mkdir -p $CATKIN_WS/src
WORKDIR $CATKIN_WS
RUN wstool init src


#setup the ceff simulator 
ADD [ "./ceff_gazebo", "$CATKIN_WS/src/ceff_gazebo" ]


RUN echo "source /opt/ros/kinetic/setup.bash" >> /root/.bashrc
RUN bash -c "source /root/.bashrc"
RUN apt-get install -y liburdf-dev
RUN /bin/bash -c '. /opt/ros/kinetic/setup.bash; cd $CATKIN_WS; catkin_make'


RUN chmod +x $CATKIN_WS/devel/setup.bash && \
    bash -c "source $CATKIN_WS/devel/setup.bash"


#use the config as env variable, with default value from build args.
ARG conf=intuitiv
ENV CONFIG_NAME=$conf


#set the ROS env variables from a predefined config file
RUN ls -la /root/* 
RUN echo "$CONFIG_NAME"

ADD [ "./configs", "/root/configs" ]

RUN ls -la /root/ 
RUN /bin/bash -c ". /root/configs/$CONFIG_NAME" 

WORKDIR $CATKIN_WS

RUN ls -la $CATKIN_WS/src

RUN ls -la /opt/ros/kinetic/lib/

CMD ["/bin/bash -c '. $CATKIN_WS/devel/setup.bash; cd $CATKIN_WS; roslaunch ceff_gazebo turtle.launch world:=corridor'" ]
