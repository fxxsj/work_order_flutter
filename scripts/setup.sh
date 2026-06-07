#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.."

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Flutter 初始化安装${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 检查 Flutter
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}错误: Flutter 未安装${NC}"
    exit 1
fi

echo -e "${GREEN}Flutter: $(flutter --version | head -1)${NC}"
echo ""

# 安装依赖
echo -e "${BLUE}安装依赖...${NC}"
flutter pub get
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ 依赖安装完成${NC}"
else
    echo -e "${RED}✗ 依赖安装失败${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Flutter 安装完成${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "开发: bash scripts/run-web.sh"
echo "测试: bash scripts/test.sh"
