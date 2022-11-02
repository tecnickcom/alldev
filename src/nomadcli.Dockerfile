# Dockerfile
#
# Nomad cli and make command - based on phusion/baseimage (Ubuntu)
#
# @author      Nicola Asuni <info@tecnick.com>
# @copyright   2016-2022 Nicola Asuni - Tecnick.com LTD
# @license     MIT (see LICENSE)
# @link        https://github.com/tecnickcom/nomadcli
# ------------------------------------------------------------------------------
FROM phusion/baseimage:master
ARG NOMAD_VERSION="1.4.2"
MAINTAINER info@tecnick.com
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux
ENV HOME /root
ENV DISPLAY :0
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
# Add repositories and update
&& apt update && apt -y dist-upgrade \
&& apt install -y \
build-essential \
make \
parallel \
sudo \
wget \
unzip \
&& cd /tmp \
&& wget https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip \
&& unzip nomad_${NOMAD_VERSION}_linux_amd64.zip -d /usr/bin/ \
&& rm -f nomad_${NOMAD_VERSION}_linux_amd64.zip \
# Cleanup temporary data and cache
&& apt clean \
&& apt autoclean \
&& apt -y autoremove \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
