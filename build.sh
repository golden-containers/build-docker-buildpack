#!/bin/bash

set -Eeuxo pipefail
rm -rf working
mkdir working
cd working

# Checkout upstream

git clone --depth 1 --branch master https://github.com/docker-library/buildpack-deps.git
cd buildpack-deps

# Transform

# This sed syntax is GNU sed specific
[ -z $(command -v gsed) ] && GNU_SED=sed || GNU_SED=gsed

${GNU_SED} -i \
    -e "1 s/FROM.*/FROM ghcr.io\/golden-containers\/buildpack-deps:bullseye/; t" \
    -e "1,// s//FROM ghcr.io\/golden-containers\/buildpack-deps:bullseye/" \
    debian/bullseye/curl/Dockerfile

${GNU_SED} -i \
    -e "1 s/FROM.*/FROM ghcr.io\/golden-containers\/buildpack-deps:bullseye-curl/; t" \
    -e "1,// s//FROM ghcr.io\/golden-containers\/buildpack-deps:bullseye-curl/" \
    debian/bullseye/scm/Dockerfile

${GNU_SED} -i \
    -e "1 s/FROM.*/FROM ghcr.io\/golden-containers\/buildpack-deps:bullseye-scm/; t" \
    -e "1,// s//FROM ghcr.io\/golden-containers\/buildpack-deps:bullseye-scm/" \
    debian/bullseye/Dockerfile

# Build

[ -z "${1:-}" ] && BUILD_LABEL_ARG="" || BUILD_LABEL_ARG=" --label \"${1}\" "

BUILD_PLATFORM=" --platform linux/amd64 "
GCI_URL="ghcr.io/golden-containers"
BUILD_ARGS=" ${BUILD_LABEL_ARG} ${BUILD_PLATFORM} "

docker build debian/bullseye/curl/ --tag ${GCI_URL}/buildpack-deps:bullseye-curl ${BUILD_ARGS}
docker build debian/bullseye/scm/ --tag ${GCI_URL}/buildpack-deps:bullseye-scm ${BUILD_ARGS}
docker build debian/bullseye/ --tag ${GCI_URL}/buildpack-deps:bullseye ${BUILD_ARGS}

# Push

docker push ${GCI_URL}/buildpack-deps -a
