# 场景 01：SQL 注入探测拿 Flag（DVWA）

## 目标

红队在 DVWA 中完成 SQL Injection 练习并留下可被 IDS 捕获的特征流量。

## 访问

- 地址：[http://localhost:8080](http://localhost:8080)
- 默认账号：`admin` / `password`
- 首次进入：点击 **Create / Reset Database** 初始化

## 红队步骤概要

1. 登录 DVWA，将 Security Level 设为 **Low**。
2. 进入 **SQL Injection** 页面。
3. 在 User ID 输入框尝试经典探测（如带 `'` 或 `UNION SELECT` 的查询）。
4. 记录页面回显中的用户信息作为完成证据。
5. （可选）使用 User-Agent 含 `sqlmap` 的请求，便于蓝队命中专用规则。

> 本场景只要求在授权靶场内完成探测与取证，不提供完整 exploit 脚本。

## 蓝队检测点

- **EveBox**（[http://localhost:5636）：查找告警](http://localhost:5636）：查找告警)  
  - `REDBLUE SQL Injection Attempt`  
  - `REDBLUE SQLi OR 1=1 Pattern`  
  - `REDBLUE sqlmap User-Agent`
- **blue-collector** 日志：`docker logs -f rb-blue-collector` 中的 `[ids]` / `[nginx]` 行
- （可选 Wazuh）规则 100101 / Suricata 关联告警

## 胜利条件


| 角色  | 条件                                  |
| --- | ----------------------------------- |
| 红队  | 在 Low 难度下成功回显至少一条用户数据，并截图/记录        |
| 蓝队  | 在 EveBox 中至少看到 1 条 REDBLUE SQL 相关告警 |


## Flag（演练标记）

`FLAG{dvwa_sqli_detected_by_blue_01}`