```shell
gitlab-runner register \
--non-interactive \
--url "https://gitlab.xx.xyz/" \
--token "glrt-xx.01.170h31mu3" \
--name "gitea-sync-runner" \
--executor "docker" \
--docker-image "alpine:3.20"

gitlab-runner run
```