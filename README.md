# 印刷生产管理系统 - Flutter 前端

Flutter 3.x + Provider + GoRouter 跨平台应用

## 技术栈

- Flutter 3.41.2
- Provider / ChangeNotifier（状态管理与 ViewModel 注入）
- GoRouter（路由）
- Dio（HTTP 客户端）

## 项目结构

```
lib/src/
├── app/                   # 应用组合根：路由、全局 provider、页面注册
├── core/
│   ├── common/              # 通用工具（Constant, ToastUtil, FormValidators）
│   ├── constants/           # 常量定义
│   ├── network/             # ApiClient, Dio 配置, Interceptors
│   └── presentation/
│       └── layout/          # 通用 UI 组件
│           ├── nav_config.dart       # 导航菜单配置
│           ├── widgets/              # CrudListPage, CrudEditPage, CrudFormField 等
│           └── theme/                # ColorTokens, TextTokens, OpacityTokens
├── features/                # 业务模块（Feature-first）
│   ├── workorders/          # 施工单
│   ├── sales_orders/        # 客户订单
│   ├── tasks/               # 任务管理
│   ├── approvals/           # 审批管理
│   ├── customer/            # 客户
│   ├── products/            # 产品
│   ├── materials/           # 物料
│   └── ...                  # 其他模块
```

## 架构模式

Feature-first Clean Architecture：

```
features/<feature>/
├── presentation/    # UI 页面和 widgets
├── application/     # ViewModels (状态管理)
├── domain/          # 实体和 Repository 接口
└── data/            # Repository 实现（API 调用）
```

依赖方向约束：

- `domain/` 不直接依赖 `data/`；DTO 与 API payload 转换留在 `data/`。
- `presentation/` 优先依赖 `application/` 和 `domain/`，页面装配逻辑放到 feature entry/module。
- `core/` 只放基础设施和通用 UI，不注册具体业务页面。

## 设计系统

- `ColorTokens` — 颜色 Token
- `TextTokens` — 文本 Token
- `OpacityTokens` — 透明度 Token
- `AnimationTokens` — 动画 Token

禁止硬编码颜色值。

## 开发命令

```bash
flutter pub get
flutter run -d chrome       # Web
flutter run -d linux        # Linux 桌面
flutter analyze
flutter test
```

## GitHub Tag 自动发布

`.github/workflows/release.yml` 监听语义化版本 Tag：

```text
v1.2.3
v1.2.3-beta.1
```

正式发布前：

1. 更新 `pubspec.yaml` 中的 `version`，版本名必须与 Tag 一致；
2. 在 GitHub 仓库的 **Settings → Secrets and variables → Actions → Secrets**
   中配置 `PROD_API_BASE_URL`，值使用 HTTPS 并以 `/api/v1/` 结尾；
3. 提交并推送代码；
4. 创建并推送 Tag。

例如，`pubspec.yaml` 为 `version: 1.2.3+12` 时：

```bash
git tag -a v1.2.3 -m "Release v1.2.3"
git push origin v1.2.3
```

工作流会先执行静态分析和测试，再并行构建：

- Web：`work-order-web-v1.2.3.tar.gz`
- Linux x64：`work-order-linux-x64-v1.2.3.tar.gz`
- Windows x64：`work-order-windows-x64-v1.2.3.zip`

构建成功后会自动创建 GitHub Release，附带 `SHA256SUMS` 和 GitHub
Artifact Attestation。预发布 Tag（如 `v1.2.3-beta.1`）会生成
Prerelease。

生产 API 地址只保存在 GitHub Actions 仓库 Secret 中，不写入公共仓库，
也不会以明文出现在 Actions 日志中。
`--dart-define` 会把它编译进客户端，因此它是部署配置，不应被当作密钥。

Android 正式产物需要长期保存的发布签名密钥。仓库尚未配置签名密钥时，
发布工作流不会生成临时 debug 签名 APK，避免后续版本因签名变化而无法覆盖
升级。

## 开发规范

详见 docs/ 目录下的文档：
- [FLUTTER_CRUD_SPEC.md](../docs/FLUTTER_CRUD_SPEC.md) — CRUD 列表页开发规范
- [FLUTTER_COMPONENT_GUIDE.md](../docs/FLUTTER_COMPONENT_GUIDE.md) — 组件复用接入指南
