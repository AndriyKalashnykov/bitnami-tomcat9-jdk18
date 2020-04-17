#!/bin/bash

IMAGE_NAME=bitnami-tomcat9-jdk18
IMAGE_VER=1.0

docker build -f Dockerfile -t ${DOCKER_LOGIN}/${IMAGE_NAME}:${IMAGE_VER} .
docker login --username=${DOCKER_LOGIN} --password ${DOCKER_PWD} ${DOCKER_REGISTRY}
docker push ${DOCKER_LOGIN}/${IMAGE_NAME}:${IMAGE_VER}
