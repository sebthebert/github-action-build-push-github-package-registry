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

# Set IMG_NAME & IMG_TAG
IMG_NAME="docker.pkg.github.com/${GITHUB_REPOSITORY,,}/${INPUT_IMAGE_NAME}"

if [[ ${GITHUB_REF} == refs/tags/* ]]; then
	IMG_TAG=$( echo ${GITHUB_REF##*/})
else
	IMG_TAG=$(echo "${GITHUB_SHA}" | cut -c1-12)
fi

# Build image
docker build -t ${IMG_NAME}:${IMG_TAG} -f ${INPUT_DOCKERFILE_PATH:-Dockerfile} ${INPUT_BUILD_CONTEXT:-.}

# Login to Docker Github Package Registry (docker.pkg.github.com)
echo ${INPUT_GITHUB_PACKAGE_REGISTRY_PASSWORD} | docker login -u ${INPUT_GITHUB_PACKAGE_REGISTRY_LOGIN} --password-stdin docker.pkg.github.com

# Push image
docker push ${IMG_NAME}:${IMG_TAG}

# Output DOCKER_IMAGE_NAME & DOCKER_IMAGE_URL
echo "::set-output name=DOCKER_IMAGE_NAME::${IMG_NAME}:${IMG_TAG}"
echo "::set-output name=DOCKER_IMAGE_URL::https://github.com/${GITHUB_REPOSITORY,,}/packages"
