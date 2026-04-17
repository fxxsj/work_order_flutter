# 发布 Secrets 配置说明

本文档记录 Flutter 全平台发布流程中需要配置的 GitHub Actions Secrets 和 Variables，以及它们的来源、生成方式和用途。

适用 workflow：

- `.github/workflows/flutter-web-release.yml`
- `.github/workflows/flutter-android-release.yml`
- `.github/workflows/flutter-windows-release.yml`
- `.github/workflows/flutter-macos-release.yml`
- `.github/workflows/flutter-linux-release.yml`

## 配置入口

GitHub 仓库中进入：

`Settings -> Secrets and variables -> Actions`

分两类配置：

- `Secrets`：证书、密码、私密账号
- `Variables`：公开构建参数，例如 API 地址、显示名

## Variables

建议至少配置以下 Variables：

### `FLUTTER_APP_API_BASE_URL`

用途：

- 所有正式构建默认读取的后端 API 地址

示例：

```text
https://api.your-domain.com/api/v1/
```

说明：

- 生产发布不要再使用 `127.0.0.1`、`localhost`、`0.0.0.0`
- `tool/build.dart` 在 `prod` 下要求显式提供生产 API 地址

### `FLUTTER_APP_DISPLAY_NAME`

用途：

- 发布构建时注入应用显示名称

示例：

```text
新西彩订单管理
```

说明：

- 不配置时，workflow 会回退到仓库内默认值

## Android Secrets

Android 发布签名使用 Java keystore。

### 需要配置的 Secrets

- `ANDROID_KEYSTORE_BASE64`
- `ANDROID_KEYSTORE_PASSWORD`
- `ANDROID_KEY_ALIAS`
- `ANDROID_KEY_PASSWORD`

### 字段说明

#### `ANDROID_KEYSTORE_BASE64`

用途：

- Android 签名 keystore 文件的 Base64 内容

生成方式：

```bash
base64 -w 0 upload-keystore.jks
```

macOS 可用：

```bash
base64 upload-keystore.jks | tr -d '\n'
```

#### `ANDROID_KEYSTORE_PASSWORD`

用途：

- keystore store password

#### `ANDROID_KEY_ALIAS`

用途：

- keystore 中用于签名的 key alias

#### `ANDROID_KEY_PASSWORD`

用途：

- alias 对应 key 的密码

### 本地生成 keystore 示例

```bash
keytool -genkeypair \
  -v \
  -keystore upload-keystore.jks \
  -alias release \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000
```

说明：

- 当前 CI 会将 `ANDROID_KEYSTORE_BASE64` 解码到：
  `flutter_frontend/android/upload-keystore.jks`
- [build.gradle.kts](../android/app/build.gradle.kts) 已支持通过环境变量注入正式签名

## Windows Secrets

Windows 发布签名使用 `.pfx` 证书。

### 需要配置的 Secrets

- `WINDOWS_CERTIFICATE_BASE64`
- `WINDOWS_CERTIFICATE_PASSWORD`

### 字段说明

#### `WINDOWS_CERTIFICATE_BASE64`

用途：

- `.pfx` 证书文件的 Base64 内容

生成方式：

```bash
base64 -w 0 codesign.pfx
```

macOS 可用：

```bash
base64 codesign.pfx | tr -d '\n'
```

#### `WINDOWS_CERTIFICATE_PASSWORD`

用途：

- `.pfx` 证书导出密码

说明：

- 当前 workflow 会使用 `signtool` 给 `release/windows/...` 下的 `.exe` 进行签名
- 目前主要签名对象是 Inno Setup 生成的安装包

## macOS Secrets

macOS 发布分两步：

1. `codesign`
2. `notarytool + stapler`

### 需要配置的 Secrets

- `MACOS_CERTIFICATE_BASE64`
- `MACOS_CERTIFICATE_PASSWORD`
- `MACOS_KEYCHAIN_PASSWORD`
- `MACOS_SIGNING_IDENTITY`
- `MACOS_NOTARY_APPLE_ID`
- `MACOS_NOTARY_TEAM_ID`
- `MACOS_NOTARY_APP_PASSWORD`

### 字段说明

#### `MACOS_CERTIFICATE_BASE64`

用途：

- Apple Developer 签名证书 `.p12` 文件的 Base64 内容

生成方式：

```bash
base64 macos-signing.p12 | tr -d '\n'
```

#### `MACOS_CERTIFICATE_PASSWORD`

用途：

- 导出 `.p12` 时设置的密码

#### `MACOS_KEYCHAIN_PASSWORD`

用途：

- GitHub Actions 临时 keychain 的密码

说明：

- 这是 CI 临时 keychain 密码，不是 Apple 账号密码
- 建议使用随机强密码

#### `MACOS_SIGNING_IDENTITY`

用途：

- `codesign` 使用的签名身份

示例：

```text
Developer ID Application: Your Company Name (TEAMID1234)
```

获取方式：

在本地 macOS 机器上导入证书后执行：

```bash
security find-identity -v -p codesigning
```

#### `MACOS_NOTARY_APPLE_ID`

用途：

- 提交 notarization 使用的 Apple ID

示例：

```text
your-account@example.com
```

#### `MACOS_NOTARY_TEAM_ID`

用途：

- Apple Developer Team ID

#### `MACOS_NOTARY_APP_PASSWORD`

用途：

- Apple ID 的 app-specific password

生成入口：

- Apple ID 管理后台 -> Sign-In and Security -> App-Specific Passwords

说明：

- 当前 workflow 只在 tag 发布时执行 notarization
- 如果未配置 notarization 相关 secrets，macOS 构建仍可完成，但不会 notarize

## Web

Web 发布不需要证书签名，但仍依赖：

- `FLUTTER_APP_API_BASE_URL`
- `FLUTTER_APP_DISPLAY_NAME`

输出产物为：

- `release/web/<profile>/...zip`

## Linux

当前 Linux 发布流程生成：

- `tar.gz`
- `deb`
- `rpm`
- `AppImage`

目前未引入 Linux 平台证书签名，因此不需要额外 Secrets。

如果后续要补：

- GPG 签名
- 仓库元数据签名
- AppImage 签名

再单独扩展这份文档。

## 推荐配置方式

建议使用仓库级 Secrets / Variables，而不是写死到 workflow：

- 便于轮换证书
- 不污染代码仓库
- 不需要改动构建脚本

建议命名保持当前文档中的 key，不要自行变体，否则 workflow 也要同步改。

## 最低可用配置

如果你只是先把 CI 跑通：

- Web:
  - `FLUTTER_APP_API_BASE_URL`
- Android:
  - 上面 Web 的变量
  - 4 个 Android secrets
- Windows:
  - 上面 Web 的变量
  - 2 个 Windows secrets
- macOS:
  - 上面 Web 的变量
  - 7 个 macOS secrets

Linux 当前不需要额外 secrets。

## 排查建议

### Android 签名失败

优先检查：

- Base64 是否为单行
- keystore 密码是否正确
- alias 是否存在
- key password 是否匹配

### Windows 签名失败

优先检查：

- `.pfx` 是否可正常导入
- 证书密码是否正确
- runner 上 `signtool.exe` 是否存在

### macOS 签名或 notarization 失败

优先检查：

- `.p12` 是否正确导出
- `MACOS_SIGNING_IDENTITY` 是否与证书匹配
- Apple ID、Team ID、app-specific password 是否有效

## 相关文件

- [Flutter 前端 README](../README.md)
- [Android 签名配置](../android/app/build.gradle.kts)
- [Android 发布 workflow](../../.github/workflows/flutter-android-release.yml)
- [Windows 发布 workflow](../../.github/workflows/flutter-windows-release.yml)
- [macOS 发布 workflow](../../.github/workflows/flutter-macos-release.yml)
