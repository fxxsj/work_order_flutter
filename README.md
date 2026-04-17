# 新西彩订单管理

新西彩订单管理系统（Work Order ERP）前端项目，基于 Flutter 构建，服务于印刷生产订单的全流程协同。

## 特性

- 自适应布局（桌面 / 平板 / 移动端）
- Material 3 视觉与主题色切换
- Dio 网络层 + GetX 状态管理
- 支持接入 Django 后端 JWT/Token

## 运行环境

- Flutter >= 3.0
- Dart >= 3.0

## 运行

```bash
flutter pub get
flutter run -d linux
```

如需运行到 Android 或 Web，请先确保对应平台已启用：

```bash
flutter config --enable-android
flutter config --enable-web
```

## 配置

默认配置会从 `config/application.yaml` 读取当前环境，再加载对应的
`config/application-<profile>.yaml`。当前仓库内置：

- `application-dev.yaml`
- `application-test.yaml`
- `application-prod.yaml`

推荐优先使用 `dart-define` 覆盖，而不是上线前手工改文件。

接口地址配置示例：

```yaml
app:
  api:
    baseUrl: http://127.0.0.1:8000/api/v1/
```

开发/测试/生产环境可分别覆盖：

```yaml
app:
  api:
    baseUrl: https://api.example.com/api/v1/
```

推荐构建方式：

```bash
flutter run \
  --dart-define=APP_PROFILE=dev \
  --dart-define=APP_API_BASE_URL=http://127.0.0.1:8000/api/v1/

flutter build windows \
  --dart-define=APP_PROFILE=prod \
  --dart-define=APP_API_BASE_URL=https://api.your-domain.com/api/v1/
```

生产环境下，如果接口地址仍然是 `127.0.0.1` / `localhost` / `0.0.0.0`，
应用启动时会直接报错，避免把开发地址误带上线。

## 全平台构建

项目提供统一构建入口：

```bash
dart run tool/build.dart <platform> [options]
```

支持平台：

- `web`
- `android`
- `windows`
- `macos`
- `linux`

示例：

```bash
dart run tool/build.dart web --profile prod --api-base-url https://api.example.com/api/v1/
dart run tool/build.dart android --profile prod --arch arm64 --api-base-url https://api.example.com/api/v1/
dart run tool/build.dart windows --profile prod --arch amd64 --api-base-url https://api.example.com/api/v1/
dart run tool/build.dart macos --profile prod --arch arm64 --api-base-url https://api.example.com/api/v1/
dart run tool/build.dart linux --profile prod --arch amd64 --api-base-url https://api.example.com/api/v1/
```

构建完成后，产物会整理到：

```text
dist/<platform>/<profile>/<arch?>/
```

发布归档会输出到：

```text
release/<platform>/<profile>/<arch?>/
```

说明：

- Android 这版会根据 `--arch` 映射到对应 ABI 并输出 APK
- Windows / macOS / Linux 当前按宿主机构建，`--arch` 主要用于发布目录标识
- 桌面端发布归档会在宿主工具可用时继续产出平台发行包

统一归档入口：

```bash
dart run tool/package_release.dart web --profile prod
dart run tool/package_release.dart android --profile prod --arch arm64
dart run tool/package_release.dart windows --profile prod
dart run tool/package_release.dart macos --profile prod
dart run tool/package_release.dart linux --profile prod --arch amd64
```

GitHub Actions 已补齐五个平台 workflow：

- `.github/workflows/flutter-web-release.yml`
- `.github/workflows/flutter-android-release.yml`
- `.github/workflows/flutter-windows-release.yml`
- `.github/workflows/flutter-macos-release.yml`
- `.github/workflows/flutter-linux-release.yml`

使用前请在仓库变量中配置：

- `FLUTTER_APP_API_BASE_URL`
- `FLUTTER_APP_DISPLAY_NAME`（可选）

发布凭据与账号配置说明见：

- [docs/release_secrets_guide.md](./docs/release_secrets_guide.md)

如果要继续向 FlClash 的发布形态靠拢，下一步需要补的就是平台专用发行器：

- Windows：当前已接入 Inno Setup，可生成 `zip + installer.exe`，支持 PFX 证书签名
- macOS：当前已接入 `zip + dmg`，支持 codesign + notarization
- Linux：当前已接入 `tar.gz + deb + rpm + AppImage`

当前发布形态：

- `web`: zip
- `android`: apk
- `windows`: zip + 安装包 exe（CI 已安装 Inno Setup）
- `macos`: zip + dmg
- `linux`: tar.gz + deb + rpm + AppImage

## 说明

- 登录页与注册页为简化版 UI，可按业务需求继续定制
- 若需接入更多模块，请在 `pages/layout/adaptive_shell.dart` 中扩展导航与页面
