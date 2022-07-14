# Dockerfile
#
# Test docker-in-docker (DooD)
#
# @author      Nicola Asuni <info@tecnick.com>
# @copyright   2016-2022 Nicola Asuni - Tecnick.com LTD
# @license     MIT (see LICENSE)
# @link        https://github.com/tecnickcom/alldev
# ------------------------------------------------------------------------------

FROM phusion/baseimage:master
ENV TINI_SUBREAPER=
ENV DOCKER_USER=root
ENV DOCKER_ENTRYPOINT=
ADD entrypoint-docker.sh /
RUN apt update \
&& apt install -y \
sudo \
&& cd /tmp \
&& curl -sSL https://get.docker.com/ | sh \
&& chown -R root:root /entrypoint-docker.sh \
&& chmod -R g=u /entrypoint-docker.sh
ENTRYPOINT ["/entrypoint-docker.sh"]
