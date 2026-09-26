```shell
gitlab-runner register \
--non-interactive \
--url "https://gitlab.bluesix.xyz" \
--token "glrt-UBF3W25Tlm6B3-OvSo8Io286MQp0OjEKdToxCw.01.120vxybid" \
--name "gitea-sync-runner" \
--executor "docker" \
--docker-image "alpine:3.20"

gitlab-runner run
```