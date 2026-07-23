#!/usr/bin/env bash
set -euo pipefail

JAVA_PACKAGE="${JAVA_PACKAGE:-java-21-amazon-corretto-devel}"
JAVA_HOME_PATH="${JAVA_HOME_PATH:-/usr/lib/jvm/java-21-amazon-corretto.x86_64}"
PROFILE_FILE="${PROFILE_FILE:-/etc/profile.d/java21.sh}"

if [[ "$(id -u)" -ne 0 ]]; then
  echo "ERROR: please run as root, for example: sudo $0" >&2
  exit 1
fi

if [[ -r /etc/os-release ]]; then
  . /etc/os-release
else
  echo "ERROR: /etc/os-release not found" >&2
  exit 1
fi

if [[ "${ID:-}" != "amzn" ]]; then
  echo "WARN: this script is intended for Amazon Linux. Detected ID=${ID:-unknown}" >&2
fi

echo "== install JDK 21: $JAVA_PACKAGE =="
dnf install -y "$JAVA_PACKAGE"

if [[ ! -x "$JAVA_HOME_PATH/bin/java" ]]; then
  detected_home="$(dirname "$(dirname "$(readlink -f "$(command -v java)")")")"
  echo "WARN: expected JAVA_HOME not found: $JAVA_HOME_PATH" >&2
  echo "WARN: detected JAVA_HOME: $detected_home" >&2
  JAVA_HOME_PATH="$detected_home"
fi

echo "== set alternatives =="
alternatives --set java "$JAVA_HOME_PATH/bin/java" || true
if [[ -x "$JAVA_HOME_PATH/bin/javac" ]]; then
  alternatives --set javac "$JAVA_HOME_PATH/bin/javac" || true
fi

echo "== write JAVA_HOME: $PROFILE_FILE =="
cat > "$PROFILE_FILE" <<EOF
export JAVA_HOME=$JAVA_HOME_PATH
export PATH=\$JAVA_HOME/bin:\$PATH
EOF
chmod 0644 "$PROFILE_FILE"

echo "== verify =="
export JAVA_HOME="$JAVA_HOME_PATH"
export PATH="$JAVA_HOME/bin:$PATH"
java -version
javac -version
echo "JAVA_HOME=$JAVA_HOME"

echo "OK: JDK 21 installed"