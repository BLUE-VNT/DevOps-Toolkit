# root-monitor

[English](README.md) | [中文](README.zh-CN.md)

轻量级 Linux 服务器安全监控脚本 — 实时检测暴力破解、隐藏进程、rootkit 和可疑变更。

## 背景

这个脚本诞生于一次真实的安全事件：攻击者暴力破解了一个测试账号，部署了 AWS 密钥扫描器（`http_grabber`），501 个进程隐藏了 9 天未被发现。传统工具无法检测，因为进程通过 rootkit 隐藏了 `ps` 输出。

## 检查项目

| # | 检查内容 | 告警阈值 |
|---|---------|---------|
| 1 | SSH 暴力破解 | 每小时 >10 次失败登录 |
| 2 | SSH 密码登录 | 检测到密码登录（应该是公钥） |
| 3 | 新登录 IP | 之前未见过的 IP |
| 4 | root authorized_keys | 文件被修改或创建 |
| 5 | hermes authorized_keys | 文件被修改 |
| 6 | 已知恶意进程 | http_grabber、xmrig、minerd 等 |
| 7 | 隐藏进程 | pgrep 能看到但 ps 看不到（rootkit） |
| 8 | 高 CPU 进程 | >80% CPU（排除已知应用） |
| 9 | /tmp 可疑文件 | 可执行文件、扫描器/挖矿程序 |
| 10 | sudo/docker 组变更 | 成员增减 |
| 11 | SSH 配置变更 | 密码/root登录设置变化 |
| 12 | 新增可登录用户 | 有 /bin/bash 或 /bin/sh 的用户 |
| 13 | Crontab 变更 | root 或系统 crontab 被修改 |

## 安装

```bash
# 复制到服务器
scp root_monitor.sh user@server:~/scripts/

# 添加执行权限
chmod +x ~/scripts/root_monitor.sh

# 测试运行
bash ~/scripts/root_monitor.sh
```

## 使用方法

```bash
# 手动检查（显示结果）
bash root_monitor.sh

# 静默模式（只在有告警时输出）
bash root_monitor.sh --quiet

# 记录到日志文件
bash root_monitor.sh --log

# 组合：静默 + 日志（适合 cron）
bash root_monitor.sh --quiet --log
```

## 设置定时任务

```bash
# 编辑 crontab
crontab -e

# 添加：每 10 分钟检查一次，静默，记录告警
*/10 * * * * /home/hermes/scripts/root_monitor.sh --quiet --log
```

## 输出示例

**正常：**
```
✅ [2026-06-12 05:23:41] 安全检查通过，未发现异常
```

**告警：**
```
🚨 [2026-06-12 05:19:26] 安全监控告警
================================
⚠️ SSH 暴力破解: 最近1小时 156 次失败登录
⚠️ 发现隐藏进程: http_grabber (pgrep: 501, ps: 0) — 可能有 rootkit!
⚠️ root authorized_keys 已变更!
```

## 工作原理

- 使用 **状态文件**（`.state/`）跟踪两次运行之间的变化
- 首次运行建立基线，后续运行检测变更
- 零依赖 — 纯 bash，适用于任何有 `journalctl` 的 Linux
- 大部分检查不需要 root 权限（仅读取 root 文件时需要 sudo）

## 局限性

- 需要 `journalctl` 分析 SSH 日志（systemd 发行版）
- 状态文件在本地 — root 权限的攻击者可以篡改
- 不能替代完整的 IDS/IPS（Snort、Suricata）
- 只检测告警，不自动阻断攻击

## 许可证

MIT