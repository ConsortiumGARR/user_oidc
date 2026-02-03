#!/bin/bash
set -e

ACTION="$1"

case "$ACTION" in
    composer)
        # Install php dependencies
        docker run --rm -v "$(pwd):/app" -w /app composer:2 composer install
        ;;
    node)
        # Install node dependencies. npm ci use package-lock.json
        docker run --rm -v "$(pwd):/app" -w /app node:lts-alpine npm ci
        ;;
    build)
        # Compile frontend
        docker run --rm -v "$(pwd):/app" -w /app node:lts-alpine npm run build
        ;;
    krankerl)
        # Package using krankerl
        mkdir -p build
        docker run --rm \
            --mount type=bind,source="$(pwd)"/build,target=/opt/build \
            ghcr.io/rizlas/krankerl-builder:latest \
            https://github.com/ConsortiumGARR/user_oidc.git \
            garr
        ;;
    all|"")
        docker run --rm -v "$(pwd):/app" -w /app composer:2 composer install
        docker run --rm -v "$(pwd):/app" -w /app node:lts-alpine npm ci
        docker run --rm -v "$(pwd):/app" -w /app node:lts-alpine npm run build
        mkdir -p build
        docker run --rm \
            --mount type=bind,source="$(pwd)"/build,target=/opt/build \
            ghcr.io/rizlas/krankerl-builder:latest \
            https://github.com/ConsortiumGARR/user_oidc.git \
            garr
        ;;
    *)
        echo "Usage: $0 [composer|node|build|krankerl|all]"
        exit 1
        ;;
esac
