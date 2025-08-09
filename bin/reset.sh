#!/bin/bash
set -euo pipefail

echo "Cleaning up old containers..."
# Stop and remove any existing containers
docker compose -f docker/docker-compose.yml down --remove-orphans || true
# Also remove any standalone container with this name
docker rm -f alchemist-lab 2>/dev/null || true

echo "Building Docker image..."
docker compose -f docker/docker-compose.yml build --no-cache

echo "Starting container..."
docker compose -f docker/docker-compose.yml up -d

echo "Entering container shell..."
docker exec -it alchemist-lab zsh
