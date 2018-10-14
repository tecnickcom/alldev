# Dockerfile
#
# Development environment based on Ubuntu 16.04 (Xenial)
#
# @author      Nicola Asuni <info@tecnick.com>
# @copyright   2016-2017 Nicola Asuni - Tecnick.com LTD
# @license     MIT (see LICENSE)
# @link        https://github.com/tecnickcom/alldev
# ------------------------------------------------------------------------------

FROM phusion/baseimage
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
&& curl -sL https://deb.nodesource.com/setup_8.x | bash - \
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
automake \
autotools-dev \
binfmt-support \
binutils-mingw-w64 \
build-essential \
bzip2 \
checkinstall \
clang \
clang-3.6 \
clang-3.9 \
clang-4.0 \
clang-5.0 \
clang-6.0 \
clang-format \
clang-format-3.6 \
clang-format-3.9 \
clang-format-4.0 \
clang-format-5.0 \
clang-format-6.0 \
clang-tidy \
clang-tidy-3.6 \
clang-tidy-3.9 \
clang-tidy-4.0 \
clang-tidy-5.0 \
clang-tidy-6.0 \
cmake \
cppcheck \
curl \
debhelper \
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
gcc-4.8 \
gcc-4.9 \
gcc-5 \
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
libgsl2 \
libgsl-dev \
libicu-dev \
liblapack-dev \
liblzma-dev \
libncurses5-dev \
libreadline6 \
libsane-extras \
libssl1.0.0 \
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
llvm-5.0 \
lsof \
make \
mawk \
memcached \
mingw-w64 \
mingw-w64-i686-dev \
mingw-w64-tools \
mingw-w64-x86-64-dev \
mongodb \
mono-complete \
mono-tools-devel \
mysql-client \
mysql-server \
mysql-utilities \
nano \
nodejs \
nsis \
nsis-pluginapi \
nuget \
openjdk-8-jdk \
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
postgresql-contrib-9.5 \
pyflakes \
pylint \
python \
python3 \
python3-all \
python3-all-dev \
python3-dev \
python3-setuptools \
python-all \
python-all-dev \
python-dev \
python-setuptools \
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
&& nuget update -self \
# Install extra Python2 dependencies
&& easy_install --upgrade pip \
&& pip2 install --ignore-installed --upgrade ansible \
pyyaml \
dnspython \
pyOpenSSL \
python-novaclient \
shade \
# Install extra Python3 dependencies
&& easy_install3 --upgrade pip \
&& pip3 install --ignore-installed --upgrade ansible \
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
shade \
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
&& wget https://github.com/htacg/tidy-html5/releases/download/5.4.0/tidy-5.4.0-64bit.deb \
&& dpkg -i tidy-5.4.0-64bit.deb \
# Composer
&& cd /tmp \
&& curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
# Install and configure GO
&& wget https://storage.googleapis.com/golang/go1.11.1.linux-amd64.tar.gz \
&& tar xvf go1.11.1.linux-amd64.tar.gz \
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
&& wget https://github.com/gohugoio/hugo/releases/download/v0.47.1/hugo_0.47.1_Linux-64bit.deb \
&& dpkg -i hugo_0.47.1_Linux-64bit.deb \
# Cleanup temporary data and cache
&& apt-get clean \
&& apt-get autoclean \
&& apt-get -y autoremove \
&& rm -rf /root/.npm/cache/* \
&& rm -rf /root/.composer/cache/* \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
