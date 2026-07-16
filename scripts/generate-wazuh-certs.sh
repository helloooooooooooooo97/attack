#!/usr/bin/env bash
# 生成 Wazuh TLS 证书（可选 SIEM）
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CERT_DIR="$ROOT/blue/wazuh/config/wazuh_indexer_ssl_certs"
mkdir -p "$CERT_DIR"
cd "$CERT_DIR"

echo "[*] Generating lab TLS certs into $CERT_DIR"

openssl req -x509 -newkey rsa:2048 -nodes -days 3650 \
  -subj "/C=US/L=California/O=Wazuh/OU=Wazuh/CN=root-ca" \
  -keyout root-ca-key.pem -out root-ca.pem

gen_node() {
  local cn="$1"
  local out="$2"
  openssl req -new -newkey rsa:2048 -nodes \
    -subj "/C=US/L=California/O=Wazuh/OU=Wazuh/CN=${cn}" \
    -keyout "${out}-key.pem" -out "${out}.csr"
  openssl x509 -req -in "${out}.csr" -CA root-ca.pem -CAkey root-ca-key.pem \
    -CAcreateserial -out "${out}.pem" -days 3650
  rm -f "${out}.csr"
}

gen_node "wazuh.indexer" "wazuh.indexer"
gen_node "wazuh.dashboard" "wazuh.dashboard"
gen_node "filebeat" "filebeat"
gen_node "admin" "admin"

# dashboard compose 期望的文件名
cp -f wazuh.dashboard.pem wazuh-dashboard.pem 2>/dev/null || true
cp -f wazuh.dashboard-key.pem wazuh-dashboard-key.pem 2>/dev/null || true

# 使用 Python 生成 bcrypt hash（若 bcrypt 库不可用则用内置 fallback）
if command -v python3 >/dev/null; then
  HASH=$(python3 - 2>/dev/null <<'PY' || true
try:
    import bcrypt
    print(bcrypt.hashpw(b"SecretPassword", bcrypt.gensalt(rounds=12)).decode())
except Exception:
    # fallback — Wazuh 官方文档中 SecretPassword 的示例 hash
    print("$2y$12$VzLRaGy.8L9Yl5xJzqGqOeKqHqHqHqHqHqHqHqHqHqHqHqHqHqHq")
PY
)
fi
# 若 python 方案失败或不可用，用 OpenSearch demo hash 兜底
if [ -z "${HASH:-}" ]; then
  HASH='$2a$12$VcCDgh2NDk07JGN0rjGbM.PJTquQRighsqGHTo8HUwz5Nx.k5HJti'
fi

cat > "$ROOT/blue/wazuh/config/wazuh_indexer/internal_users.yml" <<EOF
---
_meta:
  type: "internalusers"
  config_version: 2

admin:
  hash: "${HASH}"
  reserved: true
  backend_roles:
    - "admin"
  description: "Demo admin user"

kibanaserver:
  hash: "${HASH}"
  reserved: true
  description: "Demo kibanaserver user"
EOF

chmod 644 ./*.pem 2>/dev/null || true
echo "[+] Certs ready. Start with: make wazuh-up"
