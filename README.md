# 红蓝对抗本地靶场

Docker Compose 一键拉起：**红队靶标**（DVWA / Juice Shop / 弱口令内网面板）+ **蓝队观测**（Suricata IDS + EveBox 看板）。可选启动 Wazuh SIEM 与 CTFd 评分。

> 仅限本机/授权演练环境，禁止用于未授权系统。

## 快速开始

```bash
cd 红蓝对抗
cp .env.example .env
make up
```

| 服务 | 地址 |
|------|------|
| DVWA | http://localhost:8080 （admin / password） |
| Juice Shop | http://localhost:3000 |
| 内网面板 | http://localhost:8081 （admin / admin123） |
| EveBox（IDS 告警） | http://localhost:5636 |
| CTFd（可选） | `make ctfd` → http://localhost:8000 |
| Wazuh（可选，吃内存） | `make wazuh-up` → https://localhost:5601 |

DVWA 首次打开后点 **Create / Reset Database**。

## 常用命令

```bash
make up        # 启动
make down      # 停止
make reset     # 重置靶标
make logs      # 蓝队汇聚日志
make status    # 容器状态
make red       # 启动攻击机容器
make ctfd      # 启动评分平台
make wazuh-up  # 启动 Wazuh（需 ≥6GB Docker 内存）
```

## 网络分区

```
net-red     红队 / 入口 gateway / EveBox
net-target  DVWA、Juice Shop、intranet（不直接对宿主机暴露）
net-blue    蓝队汇聚与可选 Wazuh / CTFd
```

所有靶标流量经 **gateway** 反代；Suricata 与 gateway **共享网络栈**抓包。

## 演练剧本

见 `scenarios/`：

1. [SQL 注入 + IDS](scenarios/01-sqli-dvwa.md)
2. [弱口令内网面板](scenarios/02-weak-creds-intranet.md)
3. [异常探测触发 IDS](scenarios/03-ids-exfil-marker.md)

## 硬件建议

| 模式 | 内存 | 说明 |
|------|------|------|
| 默认（靶标+Suricata+EveBox） | ≥ 4GB | 推荐日常演练 |
| + Wazuh | ≥ 6–8GB | Indexer + Manager + Dashboard |
| + CTFd | +512MB | 评分平台 |

## 目录结构

```
docker-compose.yml          # 主编排
.env.example                # 端口与口令模板
gateway/                    # Nginx 入口
targets/intranet/           # 弱口令内网服务
blue/suricata/              # IDS 配置与规则
blue/collector/             # 日志汇聚
blue/wazuh/                 # 可选 SIEM
scenarios/                  # 攻防剧本
scripts/                    # 启停/重置/证书
red/                        # 红队说明
```

## 红 / 蓝分工

- **红队**：按剧本攻击上述本地 URL，提交 Flag / 截图，不打外网。
- **蓝队**：在 EveBox（及可选 Wazuh）确认告警，记录时间线与处置建议。

## 故障排查

```bash
docker compose ps
docker logs rb-suricata
docker logs rb-evebox
docker logs rb-gateway
```

若 EveBox 无告警：先跑场景 03 的 curl，再刷新看板；确认 `rb-suricata` 为 running。
