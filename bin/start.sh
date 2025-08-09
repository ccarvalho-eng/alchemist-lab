#!/bin/bash
set -euo pipefail

# Check if container exists and is running
if ! docker ps -q --filter "name=alchemist-lab" | grep -q .; then
    echo "Container 'alchemist-lab' is not running."
    
    # Check if container exists but is stopped
    if docker ps -aq --filter "name=alchemist-lab" | grep -q .; then
        echo "Starting existing container..."
        docker start alchemist-lab
    else
        echo "Container doesn't exist. Please run ./bin/reset.sh first."
        exit 1
    fi
fi

echo "Entering container shell..."
docker exec -it alchemist-lab zsh