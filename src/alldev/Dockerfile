# Dockerfile
#
# Development environment based on phusion/baseimage (Ubuntu)
#
# @author      Nicola Asuni <info@tecnick.com>
# @copyright   2016-2021 Nicola Asuni - Tecnick.com LTD
# @license     MIT (see LICENSE)
# @link        https://github.com/tecnickcom/alldev
# ------------------------------------------------------------------------------
FROM phusion/baseimage:master
MAINTAINER info@tecnick.com
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux
ENV HOME /root
ENV DISPLAY :0
ENV GOPATH=/root
ENV PATH=/usr/local/go/bin:$GOPATH/bin:$PATH
# Add SSH keys
ADD id_rsa /home/go/.ssh/id_rsa
ADD id_rsa.pub /home/go/.ssh/id_rsa.pub
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
# Configure SSH
&& mkdir -p /root/.ssh \
&& echo "Host *" >> /root/.ssh/config \
&& echo "    StrictHostKeyChecking no" >> /root/.ssh/config \
&& echo "    GlobalKnownHostsFile  /dev/null" >> /root/.ssh/config \
&& echo "    UserKnownHostsFile    /dev/null" >> /root/.ssh/config \
&& chmod 600 /home/go/.ssh/id_rsa \
&& chmod 644 /home/go/.ssh/id_rsa.pub \
# Configure default git user
&& echo "[user]" >> /home/go/.gitconfig \
&& echo "	email = gocd@example.com" >> /home/go/.gitconfig \
&& echo "	name = gocd" >> /home/go/.gitconfig \
# Add repositories and update
&& curl -sL https://deb.nodesource.com/setup_15.x | bash - \
&& apt update && apt -y dist-upgrade \
&& apt install -y apt-utils software-properties-common \
&& apt-add-repository universe \
&& apt-add-repository multiverse \
&& apt update \
# Set Locale
&& apt install -y language-pack-en-base \
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
dh-golang \
dh-make \
dnsutils \
dos2unix \
doxygen \
doxygen-latex \
dpkg \
fabric \
fastjar \
flawfinder \
g++ \
gawk \
gcc \
gcc-8 \
gdb \
gettext \
ghostscript \
git \
g++-multilib \
golang \
golang-golang-x-tools \
gridengine-drmaa-dev \
gsfonts \
gtk-sharp2 \
htop \
imagemagick \
intltool \
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
libglib2.0-0 \
libglib2.0-dev \
libgsl-dev \
libicu-dev \
liblapack-dev \
liblzma-dev \
libncurses5-dev \
libssl-dev \
libtool \
libwine-development \
libxml2 \
libxml2-dev \
libxml2-utils \
libxmlsec1 \
libxmlsec1-dev \
libxmlsec1-openssl \
libxslt1.1 \
libxslt1-dev \
llvm \
lsof \
make \
mawk \
memcached \
mingw-w64 \
mingw-w64-i686-dev \
mingw-w64-tools \
mingw-w64-x86-64-dev \
mongodb \
mysql-client \
mysql-server \
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
php-mongodb \
php-msgpack \
php-mysql \
php-pear \
php-sqlite3 \
php-xdebug \
php-xml \
pkg-config \
postgresql \
postgresql-contrib \
pyflakes \
pylint \
python-all-dev \
python3-all-dev \
python3-pip \
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
time \
tree \
ubuntu-restricted-addons \
ubuntu-restricted-extras \
unzip \
upx-ucl \
valgrind \
vim \
virtualenv \
wget \
wine \
wine64-development-tools \
winetricks \
xmldiff \
xmlindent \
xmlsec1 \
zbar-tools \
zip \
zlib1g \
zlib1g-dev \
# Install extra Python2 dependencies
&& pip2 install --ignore-installed --upgrade ansible \
pyyaml \
dnspython \
pyOpenSSL \
python-novaclient \
shade \
# Install extra Python3 dependencies
&& pip3 install --ignore-installed --upgrade pip \
&& pip3 install --ignore-installed --upgrade \
setuptools \
pyyaml \
autopep8 \
cffi \
coverage \
dnspython \
fabric \
json-spec \
lxml \
nose \
pyOpenSSL \
pypandoc \
pytest \
pytest-benchmark \
pytest-cov \
python-novaclient \
python-jsonschema \
python3-jsonschema \
shade \
schemathesis \
&& cd /tmp \
&& wget https://releases.hashicorp.com/nomad/1.0.5/nomad_1.0.5_linux_amd64.zip \
&& unzip nomad_1.0.5_linux_amd64.zip -d /usr/bin/ \
&& cd /tmp \
&& wget -O /usr/bin/venom https://github.com/ovh/venom/releases/download/v1.0.0-rc.4/venom.linux-amd64 \
&& chmod +x /usr/bin/venom \
&& cd /tmp \
# Install extra npm dependencies
&& npm install --global grunt-cli \
gulp-cli \
jquery \
uglify-js \
csso \
csso-cli \
js-beautify \
# Install R packages
&& Rscript -e "install.packages(c('testthat', 'inline', 'pryr', 'Rcpp'), repos = 'http://cran.us.r-project.org')" \
# HTML Tidy
&& cd /tmp \
&& wget http://launchpadlibrarian.net/413419656/libtidy5deb1_5.6.0-10_amd64.deb \
&& wget http://launchpadlibrarian.net/413419657/tidy_5.6.0-10_amd64.deb \
&& dpkg -i libtidy5deb1_5.6.0-10_amd64.deb tidy_5.6.0-10_amd64.deb \
# Composer
&& cd /tmp \
&& curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
# Install and configure GO
&& cd /tmp \
&& wget https://storage.googleapis.com/golang/go1.16.3.linux-amd64.tar.gz \
&& tar xvf go1.16.3.linux-amd64.tar.gz \
&& rm -rf /usr/local/go \
&& mv go /usr/local \
&& mkdir -p /root/bin \
&& mkdir -p /root/pkg \
&& mkdir -p /root/src \
&& echo 'export GOPATH=/root' >> /root/.profile \
&& echo 'export PATH=/usr/local/go/bin:$GOPATH/bin:$PATH' >> /root/.profile \
&& go version \
# Haskell
&& cd /tmp \
&& curl -sSL https://get.haskellstack.org/ | sh \
# hugo
&& cd /tmp \
&& wget https://github.com/gohugoio/hugo/releases/download/v0.82.0/hugo_0.82.0_Linux-64bit.deb \
&& dpkg -i hugo_0.82.0_Linux-64bit.deb \
# Cleanup temporary data and cache
&& apt clean \
&& apt autoclean \
&& apt -y autoremove \
&& rm -rf /root/.npm/cache/* \
&& rm -rf /root/.composer/cache/* \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
