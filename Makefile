# Makefile
#
# @since       2016-09-23
# @category    Docker
# @author      Nicola Asuni <info@tecnick.com>
# @copyright   2015-2020 Nicola Asuni - Tecnick.com LTD
# @license     MIT (see LICENSE)
# @link        https://github.com/tecnickcom/alldev
#
# This file is part of alldev project.
# ----------------------------------------------------------------------------------------------------------------------

# List special make targets that are not associated with files
.PHONY: help all builditem build uploaditem upload

# Project owner
OWNER=tecnickcom

# Project vendor
VENDOR=${OWNER}

# Project name
PROJECT=alldev

# Project version
VERSION=$(shell cat VERSION)

# Project release number (packaging build number)
RELEASE=$(shell cat RELEASE)

# Current directory
CURRENTDIR=$(shell pwd)

# Docker registry
DOCKER_REGISTRY=

# Docker repository
DOCKER_REPOSITORY=${DOCKER_REGISTRY}${VENDOR}

# List of Docker images to build
IMAGES="alldev gocd-agent"

# --- MAKE TARGETS ---

# Display general help about this command
help:
	@echo ""
	@echo "${PROJECT} Makefile."
	@echo "The following commands are available:"
	@echo ""
	@echo "    make build                       : Build all Docker images"
	@echo "    make builditem DIMG=<IMAGE_DIR>  : Build the specified Docker images"
	@echo "    make upload                      : Upload all Docker images (only with the right credentials)"
	@echo "    make uploaditem DIMG=<IMAGE_DIR> : Upload the specified Docker images (only with the right credentials)"
	@echo ""

# Alias for help target
all: help

# Build the specified Docker image
builditem:
	docker build --compress --no-cache -t ${DOCKER_REPOSITORY}/${DIMG}:latest ./src/${DIMG}
	docker tag ${DOCKER_REPOSITORY}/${DIMG}:latest ${DOCKER_REPOSITORY}/${DIMG}:${VERSION}-${RELEASE}

# Build the Docker image
build:
	for DIR in ${IMAGES} ; do make builditem DIMG=$$DIR ; done

# Upload the specified docker image
uploaditem:
	docker push ${DOCKER_REPOSITORY}/${DIMG}:latest
	docker push ${DOCKER_REPOSITORY}/${DIMG}:${VERSION}-${RELEASE}

# Upload docker image
upload:
	for DIR in ${IMAGES} ; do make uploaditem DIMG=$$DIR ; done
