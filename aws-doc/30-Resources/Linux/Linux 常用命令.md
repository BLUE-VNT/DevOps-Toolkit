---
type: resource
para: resources
status: active
tags: [linux, operations, runbook, cloud]
---
# Linux 常用命令

> 面向云服务器日常登录、排障和运维。先确认当前目录、目标主机和命令影响范围，再执行高风险操作。

## 目录与文件

| 目的 | 命令 |
| --- | --- |
| 查看当前目录 | `pwd` |
| 列出文件（含隐藏文件） | `ls -lah` |
| 切换目录 | `cd /path/to/dir` |
| 创建目录 | `mkdir -p /path/to/dir` |
| 复制文件或目录 | `cp -a source target` |
| 移动或重命名 | `mv old new` |
| 删除文件 | `rm -- file` |
| 删除目录 | `rm -r -- directory` |
| 查看文件类型 | `file path/to/file` |
| 查看目录大小 | `du -sh /path/to/dir` |
| 查看磁盘挂载与容量 | `df -hT` |

`rm -r` 不可逆，生产服务器上执行前应再次确认路径；不要直接对未知路径使用通配符。

## 查找与文本处理

| 目的 | 命令 |
| --- | --- |
| 按名称查找 | `find /var/log -type f -name '*.log'` |
| 查找最近修改文件 | `find /path -type f -mtime -1` |
| 搜索文本 | `grep -Rni -- 'pattern' /path` |
| 查看前 100 行 | `sed -n '1,100p' file` |
| 查看末尾并持续跟踪 | `tail -n 100 -f file` |
| 统计行数、词数、字节数 | `wc -lwm file` |
| 排序并统计重复值 | `sort file | uniq -c | sort -nr` |
| JSON 格式化与筛选 | `jq '.' file.json` |

## 权限与身份

| 目的 | 命令 |
| --- | --- |
| 查看文件权限 | `stat file` |
| 修改权限 | `chmod 640 file` |
| 修改所有者 | `chown user:group file` |
| 查看当前用户 | `id` |
| 查看当前登录用户 | `who` / `w` |
| 切换为登录 Shell | `sudo -iu user` |
| 以管理员执行单条命令 | `sudo command` |

权限建议：优先使用最小权限；不要为了“解决权限问题”直接执行 `chmod -R 777`。

## 进程、服务与日志

| 目的 | 命令 |
| --- | --- |
| 查看进程 | `ps aux --sort=-%cpu | head` |
| 交互查看资源占用 | `top` 或 `htop` |
| 按名称查进程 | `pgrep -af process-name` |
| 结束进程 | `kill PID`；无响应时再考虑 `kill -9 PID` |
| 查看服务状态 | `systemctl status service` |
| 启停服务 | `sudo systemctl start\|stop\|restart service` |
| 设置开机启动 | `sudo systemctl enable --now service` |
| 查看服务日志 | `journalctl -u service -n 100 --no-pager` |
| 实时查看服务日志 | `journalctl -u service -f` |
| 查看内核与系统日志 | `dmesg -T | tail -n 100` |

## CPU、内存与系统信息

| 目的 | 命令 |
| --- | --- |
| 查看系统版本 | `cat /etc/os-release` |
| 查看内核版本 | `uname -a` |
| 查看 CPU | `lscpu` |
| 查看内存 | `free -h` |
| 查看负载与运行时间 | `uptime` |
| 查看块设备 | `lsblk -f` |
| 查看 PCI 设备 | `lspci` |
| 查看环境变量 | `env` |

## 网络与端口

| 目的 | 命令 |
| --- | --- |
| 查看 IP 与网卡 | `ip -br address` |
| 查看路由 | `ip route` |
| 测试域名解析 | `getent hosts example.com` 或 `dig example.com` |
| 测试连通性 | `ping -c 4 host` |
| 测试 TCP 端口 | `nc -vz host 22` |
| 查看监听端口 | `ss -lntup` |
| 查看 HTTP 响应头 | `curl -I https://example.com` |
| 查看完整请求过程 | `curl -v https://example.com` |
| 下载文件 | `curl -fL -o output URL` |

## 压缩、传输与 SSH

| 目的 | 命令 |
| --- | --- |
| 创建 tar.gz | `tar -czf archive.tar.gz directory/` |
| 解压 tar.gz | `tar -xzf archive.tar.gz` |
| 查看压缩包内容 | `tar -tzf archive.tar.gz` |
| 上传文件 | `scp file user@host:/path/` |
| 同步目录 | `rsync -avh --progress source/ user@host:/path/` |
| SSH 登录 | `ssh user@host` |
| 指定密钥登录 | `ssh -i ~/.ssh/key user@host` |
| 查看 SSH 详细握手 | `ssh -vv user@host` |

## 软件包管理

| 系统 | 更新索引 | 安装软件 |
| --- | --- | --- |
| Debian / Ubuntu | `sudo apt update` | `sudo apt install package` |
| RHEL / CentOS / Rocky | `sudo dnf makecache` | `sudo dnf install package` |
| Alpine | `sudo apk update` | `sudo apk add package` |

卸载、升级内核或批量更新前，先确认系统版本、服务依赖和可用回滚方案。

## 常用排障顺序

1. `uptime`、`free -h`、`df -hT`：确认负载、内存和磁盘。
2. `systemctl status service`、`journalctl -u service -n 100`：确认服务状态与错误日志。
3. `ss -lntup`、`ip route`：确认监听端口和路由。
4. `curl -v`、`nc -vz`、`getent hosts`：区分应用、端口、DNS 和网络问题。
5. 记录执行命令、时间、现象和回滚动作到对应运维记录。

## Shell 安全提示

- 变量使用引号：`rm -- "$file"`，避免空格和通配符造成误删。
- 先用 `command -v tool` 确认命令来源，再检查 `tool --help`。
- 生产变更前保存配置备份，并在低峰期执行。
- 不在笔记或命令历史中记录密码、AccessKey Secret、私钥或会话令牌。

### 证书快速生成
```
keytool -genkey -alias jwt -keyalg RSA -keypass 123456 -keystore jwt.jks -storepass 123456   -noprompt -dname "CN=My Name, OU=My Unit, O=My Organization, L=San Francisco, ST=California, C=US"

keytool -list -rfc -storepass 123456 --keystore jwt.jks | openssl x509 -inform pem -pubkey | sed -n '/-----BEGIN PUBLIC KEY-----/,/-----END PUBLIC KEY-----/p' | sed '/-----BEGIN PUBLIC KEY-----/d;/-----END PUBLIC KEY-----/d'> public.key
```

