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
echo -e "${BLUE}  Flutter 子仓 - 初始化安装${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 检查 Flutter 环境
echo -e "${BLUE}Step 1: 检查 Flutter 环境...${NC}"
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}✗ 未找到 flutter 命令，请确保 Flutter SDK 已安装并加入 PATH${NC}"
    exit 1
fi

FLUTTER_VERSION=$(flutter --version | head -n 1)
echo -e "${GREEN}✓ $FLUTTER_VERSION${NC}"
echo ""

# 安装依赖
echo -e "${BLUE}Step 2: 安装 Flutter 依赖...${NC}"
flutter pub get
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ 依赖安装完成${NC}"
else
    echo -e "${RED}✗ 依赖安装失败${NC}"
    exit 1
fi
echo ""

# 可选：生成代码（如存在 build_runner 依赖）
echo -e "${BLUE}Step 3: 检查是否需要生成代码...${NC}"
if grep -q "build_runner" pubspec.yaml 2> /dev/null; then
    echo -e "${BLUE}运行 build_runner build...${NC}"
    dart run build_runner build --delete-conflicting-outputs
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ 代码生成完成${NC}"
    else
        echo -e "${YELLOW}⚠ 代码生成出现警告或失败，可能需要手动处理${NC}"
    fi
else
    echo -e "${YELLOW}  未检测到 build_runner，跳过代码生成${NC}"
fi
echo ""

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Flutter 子仓初始化完成！${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "常用命令:"
echo "  bash scripts/analyze.sh     # 静态分析"
echo "  bash scripts/test.sh        # 运行测试"
echo "  bash scripts/test.sh <path> # 运行指定测试"
echo "  bash scripts/run-web.sh     # 启动 Web"
echo "  bash scripts/build.sh web   # 构建 Web 生产包"
echo ""
