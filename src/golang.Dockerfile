# Dockerfile
#
# Go language basic build environment
#
# @author      Nicola Asuni <info@tecnick.com>
# @copyright   2016-2024 Nicola Asuni - Tecnick.com LTD
# @license     MIT (see LICENSE)
# @link        https://github.com/tecnickcom/alldev
# ------------------------------------------------------------------------------
ARG GO_VERSION="1.23"
FROM golang:${GO_VERSION}
ENV PATH=/root/.local/bin:$PATH
ENV USER=root
RUN apt update \
&& apt -y install \
alien \
debhelper \
devscripts \
dh-golang \
dh-make \
fakeroot \
pkg-config \
python3-all-dev \
python3-pip \
python3-venv \
rpm \
sudo \
&& pip install --break-system-packages --upgrade \
check-jsonschema \
jsonschema \
yamllint \
&& go install github.com/mikefarah/yq/v4@latest \
&& go install github.com/hairyhenderson/gomplate/v3/cmd/gomplate@latest
