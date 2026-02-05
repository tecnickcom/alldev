# Dockerfile
#
# GoCD elastic agent
#
# @author      Nicola Asuni <info@tecnick.com>
# @copyright   2016-2026 Nicola Asuni - Tecnick.com LTD
# @license     MIT (see LICENSE)
# @link        https://github.com/tecnickcom/alldev
# ------------------------------------------------------------------------------
ARG DEBIAN_VERSION="13"
ARG GOCD_VERSION="v25.3.0"
FROM gocd/gocd-agent-debian-${DEBIAN_VERSION}:${GOCD_VERSION}
ARG DEBIAN_VERSION
ARG GOCD_VERSION
ARG FLYWAY_VERSION="12.0.0"
ARG GO_VERSION="1.25.7"
ARG NOMAD_VERSION="1.11.1"
ARG VENOM_VERSION="v1.3.0"
USER root
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux
ENV HOME /home/go
ENV DISPLAY :0
ENV GOPATH=/home/go/GO
ENV PATH=/usr/local/go/bin:$GOPATH/bin:/usr/local/flyway:$PATH
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
mariadb-client \
openssl \
parallel \
perl \
pkg-config \
python3-all-dev \
python3-pip \
python3-venv \
rpm \
rsync \
ssh \
sudo \
time \
tree \
uidmap \
unzip \
wget \
xmldiff \
xmlindent \
zip \
# Install extra Python dependencies
&& pip3 install --ignore-installed --break-system-packages --upgrade pip \
&& pip3 install --break-system-packages --upgrade \
check-jsonschema \
httpx \
jsonschema \
schemathesis \
yamllint \
&& cd /tmp \
&& wget https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip \
&& unzip nomad_${NOMAD_VERSION}_linux_amd64.zip -d /usr/bin/ \
&& rm -f nomad_${NOMAD_VERSION}_linux_amd64.zip \
&& cd /tmp \
&& wget -O /usr/bin/venom https://github.com/ovh/venom/releases/download/${VENOM_VERSION}/venom.linux-amd64 \
&& chmod +x /usr/bin/venom \
&& cd /tmp \
wget https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/${FLYWAY_VERSION}/flyway-commandline-${FLYWAY_VERSION}-linux-x64.tar.gz \
&& tar xvzf flyway-commandline-${FLYWAY_VERSION}-linux-x64.tar.gz \
&& rm -f flyway-commandline-${FLYWAY_VERSION}-linux-x64.tar.gz \
&& mv -- flyway-${FLYWAY_VERSION} /usr/local/flyway-${FLYWAY_VERSION} \
&& chmod +x /usr/local/flyway-${FLYWAY_VERSION}/flyway \
&& ln -s /usr/local/flyway-${FLYWAY_VERSION} /usr/local/flyway \
# Install and configure GO
&& cd /tmp \
&& wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz \
&& tar xvf go${GO_VERSION}.linux-amd64.tar.gz \
&& rm -f go${GO_VERSION}.linux-amd64.tar.gz \
&& rm -rf /usr/local/go \
&& mv go /usr/local \
&& mkdir -p /home/go/GO/bin \
&& mkdir -p /home/go/GO/pkg \
&& mkdir -p /home/go/GO/src \
&& echo 'export GOPATH=/home/go/GO' >> /home/go/.profile \
&& echo 'export PATH=/usr/local/go/bin:$GOPATH/bin:$PATH' >> /home/go/.profile \
&& /usr/local/go/bin/go version \
&& /usr/local/go/bin/go install github.com/mikefarah/yq/v4@latest \
&& /usr/local/go/bin/go install github.com/hairyhenderson/gomplate/v3/cmd/gomplate@latest \
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
LABEL "org.opencontainers.image.source"="https://github.com/tecnickcom/alldev/blob/main/src/gocd-agent-golang.Dockerfile"
LABEL "org.opencontainers.image.vendor"="tecnickcom"
LABEL "org.opencontainers.image.licenses"="MIT"
LABEL "org.opencontainers.image.title"="gocd-agent-golang"
LABEL "org.opencontainers.image.description"="GoCD agent with Go (golang)"
LABEL "org.opencontainers.image.base.name"="gocd/gocd-agent-debian-${DEBIAN_VERSION}:${GOCD_VERSION}"
