# FogLAMP GUI Docker

A multi-architecture Docker container for the FogLAMP IIoT Framework GUI, supporting AMD64, ARM64, and ARM/v7 platforms.

## Overview

This project provides a containerized version of the FogLAMP GUI (version 3.1.0) that runs on multiple architectures:
- **linux/amd64** - Ubuntu 24.04 base
- **linux/arm64** - Ubuntu 24.04 base  
- **linux/arm/v7** - Debian Bullseye base

The container includes nginx web server and exposes the FogLAMP GUI on port 80.

## Quick Start

### Using Docker Compose (Recommended)

```bash
docker-compose up -d
```

The GUI will be available at `http://localhost:8000`

### Using Docker Run

```bash
docker run -d -p 8000:80 --name foglamp-gui robraesemann/foglamp-gui:latest
```

## Building from Source

### Multi-Architecture Build

```bash
docker buildx build \
    --platform linux/amd64,linux/arm64,linux/arm/v7 \
    -t robraesemann/foglamp-gui:latest \
    -t robraesemann/foglamp-gui:3.1.0 \
    --push \
    .
```

### Single Architecture Build

```bash
# For current platform
docker build -t foglamp-gui .

# For specific platform
docker build --platform linux/amd64 -t foglamp-gui .
```

## Configuration

The container uses the following configuration:
- **Port**: 80 (nginx web server)
- **FogLAMP Version**: 3.1.0
- **Base Images**: Ubuntu 24.04 (AMD64/ARM64), Debian Bullseye (ARM/v7)

## Docker Compose

The included `docker-compose.yaml` maps container port 80 to host port 8000:

```yaml
services:
  foglamp-gui:
    build: .
    container_name: foglamp-gui
    ports:
      - "8000:80"
```

## Supported Platforms

- linux/amd64
- linux/arm64 
- linux/arm/v7

## Container Details

- **Maintainer**: rob@raesemann.com
- **Author**: Rob Raesemann
- **Version**: 3.1.0
- **Description**: FogLAMP IIoT Framework GUI

## Access

Once running, access the FogLAMP GUI at:
- Docker Compose: `http://localhost:8000`
- Direct Docker: `http://localhost:[mapped-port]`