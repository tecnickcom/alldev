# Dockerfile
#
# Go language basic build environment
#
# @author      Nicola Asuni <info@tecnick.com>
# @copyright   2016-2020 Nicola Asuni - Tecnick.com LTD
# @license     MIT (see LICENSE)
# @link        https://github.com/tecnickcom/alldev
# ------------------------------------------------------------------------------

FROM golang:1.16
ENV PATH=/root/.local/bin:$PATH
RUN apt update \
&& apt -y install \
devscripts \
fakeroot \
debhelper \
pkg-config \
alien \
rpm \
dh-make \
dh-golang \
upx-ucl \
python \
python-pip \
python-jsonschema
