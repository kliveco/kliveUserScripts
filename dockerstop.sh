#!/bin/bash

# Docker Containers you would like to stop
# Made with user scripts in mind, set a cron and you should be off to the races
# Little over the top but whatever - TLDR: docker stop service works wonders lol
CONTAINERS=(
    "docker name"
    # Add more container names as needed
)

# Log Date Time
date

# Loop through container names
for CONTAINER in "${CONTAINERS[@]}"; do
    echo "----------------------------"
    echo "Checking container: $CONTAINER"

    # Check if the container is running
    if docker ps --filter "name=^/${CONTAINER}$" --format '{{.Names}}' | grep -q "^${CONTAINER}$"; then
        echo "[OK] Stopping Docker container: $CONTAINER"
        docker stop "$CONTAINER"
    else
        echo "[ERROR] Container $CONTAINER is not running."
    fi
done

echo -e "----------------------------\n[OK] Script execution completed.\n"
