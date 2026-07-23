# OpenVPN Access Server 部署教程

本文介绍如何使用 Docker Compose 部署 OpenVPN Access Server（OpenVPN-AS）。示例适用于 Ubuntu 22.04/24.04、Debian 12 等已安装 Docker 的 Linux 服务器。

## 1. 部署前准备

建议服务器至少具备以下配置：

- 1 核 CPU、1 GB 内存
- 一个公网 IPv4 地址
- 一个解析到服务器公网 IP 的域名，例如 `vpn.example.com`
- Docker Engine 和 Docker Compose Plugin
- 防火墙或云安全组允许以下入站端口

| 端口 | 协议 | 用途 |
| --- | --- | --- |
| `943` | TCP | 管理后台和用户门户 |
| `443` | TCP | OpenVPN TCP 连接及用户门户 |
| `1194` | UDP | OpenVPN UDP 连接，推荐使用 |

确认 Docker 已安装：

```bash
docker --version
docker compose version
```

> OpenVPN-AS 的授权按同时在线连接数计算。未导入商业许可证时，可使用官方提供的免费连接额度；具体额度和许可条款以 OpenVPN 官方说明为准。

## 2. 创建部署目录

```bash
sudo mkdir -p /opt/openvpn-as/data
cd /opt/openvpn-as
```

创建 `compose.yaml`：

```yaml
services:
  openvpn-as:
    image: openvpn/openvpn-as:latest
    container_name: openvpn-as
    restart: unless-stopped
    cap_add:
      - NET_ADMIN
    ports:
      - "943:943/tcp"
      - "443:443/tcp"
      - "1194:1194/udp"
    volumes:
      - ./data:/openvpn
```

生产环境建议将 `latest` 替换为经过验证的明确版本标签。升级前应先阅读对应版本的发布说明并备份数据。

## 3. 启动服务

拉取镜像并启动容器：

```bash
sudo docker compose pull
sudo docker compose up -d
```

查看容器状态和启动日志：

```bash
sudo docker compose ps
sudo docker compose logs --tail=100 openvpn-as
```

容器状态为 `Up` 后，服务通常已经可以访问。首次初始化可能需要等待几十秒。

## 4. 设置管理员密码

默认管理员用户名通常为 `openvpn`。使用以下命令设置本地管理员密码：

```bash
sudo docker exec -it openvpn-as \
  /usr/local/openvpn_as/scripts/sacli \
  --user openvpn \
  --new_pass '替换为高强度密码' \
  SetLocalPassword
```

不要将真实密码写入脚本、Shell 历史或 Git 仓库。更稳妥的方式是临时关闭 Shell 历史，或进入容器后交互执行命令。

## 5. 登录管理后台

浏览器访问：

```text
https://vpn.example.com:943/admin
```

使用以下信息登录：

- 用户名：`openvpn`
- 密码：上一步设置的管理员密码

首次访问时可能出现浏览器证书警告，这是因为服务默认使用自签名证书。确认访问的是自己的服务器后可临时继续，随后应在管理后台配置受信任的 TLS 证书。

登录后建议依次检查：

1. 在 **Configuration > Network Settings** 中确认 Hostname 或 IP Address 为 `vpn.example.com`。
2. 确认 UDP 端口为 `1194`，TCP 端口为 `443`。
3. 在 **Configuration > VPN Settings** 中设置客户端虚拟网段，避免与服务器内网和客户端本地网段冲突。
4. 根据需要选择仅访问指定内网，或允许客户端全部流量通过 VPN。
5. 保存设置并点击 **Update Running Server** 使配置生效。

## 6. 配置防火墙

如果服务器使用 UFW，可执行：

```bash
sudo ufw allow 943/tcp
sudo ufw allow 443/tcp
sudo ufw allow 1194/udp
sudo ufw status
```

如果服务器位于云平台，还需要在云安全组中放行相同端口。建议将 `943/tcp` 的来源限制为运维出口 IP；普通用户仍可通过 `https://vpn.example.com/` 或 `https://vpn.example.com:943/` 访问用户门户。

不要同时使用多套互相覆盖的防火墙规则。OpenVPN-AS 容器需要 `NET_ADMIN` 权限来管理隧道和相关网络规则。

## 7. 创建 VPN 用户

在管理后台进入 **User Management > User Permissions**：

1. 输入新用户名并添加用户。
2. 根据需要设置管理员权限、自动登录权限或访问控制。
3. 点击 **Save Settings**。
4. 点击 **Update Running Server**。

为用户设置本地密码：

```bash
sudo docker exec -it openvpn-as \
  /usr/local/openvpn_as/scripts/sacli \
  --user vpnuser \
  --new_pass '替换为用户密码' \
  SetLocalPassword
```

企业环境建议接入 LDAP、RADIUS、SAML 或 PAM 等统一身份认证，并启用多因素认证，不要长期维护共享账号。

## 8. 下载并连接客户端

用户访问：

```text
https://vpn.example.com:943/
```

登录后可以下载 OpenVPN Connect 客户端，或下载该用户的 `.ovpn` 连接配置文件。安装 OpenVPN Connect 后导入配置文件并连接即可。

连接后可检查公网出口 IP：

```bash
curl https://ifconfig.me
```

如果配置为仅访问内网，应测试目标内网服务是否可达，而不是以公网出口 IP 是否变化作为判断依据。

## 9. 配置正式 TLS 证书

推荐在 OpenVPN-AS 管理后台的证书页面导入受信任证书及私钥。证书应包含完整证书链，并覆盖实际访问域名 `vpn.example.com`。

如果在 OpenVPN-AS 前部署 Nginx、HAProxy 或其他反向代理，需要注意：

- Web 管理后台和用户门户可以使用 HTTPS 反向代理。
- OpenVPN TCP 流量不是普通 HTTP 流量，不能直接转发到 HTTP `location`。
- UDP `1194` 必须使用四层 UDP 转发或直接映射到服务器。
- 反向代理、OpenVPN TCP 和 Web 服务共用 `443` 时，需要明确规划四层分流，配置不当会导致客户端无法连接。

最简单可靠的方案是让 OpenVPN-AS 直接监听 `443/tcp` 和 `1194/udp`，并在 OpenVPN-AS 内配置 TLS 证书。

## 10. 备份与恢复

部署数据保存在 `/opt/openvpn-as/data`。备份前先停止容器，确保数据一致：

```bash
cd /opt/openvpn-as
sudo docker compose down
sudo tar -C /opt/openvpn-as -czf /var/backups/openvpn-as-$(date +%F).tar.gz data compose.yaml
sudo docker compose up -d
```

备份文件包含用户、证书和服务配置，应加密保存并限制访问权限。

恢复时，在版本兼容的 OpenVPN-AS 环境中停止容器，将备份的 `data` 目录恢复到 `/opt/openvpn-as/data`，再启动容器。正式恢复前建议先在隔离环境验证。

## 11. 升级

升级前先备份数据，然后执行：

```bash
cd /opt/openvpn-as
sudo docker compose pull
sudo docker compose up -d
sudo docker compose logs --tail=100 openvpn-as
```

如果 `compose.yaml` 使用固定版本标签，应先修改为计划升级的版本，再执行上述命令。升级完成后测试管理后台、用户认证、UDP/TCP 连接和内网路由。

## 12. 常见问题

### 管理后台无法访问

检查容器、端口监听和防火墙：

```bash
sudo docker compose ps
sudo docker compose logs --tail=200 openvpn-as
sudo ss -lntup | grep -E ':(443|943|1194)\b'
sudo ufw status
```

同时确认域名已经解析到正确的公网 IP，云安全组已允许 `943/tcp`。

### 客户端能认证但无法访问互联网

在管理后台确认是否启用了客户端互联网流量转发，并检查服务器上游防火墙、云平台源地址检查以及 NAT 规则。不要手工添加与 OpenVPN-AS 自动规则冲突的 iptables/nftables 规则。

### 客户端无法访问内网

检查以下项目：

- OpenVPN-AS 是否已声明需要访问的私有子网
- VPN 虚拟网段是否与客户端本地网段或目标内网冲突
- 目标网络是否有返回 VPN 客户端网段的路由
- 目标主机防火墙是否允许来自 VPN 的流量

### UDP 连接失败但 TCP 可以连接

通常是 `1194/udp` 未在主机防火墙、云安全组或上游网络中放行。检查端口映射和安全策略，并确认客户端配置中的服务器地址和 UDP 端口正确。

## 13. 安全建议

- 为管理员和普通用户启用多因素认证。
- 限制管理后台 `943/tcp` 的来源地址。
- 使用受信任的 TLS 证书，并定期自动续期。
- 使用独立用户账号，禁止多人共享管理员账号。
- 定期更新 OpenVPN-AS 镜像和宿主机安全补丁。
- 定期离线备份并演练恢复。
- 定期审计在线会话、登录日志和已停用账号。
- 生产环境固定镜像版本，不直接依赖 `latest`。

## 14. 卸载

停止并删除容器：

```bash
cd /opt/openvpn-as
sudo docker compose down
```

该命令不会删除 `./data` 持久化目录。如确认不再需要配置和用户数据，应先完成备份，再手动删除 `/opt/openvpn-as`。

## 参考资料

- [OpenVPN Access Server 官方文档](https://openvpn.net/as-docs/)
- [OpenVPN Access Server Docker Hub](https://hub.docker.com/r/openvpn/openvpn-as)
- [OpenVPN Access Server 发布说明](https://openvpn.net/as-docs/release-notes.html)
