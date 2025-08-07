#!/bin/bash
set -euo pipefail

echo "Cleaning up old containers..."
docker compose down --remove-orphans

echo "Building Docker image..."
docker compose build --no-cache

echo "Starting container..."
docker compose up -d

echo "Entering container shell..."
docker exec -it arch-dev zsh
