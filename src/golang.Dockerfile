# Dockerfile
#
# Go language basic build environment
#
# @author      Nicola Asuni <info@tecnick.com>
# @copyright   2016-2026 Nicola Asuni - Tecnick.com LTD
# @license     MIT (see LICENSE)
# @link        https://github.com/tecnickcom/alldev
# ------------------------------------------------------------------------------
ARG GO_VERSION="1.25"
FROM golang:${GO_VERSION}
ARG GO_VERSION
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
LABEL "org.opencontainers.image.authors"="info@tecnick.com"
LABEL "org.opencontainers.image.url"="https://github.com/tecnickcom/alldev"
LABEL "org.opencontainers.image.documentation"="https://github.com/tecnickcom/alldev/blob/main/README.md"
LABEL "org.opencontainers.image.source"="https://github.com/tecnickcom/alldev/blob/main/src/golang.Dockerfile"
LABEL "org.opencontainers.image.vendor"="tecnickcom"
LABEL "org.opencontainers.image.licenses"="MIT"
LABEL "org.opencontainers.image.title"="golang"
LABEL "org.opencontainers.image.description"="Go (golang) image with extra tools"
LABEL "org.opencontainers.image.base.name"="golang:${GO_VERSION}"
