#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
docker compose --profile ctfd --profile red down --remove-orphans 2>/dev/null || true
docker compose -f blue/wazuh/docker-compose.wazuh.yml --env-file .env down --remove-orphans 2>/dev/null || true
docker compose down --remove-orphans
echo "[+] Lab stopped."
