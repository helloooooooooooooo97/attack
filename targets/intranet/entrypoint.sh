#!/bin/sh
set -e
USER="${INTRANET_USER:-admin}"
PASS="${INTRANET_PASSWORD:-admin123}"

# 使用镜像自带 openssl 生成 htpasswd，无需 apache2-utils
if command -v openssl >/dev/null 2>&1; then
  HASH=$(openssl passwd -apr1 "$PASS")
  echo "${USER}:${HASH}" > /etc/nginx/.htpasswd
elif [ "$USER" = "admin" ] && [ "$PASS" = "admin123" ]; then
  # openssl 不可用时的默认口令回退（admin / admin123）
  echo 'admin:$apr1$I9OigIh2$IKpF22gwbPklbhLGPdqGQ.' > /etc/nginx/.htpasswd
else
  echo "error: openssl not found and custom INTRANET_* credentials require it" >&2
  exit 1
fi

cat > /etc/nginx/conf.d/default.conf <<EOF
server {
    listen 80;
    server_name _;
    root /usr/share/nginx/html;
    index index.html;

    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    location / {
        auth_basic "Intranet Lab";
        auth_basic_user_file /etc/nginx/.htpasswd;
        try_files \$uri \$uri/ =404;
    }
}
EOF

exec nginx -g "daemon off;"
