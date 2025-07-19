ARG FOGLAMP_DISTRIBUTION
ARG FOGLAMP_PLATFORM
ARG OS_CODENAME

##### AMD64 section ##### 
FROM --platform=linux/amd64 ubuntu:24.04 AS stage-amd64
ARG FOGLAMP_DISTRIBUTION=ubuntu2404
ARG FOGLAMP_PLATFORM=x86_64
ARG OS_CODENAME=noble

##### AARCH64 section #####
FROM --platform=linux/aarch64 ubuntu:24.04 AS stage-arm64
ARG FOGLAMP_DISTRIBUTION=ubuntu2404
ARG FOGLAMP_PLATFORM=aarch64
ARG OS_CODENAME=noble

##### ARM/v7 section ##### 
FROM --platform=linux/arm/v7 debian:bullseye-slim AS stage-arm
ARG FOGLAMP_DISTRIBUTION=bookworm
ARG FOGLAMP_PLATFORM=armv7l
ARG OS_CODENAME=bookworm

##### Final arm/amd section ##### 
# pick the right base image created before based on architecture (automatically set by docker depending on chosen architecture)
ARG TARGETARCH
# Select final stage based on TARGETARCH ARG
FROM stage-${TARGETARCH} AS base

# Set FogLAMP version, distribution, and platform
ENV FOGLAMP_VERSION=3.1.0
ENV FOGLAMP_DISTRIBUTION=$FOGLAMP_DISTRIBUTION
ENV FOGLAMP_PLATFORM=$FOGLAMP_PLATFORM

# Install dependencies, add Dianomic repository and key
RUN export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 && \
    apt-get update --allow-insecure-repositories && \
    apt-get install -y --no-install-recommends --allow-unauthenticated -o APT::Install-Suggests=false -o APT::Install-Recommends=false \
    wget \
    gnupg \
    ca-certificates \
    apt-transport-https && \
    rm -rf /var/lib/apt/lists/* && \
    wget -q -O /tmp/dianomic.gpg http://archives.dianomic.com/KEY.gpg && \
    gpg --dearmor --output /usr/share/keyrings/dianomic-keyring.gpg /tmp/dianomic.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/dianomic-keyring.gpg] http://archives.dianomic.com/foglamp/${FOGLAMP_VERSION}/${FOGLAMP_DISTRIBUTION}/${FOGLAMP_PLATFORM}/ / " >> /etc/apt/sources.list.d/dianomic.list && \
    rm /tmp/dianomic.gpg && \
    apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install FogLAMP GUI - Workaoround systemctl issues in containers
RUN echo "#!/bin/sh\nexit 0" > /usr/bin/systemctl && \
    chmod +x /usr/bin/systemctl && \ 
    apt-get update && \
    apt-get install -y --no-install-recommends nginx && \
    # Install FogLAMP - systemctl and template file errors are expected in containers
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends foglamp-gui && \
    # Clean up
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* && \
    echo "FogLAMP GUI installation completed successfully"

# Startup script to launch nginx and keep container running
# Tails nginx logs to keep container alive
RUN echo "#!/bin/bash" > /usr/local/bin/start.sh && \
    echo "nginx &"  >> /usr/local/bin/start.sh && \
    echo "echo 'FogLAMP GUI is running...'" >> /usr/local/bin/start.sh && \
    echo "tail -f /var/log/nginx/access.log /var/log/nginx/error.log" >> /usr/local/bin/start.sh && \
    chmod +x /usr/local/bin/start.sh

EXPOSE 80

CMD ["bash","/usr/local/bin/start.sh"]

LABEL maintainer="rob@raesemann.com" \
  author="Rob Raesemann" \
  target="Docker" \
  version="${FOGLAMP_VERSION}" \
  description="FogLAMP IIoT Framework GUI"