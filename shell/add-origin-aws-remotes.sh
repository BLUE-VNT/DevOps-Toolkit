#!/usr/bin/env bash
set -euo pipefail

## 批量转移新仓库

ROOT="${1:-.}"
REMOTE_NAME="${REMOTE_NAME:-origin-aws}"
AWS_BASE_URL="${AWS_BASE_URL:-https://git.bluesixsix.xyz/XianZhu}"
OVERWRITE="${OVERWRITE:-0}"

if [[ ! -d "$ROOT" ]]; then
  echo "ERROR: root directory not found: $ROOT" >&2
  exit 1
fi

find "$ROOT" -type d -name .git -prune | while IFS= read -r git_dir; do
  repo_dir="$(dirname "$git_dir")"

  origin_url="$(git -C "$repo_dir" remote get-url origin 2>/dev/null || true)"
  if [[ -z "$origin_url" ]]; then
    echo "SKIP  $repo_dir: no origin remote"
    continue
  fi

  repo_name="$(basename "$origin_url")"
  repo_name="${repo_name%.git}"

  if [[ -z "$repo_name" ]]; then
    echo "SKIP  $repo_dir: cannot parse repo name from origin: $origin_url"
    continue
  fi

  aws_url="${AWS_BASE_URL}/${repo_name}.git"

  if git -C "$repo_dir" remote get-url "$REMOTE_NAME" >/dev/null 2>&1; then
    current_url="$(git -C "$repo_dir" remote get-url "$REMOTE_NAME")"
    if [[ "$OVERWRITE" == "1" ]]; then
      git -C "$repo_dir" remote set-url "$REMOTE_NAME" "$aws_url"
      echo "SET   $repo_dir: $REMOTE_NAME $current_url -> $aws_url"
    else
      echo "KEEP  $repo_dir: $REMOTE_NAME already exists: $current_url"
    fi
  else
    git -C "$repo_dir" remote add "$REMOTE_NAME" "$aws_url"
    echo "ADD   $repo_dir: $REMOTE_NAME $aws_url"
  fi
done

