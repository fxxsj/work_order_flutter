# 新西彩订单管理 - Flutter 前端

Flutter 3.x + Riverpod + GoRouter 跨平台应用

## 技术栈

- Flutter 3.41.2
- Riverpod（状态管理）
- GoRouter（路由）
- Dio（HTTP 客户端）
- Provider（ViewModel 注入）

## 项目结构

```
lib/src/
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
│   ├── sales_orders/        # 销售订单
│   ├── tasks/               # 任务管理
│   ├── approvals/           # 审批管理
│   ├── customer/            # 客户
│   ├── products/            # 产品
│   ├── materials/           # 物料
│   └── ...                  # 其他模块
└── app.dart                 # App 入口
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

## 开发规范

详见 docs/ 目录下的文档：
- [FLUTTER_CRUD_SPEC.md](../docs/FLUTTER_CRUD_SPEC.md) — CRUD 列表页开发规范
- [FLUTTER_COMPONENT_GUIDE.md](../docs/FLUTTER_COMPONENT_GUIDE.md) — 组件复用接入指南
