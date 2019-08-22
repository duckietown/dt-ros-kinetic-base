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
    stage('Pre-Clean') {
      steps {
        sh 'dts devel clean'
      }
    }
    stage('Build') {
      steps {
        sh 'dts devel build --no-multiarch'
      }
    }
    stage('Push') {
      steps {
        withDockerRegistry(credentialsId: 'DockerHub', url: 'https://index.docker.io/v1/') {
          sh 'dts devel push'
        }
      }
    }
    stage('Post-Clean') {
      steps {
        sh 'dts devel clean'
      }
    }
  }
  post {
      always {
          sh 'dts devel clean'
          cleanWs()
      }
  }
}
