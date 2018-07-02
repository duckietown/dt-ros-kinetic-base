FROM maidbot/resin-raspberrypi3-qemu

RUN [ "cross-build-start" ]

#switch on systemd init system in container
ENV INITSYSTEM off

MAINTAINER Breandan Considine breandan.considine@nutonomy.com

## ros-kinetic-core
# install packages
RUN apt-get update && apt-get install -q -y \
    	dirmngr \
    	gnupg2 \
    	sudo \
	locales \
	locales-all \
	i2c-tools \
	net-tools \
	iputils-ping \
	man \
	ssh \
	htop \
	atop \
	iftop \
	less \
	lsb-release \
    && rm -rf /var/lib/apt/lists/*

# setup keys
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 421C365BD9FF1F717815A3895523BAEEB01FA116

# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" > /etc/apt/sources.list.d/ros-latest.list

# install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    	python-rosdep \
    	python-rosinstall \
    	python-vcstools \
    	python-pip \
    && rm -rf /var/lib/apt/lists/*


# development tools
RUN apt-get update && apt-get install --no-install-recommends -y \
	build-essential \
	emacs \
	vim \
	byobu \
	zsh \
	git \
	git-extras \
	libxslt-dev \
	libxml2-dev \
	libnss-mdns \
	libffi-dev \
	libturbojpeg1 \
	libblas-dev \
	liblapack-dev \
	libatlas-base-dev \
	libyaml-cpp-dev \
	libpcl-dev \
	libvtk5-dev \
	libboost-all-dev \
     && rm -rf /var/lib/apt/lists/*

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV TERM "xterm"

# bootstrap rosdep
RUN rosdep init && rosdep update

# install ros packages
ENV ROS_DISTRO kinetic
RUN apt-get update && apt-get install -y \
     	ros-kinetic-ros-base=1.3.2-0* \
     	ros-kinetic-ros-core=1.3.2-0* \
    	ros-kinetic-robot=1.3.2-0* \
  	ros-kinetic-perception=1.3.2-0* \
    	ros-kinetic-navigation \
 	ros-kinetic-robot-localization \
    	ros-kinetic-roslint \
 	ros-kinetic-hector-trajectory-server \
    	ros-kinetic-joystick-drivers \
    	# Python Dependencies
    	# https://github.com/duckietown/duckuments/blob/dd3c5229526bcbb3e2f6cacc813b1313e7a4dbbc/docs/atoms_17_opmanual_duckiebot/atoms_17_setup_duckiebot_DB17-jwd/1_1_reproducing_ubuntu_image.md#install-packages
	python-dev \
	ipython \
	python-sklearn \
	python-smbus \
	python-termcolor \
	python-tables \
	python-frozendict \
	python-lxml \
	python-bs4 \
	python-openssl \
	python-service-identity \
	python-catkin-tools \
     && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade \
	pyparsing==2.2.0 \
	PyContracts==1.8.2 \
	compmake==3.5.23 \
	comptests==1.4.22 \
	DecentLogs==1.1.2 \
	QuickApp==1.3.12 \
	conftools==1.9.1 \
	procgraph==1.10.10 \
	ros_node_utils==1.1.1 \
	pymongo==3.5.1 \
	ruamel.yaml==0.15.34 \
	PyGeometry==1.3 \
	beautifulsoup4==4.6.0 \
	matplotlib==1.5.1 \
	pycamera \
	jpeg4py

RUN [ "cross-build-end" ] 

# setup entrypoint
COPY ./ros_entrypoint.sh /

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]
