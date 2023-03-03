#!/bin/sh

version='2.1.0'

docker buildx build \
	--platform linux/amd64 \
	--build-arg FOGLAMP_VERSION=$version \
	--build-arg FOGLAMP_PLATFORM=x86_64 \
	--build-arg DOCKER_IMAGE=ubuntu:20.04 \
	--build-arg FOGLAMP_DISTRIBUTION=ubuntu2004 \
	--push \
	--tag robraesemann/foglamp-gui:$version \
	--tag robraesemann/foglamp-gui:latest \
	.