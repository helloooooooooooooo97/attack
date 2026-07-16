# 场景 03：异常探测触发 IDS

## 目标

红队主动触发预置 IDS 规则；蓝队在 EveBox 中完成告警确认与分级。

## 访问

任意经 gateway 的 HTTP 入口即可，例如：

- [http://localhost:8080/lab-exfil?token=demo](http://localhost:8080/lab-exfil?token=demo)
- [http://localhost:3000/lab-exfil](http://localhost:3000/lab-exfil)

## 红队步骤概要

1. 向靶场入口发起带 `/lab-exfil` 路径的 HTTP 请求（可用浏览器或 curl）。
2. 可选：使用含 `Nikto` 或 `sqlmap` 的 User-Agent 再发一次请求。
3. 通知蓝队「已释放探测流量」，等待对方确认告警。

示例（授权靶场内）：

```bash
curl -s -o /dev/null -w "%{http_code}\n" "http://localhost:8080/lab-exfil?token=demo"
curl -s -o /dev/null -A "sqlmap/1.0" "http://localhost:8080/"
curl -s -o /dev/null -A "Nikto/2.0" "http://localhost:3000/"
```

## 蓝队检测点

在 EveBox（[http://localhost:5636）查找：](http://localhost:5636）查找：)

- `REDBLUE Suspicious Lab Exfil Marker`（sid 1000020）
- `REDBLUE sqlmap User-Agent`（sid 1000021）
- `REDBLUE Nikto Scanner`（sid 1000022）

响应建议（演练）：

1. 记录告警时间与源 IP
2. 判断严重级别（演练标记 vs 真实扫描器 UA）
3. 向指挥组报告「已检出异常出站/扫描特征」

## 胜利条件


| 角色  | 条件                            |
| --- | ----------------------------- |
| 红队  | 成功打出至少 1 条可复现的 IDS 告警         |
| 蓝队  | 在看板定位告警，并完成简短事件单（时间/规则名/处置建议） |


## Flag（演练标记）

`FLAG{ids_exfil_marker_caught_03}`