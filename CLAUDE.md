# 印刷施工单跟踪系统 - Flutter

> Flutter 3.x + Riverpod + GoRouter 跨平台应用

## 技术栈

- Flutter 3.41.2
- Riverpod (状态管理)
- GoRouter (路由)
- Dio (HTTP 客户端)

## 关键目录

- `lib/src/core/` - 核心层 (网络、模型、工具)
- `lib/src/features/` - 业务模块 (Feature-first)
- `lib/src/features/*/presentation/` - UI 页面
- `lib/src/features/*/application/` - 业务逻辑
- `lib/src/features/*/domain/` - 实体
- `lib/src/features/*/data/` - Repository

## 架构模式

- **Feature-first Clean Architecture**
- **presentation/** - UI 页面和 widgets
- **application/** - Use cases / ViewModels
- **domain/** - 实体和业务规则
- **data/** - Repository 实现 (API 调用)

## 设计系统

- `ColorTokens` - 颜色 Token
- `TextTokens` - 文本 Token
- `OpacityTokens` - 透明度 Token
- `AnimationTokens` - 动画 Token

## Critical Rules

- 硬编码颜色必须使用 Token 系统
- 编辑页业务逻辑在 `*_edit_page.dart`
- HTTP 错误处理统一走 `AppDioInterceptors`

## 开发命令

```bash
flutter pub get
flutter run -d chrome      # Web
flutter run -d linux      # Linux
flutter analyze
flutter test
```

## Skill Activation

- Flutter 页面 → `flutter-patterns` + `flutter-architecture`
