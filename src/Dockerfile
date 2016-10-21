# Dockerfile
#
# Development environment based on Ubuntu 16.04 (Xenial)
#
# @author      Nicola Asuni <nicola.asuni@tecnickcom.com>
# @copyright   2016-2016 Nicola Asuni - Tecnick.com LTD
# @license     http://www.gnu.org/copyleft/lesser.html GNU-LGPL v3 (see LICENSE)
# @link        https://github.com/tecnickcom/alldev
# ------------------------------------------------------------------------------

FROM phusion/baseimage
MAINTAINER info@tecnick.com

ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
ENV HOME /root
ENV DISPLAY :0
ENV GOPATH=/root
ENV PATH=/usr/local/go/bin:$GOPATH/bin:$PATH


FROM phusion/baseimage
MAINTAINER info@tecnick.com

ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
ENV HOME /root
ENV DISPLAY :0
ENV GOPATH=/root
ENV PATH=/usr/local/go/bin:$GOPATH/bin:$PATH

# Add i386 architecture
RUN dpkg --add-architecture i386

# Add repositories and update
RUN apt-get update && apt-get -y dist-upgrade && \
apt-get install -y apt-utils software-properties-common python-software-properties && \
apt-add-repository universe && \
apt-add-repository multiverse && \
apt-get update

# install development packages and debugging tools
RUN apt-get install -y \
alien \
apache2 \
astyle \
autoconf \
autotools-dev \
binfmt-support \
binutils-mingw-w64 \
build-essential \
cmake \
curl \
debhelper \
devscripts \
dh-golang \
dh-make \
dos2unix \
doxygen \
doxygen-latex \
fabric \
fastjar \
flawfinder \
g++ \
gcc \
gdb \
ghostscript \
git \
g++-multilib \
golang \
golang-golang-x-tools \
gsfonts \
imagemagick \
lcov \
libboost-all-dev \
libc6 \
libc6-dev \
libc6-dev-i386 \
libffi-dev \
libglib2.0-0 \
libglib2.0-dev \
libssl1.0.0 \
libssl-dev \
libwine-development \
libxml2 \
libxml2-dev \
libxmlsec1 \
libxmlsec1-dev \
libxmlsec1-openssl \
libxslt1.1 \
libxslt1-dev \
lsof \
make \
mingw-w64 \
mingw-w64-i686-dev \
mingw-w64-tools \
mingw-w64-x86-64-dev \
mongodb \
mysql-client \
mysql-server \
mysql-utilities \
nano \
npm \
openssh-client \
openssh-server \
openssl \
parallel \
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
postgresql-contrib-9.5 \
pyflakes \
pylint \
python \
python-all \
python-all-dev \
python-coverage \
python-dev \
python-lxml \
python-nose \
python-pip \
python-setuptools \
redis-server \
redis-tools \
rpm \
rsync \
ruby-all-dev \
screen \
ssh \
strace \
swig \
texlive-base \
ubuntu-restricted-addons \
ubuntu-restricted-extras \
upx-ucl \
valgrind \
vim \
wget \
wine \
wine64-development-tools \
winetricks \
zbar-tools \
zlib1g \
zlib1g-dev

# Configure SSH
RUN mkdir -p /root/.ssh && echo "Host github.com\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config

# Install extra python dependencies
RUN pip install --upgrade pip && \
pip install cffi && \
pip install --upgrade autopep8 && \
pip install fabric

# Install extra npm dependencies
RUN cd /usr/bin && \
ln -s nodejs node && \
npm install --global grunt-cli && \
npm install --global gulp-cli && \
npm install --global jquery && \
npm install --global uglify-js && \
npm install --global uglifyjs && \
npm install --global csso && \
npm install --global html-minifier

# Install and configure GO
RUN wget https://storage.googleapis.com/golang/go1.7.3.linux-amd64.tar.gz && \
tar xvf go1.7.3.linux-amd64.tar.gz && \
mv go /usr/local && \
mkdir -p /root/bin && \
mkdir -p /root/pkg && \
mkdir -p /root/src && \
echo 'export GOPATH=/root' >> /root/.profile && \
echo 'export PATH=/usr/local/go/bin:$GOPATH/bin:$PATH' >> /root/.profile && \
go version
