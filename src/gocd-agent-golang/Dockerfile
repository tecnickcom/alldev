# Dockerfile
#
# GoCD elastic agent based on Ubuntu 18.04 (Bionic)
#
# @author      Nicola Asuni <info@tecnick.com>
# @copyright   2016-2021 Nicola Asuni - Tecnick.com LTD
# @license     MIT (see LICENSE)
# @link        https://github.com/tecnickcom/alldev
# ------------------------------------------------------------------------------
FROM gocd/gocd-agent-ubuntu-18.04:v21.2.0
MAINTAINER info@tecnick.com
USER root
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux
ENV HOME /home/go
ENV DISPLAY :0
ENV GOPATH=/home/go/GO
ENV PATH=/usr/local/go/bin:$GOPATH/bin:$PATH
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
unzip \
upx-ucl \
wget \
xmldiff \
xmlindent \
zip \
# Install extra Python dependencies
&& pip3 install --ignore-installed --upgrade pip \
&& pip3 install --ignore-installed --upgrade \
jsonschema \
schemathesis \
&& cd /tmp \
&& wget https://releases.hashicorp.com/nomad/1.1.4/nomad_1.1.4_linux_amd64.zip \
&& unzip nomad_1.1.4_linux_amd64.zip -d /usr/bin/ \
&& rm -f nomad_1.1.4_linux_amd64.zip \
&& cd /tmp \
&& wget -O /usr/bin/venom https://github.com/ovh/venom/releases/download/v1.0.0-rc.7/venom.linux-amd64 \
&& chmod +x /usr/bin/venom \
&& cd /tmp \
# Install and configure GO
&& wget https://storage.googleapis.com/golang/go1.17.1.linux-amd64.tar.gz \
&& tar xvf go1.17.1.linux-amd64.tar.gz \
&& rm -f go1.17.1.linux-amd64.tar.gz \
&& rm -rf /usr/local/go \
&& mv go /usr/local \
&& mkdir -p /home/go/GO/bin \
&& mkdir -p /home/go/GO/pkg \
&& mkdir -p /home/go/GO/src \
&& echo 'export GOPATH=/home/go/GO' >> /home/go/.profile \
&& echo 'export PATH=/usr/local/go/bin:$GOPATH/bin:$PATH' >> /home/go/.profile \
&& go version \
&& cd /tmp \
# Allow go user to run root commands via sudo
&& chown -R go:root /home/go \
&& usermod -aG sudo go \
&& echo "go ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
# Cleanup temporary data and cache \
&& apt clean \
&& apt autoclean \
&& apt -y autoremove \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
USER go
