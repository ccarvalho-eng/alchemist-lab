#!/bin/bash
set -euo pipefail

# Check if container exists and is running
if ! docker ps -q --filter "name=arch-dev" | grep -q .; then
    echo "Container 'arch-dev' is not running."
    
    # Check if container exists but is stopped
    if docker ps -aq --filter "name=arch-dev" | grep -q .; then
        echo "Starting existing container..."
        docker start arch-dev
    else
        echo "Container doesn't exist. Please run ./bin/setup.sh first."
        exit 1
    fi
fi

echo "Entering container shell..."
docker exec -it arch-dev zsh