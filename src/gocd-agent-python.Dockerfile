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
ENV PATH=/usr/local/go/bin:$GOPATH/bin:$PATH
ENV TINI_SUBREAPER=
ENV DOCKER_USER=go
ENV DOCKER_ENTRYPOINT=/docker-entrypoint.sh
COPY entrypoint-docker.sh /
# Add SSH keys
COPY id_rsa /home/go/.ssh/id_rsa
COPY id_rsa.pub /home/go/.ssh/id_rsa.pub
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
# Configure SSH
&& echo "Host *" >> /home/go/.ssh/config \
&& echo "    StrictHostKeyChecking no" >> /home/go/.ssh/config \
&& echo "    GlobalKnownHostsFile  /dev/null" >> /home/go/.ssh/config \
&& echo "    UserKnownHostsFile    /dev/null" >> /home/go/.ssh/config \
&& chmod 600 /home/go/.ssh/id_rsa \
&& chmod 644 /home/go/.ssh/id_rsa.pub \
# Configure default git user
&& echo "[user]" >> /home/go/.gitconfig \
&& echo "	email = gocd@example.com" >> /home/go/.gitconfig \
&& echo "	name = gocd" >> /home/go/.gitconfig \
# Add repositories and update
&& apt update && apt -y dist-upgrade \
&& apt install -y gnupg apt-utils software-properties-common \
&& apt update \
&& locale-gen en_US en_US.UTF-8 \
&& dpkg-reconfigure locales \
# install development packages and debugging tools
&& apt install -y \
curl \
default-jdk \
devscripts \
jq \
libffi-dev \
libmariadb-dev \
librdkafka-dev \
libssl-dev \
make \
mariadb-client \
pylint \
python3-all-dev \
python3-pip \
python3-venv \
python3-novaclient \
rsync \
ssh \
sudo \
tree \
uidmap \
unzip \
virtualenv \
# Install extra Python dependencies
&& pip3 install --ignore-installed --break-system-packages --upgrade pip \
&& pip3 install --break-system-packages --upgrade \
autopep8 \
cffi \
check-jsonschema \
coverage \
dnspython \
fabric \
httpx \
jsonschema \
lxml \
nose \
pipenv \
pyOpenSSL \
pyflakes \
pypandoc \
pytest \
pytest-benchmark \
pytest-cov \
pyyaml \
schemathesis \
setuptools \
yamllint \
# Docker
&& cd /tmp \
&& curl -sSL https://get.docker.com/ | sh \
# Allow go user to run root commands via sudo
&& mkdir /home/go/shared \
&& chown -R go:root /home/go \
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
LABEL "org.opencontainers.image.source"="https://github.com/tecnickcom/alldev/blob/main/src/gocd-agent-python.Dockerfile"
LABEL "org.opencontainers.image.vendor"="tecnickcom"
LABEL "org.opencontainers.image.licenses"="MIT"
LABEL "org.opencontainers.image.title"="gocd-agent-python"
LABEL "org.opencontainers.image.description"="GoCD agent with Python"
LABEL "org.opencontainers.image.base.name"="gocd/gocd-agent-debian-${DEBIAN_VERSION}:${GOCD_VERSION}"
