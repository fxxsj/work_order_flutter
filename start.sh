#!/bin/bash
# Flutter 一键启动脚本

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 默认值
PLATFORM="android"
PROFILE="dev"
API_URL="http://127.0.0.1:8000/api/v1/"

# 帮助信息
show_help() {
    echo "用法: ./start.sh [平台] [环境]"
    echo ""
    echo "平台选项:"
    echo "  android - Android (默认)"
    echo "  chrome  - Chrome Web"
    echo "  linux  - Linux 桌面"
    echo "  windows - Windows 桌面"
    echo "  macos  - macOS 桌面"
    echo "  web    - Web (生产构建)"
    echo ""
    echo "环境选项:"
    echo "  dev  - 开发环境 (默认)"
    echo "  test - 测试环境"
    echo "  prod - 生产环境"
    echo ""
    echo "示例:"
    echo "  ./start.sh              # 交互式选择"
    echo "  ./start.sh android dev  # Android 开发模式"
    echo "  ./start.sh chrome dev   # Chrome 开发模式"
    echo "  ./start.sh linux prod  # Linux 生产环境"
    echo ""
    echo "API 地址配置:"
    echo "  dev:  http://127.0.0.1:8000/api/v1/"
    echo "  test: https://api.test.example.com/api/v1/"
    echo "  prod: https://api.example.com/api/v1/"
}

# 检查 Flutter 安装
check_flutter() {
    if ! command -v flutter &> /dev/null; then
        echo -e "${RED}错误: Flutter 未安装或不在 PATH 中${NC}"
        echo "请访问 https://flutter.dev/docs/get-started/install 安装 Flutter"
        exit 1
    fi

    if ! command -v dart &> /dev/null; then
        echo -e "${RED}错误: Dart 未安装${NC}"
        exit 1
    fi
}

# 获取 Flutter 版本
get_flutter_version() {
    flutter --version | head -1
}

# 安装依赖
install_deps() {
    echo -e "${GREEN}安装 Flutter 依赖...${NC}"
    flutter pub get
}

# 设置 API URL
set_api_url() {
    case $PROFILE in
        dev)
            API_URL="http://127.0.0.1:8000/api/v1/"
            ;;
        test)
            API_URL="https://api.test.example.com/api/v1/"
            ;;
        prod)
            API_URL="https://api.example.com/api/v1/"
            ;;
    esac
}

# 选择平台
select_platform() {
    echo ""
    echo "请选择运行平台:"
    echo "  1) Android (默认)"
    echo "  2) Chrome Web"
    echo "  3) Linux 桌面"
    echo "  4) Windows 桌面"
    echo "  5) macOS 桌面"
    echo "  6) Web (生产构建)"
    echo ""
    read -p "请输入选择 [1-6]: " choice

    case $choice in
        1) PLATFORM="android" ;;
        2) PLATFORM="chrome" ;;
        3) PLATFORM="linux" ;;
        4) PLATFORM="windows" ;;
        5) PLATFORM="macos" ;;
        6) PLATFORM="web" ;;
        *) echo -e "${YELLOW}无效选择，默认使用 Android${NC}"; PLATFORM="android" ;;
    esac
}

# 选择环境
select_profile() {
    echo ""
    echo "请选择运行环境:"
    echo "  1) dev  - 开发环境 (默认)"
    echo "  2) test - 测试环境"
    echo "  3) prod - 生产环境"
    echo ""
    read -p "请输入选择 [1-3]: " choice

    case $choice in
        1) PROFILE="dev" ;;
        2) PROFILE="test" ;;
        3) PROFILE="prod" ;;
        *) echo -e "${YELLOW}无效选择，默认使用 dev${NC}"; PROFILE="dev" ;;
    esac
}

# 启动 Flutter
launch_flutter() {
    set_api_url

    echo ""
    echo -e "${GREEN}=======================================${NC}"
    echo -e "${GREEN}  Flutter 启动配置${NC}"
    echo -e "${GREEN}=======================================${NC}"
    echo "  平台:   $PLATFORM"
    echo "  环境:   $PROFILE"
    echo "  API:    $API_URL"
    echo -e "${GREEN}=======================================${NC}"
    echo ""

    case $PLATFORM in
        android)
            flutter run -d android \
                --dart-define=APP_PROFILE=$PROFILE \
                --dart-define=APP_API_BASE_URL=$API_URL
            ;;
        chrome)
            flutter run -d chrome \
                --dart-define=APP_PROFILE=$PROFILE \
                --dart-define=APP_API_BASE_URL=$API_URL
            ;;
        linux)
            flutter run -d linux \
                --dart-define=APP_PROFILE=$PROFILE \
                --dart-define=APP_API_BASE_URL=$API_URL
            ;;
        windows)
            flutter run -d windows \
                --dart-define=APP_PROFILE=$PROFILE \
                --dart-define=APP_API_BASE_URL=$API_URL
            ;;
        macos)
            flutter run -d macos \
                --dart-define=APP_PROFILE=$PROFILE \
                --dart-define=APP_API_BASE_URL=$API_URL
            ;;
        web)
            echo "构建 Web 生产版本..."
            flutter build web --release \
                --dart-define=APP_PROFILE=$PROFILE \
                --dart-define=APP_API_BASE_URL=$API_URL
            echo ""
            echo -e "${GREEN}构建完成！产物在 build/web/${NC}"
            ;;
    esac
}

# 主流程
main() {
    check_flutter

    echo -e "${GREEN}Flutter 快速启动${NC}"
    get_flutter_version

    # 解析命令行参数
    if [ $# -ge 1 ]; then
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            android) PLATFORM="android" ;;
            chrome) PLATFORM="chrome" ;;
            linux) PLATFORM="linux" ;;
            windows) PLATFORM="windows" ;;
            macos) PLATFORM="macos" ;;
            web) PLATFORM="web" ;;
            *)
                echo -e "${RED}未知平台: $1${NC}"
                show_help
                exit 1
                ;;
        esac
    else
        select_platform
    fi

    if [ $# -ge 2 ]; then
        case $2 in
            dev) PROFILE="dev" ;;
            test) PROFILE="test" ;;
            prod) PROFILE="prod" ;;
            *)
                echo -e "${RED}未知环境: $2${NC}"
                show_help
                exit 1
                ;;
        esac
    else
        select_profile
    fi

    install_deps
    launch_flutter
}

main "$@"
