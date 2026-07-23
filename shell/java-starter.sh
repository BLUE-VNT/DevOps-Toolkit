#!/usr/bin/env bash
set -euo pipefail

APP_NAME="${APP_NAME:-app}"
APP_HOME="${APP_HOME:-$(cd "$(dirname "$0")" && pwd)}"
JAR_FILE="${JAR_FILE:-$APP_HOME/app.jar}"
JAVA_BIN="${JAVA_BIN:-java}"
JAVA_OPTS="${JAVA_OPTS:--Xms512m -Xmx512m -XX:+UseG1GC}"
APP_OPTS="${APP_OPTS:-}"
SPRING_PROFILES_ACTIVE="${SPRING_PROFILES_ACTIVE:-}"
SERVER_PORT="${SERVER_PORT:-}"

LOG_DIR="${LOG_DIR:-$APP_HOME/logs}"
PID_FILE="${PID_FILE:-$APP_HOME/$APP_NAME.pid}"
OUT_FILE="${OUT_FILE:-$LOG_DIR/$APP_NAME.out}"

mkdir -p "$LOG_DIR"

is_running() {
  [[ -f "$PID_FILE" ]] || return 1
  local pid
  pid="$(cat "$PID_FILE")"
  [[ -n "$pid" ]] || return 1
  kill -0 "$pid" >/dev/null 2>&1
}

build_app_args() {
  local args=()

  if [[ -n "$SPRING_PROFILES_ACTIVE" ]]; then
    args+=("--spring.profiles.active=$SPRING_PROFILES_ACTIVE")
  fi

  if [[ -n "$SERVER_PORT" ]]; then
    args+=("--server.port=$SERVER_PORT")
  fi

  if [[ -n "$APP_OPTS" ]]; then
    # shellcheck disable=SC2206
    args+=($APP_OPTS)
  fi

  printf '%q ' "${args[@]}"
}

start() {
  if is_running; then
    echo "$APP_NAME is already running, pid=$(cat "$PID_FILE")"
    return 0
  fi

  if [[ ! -f "$JAR_FILE" ]]; then
    echo "ERROR: jar file not found: $JAR_FILE" >&2
    exit 1
  fi

  local app_args
  app_args="$(build_app_args)"

  echo "Starting $APP_NAME"
  echo "JAR_FILE=$JAR_FILE"
  echo "JAVA_OPTS=$JAVA_OPTS"
  echo "APP_ARGS=$app_args"
  echo "LOG=$OUT_FILE"

  # shellcheck disable=SC2086
  nohup "$JAVA_BIN" $JAVA_OPTS -jar "$JAR_FILE" $app_args >> "$OUT_FILE" 2>&1 &
  echo $! > "$PID_FILE"
  sleep 1

  if is_running; then
    echo "$APP_NAME started, pid=$(cat "$PID_FILE")"
  else
    echo "ERROR: $APP_NAME failed to start. Last logs:" >&2
    tail -n 80 "$OUT_FILE" >&2 || true
    exit 1
  fi
}

stop() {
  if ! is_running; then
    echo "$APP_NAME is not running"
    rm -f "$PID_FILE"
    return 0
  fi

  local pid
  pid="$(cat "$PID_FILE")"
  echo "Stopping $APP_NAME, pid=$pid"
  kill "$pid"

  for _ in {1..30}; do
    if ! kill -0 "$pid" >/dev/null 2>&1; then
      rm -f "$PID_FILE"
      echo "$APP_NAME stopped"
      return 0
    fi
    sleep 1
  done

  echo "Force stopping $APP_NAME, pid=$pid"
  kill -9 "$pid" >/dev/null 2>&1 || true
  rm -f "$PID_FILE"
}

status() {
  if is_running; then
    echo "$APP_NAME is running, pid=$(cat "$PID_FILE")"
  else
    echo "$APP_NAME is not running"
    exit 1
  fi
}

logs() {
  touch "$OUT_FILE"
  tail -n "${TAIL_LINES:-200}" -f "$OUT_FILE"
}

case "${1:-}" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  restart)
    stop
    start
    ;;
  status)
    status
    ;;
  logs)
    logs
    ;;
  *)
    echo "Usage: $0 {start|stop|restart|status|logs}"
    echo
    echo "Environment variables:"
    echo "  APP_NAME=$APP_NAME"
    echo "  APP_HOME=$APP_HOME"
    echo "  JAR_FILE=$JAR_FILE"
    echo "  JAVA_BIN=$JAVA_BIN"
    echo "  JAVA_OPTS=$JAVA_OPTS"
    echo "  APP_OPTS=$APP_OPTS"
    echo "  SPRING_PROFILES_ACTIVE=$SPRING_PROFILES_ACTIVE"
    echo "  SERVER_PORT=$SERVER_PORT"
    echo "  LOG_DIR=$LOG_DIR"
    exit 2
    ;;
esac
