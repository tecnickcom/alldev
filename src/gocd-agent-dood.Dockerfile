# Dockerfile
#
# GoCD elastic agent
#
# @author      Nicola Asuni <info@tecnick.com>
# @copyright   2016-2025 Nicola Asuni - Tecnick.com LTD
# @license     MIT (see LICENSE)
# @link        https://github.com/tecnickcom/alldev
# ------------------------------------------------------------------------------
ARG DEBIAN_VERSION="12"
ARG GOCD_VERSION="v25.1.0"
FROM gocd/gocd-agent-debian-${DEBIAN_VERSION}:${GOCD_VERSION}
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
COPY entrypoint-docker.sh /
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
LABEL "org.opencontainers.image.authors"="info@tecnick.com"
LABEL "org.opencontainers.image.url"="https://github.com/tecnickcom/alldev"
LABEL "org.opencontainers.image.documentation"="https://github.com/tecnickcom/alldev/blob/main/README.md"
LABEL "org.opencontainers.image.source"="https://github.com/tecnickcom/alldev/blob/main/src/gocd-agent-dood.Dockerfile"
LABEL "org.opencontainers.image.vendor"="tecnickcom"
LABEL "org.opencontainers.image.licenses"="MIT"
LABEL "org.opencontainers.image.title"="gocd-agent-dood"
LABEL "org.opencontainers.image.description"="GoCD agent with Docker on Docker"
LABEL "org.opencontainers.image.base.name"="gocd/gocd-agent-debian-${DEBIAN_VERSION}:${GOCD_VERSION}"
