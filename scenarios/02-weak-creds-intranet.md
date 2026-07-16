# 场景 02：弱口令进入内网面板

## 目标

红队发现并登录「内部运维面板」，读取安全区 Flag；蓝队关注认证失败与成功访问。

## 访问

- 地址：[http://localhost:8081](http://localhost:8081)
- 弱口令（见 `.env`）：默认 `admin` / `admin123`

## 红队步骤概要

1. 访问内网面板，确认存在 HTTP Basic 认证。
2. 使用常见弱口令字典尝试登录（仅限本机靶场）。
3. 登录成功后打开 `/secure/flag.txt` 获取 Flag。
4. 将凭据来源记录到演练报告（例如：口令喷洒 / 默认口令）。

## 蓝队检测点

- Nginx 访问日志中大量 `401`，随后出现 `200` 访问 `/secure/flag.txt`
- EveBox：`REDBLUE Brute Force Tool UA`（若使用 hydra 类 UA）
- Wazuh 本地规则 `100102`（401 相关）

查看日志：

```bash
docker logs rb-blue-collector
docker exec rb-gateway tail -50 /var/log/nginx/access.log
```

## 胜利条件


| 角色  | 条件                      |
| --- | ----------------------- |
| 红队  | 提交正确 Flag               |
| 蓝队  | 能指出爆破/失败认证时间窗，并标记成功登录事件 |


## Flag

见面板内 `/secure/flag.txt`（默认 `FLAG{intranet_weak_creds_lateral_01}`）