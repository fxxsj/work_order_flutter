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
echo -e "${BLUE}  Flutter 子仓 - 静态分析${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

echo -e "${BLUE}运行 flutter analyze...${NC}"
flutter analyze

EXIT_CODE=$?
echo ""
if [ $EXIT_CODE -eq 0 ]; then
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}  静态分析通过，无问题！${NC}"
    echo -e "${GREEN}========================================${NC}"
else
    echo -e "${RED}========================================${NC}"
    echo -e "${RED}  静态分析发现问题，请修复后重试${NC}"
    echo -e "${RED}========================================${NC}"
fi

exit $EXIT_CODE
