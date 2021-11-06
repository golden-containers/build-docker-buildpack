rm -rf buildpack-deps
git clone --depth 1 --branch master https://github.com/docker-library/buildpack-deps.git
cd buildpack-deps

sed -i -e "1 s/FROM.*/FROM ghcr.io\/jgowdy\/bullseye/; t" -e "1,// s//FROM ghcr.io\/jgowdy\/bullseye/" debian/bullseye/curl/Dockerfile
sed -i -e "1 s/FROM.*/FROM ghcr.io\/jgowdy\/bullseye-curl/; t" -e "1,// s//FROM ghcr.io\/jgowdy\/bullseye-curl/" debian/bullseye/scm/Dockerfile
sed -i -e "1 s/FROM.*/FROM ghcr.io\/jgowdy\/bullseye-scm/; t" -e "1,// s//FROM ghcr.io\/jgowdy\/bullseye-scm/" debian/bullseye/Dockerfile


