ARG ARCH=arm32v7
ARG ROS_DISTRO=kinetic
ARG OS_DISTRO=xenial
ARG BASE_TAG=${ROS_DISTRO}-ros-base-${OS_DISTRO}

FROM ${ARCH}/ros:${BASE_TAG}

ARG ARCH
ARG ROS_DISTRO
ARG OS_DISTRO

# setup environment
ENV INITSYSTEM off
ENV QEMU_EXECVE 1
ENV TERM "xterm"
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV ROS_DISTRO "${ROS_DISTRO}"
ENV OS_DISTRO "${OS_DISTRO}"

# copy QEMU
COPY ./assets/qemu/${ARCH}/ /usr/bin/

# install packages
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        sudo \
        locales \
        locales-all \
        i2c-tools \
    && rm -rf /var/lib/apt/lists/*

# setup keys
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 421C365BD9FF1F717815A3895523BAEEB01FA116

# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" > /etc/apt/sources.list.d/ros-latest.list

# install additional ros packages
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        ros-kinetic-robot \
        ros-kinetic-joystick-drivers \
    && rm -rf /var/lib/apt/lists/*

# RPi libs
ADD assets/vc.tgz /opt/
COPY assets/00-vmcs.conf /etc/ld.so.conf.d
RUN ldconfig

# development tools & libraries
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        libxslt-dev \
        libnss-mdns \
        libffi-dev \
        libturbojpeg \
        libblas-dev \
        liblapack-dev \
        libatlas-base-dev \
        # Python Dependencies
        python-pip \
        python-smbus \
        python-termcolor \
        python-tables \
        python-lxml \
        python-bs4 \
        python-catkin-tools \
        python-ruamel.yaml \
        python-pymongo \
    && rm -rf /var/lib/apt/lists/*

# setup entrypoint
COPY ./assets/ros_entrypoint.sh /

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]

LABEL maintainer="Andrea F. Daniele (afdaniele@ttic.edu)"
