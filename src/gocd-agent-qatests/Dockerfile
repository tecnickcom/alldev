# Dockerfile
#
# GoCD elastic agent based on Ubuntu 16.04
#
# @author      Nicola Asuni <info@tecnick.com>
# @copyright   2016-2020 Nicola Asuni - Tecnick.com LTD
# @license     MIT (see LICENSE)
# @link        https://github.com/tecnickcom/alldev
# ------------------------------------------------------------------------------
FROM gocd/gocd-agent-ubuntu-16.04:v20.1.0
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
&& apt-get update && apt-get -y dist-upgrade \
&& apt-get install -y gnupg apt-utils software-properties-common \
&& apt-add-repository universe \
&& apt-add-repository multiverse \
&& apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
&& apt-key adv --fetch-keys http://packages.confluent.io/deb/4.0/archive.key \
&& add-apt-repository "deb [arch=amd64] http://packages.confluent.io/deb/4.0 stable main" \
&& apt-get update \
&& apt-get install -y language-pack-en-base \
&& locale-gen en_US en_US.UTF-8 \
&& dpkg-reconfigure locales \
# install development packages and debugging tools
&& apt-get install -y \
curl \
devscripts \
jq \
make \
rsync \
ssh \
sudo \
tree \
unzip \
libffi-dev \
libssl-dev \
default-jdk \
libmysqlclient-dev \
python \
python3 \
python3-all \
python3-all-dev \
python3-dev \
python3-pip \
python3-setuptools \
python-all \
python-all-dev \
python-dev \
python-pip \
python-setuptools \
python-jsonschema \
virtualenv \
pyflakes \
pylint \
librdkafka-dev \
&& pip install --ignore-installed --upgrade pip pipenv \
# Install extra Python3 dependencies
&& pip3 install --ignore-installed --upgrade \
pip \
pyyaml \
autopep8 \
cffi \
coverage \
dnspython \
fabric \
lxml \
nose \
pyOpenSSL \
pypandoc \
pytest \
pytest-benchmark \
pytest-cov \
python-novaclient \
jsonschema \
schemathesis \
&& wget http://packages.couchbase.com/releases/couchbase-release/couchbase-release-1.0-4-amd64.deb \
&& dpkg -i couchbase-release-1.0-4-amd64.deb \
&& apt-get update \
&& apt-get install -y libcouchbase-dev \
# Allow go user to run root comman
# Allow go user to run root commands via sudo
&& chown -R go:root /home/go \
&& usermod -aG sudo go \
&& echo "go ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
# Cleanup temporary data and cache \
&& apt-get clean \
&& apt-get autoclean \
&& apt-get -y autoremove \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
USER go
