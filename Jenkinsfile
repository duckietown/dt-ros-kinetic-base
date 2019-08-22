pipeline {
  agent any
  environment {
    ARCH = "arm32v7"
    ROS_DISTRO = "kinetic"
    OS_DISTRO = "xenial"
    BASE_TAG = "${ROS_DISTRO}-ros-base-${OS_DISTRO}"
    BASE_IMAGE = "${ARCH}/ros:${BASE_TAG}"

    GIT_REPO_NAME = GIT_URL.replaceFirst(/^.*\/([^\/]+?)(.git)?$/, '$1')
    GIT_REPO_BRANCH = GIT_BRANCH.replaceFirst(/^.*\/([^\/]+?)$/, '$1')
    IMAGE_TAG_1 = "${GIT_REPO_BRANCH}-${ARCH}"
    IMAGE_BASE_1 = "${GIT_REPO_NAME}:${IMAGE_TAG_1}"
    IMAGE_TAG_2 = "${GIT_REPO_BRANCH}"
    IMAGE_BASE_2 = "${GIT_REPO_NAME}:${IMAGE_TAG_2}"
  }
  stages {
    stage('Prepare') {
      steps {
          sh 'pip3 install --upgrade duckietown-shell'
          sh 'dts update'
	  sh 'dts install devel'
      }
    }
    stage('Build') {
      steps {
          sh 'dts devel build --rm --no-multiarch'
      }
    }
  }
}
