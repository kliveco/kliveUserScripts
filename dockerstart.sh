#!/bin/bash

# Docker Containers you would like to start
# Made with user scripts in mind, set a cron and you should be off to the races
# Little over the top but whatever - TLDR: docker start service works wonders lol
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
        echo "[OK] Container $CONTAINER is already running."
    else
        echo "[INFO] Starting Docker container: $CONTAINER"
        docker start "$CONTAINER"
    fi
done

echo -e "----------------------------\n[OK] Script execution completed.\n"
