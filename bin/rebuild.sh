#!/bin/bash
set -euo pipefail

echo "Quick rebuild with cache..."
# Stop and remove any existing containers
docker compose -f docker/docker-compose.yml down --remove-orphans || true
docker rm -f alchemist-lab 2>/dev/null || true

echo "Building Docker image (using cache)..."
docker compose -f docker/docker-compose.yml build

echo "Starting container..."
docker compose -f docker/docker-compose.yml up -d

echo "Entering container shell..."
docker exec -it alchemist-lab zsh