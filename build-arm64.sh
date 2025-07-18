#!/bin/sh

version='3.0.0'

docker buildx build \
	--platform linux/arm64 \
	--build-arg FOGLAMP_VERSION=$version \
	--build-arg FOGLAMP_PLATFORM=aarch64 \
	--build-arg DOCKER_IMAGE=ubuntu:18.04 \
	--build-arg FOGLAMP_DISTRIBUTION=ubuntu1804 \
	--push \
	--tag robraesemann/foglamp-gui:$version-arm64 \
    --tag robraesemann/foglamp-gui:latest-arm64 \
    .