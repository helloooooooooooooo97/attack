# CTFd 可选评分平台

```bash
make ctfd
```

浏览器打开 http://localhost:8000 ，按向导创建管理员。

建议手工录入三个挑战，Flag 与 `scenarios/` 中一致：

| 挑战 | Flag |
|------|------|
| DVWA SQLi | `FLAG{dvwa_sqli_detected_by_blue_01}` |
| 弱口令内网 | `FLAG{intranet_weak_creds_lateral_01}` |
| IDS 标记 | `FLAG{ids_exfil_marker_caught_03}` |
