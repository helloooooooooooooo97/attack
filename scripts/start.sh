#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if [ ! -f .env ]; then
  cp .env.example .env
  echo "[*] Created .env from .env.example"
fi

echo "[*] Starting red-blue lab (targets + IDS)..."
docker compose up -d --build
echo "[+] Lab is up."
echo "    DVWA:      http://localhost:${DVWA_PORT:-8080}"
echo "    Juice:     http://localhost:${JUICE_PORT:-3000}"
echo "    Intranet:  http://localhost:${INTRANET_PORT:-8081}"
echo "    EveBox:    http://localhost:${EVEBOX_PORT:-5636}"
