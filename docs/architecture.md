# Flutter 架构

> Flutter 3.x + Provider + GoRouter 跨平台应用架构说明。

## 目录结构

```
flutter/
├── lib/
│   ├── src/
│   │   ├── core/              # 核心层（网络、模型、工具）
│   │   │   ├── network/       # Dio 配置、拦截器
│   │   │   ├── models/        # 数据模型
│   │   │   └── utils/         # 工具函数
│   │   └── features/          # 业务模块（Feature-first）
│   │       └── workorder/
│   │           ├── presentation/  # UI 页面和 widgets
│   │           ├── application/   # Use cases / ViewModels
│   │           ├── domain/        # 实体和业务规则
│   │           └── data/          # Repository 实现
│   └── main.dart              # 应用入口
├── test/                      # 测试
│   ├── unit/
│   ├── widget/
│   └── integration/
├── docs/                      # 文档
└── pubspec.yaml
```

## Feature-first Clean Architecture

```
┌─────────────────────────────────────────┐
│           Presentation                  │
│  UI 页面、widgets、状态监听              │
│  调用 → Application                     │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│           Application                   │
│  Use cases / ViewModels                 │
│  业务逻辑编排、状态管理                   │
│  调用 → Domain / Data                   │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│             Domain                      │
│  实体（Entity）、值对象                   │
│  业务规则（不依赖框架）                   │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│              Data                       │
│  Repository 实现                         │
│  API 调用、本地存储、数据转换             │
│  Dio / SharedPreferences                 │
└─────────────────────────────────────────┘
```

## 关键约定

- **硬编码颜色**：必须使用 Token 系统，禁止硬编码
- **编辑页逻辑**：在对应 `*_edit_page.dart` 中实现
- **HTTP 错误**：统一走 `AppDioInterceptors`
- **文件上传**：使用 `requestRaw()`
- **状态管理**：Provider / ChangeNotifier
- **路由**：GoRouter
