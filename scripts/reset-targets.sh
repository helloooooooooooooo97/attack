#!/usr/bin/env bash
# 重置靶标（DVWA / Juice / Intranet / Gateway），不清除蓝方日志
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

echo "[*] Resetting targets (recreate dvwa / juice / intranet / gateway)..."

# 先停核心服务（保留 blue-collector / evebox / suricata 继续运行）
docker compose stop dvwa juice-shop intranet gateway suricata || true
docker compose rm -f dvwa juice-shop intranet || true

# 清除已 exit 的容器，避免残留名冲突
docker container prune -f --filter "label=com.docker.compose.project=redblue" 2>/dev/null || true

# 如果存在 dvwa/juice 的匿名卷，也一并清除
docker volume ls -q | grep -E 'dvwa|juice' | while read v; do
  echo "  - removing volume: $v"
  docker volume rm "$v" 2>/dev/null || true
done

# 重建核心服务 + 监控栈
docker compose up -d --build dvwa juice-shop intranet gateway suricata evebox blue-collector

echo "[+] Targets reset complete."
echo "  - DVWA 可能需要点击 'Create / Reset Database' 初始化数据库"
echo "  - EveBox 日志历史保留，可继续查看"
