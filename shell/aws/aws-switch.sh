#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
用法:
  aws-switch.sh add <profile>       添加或更新一个 AWS profile
  aws-switch.sh export <profile> <file> 导出 profile 配置
  aws-switch.sh import <profile> <file> 导入 profile 配置
  aws-switch.sh clean <profile>       删除 profile 配置和凭证
  aws-switch.sh backup [file]         备份 ~/.aws 配置
  aws-switch.sh restore <file>        恢复 ~/.aws 配置
  aws-switch.sh list                列出已配置的 profile
  aws-switch.sh use <profile>       设置当前 shell 的 AWS_PROFILE
  aws-switch.sh current             查看当前账号身份
  aws-switch.sh help                显示帮助

示例:
  aws-switch.sh add production
  aws-switch.sh add backup
  aws-switch.sh export backup ./backup.aws
  aws-switch.sh import backup ./backup.aws
  aws-switch.sh list
  source ./aws-switch.sh use backup
  aws-switch.sh current
EOF
}

command -v aws >/dev/null 2>&1 || {
  echo "错误：未找到 aws 命令，请先安装 AWS CLI。" >&2
  exit 1
}

cmd="${1:-help}"

case "$cmd" in
  add)
    profile="${2:-}"
    if [[ -z "$profile" ]]; then
      echo "用法：$0 add <profile>" >&2
      exit 1
    fi
    aws configure --profile "$profile"
    echo "已配置 profile: $profile"
    aws sts get-caller-identity --profile "$profile"
    ;;
  export)
    profile="${2:-}"
    file="${3:-}"
    if [[ -z "$profile" || -z "$file" ]]; then
      echo "用法：$0 export <profile> <file>" >&2
      exit 1
    fi
    key_id="$(aws configure get aws_access_key_id --profile "$profile")"
    secret_key="$(aws configure get aws_secret_access_key --profile "$profile")"
    region="$(aws configure get region --profile "$profile" || true)"
    output="$(aws configure get output --profile "$profile" || true)"
    if [[ -z "$key_id" || -z "$secret_key" ]]; then
      echo "错误：profile '$profile' 不存在或没有完整凭证。" >&2
      exit 1
    fi
    umask 077
    {
      echo "aws_access_key_id=$key_id"
      echo "aws_secret_access_key=$secret_key"
      [[ -n "$region" ]] && echo "region=$region"
      [[ -n "$output" ]] && echo "output=$output"
    } > "$file"
    chmod 600 "$file"
    echo "已导出 $profile 到 $file（文件权限已设为 600）"
    ;;
  import)
    profile="${2:-}"
    file="${3:-}"
    if [[ -z "$profile" || -z "$file" || ! -f "$file" ]]; then
      echo "用法：$0 import <profile> <file>" >&2
      exit 1
    fi
    while IFS='=' read -r key value; do
      [[ -z "$key" || "$key" == \#* ]] && continue
      case "$key" in
        aws_access_key_id|aws_secret_access_key|region|output)
          aws configure set "$key" "$value" --profile "$profile" ;;
        *) echo "忽略未知配置项：$key" >&2 ;;
      esac
    done < "$file"
    echo "已导入 profile: $profile"
    aws sts get-caller-identity --profile "$profile"
    ;;
  clean|remove)
    profile="${2:-}"
    if [[ -z "$profile" ]]; then
      echo "用法：$0 clean <profile>" >&2
      exit 1
    fi
    if [[ "$profile" == "default" ]]; then
      echo "为避免误删，不能使用 clean 删除 default profile。" >&2
      exit 1
    fi
    read -r -p "确认删除 AWS profile '$profile'？输入 profile 名称确认：" confirm
    if [[ "$confirm" != "$profile" ]]; then
      echo "已取消。"
      exit 1
    fi
    for key in aws_access_key_id aws_secret_access_key aws_session_token region output; do
      aws configure unset "$key" --profile "$profile" 2>/dev/null || true
    done
    # 清理空的 profile 段（AWS CLI 没有专门的 delete-profile 命令）
    python3 - "$profile" <<'PY'
import configparser, os, sys
profile = sys.argv[1]
for path, section in [(os.path.expanduser('~/.aws/credentials'), profile),
                      (os.path.expanduser('~/.aws/config'), 'profile ' + profile)]:
    if not os.path.exists(path):
        continue
    parser = configparser.RawConfigParser()
    parser.read(path)
    if parser.has_section(section):
        parser.remove_section(section)
        with open(path, 'w') as f:
            parser.write(f)
PY
    echo "已删除 profile: $profile"
    ;;
  list)
    aws configure list-profiles
    ;;
  use)
    profile="${2:-}"
    if [[ -z "$profile" ]]; then
      echo "用法：source $0 use <profile>" >&2
      exit 1
    fi
    export AWS_PROFILE="$profile"
    echo "当前 shell 已切换到 AWS_PROFILE=$AWS_PROFILE"
    aws sts get-caller-identity --profile "$AWS_PROFILE"
    ;;
  current)
    profile="${AWS_PROFILE:-default}"
    echo "AWS_PROFILE=$profile"
    aws sts get-caller-identity --profile "$profile"
    ;;
  backup)
    file="${2:-$PWD/aws-config-$(date +%Y%m%d-%H%M%S).tar.gz}"
    aws_dir="$HOME/.aws"
    if [[ ! -f "$aws_dir/credentials" && ! -f "$aws_dir/config" ]]; then
      echo "错误：未找到 $aws_dir/credentials 或 $aws_dir/config。" >&2
      exit 1
    fi
    tmp_dir="$(mktemp -d)"
    trap 'rm -rf "$tmp_dir"' EXIT
    mkdir -p "$tmp_dir/.aws"
    [[ -f "$aws_dir/credentials" ]] && cp "$aws_dir/credentials" "$tmp_dir/.aws/credentials"
    [[ -f "$aws_dir/config" ]] && cp "$aws_dir/config" "$tmp_dir/.aws/config"
    umask 077
    tar -czf "$file" -C "$tmp_dir" .aws
    chmod 600 "$file"
    echo "已备份 AWS 配置到: $file"
    ;;
  restore)
    file="${2:-}"
    if [[ -z "$file" || ! -f "$file" ]]; then
      echo "用法：$0 restore <file>" >&2
      exit 1
    fi
    read -r -p "恢复将覆盖 ~/.aws 中的 credentials/config，输入 RESTORE 确认：" confirm
    if [[ "$confirm" != "RESTORE" ]]; then
      echo "已取消。"
      exit 1
    fi
    restore_dir="$(mktemp -d)"
    trap 'rm -rf "$restore_dir"' EXIT
    tar -xzf "$file" -C "$restore_dir"
    if [[ ! -d "$restore_dir/.aws" ]]; then
      echo "错误：备份文件格式无效。" >&2
      exit 1
    fi
    mkdir -p "$HOME/.aws"
    for name in credentials config; do
      if [[ -f "$restore_dir/.aws/$name" ]]; then
        install -m 600 "$restore_dir/.aws/$name" "$HOME/.aws/$name"
      fi
    done
    echo "已恢复 AWS 配置到 $HOME/.aws"
    ;;
  help|--help|-h)
    usage
    ;;
  *)
    echo "未知命令：$cmd" >&2
    usage >&2
    exit 1
    ;;
esac
