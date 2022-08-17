# Dockerfile
#
# GoCD elastic agent based on Ubuntu 18.04 (Bionic)
#
# @author      Nicola Asuni <info@tecnick.com>
# @copyright   2016-2022 Nicola Asuni - Tecnick.com LTD
# @license     MIT (see LICENSE)
# @link        https://github.com/tecnickcom/alldev
# ------------------------------------------------------------------------------
ARG UBUNTU_VERSION="22.04"
ARG GOCD_VERSION="v22.1.0"
FROM gocd/gocd-agent-ubuntu-${UBUNTU_VERSION}:${GOCD_VERSION}
ARG NOMAD_VERSION="1.3.3"
ARG GO_VERSION="1.19"
ARG VENOM_VERSION="v1.0.1"
MAINTAINER info@tecnick.com
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
ADD entrypoint-docker.sh /
# Add SSH keys
ADD id_rsa /home/go/.ssh/id_rsa
ADD id_rsa.pub /home/go/.ssh/id_rsa.pub
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
&& apt-add-repository universe \
&& apt-add-repository multiverse \
&& apt update \
&& apt install -y language-pack-en-base \
&& locale-gen en_US en_US.UTF-8 \
&& dpkg-reconfigure locales \
# install development packages and debugging tools
&& apt install -y \
alien \
build-essential \
bzip2 \
checkinstall \
curl \
debhelper \
default-jdk \
devscripts \
dpkg \
fakeroot \
gawk \
git \
jq \
libffi-dev \
libssl-dev \
libxml2-utils \
make \
mysql-client \
openssl \
parallel \
perl \
pkg-config \
python3-all-dev \
python3-pip \
rpm \
rsync \
ssh \
sudo \
time \
tree \
uidmap \
unzip \
upx-ucl \
wget \
xmldiff \
xmlindent \
zip \
# Install extra Python dependencies
&& pip3 install --ignore-installed --upgrade pip \
&& pip3 install --upgrade jsonschema \
&& pip3 install --upgrade schemathesis \
&& cd /tmp \
&& wget https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip \
&& unzip nomad_${NOMAD_VERSION}_linux_amd64.zip -d /usr/bin/ \
&& rm -f nomad_${NOMAD_VERSION}_linux_amd64.zip \
&& cd /tmp \
&& wget -O /usr/bin/venom https://github.com/ovh/venom/releases/download/${VENOM_VERSION}/venom.linux-amd64 \
&& chmod +x /usr/bin/venom \
&& cd /tmp \
# Install and configure GO
&& wget https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz \
&& tar xvf go${GO_VERSION}.linux-amd64.tar.gz \
&& rm -f go${GO_VERSION}.linux-amd64.tar.gz \
&& rm -rf /usr/local/go \
&& mv go /usr/local \
&& mkdir -p /home/go/GO/bin \
&& mkdir -p /home/go/GO/pkg \
&& mkdir -p /home/go/GO/src \
&& echo 'export GOPATH=/home/go/GO' >> /home/go/.profile \
&& echo 'export PATH=/usr/local/go/bin:$GOPATH/bin:$PATH' >> /home/go/.profile \
&& go version \
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
