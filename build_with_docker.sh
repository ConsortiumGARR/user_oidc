#!/bin/bash
set -e

ACTION="$1"

case "$ACTION" in
    composer)
        # Install php dependencies
        docker run --rm -v "$(pwd):/app" -w /app composer:2.6 composer install
        ;;
    node)
        # Install node dependencies. npm ci use package-lock.json
        docker run --rm -v "$(pwd):/app" -w /app node:22 npm ci
        ;;
    build)
        # Compile frontend
        docker run --rm -v "$(pwd):/app" -w /app node:22 npm run build
        ;;
    all|"")
        docker run --rm -v "$(pwd):/app" -w /app composer:2.6 composer install
        docker run --rm -v "$(pwd):/app" -w /app node:22 npm ci
        docker run --rm -v "$(pwd):/app" -w /app node:22 npm run build
        ;;
    *)
        echo "Usage: $0 [composer|node|build|all]"
        exit 1
        ;;
esac
