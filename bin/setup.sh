#!/bin/bash
set -euo pipefail

echo "Cleaning up old containers..."
docker compose -f docker/docker-compose.yml down --remove-orphans

echo "Building Docker image..."
docker compose -f docker/docker-compose.yml build --no-cache

echo "Starting container..."
docker compose -f docker/docker-compose.yml up -d

echo "Entering container shell..."
docker exec -it arch-dev zsh
