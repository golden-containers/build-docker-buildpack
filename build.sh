#!/bin/sh

set -xe
rm -rf working
mkdir working
cd working

# Checkout upstream

git clone --depth 1 --branch master https://github.com/docker-library/buildpack-deps.git
cd buildpack-deps

# Transform

sed -i -e "1 s/FROM.*/FROM ghcr.io\/golden-containers\/buildpack-deps:bullseye/; t" -e "1,// s//FROM ghcr.io\/golden-containers\/buildpack-deps:bullseye/" debian/bullseye/curl/Dockerfile
echo "LABEL ${1:-DEBUG=TRUE}" >> debian/bullseye/curl/Dockerfile

sed -i -e "1 s/FROM.*/FROM ghcr.io\/golden-containers\/buildpack-deps:bullseye-curl/; t" -e "1,// s//FROM ghcr.io\/golden-containers\/buildpack-deps:bullseye-curl/" debian/bullseye/scm/Dockerfile
echo "LABEL ${1:-DEBUG=TRUE}" >> debian/bullseye/scm/Dockerfile

sed -i -e "1 s/FROM.*/FROM ghcr.io\/golden-containers\/buildpack-deps:bullseye-scm/; t" -e "1,// s//FROM ghcr.io\/golden-containers\/buildpack-deps:bullseye-scm/" debian/bullseye/Dockerfile
echo "LABEL ${1:-DEBUG=TRUE}" >> debian/bullseye/Dockerfile

# Build

docker build --tag ghcr.io/golden-containers/buildpack-deps:bullseye-curl debian/bullseye/curl
docker build --tag ghcr.io/golden-containers/buildpack-deps:bullseye-scm debian/bullseye/scm
docker build --tag ghcr.io/golden-containers/buildpack-deps:bullseye debian/bullseye

# Push

docker push ghcr.io/golden-containers/buildpack-deps -a
