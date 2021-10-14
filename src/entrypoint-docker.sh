#!/usr/bin/env bash
#
# entrypoint-docker.sh
#
# Add the specified user to the docker group with the right GID
# and execute the parent entrypoint if specified.
# To mount the host docker sock use the docker run option:
# -v /var/run/docker.sock:/var/run/docker.sock
#
# @author Nicola Asuni <info@tecnick.com>
# ----------------------------------------------------------------------

: ${DOCKER_SOCKET:=/var/run/docker.sock}
: ${DOCKER_GROUP:=docker}
: ${DOCKER_USER:=root}
: ${DOCKER_ENTRYPOINT:=} # e.g.: /docker-entrypoint.sh

if [ -S ${DOCKER_SOCKET} ]; then
    # set the group ID of the local docker group to be the same as the
    # one of the mounted docker sock volume.
    DOCKER_GID=$(stat --format='%g' ${DOCKER_SOCKET})
    sudo groupmod --gid ${DOCKER_GID} ${DOCKER_GROUP}
fi

# add the user to the docker group
sudo usermod --append --groups ${DOCKER_GROUP} ${DOCKER_USER}

# execute the parent entrypoint and/or additional commands with the docker group ID
sg ${DOCKER_GROUP} -c "${DOCKER_ENTRYPOINT}"' '"$@"
