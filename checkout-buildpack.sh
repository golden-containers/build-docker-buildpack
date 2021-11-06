#!/bin/sh

set -xe

rm -rf buildpack-deps
git clone --depth 1 --branch master https://github.com/docker-library/buildpack-deps.git
cd buildpack-deps

sed -i -e "1 s/FROM.*/FROM ghcr.io\/golden-containers\/bullseye/; t" -e "1,// s//FROM ghcr.io\/golden-containers\/bullseye/" debian/bullseye/curl/Dockerfile
sed -i -e "1 s/FROM.*/FROM ghcr.io\/golden-containers\/bullseye-curl/; t" -e "1,// s//FROM ghcr.io\/golden-containers\/bullseye-curl/" debian/bullseye/scm/Dockerfile
sed -i -e "1 s/FROM.*/FROM ghcr.io\/golden-containers\/bullseye-scm/; t" -e "1,// s//FROM ghcr.io\/golden-containers\/bullseye-scm/" debian/bullseye/Dockerfile


