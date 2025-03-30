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
ARG DEBIAN_VERSION
ARG GOCD_VERSION
ARG FLYWAY_VERSIONS="11.5.0,10.22.0,7.15.0,9.22.3"
ARG GO_VERSION="1.24.1"
ARG HUGO_VERSION="0.145.0"
ARG KOTLIN_VERSION="2.1.20"
ARG MONGODB_VERSION="8.0"
ARG NODE_VERSION="22"
ARG NOMAD_VERSION="1.9.6"
ARG VENOM_VERSION="v1.2.0"
LABEL com.tecnick.vendor="Tecnick.com"
USER root
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux
ENV HOME /home/go
ENV DISPLAY :0
ENV GOPATH=/home/go/GO
ENV PATH=/usr/local/go/bin:$GOPATH/bin:/home/go/kotlinc/bin:/usr/local/flyway:$PATH
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
&& curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
&& apt update && apt -y dist-upgrade \
&& apt install -y gnupg apt-utils software-properties-common \
&& curl -fsSL https://apt.corretto.aws/corretto.key | gpg --dearmor -o /usr/share/keyrings/corretto-keyring.gpg \
&& echo "deb [signed-by=/usr/share/keyrings/corretto-keyring.gpg] https://apt.corretto.aws stable main" | tee /etc/apt/sources.list.d/corretto.list \
&& apt update \
&& locale-gen en_US en_US.UTF-8 \
&& dpkg-reconfigure locales \
# install development packages and debugging tools
&& apt install -y \
alien \
apache2 \
astyle \
autoconf \
automake \
autotools-dev \
binfmt-support \
binutils-mingw-w64 \
build-essential \
bzip2 \
checkinstall \
clang \
clang-format \
clang-tidy \
cmake \
cppcheck \
curl \
debhelper \
default-jdk \
default-jre \
devscripts \
dh-make \
dnsutils \
dos2unix \
doxygen \
doxygen-latex \
dpkg \
fabric \
fakeroot \
fastjar \
flawfinder \
g++ \
g++-multilib \
gawk \
gcc \
gdb \
gettext \
ghostscript \
git \
gridengine-drmaa-dev \
gsfonts \
gtk-sharp2 \
htop \
imagemagick \
intltool \
java-1.8.0-amazon-corretto-jdk \
java-11-amazon-corretto-jdk \
java-17-amazon-corretto-jdk \
java-21-amazon-corretto-jdk \
jq \
lcov \
libboost-all-dev \
libbz2-dev \
libc6 \
libc6-dev \
libc6-dev-i386 \
libcurl4-openssl-dev \
libcurlpp-dev \
libffi-dev \
libfontconfig1-dev \
libfreetype6-dev \
libfribidi-dev \
libglib2.0-0 \
libglib2.0-dev \
libgsl-dev \
libharfbuzz-dev \
libicu-dev \
libjpeg-dev \
liblapack-dev \
liblzma-dev \
libncurses5-dev \
libpng-dev \
libssl-dev \
libtidy5deb1 \
libtiff5-dev \
libtool \
libxml2 \
libxml2-dev \
libxml2-utils \
libxmlsec1 \
libxmlsec1-dev \
libxmlsec1-openssl \
libxslt1-dev \
libxslt1.1 \
llvm \
lsof \
make \
mariadb-client \
mariadb-server \
mawk \
memcached \
mingw-w64 \
mingw-w64-i686-dev \
mingw-w64-tools \
mingw-w64-x86-64-dev \
nano \
nodejs \
nsis \
nsis-pluginapi \
openssh-client \
openssh-server \
openssl \
pandoc \
parallel \
pass \
pbuilder \
perl \
php \
php-all-dev \
php-amqp \
php-apcu \
php-bcmath \
php-bz2 \
php-cgi \
php-cli \
php-codesniffer \
php-common \
php-curl \
php-db \
php-dev \
php-gd \
php-igbinary \
php-imagick \
php-intl \
php-json \
php-mbstring \
php-memcache \
php-memcached \
php-msgpack \
php-mysql \
php-pear \
php-sqlite3 \
php-xdebug \
php-xml \
pkg-config \
postgresql \
postgresql-contrib \
pylint \
python3-all-dev \
python3-novaclient \
python3-pip \
python3-setuptools \
python3-venv \
r-base \
redis-server \
redis-tools \
rpm \
rsync \
ruby-all-dev \
screen \
ssh \
strace \
sudo \
swig \
texlive-base \
tidy \
time \
tree \
uidmap \
unzip \
valgrind \
vim \
virtualenv \
wget \
xmldiff \
xmlindent \
xmlsec1 \
zbar-tools \
zip \
zlib1g \
zlib1g-dev \
&& java -version \
# Install extra Python dependencies
&& pip3 install --ignore-installed --break-system-packages --upgrade pip \
&& pip3 install --break-system-packages --upgrade \
ansible \
autopep8 \
cffi \
check-jsonschema \
coverage \
dnspython \
fabric \
httpx \
json-spec \
jsonschema \
lxml \
nose \
pyOpenSSL \
pyflakes \
pypandoc \
pytest \
pytest-benchmark \
pytest-cov \
pyyaml \
schemathesis \
setuptools \
shade \
yamllint \
&& cd /home/go/ \
&& wget https://github.com/JetBrains/kotlin/releases/download/v${KOTLIN_VERSION}/kotlin-compiler-${KOTLIN_VERSION}.zip \
&& unzip kotlin-compiler-${KOTLIN_VERSION}.zip \
&& rm -f kotlin-compiler-${KOTLIN_VERSION}.zip \
&& kotlin -version \
&& cd /tmp \
&& wget https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip \
&& unzip nomad_${NOMAD_VERSION}_linux_amd64.zip -d /usr/bin/ \
&& rm -f nomad_${NOMAD_VERSION}_linux_amd64.zip \
&& cd /tmp \
&& wget -O /usr/bin/venom https://github.com/ovh/venom/releases/download/${VENOM_VERSION}/venom.linux-amd64 \
&& chmod +x /usr/bin/venom \
&& cd /tmp \
# Install extra npm dependencies
&& npm install --global \
csso \
csso-cli \
grunt-cli \
gulp-cli \
jquery \
js-beautify \
uglify-js \
# Install R packages
&& Rscript -e "install.packages(c('Rcpp', 'base', 'devtools', 'inline', 'pryr', 'renv', 'ragg', 'roxygen2', 'testthat', 'pkgdown', 'libgfortran-ng'), repos = 'http://cran.us.r-project.org')" \
# Composer
&& cd /tmp \
&& curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
&& cd /tmp \
&& for FLYWAY_VERSION in $(echo ${FLYWAY_VERSIONS} | sed "s/,/ /g"); do \
wget https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/${FLYWAY_VERSION}/flyway-commandline-${FLYWAY_VERSION}-linux-x64.tar.gz \
&& tar xvzf flyway-commandline-${FLYWAY_VERSION}-linux-x64.tar.gz \
&& rm -f flyway-commandline-${FLYWAY_VERSION}-linux-x64.tar.gz \
&& mv -- flyway-${FLYWAY_VERSION} /usr/local/flyway-${FLYWAY_VERSION} \
&& chmod +x /usr/local/flyway-${FLYWAY_VERSION}/flyway \
; done \
&& ln -s /usr/local/flyway-${FLYWAY_VERSION} /usr/local/flyway \
# Install and configure GO
&& cd /tmp \
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
&& /usr/local/go/bin/go version \
&& /usr/local/go/bin/go install github.com/mikefarah/yq/v4@latest \
&& /usr/local/go/bin/go install github.com/hairyhenderson/gomplate/v3/cmd/gomplate@latest \
# Docker
&& cd /tmp \
&& curl -sSL https://get.docker.com/ | sh \
# Haskell
&& curl -sSL https://get.haskellstack.org/ | sh \
# Allow go user to run root commands via sudo
&& mkdir /home/go/shared \
&& chown -R go:root /home/go \
&& usermod -aG sudo go \
&& echo "go ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
# hugo
&& cd /tmp \
&& wget https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_linux-amd64.deb \
&& dpkg -i hugo_${HUGO_VERSION}_linux-amd64.deb \
&& rm -f hugo_${HUGO_VERSION}_linux-amd64.deb \
# Cleanup temporary data and cache
&& apt clean \
&& apt autoclean \
&& apt -y autoremove \
&& rm -rf /root/.composer/cache/* \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
&& chown -R go:root /entrypoint-docker.sh \
&& chmod -R g=u /entrypoint-docker.sh
ENTRYPOINT ["/entrypoint-docker.sh"]
USER go
LABEL "org.opencontainers.image.authors"="info@tecnick.com"
LABEL "org.opencontainers.image.url"="https://github.com/tecnickcom/alldev"
LABEL "org.opencontainers.image.documentation"="https://github.com/tecnickcom/alldev/blob/main/README.md"
LABEL "org.opencontainers.image.source"="https://github.com/tecnickcom/alldev/blob/main/src/gocd-agent.Dockerfile"
LABEL "org.opencontainers.image.vendor"="tecnickcom"
LABEL "org.opencontainers.image.licenses"="MIT"
LABEL "org.opencontainers.image.title"="gocd-agent"
LABEL "org.opencontainers.image.description"="GoCD agent with support for multiple programming languages"
LABEL "org.opencontainers.image.base.name"="gocd/gocd-agent-debian-${DEBIAN_VERSION}:${GOCD_VERSION}"
