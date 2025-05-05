#!/bin/bash

# Using (External) Uptime Kuma Service with PUSH links to show heartbeat from home server 
# Format: "DOCKER_CONTAINER_NAME|HEARTBEAT_URL|PORT"
# Changed links/ports for obvious reasons
SERVICES=(
    "cloudflared-tunnel|https://github.com/kliveco/push/API?status=up|1234"
    "homebridge|https://github.com/kliveco/push/API?status=up|1234"
)

# Function to check port - ASSUME LOCAL SERVICE (localhost)
check_port() {
    local host="localhost"
    local port=$1

    curl --connect-timeout 1 -s "http://${host}:${port}" > /dev/null
    return $?
}

# Check each service, utilising docker ps command
for SERVICE in "${SERVICES[@]}"; do
    CONTAINER_NAME=$(echo "$SERVICE" | cut -d'|' -f1)
    HEARTBEAT_URL_UP=$(echo "$SERVICE" | cut -d'|' -f2)
    PORT=$(echo "$SERVICE" | cut -d'|' -f3)
    HEARTBEAT_URL_DOWN="${HEARTBEAT_URL_UP/status=up/status=down}"

    echo "----------------------------"
    echo "[CHECK] Checking docker container: $CONTAINER_NAME"

    if docker ps --filter "name=^/${CONTAINER_NAME}$" --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        echo "[OK] $CONTAINER_NAME is running. Checking port $PORT..."

        if check_port "$PORT"; then
            echo "[OK] Port $PORT is responsive."
            curl -s "$HEARTBEAT_URL_UP" > /dev/null && echo "[OK] Heartbeat UP sent." || echo "[ERROR] Failed to send UP heartbeat."
        else
            echo "[WARN] Port $PORT is NOT responsive. Service UP / Port DOWN - service is not exposed"
            curl -s "$HEARTBEAT_URL_DOWN" > /dev/null && echo "[OK] Heartbeat DOWN sent." || echo "[ERROR] Failed to send DOWN heartbeat."
        fi
    else
        echo "[ERROR] $CONTAINER_NAME is NOT running. Service DOWN"
        curl -s "$HEARTBEAT_URL_DOWN" > /dev/null && echo "[OK] Heartbeat DOWN sent." || echo "[ERROR] Failed to send DOWN heartbeat."
    fi
done

echo -e "----------------------------\n[OK] Script execution completed.\n"
