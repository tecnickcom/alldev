# Dockerfile
#
# Development environment based on Ubuntu 16.04 (Xenial)
#
# @author      Nicola Asuni <info@tecnick.com>
# @copyright   2016-2017 Nicola Asuni - Tecnick.com LTD
# @license     MIT (see LICENSE)
# @link        https://github.com/tecnickcom/alldev
# ------------------------------------------------------------------------------

FROM gocd/gocd-agent-ubuntu-16.04:v17.8.0
MAINTAINER info@tecnick.com

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

# Add i386 architecture
&& dpkg --add-architecture i386 \

# Add repositories and update
&& apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
&& echo "deb http://download.mono-project.com/repo/debian wheezy main" | tee /etc/apt/sources.list.d/mono-xamarin.list \
&& apt-get update && apt-get -y dist-upgrade \
&& apt-get install -y apt-utils software-properties-common python-software-properties \
&& apt-add-repository universe \
&& apt-add-repository multiverse \
&& apt-get update \

# Repository for node
&& curl -sL https://deb.nodesource.com/setup_6.x | bash - \

# Set Locale
&& apt-get install -y language-pack-en-base \
&& locale-gen en_US en_US.UTF-8 \
&& dpkg-reconfigure locales \

# install development packages and debugging tools
&& apt-get install -y \
alien \
apache2 \
astyle \
autoconf \
autotools-dev \
automake \
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
gettext \
ghostscript \
git \
g++-multilib \
golang \
golang-golang-x-tools \
gsfonts \
gtk-sharp2 \
imagemagick \
intltool \
jq \
lcov \
libboost-all-dev \
libc6 \
libc6-dev \
libc6-dev-i386 \
libffi-dev \
libglib2.0-0 \
libglib2.0-dev \
libreadline6 \
libssl1.0.0 \
libssl-dev \
libtool \
libwine-development \
libxml2 \
libxml2-dev \
libxmlsec1 \
libxmlsec1-dev \
libxmlsec1-openssl \
libxslt1.1 \
libxslt1-dev \
liblzma-dev \
lsof \
make \
memcached \
mingw-w64 \
mingw-w64-i686-dev \
mingw-w64-tools \
mingw-w64-x86-64-dev \
mongodb \
mono-complete \
mysql-client \
mysql-server \
mysql-utilities \
nano \
nodejs \
nuget \
nsis \
nsis-pluginapi \
openjdk-8-jdk \
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
xmlsec1 \
zbar-tools \
zip \
zlib1g \
zlib1g-dev \

&& nuget update -self \

# Mono tools
&& git clone https://github.com/mono/mono-tools.git \
&& cd mono-tools \
&& export enable_gtkhtml=no \
&& export enable_gecko=no \
&& export enable_webkit=no \
&& ./autogen.sh \
&& make \
&& make install \

# Install extra python dependencies
&& pip install --upgrade pip \
&& pip install --upgrade cffi \
&& pip install --upgrade autopep8 \
&& pip install --upgrade fabric \
&& pip install --upgrade json-spec \
&& pip install --upgrade pypandoc \

# Install extra npm dependencies
&& npm install --global grunt-cli \
&& npm install --global gulp-cli \
&& npm install --global jquery \
&& npm install --global uglify-js \
&& npm install --global csso \
&& npm install --global csso-cli \

# HTML Tidy
&& cd /tmp \
&& wget https://github.com/htacg/tidy-html5/releases/download/5.4.0/tidy-5.4.0-64bit.deb \
&& dpkg -i tidy-5.4.0-64bit.deb \

# Composer
&& cd /tmp \
&& curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \

# Install and configure GO
&& wget https://storage.googleapis.com/golang/go1.9.linux-amd64.tar.gz \
&& tar xvf go1.9.linux-amd64.tar.gz \
&& rm -rf /usr/local/go \
&& mv go /usr/local \
&& mkdir -p /root/bin \
&& mkdir -p /root/pkg \
&& mkdir -p /root/src \
&& echo 'export GOPATH=/root' >> /root/.profile \
&& echo 'export PATH=/usr/local/go/bin:$GOPATH/bin:$PATH' >> /root/.profile \
&& go version \

# hugo
&& cd /tmp \
&& wget https://github.com/gohugoio/hugo/releases/download/v0.28/hugo_0.28_Linux-64bit.deb \
&& dpkg -i hugo_0.28_Linux-64bit.deb \

# Cleanup temporary data and cache
&& apt-get clean \
&& rm -rf /root/.npm/cache/* \
&& rm -rf /root/.composer/cache/* \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
