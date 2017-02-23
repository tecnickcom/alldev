# Makefile
#
# @since       2016-09-23
# @category    Docker
# @author      Nicola Asuni <info@tecnick.com>
# @copyright   2015-2017 Nicola Asuni - Tecnick.com LTD
# @license     MIT (see LICENSE)
# @link        https://github.com/tecnickcom/alldev
#
# This file is part of alldev project.
# ----------------------------------------------------------------------------------------------------------------------

# List special make targets that are not associated with files
.PHONY: help all build upload

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

# --- MAKE TARGETS ---

# Display general help about this command
help:
	@echo ""
	@echo "${PROJECT} Makefile."
	@echo "The following commands are available:"
	@echo ""
	@echo "    make build  : Build the Docker image"
	@echo "    make upload : Upload the docker image (only with the right credentials)"
	@echo ""

# Alias for help target
all: help

# Build the Docker image
build:
	docker rm `docker ps -a | grep ${OWNER}/${PROJECT}:raw | awk '{print $$1}'` || true
	docker build -t ${OWNER}/${PROJECT}:raw ./src/
	docker run -it ${OWNER}/${PROJECT}:raw bash -c "exit"
	docker ps -a | grep ${OWNER}/${PROJECT}:raw | awk '{print $$1}' > container.id
	docker export `cat container.id` | docker import - ${OWNER}/${PROJECT}:latest
	docker rm `cat container.id`
	docker tag ${OWNER}/${PROJECT}:latest ${OWNER}/${PROJECT}:${VERSION}-${RELEASE}

# Upload docker image
upload:
	docker push ${OWNER}/${PROJECT}:latest
	docker push ${OWNER}/${PROJECT}:${VERSION}-${RELEASE}
