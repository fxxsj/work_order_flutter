#!/usr/bin/env bash
set -euo pipefail

SCRIPT_SOURCE="${BASH_SOURCE[0]:-$0}"
if [[ "$SCRIPT_SOURCE" != /* ]]; then
    SCRIPT_SOURCE="$PWD/$SCRIPT_SOURCE"
fi
SCRIPT_DIR="$(cd "$(dirname "$SCRIPT_SOURCE")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$ROOT"

# Flutter 静态分析已作为 release-check 入口；style-check 保留格式检查占位，
# 后续可接入 dart format --set-exit-if-changed。
echo "Flutter style-check: skipped (analyze covers static style)"
