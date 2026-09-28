#!/usr/bin/env bash
set -Eeuo pipefail

# 一键提交并推送当前仓库。
# 用法：
#   ./scripts/git-push.sh
#   ./scripts/git-push.sh "更新账号记录"

repo_root="$(git rev-parse --show-toplevel 2>/dev/null)" || {
  echo "错误：当前目录不在 Git 仓库内。" >&2
  exit 1
}

cd "$repo_root"

branch="$(git symbolic-ref --quiet --short HEAD 2>/dev/null || true)"
remote_url="$(git remote get-url origin 2>/dev/null || true)"

if [[ -z "$branch" ]]; then
  echo "错误：当前处于 detached HEAD，无法安全推送。" >&2
  exit 1
fi

if [[ -z "$remote_url" ]]; then
  echo "错误：未配置 origin 远端。" >&2
  exit 1
fi

if ! git diff --check; then
  echo "错误：发现空白字符或差异格式问题，已停止提交。" >&2
  exit 1
fi

git add -A

if git diff --cached --quiet; then
  echo "没有需要提交的变更。"
  exit 0
fi

commit_message="${1:-}"
if [[ -z "$commit_message" ]]; then
  commit_message="docs: update vault $(date '+%Y-%m-%d %H:%M:%S')"
fi

echo "仓库：$repo_root"
echo "分支：$branch"
echo "远端：$remote_url"
echo
git diff --cached --stat
echo
echo "提交信息：$commit_message"

git commit -m "$commit_message"
git push origin "$branch"

echo
echo "提交并推送完成：$branch"
