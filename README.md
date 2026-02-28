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

接口地址在 `config/application.yaml` 中配置：

```yaml
app:
  api:
    baseUrl: http://127.0.0.1:8000/api/
```

开发/测试环境可覆盖：

```yaml
app:
  api:
    baseUrl: http://127.0.0.1:8000/api/
```

## 说明

- 登录页与注册页为简化版 UI，可按业务需求继续定制
- 若需接入更多模块，请在 `pages/layout/adaptive_shell.dart` 中扩展导航与页面

