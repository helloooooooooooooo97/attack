#!/bin/sh
# 蓝队日志汇聚：持续打印 nginx 访问与 Suricata 告警摘要
echo "[blue-collector] watching nginx access.log and suricata eve.json"
touch /tmp/seen_eve

while true; do
  if [ -f /var/log/nginx/access.log ]; then
    tail -n 5 /var/log/nginx/access.log 2>/dev/null | sed 's/^/[nginx] /'
  fi
  if [ -f /var/log/suricata/eve.json ]; then
    grep '"event_type":"alert"' /var/log/suricata/eve.json 2>/dev/null | tail -n 5 | sed 's/^/[ids] /'
  fi
  sleep 15
done
