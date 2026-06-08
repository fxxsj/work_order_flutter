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

usage() {
    echo "用法: bash scripts/build.sh [web|apk|ios|linux|macos|windows]"
    echo ""
    echo "示例:"
    echo "  bash scripts/build.sh web   # 构建 Web 包"
    echo "  bash scripts/build.sh apk   # 构建 Android APK"
    exit 0
}

TARGET="${1:-web}"

if [ "$TARGET" = "-h" ] || [ "$TARGET" = "--help" ]; then
    usage
fi

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Flutter 子仓 - 构建 $TARGET${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

case "$TARGET" in
    web)
        echo -e "${BLUE}构建 Flutter Web 生产包...${NC}"
        flutter build web --release
        ;;
    apk)
        echo -e "${BLUE}构建 Android APK...${NC}"
        flutter build apk --release
        ;;
    ios)
        echo -e "${BLUE}构建 iOS Release...${NC}"
        flutter build ios --release
        ;;
    linux)
        echo -e "${BLUE}构建 Linux 桌面应用...${NC}"
        flutter build linux --release
        ;;
    macos)
        echo -e "${BLUE}构建 macOS 桌面应用...${NC}"
        flutter build macos --release
        ;;
    windows)
        echo -e "${BLUE}构建 Windows 桌面应用...${NC}"
        flutter build windows --release
        ;;
    *)
        echo -e "${RED}✗ 不支持的构建目标: $TARGET${NC}"
        usage
        ;;
esac

EXIT_CODE=$?
echo ""
if [ $EXIT_CODE -eq 0 ]; then
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}  $TARGET 构建成功！${NC}"
    echo -e "${GREEN}========================================${NC}"
else
    echo -e "${RED}========================================${NC}"
    echo -e "${RED}  $TARGET 构建失败${NC}"
    echo -e "${RED}========================================${NC}"
fi

exit $EXIT_CODE
