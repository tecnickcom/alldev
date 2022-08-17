# Makefile
#
# @since       2016-09-23
# @category    Docker
# @author      Nicola Asuni <info@tecnick.com>
# @copyright   2015-2022 Nicola Asuni - Tecnick.com LTD
# @license     MIT (see LICENSE)
# @link        https://github.com/tecnickcom/alldev
#
# This file is part of alldev project.
# ----------------------------------------------------------------------------------------------------------------------

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

# --- MAKE TARGETS ---

# Display general help about this command
.PHONY: help
help:
	@echo ""
	@echo "${PROJECT} Makefile."
	@echo "The following commands are available:"
	@echo ""
	@echo "    make build  DIMG=<IMAGE_DIR> : Build the specified Docker images"
	@echo "    make upload DIMG=<IMAGE_DIR> : Upload the specified Docker images (only with the right credentials)"
	@echo "    make tag                     : Tag the Git repository"
	@echo ""

# Alias for help target
.PHONY: all
all: help

# Build the specified Docker image
.PHONY: build
build:
	docker build --compress --no-cache --tag ${DOCKER_REPOSITORY}/${DIMG}:latest --file ./src/${DIMG}.Dockerfile ./src/
	docker tag ${DOCKER_REPOSITORY}/${DIMG}:latest ${DOCKER_REPOSITORY}/${DIMG}:${VERSION}-${RELEASE}

# Upload the specified docker image
.PHONY: upload
upload:
	docker push ${DOCKER_REPOSITORY}/${DIMG}:latest
	docker push ${DOCKER_REPOSITORY}/${DIMG}:${VERSION}-${RELEASE}

# Tag the Git repository
.PHONY: tag
tag:
	git tag -a "v$(VERSION)" -m "Version $(VERSION)" && \
	git push origin --tags
