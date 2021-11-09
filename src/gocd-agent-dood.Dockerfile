# Dockerfile
#
# GoCD elastic agent based on Ubuntu 18.04 (Bionic)
#
# @author      Nicola Asuni <info@tecnick.com>
# @copyright   2016-2021 Nicola Asuni - Tecnick.com LTD
# @license     MIT (see LICENSE)
# @link        https://github.com/tecnickcom/alldev
# ------------------------------------------------------------------------------
ARG UBUNTU_VERSION="20.04"
ARG GOCD_VERSION="v21.3.0"
FROM gocd/gocd-agent-ubuntu-${UBUNTU_VERSION}:${GOCD_VERSION}
MAINTAINER info@tecnick.com
USER root
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux
ENV HOME /home/go
ENV DISPLAY :0
ENV GOPATH=/home/go/GO
ENV PATH=/usr/local/go/bin:$GOPATH/bin:/home/go/kotlinc/bin:$PATH
ENV TINI_SUBREAPER=
ENV DOCKER_USER=go
ENV DOCKER_ENTRYPOINT=/docker-entrypoint.sh
ADD entrypoint-docker.sh /
RUN apt update \
&& apt install -y \
sudo \
# Docker
&& cd /tmp \
&& curl -sSL https://get.docker.com/ | sh \
# Allow go user to run root commands via sudo
&& mkdir /home/go/shared \
&& chown -R go:root /home/go \
&& usermod -aG sudo go \
&& echo "go ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
# Cleanup temporary data and cache \
&& apt clean \
&& apt autoclean \
&& apt -y autoremove \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
&& chown -R go:root /entrypoint-docker.sh \
&& chmod -R g=u /entrypoint-docker.sh
ENTRYPOINT ["/entrypoint-docker.sh"]
USER go
