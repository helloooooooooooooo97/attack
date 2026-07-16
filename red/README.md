# 红队工具区说明

默认不自动启动攻击机容器。若需要在隔离网络内做端口发现：

```bash
# 启动攻击机（nmap 镜像）
docker compose --profile red up -d attacker

# 进入容器
docker exec -it rb-attacker sh

# 示例：扫描网关侧可达服务（容器 DNS）
nmap -Pn gateway
```

日常 Web 演练直接使用宿主机浏览器访问即可：
- DVWA http://localhost:8080
- Juice Shop http://localhost:3000
- Intranet http://localhost:8081

**约束**：仅允许攻击本 compose 拉起的靶标，禁止对真实外网或未授权系统测试。
