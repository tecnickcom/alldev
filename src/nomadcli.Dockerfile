# Dockerfile
#
# Nomad cli and make command
#
# @author      Nicola Asuni <info@tecnick.com>
# @copyright   2016-2025 Nicola Asuni - Tecnick.com LTD
# @license     MIT (see LICENSE)
# @link        https://github.com/tecnickcom/nomadcli
# ------------------------------------------------------------------------------
FROM debian:12
ARG NOMAD_VERSION="1.10.4"
ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=linux
ENV HOME=/root
ENV DISPLAY=:0
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
# Add repositories and update
&& apt update && apt -y dist-upgrade \
&& apt install -y \
build-essential \
make \
parallel \
sudo \
unzip \
wget \
&& cd /tmp \
&& wget https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip \
&& unzip nomad_${NOMAD_VERSION}_linux_amd64.zip -d /usr/bin/ \
&& rm -f nomad_${NOMAD_VERSION}_linux_amd64.zip \
# Cleanup temporary data and cache
&& apt clean \
&& apt autoclean \
&& apt -y autoremove \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
LABEL "org.opencontainers.image.authors"="info@tecnick.com"
LABEL "org.opencontainers.image.url"="https://github.com/tecnickcom/alldev"
LABEL "org.opencontainers.image.documentation"="https://github.com/tecnickcom/alldev/blob/main/README.md"
LABEL "org.opencontainers.image.source"="https://github.com/tecnickcom/alldev/blob/main/src/nomadcli.Dockerfile"
LABEL "org.opencontainers.image.vendor"="tecnickcom"
LABEL "org.opencontainers.image.licenses"="MIT"
LABEL "org.opencontainers.image.title"="nomadcli"
LABEL "org.opencontainers.image.description"="Nomad CLI with extra tools"
LABEL "org.opencontainers.image.base.name"="debian:12"
