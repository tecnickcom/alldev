# Dockerfile
#
# Test docker-in-docker (DooD)
#
# @author      Nicola Asuni <info@tecnick.com>
# @copyright   2016-2026 Nicola Asuni - Tecnick.com LTD
# @license     MIT (see LICENSE)
# @link        https://github.com/tecnickcom/alldev
# ------------------------------------------------------------------------------

FROM debian:13
ENV TINI_SUBREAPER=
ENV DOCKER_USER=root
ENV DOCKER_ENTRYPOINT=
ADD entrypoint-docker.sh /
RUN apt update \
&& apt install -y \
curl \
sudo \
&& cd /tmp \
&& curl -sSL https://get.docker.com/ | sh \
&& chown -R root:root /entrypoint-docker.sh \
&& chmod -R g=u /entrypoint-docker.sh
ENTRYPOINT ["/entrypoint-docker.sh"]
LABEL "org.opencontainers.image.authors"="info@tecnick.com"
LABEL "org.opencontainers.image.url"="https://github.com/tecnickcom/alldev"
LABEL "org.opencontainers.image.documentation"="https://github.com/tecnickcom/alldev/blob/main/README.md"
LABEL "org.opencontainers.image.source"="https://github.com/tecnickcom/alldev/blob/main/src/dood.Dockerfile"
LABEL "org.opencontainers.image.vendor"="tecnickcom"
LABEL "org.opencontainers.image.licenses"="MIT"
LABEL "org.opencontainers.image.title"="dood"
LABEL "org.opencontainers.image.description"="Docker-on-Docker"
LABEL "org.opencontainers.image.base.name"="debian:13"
