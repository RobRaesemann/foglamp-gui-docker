



docker buildx build \
    --platform linux/amd64,linux/arm64,linux/arm/v7 \
    -t robraesemann/foglamp-gui:latest \
    -t robraesemann/foglamp-gui:3.1.0 \
    --push \
    .