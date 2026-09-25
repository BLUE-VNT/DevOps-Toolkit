#!/bin/bash
# root_monitor.sh — 监控 root 用户可疑活动
# 用法: bash root_monitor.sh [--log] [--quiet]
#   --log   记录到日志文件
#   --quiet 只在有发现时输出

LOG_FILE="/home/hermes/scripts/root_monitor.log"
STATE_DIR="/home/hermes/scripts/.root_monitor_state"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
ALERTS=""
QUIET=false
WRITE_LOG=false

# 参数解析
for arg in "$@"; do
  case $arg in
    --log) WRITE_LOG=true ;;
    --quiet) QUIET=true ;;
  esac
done

mkdir -p "$STATE_DIR"

# ===== 工具函数 =====
alert() {
  ALERTS="${ALERTS}⚠️ $1\n"
}

check_changed() {
  local name="$1"
  local current="$2"
  local state_file="$STATE_DIR/$name"

  if [ -f "$state_file" ]; then
    local previous
    previous=$(cat "$state_file")
    if [ "$current" != "$previous" ]; then
      return 0  # changed
    fi
    return 1  # no change
  else
    echo "$current" > "$state_file"
    return 1  # first run
  fi
}

save_state() {
  local name="$1"
  local value="$2"
  echo "$value" > "$STATE_DIR/$name"
}

# ===== 1. 检查 SSH 登录 =====
check_ssh_logins() {
  # 最近 1 小时的失败登录
  local failed_count
  failed_count=$(journalctl _COMM=sshd --since "1 hour ago" 2>/dev/null | grep -c "Failed password" || true)
  failed_count=${failed_count:-0}
  failed_count=$(echo "$failed_count" | head -1 | tr -d '[:space:]')

  if [ "$failed_count" -gt 10 ] 2>/dev/null; then
    alert "SSH 暴力破解: 最近1小时 ${failed_count} 次失败登录"
    # 列出 Top 5 IP
    local top_ips
    top_ips=$(journalctl _COMM=sshd --since "1 hour ago" 2>/dev/null | grep "Failed password" | grep -oP "\d+\.\d+\.\d+\.\d+" | sort | uniq -c | sort -rn | head -5)
    if [ -n "$top_ips" ]; then
      alert "Top IP:\n${top_ips}"
    fi
  fi

  # 最近 1 小时的成功登录（非公钥）
  local password_logins
  password_logins=$(journalctl _COMM=sshd --since "1 hour ago" 2>/dev/null | grep "Accepted password" | grep -v "^$")
  if [ -n "$password_logins" ]; then
    alert "检测到密码登录（应该是公钥）:\n${password_logins}"
  fi

  # 成功登录的新 IP
  local current_ips
  current_ips=$(journalctl _COMM=sshd --since "24 hours ago" 2>/dev/null | grep "Accepted" | grep -oP "\d+\.\d+\.\d+\.\d+" | sort -u | tr '\n' ',')
  if check_changed "ssh_ips" "$current_ips"; then
    local new_ips
    new_ips=$(comm -13 <(cat "$STATE_DIR/ssh_ips_prev" 2>/dev/null | tr ',' '\n' | sort) <(echo "$current_ips" | tr ',' '\n' | sort) | grep -v "^$")
    if [ -n "$new_ips" ]; then
      alert "新的登录 IP: ${new_ips}"
    fi
  fi
  save_state "ssh_ips_prev" "$current_ips"
  save_state "ssh_ips" "$current_ips"
}

# ===== 2. 检查 root authorized_keys =====
check_root_keys() {
  local keys_file="/root/.ssh/authorized_keys"
  if [ -f "$keys_file" ]; then
    local current_keys
    current_keys=$(md5sum "$keys_file" 2>/dev/null | awk '{print $1}')
    if check_changed "root_keys" "$current_keys"; then
      alert "root authorized_keys 已变更!"
      alert "当前内容:\n$(cat "$keys_file" 2>/dev/null)"
    fi
  else
    if check_changed "root_keys" "deleted"; then
      # 第一次运行时文件不存在，记录状态但不告警
      save_state "root_keys" "deleted"
    fi
  fi

  # hermes 的 authorized_keys
  local hermes_keys="/home/hermes/.ssh/authorized_keys"
  if [ -f "$hermes_keys" ]; then
    local hermes_hash
    hermes_hash=$(md5sum "$hermes_keys" 2>/dev/null | awk '{print $1}')
    if check_changed "hermes_keys" "$hermes_hash"; then
      alert "hermes authorized_keys 已变更!"
    fi
  fi
}

# ===== 3. 检查可疑进程 =====
check_suspicious_processes() {
  # 检查常见恶意进程名
  local suspicious_names="http_grabber xmrig minerd kworkerds kdevtmpfsi solrd dbused"
  for name in $suspicious_names; do
    local count
    count=$(pgrep -c "$name" 2>/dev/null || true)
    count=${count:-0}
    count=$(echo "$count" | head -1 | tr -d '[:space:]')
    if [ "$count" -gt 0 ] 2>/dev/null; then
      alert "发现可疑进程: ${name} (${count} 个)"
    fi
  done

  # 检查高 CPU 进程（>80%）排除已知进程
  local high_cpu
  high_cpu=$(ps -eo pid,user,%cpu,comm --sort=-%cpu --no-headers 2>/dev/null | awk '$3+0 > 80 {print $0}' | grep -v "node\|next-server\|hermes\|v2ray\|nginx\|sshd\|free\|ps\|grep\|awk\|top\|bash\|rtk" | head -5)
  if [ -n "$high_cpu" ]; then
    alert "异常高 CPU 进程:\n${high_cpu}"
  fi

  # 检查隐藏进程（pgrep 有但 ps 没有）
  for proc in http_grabber xmrig minerd; do
    local pgrep_count ps_count
    pgrep_count=$(pgrep -c "$proc" 2>/dev/null || true)
    pgrep_count=${pgrep_count:-0}
    pgrep_count=$(echo "$pgrep_count" | head -1 | tr -d '[:space:]')
    ps_count=$(ps -e 2>/dev/null | grep -c "$proc" || true)
    ps_count=${ps_count:-0}
    ps_count=$(echo "$ps_count" | head -1 | tr -d '[:space:]')
    if [ "$pgrep_count" -gt 0 ] 2>/dev/null && [ "$ps_count" -eq 0 ] 2>/dev/null; then
      alert "发现隐藏进程: ${proc} (pgrep: ${pgrep_count}, ps: ${ps_count}) — 可能有 rootkit!"
    fi
  done
}

# ===== 4. 检查可疑文件 =====
check_suspicious_files() {
  # 检查 /root 下的隐藏目录
  local hidden_dirs
  hidden_dirs=$(ls -la /root/ 2>/dev/null | grep "^d" | grep -E "^\." | grep -v "^\.\.$\|^\.$" | awk '{print $NF}')
  local known_dirs=".cache .config .docker .local .npm .ssh"
  for dir in $hidden_dirs; do
    if ! echo "$known_dirs" | grep -qw "$dir"; then
      if check_changed "root_dir_$dir" "exists"; then
        alert "root 目录下发现新的隐藏目录: /root/${dir}"
      fi
    fi
  done

  # 检查 /tmp 和 /dev/shm 下的可疑可执行文件
  local tmp_files
  tmp_files=$(find /tmp /dev/shm -type f \( -perm -u+x -o -name "*grabber*" -o -name "*miner*" -o -name "*backdoor*" \) ! -name "*.py" ! -name "*.sh" ! -name "hsperfdata_*" ! -path "*/.git/*" ! -path "*/node_modules/*" 2>/dev/null | head -10)
  if [ -n "$tmp_files" ]; then
    alert "/tmp 或 /dev/shm 下发现可疑可执行文件:\n${tmp_files}"
  fi
}

# ===== 5. 检查 sudo 用户 =====
check_sudo_users() {
  local current_sudo
  current_sudo=$(getent group sudo 2>/dev/null | cut -d: -f4 | sort | tr '\n' ',')
  if check_changed "sudo_users" "$current_sudo"; then
    alert "sudo 组成员变更: ${current_sudo}"
  fi

  local current_docker
  current_docker=$(getent group docker 2>/dev/null | cut -d: -f4 | sort | tr '\n' ',')
  if check_changed "docker_users" "$current_docker"; then
    alert "docker 组成员变更: ${current_docker}"
  fi
}

# ===== 6. 检查 SSH 配置 =====
check_ssh_config() {
  local current_config
  current_config=$(sshd -T 2>/dev/null | grep -E "passwordauthentication|permitrootlogin" | sort | tr '\n' ',')
  if check_changed "ssh_config" "$current_config"; then
    alert "SSH 配置变更: ${current_config}"
  fi
}

# ===== 7. 检查新增用户 =====
check_new_users() {
  local current_users
  current_users=$(grep -v "nologin\|false\|sync\|halt\|shutdown" /etc/passwd | grep "/bash\|/sh$" | cut -d: -f1 | sort | tr '\n' ',')
  if check_changed "shell_users" "$current_users"; then
    alert "可登录用户变更: ${current_users}"
  fi
}

# ===== 8. 检查 crontab =====
check_crontabs() {
  local root_cron
  root_cron=$(md5sum <(crontab -l 2>/dev/null) 2>/dev/null | awk '{print $1}')
  if check_changed "root_crontab" "$root_cron"; then
    alert "root crontab 已变更!"
  fi

  local system_cron
  system_cron=$(md5sum <(cat /etc/crontab 2>/dev/null) 2>/dev/null | awk '{print $1}')
  if check_changed "system_crontab" "$system_cron"; then
    alert "系统 crontab 已变更!"
  fi
}

# ===== 执行所有检查 =====
check_ssh_logins
check_root_keys
check_suspicious_processes
check_suspicious_files
check_sudo_users
check_ssh_config
check_new_users
check_crontabs

# ===== 输出结果 =====
if [ -n "$ALERTS" ]; then
  echo "🚨 [${TIMESTAMP}] 安全监控告警"
  echo "================================"
  echo -e "$ALERTS"

  if [ "$WRITE_LOG" = true ]; then
    echo "[${TIMESTAMP}] ALERTS:" >> "$LOG_FILE"
    echo -e "$ALERTS" >> "$LOG_FILE"
    echo "---" >> "$LOG_FILE"
  fi

  exit 1  # 有告警
else
  if [ "$QUIET" = false ]; then
    echo "✅ [${TIMESTAMP}] 安全检查通过，未发现异常"
  fi
  exit 0  # 正常
fi