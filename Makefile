.PHONY: up down reset logs status certs wazuh-up wazuh-down ctfd red help

help:
	@echo "make up          - 启动靶标 + Suricata + EveBox"
	@echo "make down        - 停止全部"
	@echo "make reset       - 重置靶标"
	@echo "make logs        - 跟踪蓝队采集日志"
	@echo "make status      - 查看容器状态"
	@echo "make ctfd        - 附加启动 CTFd 评分"
	@echo "make red         - 附加启动攻击机容器"
	@echo "make certs       - 生成 Wazuh TLS 证书"
	@echo "make wazuh-up    - 启动可选 Wazuh SIEM"
	@echo "make wazuh-down  - 停止 Wazuh"

up:
	@chmod +x scripts/*.sh blue/collector/watch.sh 2>/dev/null || true
	@./scripts/start.sh

down:
	@./scripts/stop.sh

reset:
	@./scripts/reset-targets.sh

logs:
	docker logs -f rb-blue-collector

status:
	docker compose ps
	@docker compose -f blue/wazuh/docker-compose.wazuh.yml --env-file .env ps 2>/dev/null || true

ctfd:
	docker compose --profile ctfd up -d
	@echo "CTFd: http://localhost:$${CTFD_PORT:-8000}"

red:
	docker compose --profile red up -d attacker
	@echo "docker exec -it rb-attacker sh"

certs:
	@chmod +x scripts/generate-wazuh-certs.sh
	@./scripts/generate-wazuh-certs.sh

wazuh-up: certs
	@test -f .env || cp .env.example .env
	docker compose -f blue/wazuh/docker-compose.wazuh.yml --env-file .env up -d
	@echo "Wazuh Dashboard: https://localhost:$${WAZUH_DASHBOARD_PORT:-5601}"
	@echo "默认账号见 .env（admin / SecretPassword）"

wazuh-down:
	docker compose -f blue/wazuh/docker-compose.wazuh.yml --env-file .env down
