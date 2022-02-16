# Dockerfile
#
# GoCD elastic agent based on Ubuntu 18.04 (Bionic)
#
# @author      Nicola Asuni <info@tecnick.com>
# @copyright   2016-2021 Nicola Asuni - Tecnick.com LTD
# @license     MIT (see LICENSE)
# @link        https://github.com/tecnickcom/alldev
# ------------------------------------------------------------------------------
ARG UBUNTU_VERSION="20.04"
ARG GOCD_VERSION="v21.4.0"
FROM gocd/gocd-agent-ubuntu-${UBUNTU_VERSION}:${GOCD_VERSION}
ARG NOMAD_VERSION="1.2.6"
ARG KOTLIN_VERSION="1.6.10"
ARG VENOM_VERSION="v1.0.1"
MAINTAINER info@tecnick.com
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
ant \
ant-contrib \
ant-optional \
build-essential \
bzip2 \
checkinstall \
curl \
debhelper \
default-jdk \
default-jre \
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
openjdk-8-jdk \
openjdk-8-jre \
openjdk-11-jdk \
openjdk-11-jre \
openjdk-17-jdk \
openjdk-17-jre \
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
# Install Java JDK 12
&& mkdir -p /usr/lib/jvm/ \
&& wget -O /usr/lib/jvm/openjdk-12+32_linux-x64_bin.tar.gz https://download.java.net/openjdk/jdk12/ri/openjdk-12+32_linux-x64_bin.tar.gz \
&& cd /usr/lib/jvm/ \
&& tar -xzvf openjdk-12+32_linux-x64_bin.tar.gz \
&& rm -f openjdk-12+32_linux-x64_bin.tar.gz \
&& mv jdk-12 java-12-openjdk-amd64 \
&& ln -s java-12-openjdk-amd64 java-1.12.0-openjdk-amd64 \
&& cp .java-1.11.0-openjdk-amd64.jinfo .java-1.12.0-openjdk-amd64.jinfo \
&& sed -i 's|\.11|.12|g;s|-11|-12|g' .java-1.12.0-openjdk-amd64.jinfo \
&& update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/java-12-openjdk-amd64/bin/java" 1 \
&& update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/java-12-openjdk-amd64/bin/javac" 1 \
&& update-alternatives --install "/usr/bin/jexec" "jexec" "/usr/lib/jvm/java-12-openjdk-amd64/lib/jexec" 1 \
&& update-alternatives --install "/usr/bin/jjs" "jjs" "/usr/lib/jvm/java-12-openjdk-amd64/bin/jjs" 1 \
&& update-alternatives --install "/usr/bin/keytool" "keytool" "/usr/lib/jvm/java-12-openjdk-amd64/bin/keytool" 1 \
&& update-alternatives --install "/usr/bin/pack200" "pack200" "/usr/lib/jvm/java-12-openjdk-amd64/bin/pack200" 1 \
&& update-alternatives --install "/usr/bin/rmid" "rmid" "/usr/lib/jvm/java-12-openjdk-amd64/bin/rmid" 1 \
&& update-alternatives --install "/usr/bin/rmiregistry" "rmiregistry" "/usr/lib/jvm/java-12-openjdk-amd64/bin/rmiregistry" 1 \
&& update-alternatives --install "/usr/bin/unpack200" "unpack200" "/usr/lib/jvm/java-12-openjdk-amd64/bin/unpack200" 1 \
&& update-alternatives --install "/usr/bin/jaotc" "jaotc" "/usr/lib/jvm/java-12-openjdk-amd64/bin/jaotc" 1 \
&& update-alternatives --install "/usr/bin/jarsigner" "jarsigner" "/usr/lib/jvm/java-12-openjdk-amd64/bin/jarsigner" 1 \
&& update-alternatives --install "/usr/bin/jar" "jar" "/usr/lib/jvm/java-12-openjdk-amd64/bin/jar" 1 \
&& update-alternatives --install "/usr/bin/javadoc" "javadoc" "/usr/lib/jvm/java-12-openjdk-amd64/bin/javadoc" 1 \
&& update-alternatives --install "/usr/bin/javap" "javap" "/usr/lib/jvm/java-12-openjdk-amd64/bin/javap" 1 \
&& update-alternatives --install "/usr/bin/jcmd" "jcmd" "/usr/lib/jvm/java-12-openjdk-amd64/bin/jcmd" 1 \
&& update-alternatives --install "/usr/bin/jdb" "jdb" "/usr/lib/jvm/java-12-openjdk-amd64/bin/jdb" 1 \
&& update-alternatives --install "/usr/bin/jdeprscan" "jdeprscan" "/usr/lib/jvm/java-12-openjdk-amd64/bin/jdeprscan" 1 \
&& update-alternatives --install "/usr/bin/jdeps" "jdeps" "/usr/lib/jvm/java-12-openjdk-amd64/bin/jdeps" 1 \
&& update-alternatives --install "/usr/bin/jfr" "jfr" "/usr/lib/jvm/java-12-openjdk-amd64/bin/jfr" 1 \
&& update-alternatives --install "/usr/bin/jhsdb" "jhsdb" "/usr/lib/jvm/java-12-openjdk-amd64/bin/jhsdb" 1 \
&& update-alternatives --install "/usr/bin/jimage" "jimage" "/usr/lib/jvm/java-12-openjdk-amd64/bin/jimage" 1 \
&& update-alternatives --install "/usr/bin/jinfo" "jinfo" "/usr/lib/jvm/java-12-openjdk-amd64/bin/jinfo" 1 \
&& update-alternatives --install "/usr/bin/jlink" "jlink" "/usr/lib/jvm/java-12-openjdk-amd64/bin/jlink" 1 \
&& update-alternatives --install "/usr/bin/jmap" "jmap" "/usr/lib/jvm/java-12-openjdk-amd64/bin/jmap" 1 \
&& update-alternatives --install "/usr/bin/jmod" "jmod" "/usr/lib/jvm/java-12-openjdk-amd64/bin/jmod" 1 \
&& update-alternatives --install "/usr/bin/jps" "jps" "/usr/lib/jvm/java-12-openjdk-amd64/bin/jps" 1 \
&& update-alternatives --install "/usr/bin/jrunscript" "jrunscript" "/usr/lib/jvm/java-12-openjdk-amd64/bin/jrunscript" 1 \
&& update-alternatives --install "/usr/bin/jshell" "jshell" "/usr/lib/jvm/java-12-openjdk-amd64/bin/jshell" 1 \
&& update-alternatives --install "/usr/bin/jstack" "jstack" "/usr/lib/jvm/java-12-openjdk-amd64/bin/jstack" 1 \
&& update-alternatives --install "/usr/bin/jstatd" "jstatd" "/usr/lib/jvm/java-12-openjdk-amd64/bin/jstatd" 1 \
&& update-alternatives --install "/usr/bin/jstat" "jstat" "/usr/lib/jvm/java-12-openjdk-amd64/bin/jstat" 1 \
&& update-alternatives --install "/usr/bin/rmic" "rmic" "/usr/lib/jvm/java-12-openjdk-amd64/bin/rmic" 1 \
&& update-alternatives --install "/usr/bin/serialver" "serialver" "/usr/lib/jvm/java-12-openjdk-amd64/bin/serialver" 1 \
&& update-alternatives --install "/usr/bin/jconsole" "jconsole" "/usr/lib/jvm/java-12-openjdk-amd64/bin/jconsole" 1 \
&& update-java-alternatives -s java-1.11.0-openjdk-amd64 \
&& java -version \
&& cd /home/go/ \
&& wget https://github.com/JetBrains/kotlin/releases/download/v${KOTLIN_VERSION}/kotlin-compiler-${KOTLIN_VERSION}.zip \
&& unzip kotlin-compiler-${KOTLIN_VERSION}.zip \
&& rm -f kotlin-compiler-${KOTLIN_VERSION}.zip \
&& kotlin -version \
# Install extra Python dependencies
&& pip3 install --ignore-installed --upgrade pip \
&& pip3 install --upgrade jsonschema \
&& cd /tmp \
&& wget https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip \
&& unzip nomad_${NOMAD_VERSION}_linux_amd64.zip -d /usr/bin/ \
&& rm -f nomad_${NOMAD_VERSION}_linux_amd64.zip \
&& cd /tmp \
&& wget -O /usr/bin/venom https://github.com/ovh/venom/releases/download/${VENOM_VERSION}/venom.linux-amd64 \
&& chmod +x /usr/bin/venom \
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
