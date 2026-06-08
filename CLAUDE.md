# 印刷生产管理系统 - Flutter

> Flutter 3.x + Provider + GoRouter 跨平台应用

## 技术栈

- Flutter 3.41.2
- Provider / ChangeNotifier (状态管理与 ViewModel 注入)
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
- FormData 文件上传优先使用 `ApiClient.requestRaw()`
- CRUD 表单字段使用 `CrudFieldConfig` 静态工厂
- 修改已有复杂页面使用精确 patch，避免整文件覆写

## 开发命令

推荐使用 `scripts/` 目录下的脚本，保持与 `.claude/commands/` 一致：

```bash
bash scripts/setup.sh       # 初始化安装（flutter pub get + build_runner）
bash scripts/analyze.sh     # 静态分析
bash scripts/test.sh        # 运行全部测试
bash scripts/test.sh test/e2e/  # 运行指定目录测试
bash scripts/run-web.sh     # 启动 Web (chrome)
bash scripts/build.sh web   # 构建 Web 生产包
bash scripts/build.sh apk   # 构建 Android APK
```

也支持直接使用 Flutter CLI：

```bash
flutter pub get
flutter run -d chrome
flutter run -d linux
flutter analyze
flutter test
```

## AI 命令

通过 `.claude/commands/` 提供快捷入口：

- `/flutter-analyze` → `bash scripts/analyze.sh`
- `/flutter-test` → `bash scripts/test.sh`
- `/flutter-build` → `bash scripts/build.sh`
- `/flutter-run-web` → `bash scripts/run-web.sh`

## Skill Activation

- Flutter 页面 → `flutter-patterns` + `flutter-architecture`
- Work Order Flutter 约定 → `work-order-flutter-patterns`
