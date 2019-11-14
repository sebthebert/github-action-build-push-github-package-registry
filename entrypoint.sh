#!/bin/bash

set -e

#
# Validate inputs GITHUB_PACKAGE_REGISTRY_LOGIN, GITHUB_PACKAGE_REGISTRY_PASSWORD & IMAGE_NAME
#
if [[ -z "$INPUT_GITHUB_PACKAGE_REGISTRY_LOGIN" ]]; then
	echo "GITHUB_PACKAGE_REGISTRY_LOGIN required."
	exit 1
fi
if [[ -z "$INPUT_GITHUB_PACKAGE_REGISTRY_PASSWORD" ]]; then
	echo "GITHUB_PACKAGE_REGISTRY_PASSWORD required."
	exit 1
fi
if [[ -z "$INPUT_IMAGE_NAME" ]]; then
	echo "IMAGE_NAME required."
	exit 1
fi

# Login to Docker Github Package Registry (docker.pkg.github.com)
echo ${INPUT_GITHUB_PACKAGE_REGISTRY_PASSWORD} | docker login -u ${INPUT_GITHUB_PACKAGE_REGISTRY_LOGIN} --password-stdin docker.pkg.github.com

# Set Local Variables
IMG_TAG=$(echo "${GITHUB_SHA}" | cut -c1-12)
IMG_NAME="docker.pkg.github.com/${GITHUB_REPOSITORY,,}/${INPUT_IMAGE_NAME}"

# Build The Container
docker build -t ${IMG_NAME}:${IMG_TAG} -f ${INPUT_DOCKERFILE_PATH:-Dockerfile} ${INPUT_BUILD_CONTEXT:-.}

# Push two versions, with and without the SHA
docker push ${BASE_NAME}
docker push ${SHA_NAME}

echo "::set-output name=IMAGE_SHA_NAME::${SHA_NAME}"
echo "::set-output name=IMAGE_URL::https://github.com/${GITHUB_REPOSITORY}/packages"
