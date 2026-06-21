#!/usr/bin/env bash
set -euo pipefail

SCRIPT_SOURCE="${BASH_SOURCE[0]:-$0}"
if [[ "$SCRIPT_SOURCE" != /* ]]; then
    SCRIPT_SOURCE="$PWD/$SCRIPT_SOURCE"
fi
SCRIPT_DIR="$(cd "$(dirname "$SCRIPT_SOURCE")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$ROOT"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Flutter 子仓 - 启动开发环境${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 默认使用 chrome，可通过参数指定设备
DEVICE="${1:-chrome}"

echo -e "${BLUE}启动 Flutter 开发服务器 (device: $DEVICE)...${NC}"
flutter run -d "$DEVICE" --hot
