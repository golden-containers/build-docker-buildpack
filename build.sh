#!/bin/bash

set -Eeuxo pipefail
rm -rf working
mkdir working
cd working

# Checkout upstream

git clone --depth 1 --branch master https://github.com/docker-library/buildpack-deps.git
cd buildpack-deps

# Transform

sed -i -e "1 s/FROM.*/FROM ghcr.io\/golden-containers\/buildpack-deps:bullseye/; t" -e "1,// s//FROM ghcr.io\/golden-containers\/buildpack-deps:bullseye/" debian/bullseye/curl/Dockerfile

sed -i -e "1 s/FROM.*/FROM ghcr.io\/golden-containers\/buildpack-deps:bullseye-curl/; t" -e "1,// s//FROM ghcr.io\/golden-containers\/buildpack-deps:bullseye-curl/" debian/bullseye/scm/Dockerfile

sed -i -e "1 s/FROM.*/FROM ghcr.io\/golden-containers\/buildpack-deps:bullseye-scm/; t" -e "1,// s//FROM ghcr.io\/golden-containers\/buildpack-deps:bullseye-scm/" debian/bullseye/Dockerfile

# Build

docker build debian/bullseye/curl/ --tag ghcr.io/golden-containers/buildpack-deps:bullseye-curl --label ${1:-DEBUG=TRUE}
docker build debian/bullseye/scm/ --tag ghcr.io/golden-containers/buildpack-deps:bullseye-scm --label ${1:-DEBUG=TRUE}
docker build debian/bullseye/ --tag ghcr.io/golden-containers/buildpack-deps:bullseye --label ${1:-DEBUG=TRUE}

# Push

docker push ghcr.io/golden-containers/buildpack-deps -a
