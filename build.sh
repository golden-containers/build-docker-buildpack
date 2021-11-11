#!/bin/sh

set -xe
rm -rf working
mkdir working
cd working

# Checkout upstream

git clone --depth 1 --branch master https://github.com/docker-library/buildpack-deps.git
cd buildpack-deps

# Transform

BASHBREW_SCRIPTS=../.. ./apply-templates.sh

sed -i -e "1 s/FROM.*/FROM ghcr.io\/golden-containers\/bullseye/; t" -e "1,// s//FROM ghcr.io\/golden-containers\/bullseye/" debian/bullseye/curl/Dockerfile
sed -i -e "1 s/FROM.*/FROM ghcr.io\/golden-containers\/bullseye-curl/; t" -e "1,// s//FROM ghcr.io\/golden-containers\/bullseye-curl/" debian/bullseye/scm/Dockerfile
sed -i -e "1 s/FROM.*/FROM ghcr.io\/golden-containers\/bullseye-scm/; t" -e "1,// s//FROM ghcr.io\/golden-containers\/bullseye-scm/" debian/bullseye/Dockerfile

# Build

docker build --tag ghcr.io/golden-containers/buildpack-deps:bullseye-curl buildpack-deps/debian/bullseye/curl
docker build --tag ghcr.io/golden-containers/buildpack-deps:bullseye-scm buildpack-deps/debian/bullseye/scm
docker build --tag ghcr.io/golden-containers/buildpack-deps:bullseye buildpack-deps/debian/bullseye

# Push

docker push ghcr.io/golden-containers/buildpack-deps:bullseye-curl
docker push ghcr.io/golden-containers/buildpack-deps:bullseye-scm
docker push ghcr.io/golden-containers/buildpack-deps:bullseye
