#!/bin/bash

# allow the go user to use docker
: ${DOCKER_SOCKET:=/var/run/docker.sock}
: ${DOCKER_GROUP:=docker}
: ${USER:=go}

if [ -S ${DOCKER_SOCKET} ]; then
    DOCKER_GID=$(stat --format='%g' ${DOCKER_SOCKET})
    sudo groupmod --gid ${DOCKER_GID} ${DOCKER_GROUP}
    sudo usermod --append --groups ${DOCKER_GROUP} ${USER}
fi

sg ${DOCKER_GROUP} -c '/docker-entrypoint.sh '"$@"
