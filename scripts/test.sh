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
echo -e "${BLUE}  Flutter 子仓 - 运行测试${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 可选参数：指定测试文件或目录
TEST_TARGET="${1:-}"

if [ -n "$TEST_TARGET" ]; then
    echo -e "${BLUE}运行指定测试: $TEST_TARGET${NC}"
    flutter test "$TEST_TARGET"
else
    echo -e "${BLUE}运行全部测试...${NC}"
    flutter test
fi

EXIT_CODE=$?
echo ""
if [ $EXIT_CODE -eq 0 ]; then
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}  所有测试通过！${NC}"
    echo -e "${GREEN}========================================${NC}"
else
    echo -e "${RED}========================================${NC}"
    echo -e "${RED}  部分测试失败，请查看上方输出${NC}"
    echo -e "${RED}========================================${NC}"
fi

exit $EXIT_CODE
