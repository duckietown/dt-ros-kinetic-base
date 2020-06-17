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
ENV PYTHONIOENCODING UTF-8
ENV ROS_DISTRO "${ROS_DISTRO}"
ENV OS_DISTRO "${OS_DISTRO}"

# copy QEMU
COPY ./assets/qemu/${ARCH}/ /usr/bin/

# setup keys
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" > /etc/apt/sources.list.d/ros1-latest.list

# copy dependencies file
COPY dependencies-apt.txt /tmp/
COPY dependencies-py.txt /tmp/

# install apt dependencies
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    $(awk -F: '/^[^#]/ { print $1 }' /tmp/dependencies-apt.txt | uniq) \
  && rm -rf /var/lib/apt/lists/*

# install python dependencies
RUN pip install -r /tmp/dependencies-py.txt

# remove dependencies files
RUN rm /tmp/dependencies*

# configure catkin to work nicely with docker
RUN sed \
  -i \
  's/__default_terminal_width = 80/__default_terminal_width = 160/' \
  /usr/lib/python2.7/dist-packages/catkin_tools/common.py

# RPi libs
ADD assets/vc.tgz /opt/
COPY assets/00-vmcs.conf /etc/ld.so.conf.d
RUN ldconfig

# setup entrypoint
COPY ./assets/ros_entrypoint.sh /
ENTRYPOINT ["/ros_entrypoint.sh"]

# configure command
CMD ["bash"]

LABEL maintainer="Andrea F. Daniele (afdaniele@ttic.edu)"
