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

${GNU_SED} -i -e "1 s/FROM.*/FROM ghcr.io\/golden-containers\/buildpack-deps:bullseye/; t" -e "1,// s//FROM ghcr.io\/golden-containers\/buildpack-deps:bullseye/" debian/bullseye/curl/Dockerfile

${GNU_SED} -i -e "1 s/FROM.*/FROM ghcr.io\/golden-containers\/buildpack-deps:bullseye-curl/; t" -e "1,// s//FROM ghcr.io\/golden-containers\/buildpack-deps:bullseye-curl/" debian/bullseye/scm/Dockerfile

${GNU_SED} -i -e "1 s/FROM.*/FROM ghcr.io\/golden-containers\/buildpack-deps:bullseye-scm/; t" -e "1,// s//FROM ghcr.io\/golden-containers\/buildpack-deps:bullseye-scm/" debian/bullseye/Dockerfile

# Build

docker build debian/bullseye/curl/ --platform linux/amd64 --tag ghcr.io/golden-containers/buildpack-deps:bullseye-curl --label ${1:-DEBUG=TRUE}
docker build debian/bullseye/scm/ --platform linux/amd64 --tag ghcr.io/golden-containers/buildpack-deps:bullseye-scm --label ${1:-DEBUG=TRUE}
docker build debian/bullseye/ --platform linux/amd64 --tag ghcr.io/golden-containers/buildpack-deps:bullseye --label ${1:-DEBUG=TRUE}

# Push

docker push ghcr.io/golden-containers/buildpack-deps -a
