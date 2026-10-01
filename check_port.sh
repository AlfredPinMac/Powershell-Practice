#!/bin/bash

# ==============================================================================
# Script: check_port.sh
# Description: Checks whether a specific TCP port is open or closed.
# Usage: ./check_port.sh <PORT> [HOST/IP]
# Example: ./check_port.sh 80 google.com
#          ./check_port.sh 22 127.0.0.1
# ==============================================================================

# Colors for terminal output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 1. Validate that the port argument is provided
if [ -z "$1" ]; then
    echo -e "${RED}[ERROR] You must provide a port as an argument.${NC}"
    echo -e "${YELLOW}Usage:${NC} $0 <PORT> [HOST/IP]"
    echo -e "${YELLOW}Example:${NC} $0 80 google.com"
    echo -e "${YELLOW}Local Example:${NC} $0 22"
    exit 1
fi

PORT="$1"
# Default host is 127.0.0.1 (localhost) if not specified
HOST="${2:-127.0.0.1}"
TIMEOUT=2

# 2. Validate that the port is a valid number (1 - 65535)
if ! [[ "$PORT" =~ ^[0-9]+$ ]] || [ "$PORT" -lt 1 ] || [ "$PORT" -gt 65535 ]; then
    echo -e "${RED}[ERROR] Port '$PORT' is invalid. It must be a number between 1 and 65535.${NC}"
    exit 1
fi

echo -e "${BLUE}[*] Checking port ${PORT} on host ${HOST}...${NC}"

# 3. Check port status using Netcat if available, otherwise fallback to /dev/tcp
if command -v nc >/dev/null 2>&1; then
    # Using Netcat
    nc -z -w "$TIMEOUT" "$HOST" "$PORT" >/dev/null 2>&1
    STATUS=$?
else
    # Using Bash native /dev/tcp descriptor
    timeout "$TIMEOUT" bash -c "cat < /dev/null > /dev/tcp/$HOST/$PORT" 2>/dev/null
    STATUS=$?
fi

# 4. Display result
if [ $STATUS -eq 0 ]; then
    echo -e "${GREEN}[+] Port ${PORT} is OPEN on ${HOST}.${NC}"
    exit 0
else
    echo -e "${RED}[-] Port ${PORT} is CLOSED (or not responding) on ${HOST}.${NC}"
    exit 1
fi
