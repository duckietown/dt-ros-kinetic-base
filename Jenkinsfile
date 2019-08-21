pipeline {
  agent any
  environment {
    ARCH = "arm32v7"
    ROS_DISTRO = "kinetic"
    OS_DISTRO = "xenial"
    BASE_TAG = "${ROS_DISTRO}-ros-base-${OS_DISTRO}"
    BASE_IMAGE = "${ARCH}/ros:${BASE_TAG}"
  }
  stages {
    stage('Build') {
      steps {
          sh 'printenv'
          echo scm.branches[0].name
      }
    }
  }
}
