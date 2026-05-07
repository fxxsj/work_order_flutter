# 新西彩订单管理 - Flutter 前端

> Flutter 3.x + Riverpod + GoRouter 跨平台应用

## 技术栈

- Flutter 3.41.2
- Riverpod (状态管理)
- GoRouter (路由)
- Dio (HTTP 客户端)

## 快速启动

### 1. 安装依赖

```bash
flutter pub get
```

### 2. 配置后端地址

默认连接 `http://127.0.0.1:8000/api/v1/`

修改方式（选一种）：

**方式 A：命令行参数（推荐）**
```bash
flutter run --dart-define=APP_API_BASE_URL=http://127.0.0.1:8000/api/v1/
```

**方式 B：修改配置文件**
```yaml
# config/application-dev.yaml
app:
  api:
    baseUrl: http://127.0.0.1:8000/api/v1/
```

### 3. 启动开发服务器

```bash
# Chrome Web
flutter run -d chrome

# Linux 桌面
flutter run -d linux

# Windows 桌面
flutter run -d windows

# macOS 桌面
flutter run -d macos
```

### 一键启动（需先配置）

```bash
# 交互式选择平台
./start.sh

# 或指定平台和环境
./start.sh chrome dev
./start.sh linux prod
```

## 环境说明

| 环境 | Profile | 用途 |
|------|---------|------|
| dev | `application-dev.yaml` | 本地开发 |
| test | `application-test.yaml` | 测试环境 |
| prod | `application-prod.yaml` | 生产环境 |

## 全平台构建

### 使用构建工具

```bash
# Web
dart run tool/build.dart web --profile prod --api-base-url https://api.example.com/api/v1/

# Android
dart run tool/build.dart android --profile prod --arch arm64 --api-base-url https://api.example.com/

# Windows
dart run tool/build.dart windows --profile prod --api-base-url https://api.example.com/

# Linux
dart run tool/build.dart linux --profile prod --api-base-url https://api.example.com/

# macOS
dart run tool/build.dart macos --profile prod --api-base-url https://api.example.com/
```

### 构建产物位置

- 开发构建: `dist/<platform>/<profile>/`
- 发布包: `release/<platform>/<profile>/`

## 目录结构

```
flutter/
├── lib/src/
│   ├── core/              # 核心层
│   │   ├── network/       # Dio HTTP 客户端
│   │   ├── models/        # 数据模型
│   │   ├── common/        # 工具类
│   │   └── presentation/  # 设计系统 (Tokens)
│   ├── features/          # 业务模块 (Feature-first)
│   │   └── */presentation/  # UI 页面
│   └── app/              # 应用入口
├── config/               # 环境配置文件
│   ├── application.yaml
│   ├── application-dev.yaml
│   ├── application-test.yaml
│   └── application-prod.yaml
├── tool/                 # 构建工具
│   ├── build.dart        # 统一构建入口
│   └── package_release.dart  # 发布打包
└── start.sh             # 一键启动脚本
```

## 启用平台支持

```bash
# Android
flutter config --enable-android

# Web
flutter config --enable-web

# Linux
flutter config --enable-linux

# Windows (仅 Windows)
flutter config --enable-windows

# macOS (仅 macOS)
flutter config --enable-macos
```

## 常见问题

**Q: 接口连接失败？**
A: 确保后端已启动且 `APP_API_BASE_URL` 配置正确。

**Q: 热重载不生效？**
A: 尝试 `flutter clean` 后重新 `flutter pub get`。

**Q: 生产构建后接口报错？**
A: 检查 `APP_API_BASE_URL` 是否为生产环境地址。

## GitHub Actions

- `ci.yml` - 分析、测试、Web 构建
- `release.yml` - 多平台发布 (Web/Linux/Windows)

触发 release：
- 手动: `workflow_dispatch`
- 自动: push tag `flutter-v*`
