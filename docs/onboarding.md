# Flutter 上手指南

## 前置要求

- Flutter SDK >= 3.8.0
- Dart SDK
- Chrome（用于 Web 调试）

## 快速开始

```bash
# 安装
bash scripts/setup.sh

# 运行 Web 调试
bash scripts/run-web.sh

# 运行测试
bash scripts/test.sh

# 运行静态分析
bash scripts/analyze.sh
```

## 手动安装（如脚本不可用）

```bash
flutter pub get
flutter run -d chrome
```

## 开发命令

```bash
flutter pub get              # 安装依赖
flutter run -d chrome        # Web 调试
flutter run -d linux         # Linux 桌面
flutter analyze              # 静态分析
flutter test                 # 运行测试
flutter build web            # 构建 Web
flutter build apk            # 构建 APK
```

## 注意事项

- 开发时 API 地址默认指向 `http://127.0.0.1:8000/api/v1/`
- 通过 `--dart-define=APP_API_BASE_URL=...` 可自定义 API 地址
