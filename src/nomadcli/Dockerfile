# Dockerfile
#
# Nomad cli and make command - based on phusion/baseimage (Ubuntu)
#
# @author      Nicola Asuni <info@tecnick.com>
# @copyright   2016-2020 Nicola Asuni - Tecnick.com LTD
# @license     MIT (see LICENSE)
# @link        https://github.com/tecnickcom/nomadcli
# ------------------------------------------------------------------------------

FROM phusion/baseimage:master
MAINTAINER info@tecnick.com
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux
ENV HOME /root
ENV DISPLAY :0
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
# Add repositories and update
&& apt-get update && apt-get -y dist-upgrade \
&& apt-get install -y \
build-essential \
make \
parallel \
sudo \
wget \
unzip \
&& cd /tmp \
&& wget https://releases.hashicorp.com/nomad/1.0.0/nomad_1.0.0_linux_amd64.zip \
&& unzip nomad_1.0.0_linux_amd64.zip -d /usr/bin/ \
# Cleanup temporary data and cache
&& apt-get clean \
&& apt-get autoclean \
&& apt-get -y autoremove \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
