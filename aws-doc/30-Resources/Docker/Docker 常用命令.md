---
type: resource
para: resources
status: active
tags: [docker, containers, operations, runbook, cloud]
---
# Docker 常用命令

> 面向云服务器上的 Docker 日常部署、排障和维护。生产环境执行停止、删除、清理前，先确认容器、卷和网络的归属，并保留回滚方案。

## Docker 服务与版本

| 目的 | 命令 |
| --- | --- |
| 查看 Docker 版本 | `docker version` |
| 查看 Docker 信息 | `docker info` |
| 查看 Docker 服务状态 | `sudo systemctl status docker` |
| 启动 Docker | `sudo systemctl start docker` |
| 重启 Docker | `sudo systemctl restart docker` |
| 设置开机启动 | `sudo systemctl enable --now docker` |
| 查看磁盘占用 | `docker system df` |

## 容器生命周期

| 目的 | 命令 |
| --- | --- |
| 查看运行中容器 | `docker ps` |
| 查看全部容器 | `docker ps -a` |
| 格式化查看容器 | `docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}'` |
| 创建并后台运行 | `docker run -d --name web -p 8080:80 nginx:latest` |
| 启动容器 | `docker start CONTAINER` |
| 停止容器 | `docker stop CONTAINER` |
| 重启容器 | `docker restart CONTAINER` |
| 强制终止容器 | `docker kill CONTAINER` |
| 删除已停止容器 | `docker rm CONTAINER` |
| 停止并删除容器 | `docker rm -f CONTAINER` |
| 查看容器详细信息 | `docker inspect CONTAINER` |
| 查看容器状态 | `docker inspect -f '{{.State.Status}}' CONTAINER` |

## 进入容器与文件复制

| 目的 | 命令 |
| --- | --- |
| 进入容器 Shell | `docker exec -it CONTAINER sh` |
| 进入 Bash（镜像提供时） | `docker exec -it CONTAINER bash` |
| 以 root 进入容器 | `docker exec -u 0 -it CONTAINER sh` |
| 执行单条命令 | `docker exec CONTAINER command --arg` |
| 宿主机复制到容器 | `docker cp ./local.conf CONTAINER:/etc/app/` |
| 容器复制到宿主机 | `docker cp CONTAINER:/var/log/app.log ./` |
| 查看容器环境变量 | `docker inspect -f '{{range .Config.Env}}{{println .}}{{end}}' CONTAINER` |
| 查看容器挂载 | `docker inspect -f '{{json .Mounts}}' CONTAINER` |

## 日志与排障

| 目的 | 命令 |
| --- | --- |
| 查看最近 100 行 | `docker logs --tail 100 CONTAINER` |
| 持续跟踪日志 | `docker logs -f --tail 100 CONTAINER` |
| 查看带时间戳日志 | `docker logs -t --since 1h CONTAINER` |
| 查看容器进程 | `docker top CONTAINER` |
| 查看实时资源占用 | `docker stats` |
| 查看单个容器资源 | `docker stats --no-stream CONTAINER` |
| 查看容器端口映射 | `docker port CONTAINER` |
| 查看健康检查 | `docker inspect -f '{{json .State.Health}}' CONTAINER` |
| 查看事件流 | `docker events --since 1h` |

常见排障顺序：先看 `docker ps -a` 和容器状态，再看 `docker logs`，然后检查端口、挂载、环境变量、健康检查和宿主机磁盘空间。

## 镜像

| 目的 | 命令 |
| --- | --- |
| 查看本地镜像 | `docker image ls` |
| 拉取镜像 | `docker pull IMAGE:TAG` |
| 删除镜像 | `docker image rm IMAGE:TAG` |
| 查看镜像详情 | `docker image inspect IMAGE:TAG` |
| 构建镜像 | `docker build -t APP:TAG .` |
| 不使用缓存构建 | `docker build --no-cache -t APP:TAG .` |
| 标记镜像 | `docker tag APP:TAG REGISTRY/APP:TAG` |
| 导出镜像 | `docker save -o app.tar APP:TAG` |
| 导入镜像 | `docker load -i app.tar` |
| 查看镜像历史 | `docker history IMAGE:TAG` |

## Docker Compose

在包含 `compose.yaml` 或 `docker-compose.yml` 的目录执行：

| 目的 | 命令 |
| --- | --- |
| 启动服务 | `docker compose up -d` |
| 按需重新构建并启动 | `docker compose up -d --build` |
| 查看服务状态 | `docker compose ps` |
| 查看服务日志 | `docker compose logs --tail 100 SERVICE` |
| 持续跟踪日志 | `docker compose logs -f SERVICE` |
| 重启服务 | `docker compose restart SERVICE` |
| 执行命令 | `docker compose exec SERVICE sh` |
| 拉取新镜像 | `docker compose pull` |
| 停止并移除容器 | `docker compose down` |
| 停止并移除附加卷 | `docker compose down -v` |

`docker compose down -v` 可能删除数据库等持久化卷，执行前必须确认卷用途和备份状态。

## 卷与网络

| 目的     | 命令                                            |
| ------ | --------------------------------------------- |
| 查看卷    | `docker volume ls`                            |
| 查看卷详情  | `docker volume inspect VOLUME`                |
| 创建卷    | `docker volume create VOLUME`                 |
| 删除卷    | `docker volume rm VOLUME`                     |
| 查看网络   | `docker network ls`                           |
| 查看网络详情 | `docker network inspect NETWORK`              |
| 创建网络   | `docker network create NETWORK`               |
| 连接网络   | `docker network connect NETWORK CONTAINER`    |
| 断开网络   | `docker network disconnect NETWORK CONTAINER` |
|        |                                               |

## 批量停止与恢复容器

以下保留批量操作模板。执行前先确认当前主机上的容器是否都允许停止，并保存容器 ID 清单：

```bash
docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Image}}' > running-containers.txt
docker ps -q > running-container-ids.txt
xargs -r docker stop < running-container-ids.txt
```

恢复刚才记录的容器：

```bash
xargs -r docker start < running-container-ids.txt
```

`running-container-ids.txt` 是临时运维文件，不应提交到仓库或长期保存。

## 清理与回收空间

| 目的 | 命令 |
| --- | --- |
| 删除已停止容器 | `docker container prune` |
| 删除未使用镜像 | `docker image prune` |
| 删除未使用网络 | `docker network prune` |
| 删除未使用卷 | `docker volume prune` |
| 清理未使用对象 | `docker system prune` |
| 连同未使用镜像清理 | `docker system prune -a` |

这些命令可能删除仍需回滚的对象。生产环境先执行 `docker system df`，再逐类确认容器、镜像、卷和网络，避免直接使用 `-a` 或 `--volumes`。

## 私有仓库

| 目的 | 命令 |
| --- | --- |
| 登录仓库 | `docker login REGISTRY` |
| 推送镜像 | `docker push REGISTRY/APP:TAG` |
| 注销凭据 | `docker logout REGISTRY` |

不要把仓库密码、Access Token 或登录配置写入笔记、脚本和命令历史；优先使用短期凭据或云厂商的实例角色。

## 安全检查清单

- [ ] 容器只暴露必要端口，宿主机安全组同步收敛。
- [ ] 数据库、上传目录和配置文件使用明确的命名卷或绑定挂载。
- [ ] 镜像使用固定版本或 digest，不长期依赖 `latest`。
- [ ] 容器尽量以非 root 用户运行，并限制 CPU、内存和文件系统权限。
- [ ] 变更前确认备份、回滚镜像和 Compose 配置可用。
- [ ] 清理前确认没有误删生产容器、镜像或数据卷。
