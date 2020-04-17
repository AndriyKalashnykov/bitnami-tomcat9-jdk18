#!/bin/bash

cd ~/projects/k8s-mac/sb/docker-images/bitnami-tomcat9-jdk18
docker build -f Dockerfile -t ${DOCKER_LOGIN}/bitnami-tomcat9-jdk18:1.0 .
docker login --username=${DOCKER_LOGIN} --password ${DOCKER_PWD} ${DOCKER_REGISTRY}
docker push ${DOCKER_LOGIN}/bitnami-tomcat9-jdk18:1.0
