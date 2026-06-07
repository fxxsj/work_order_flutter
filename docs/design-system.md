# 设计系统

## Token 系统

Flutter 端使用以下 Token 系统，禁止硬编码颜色、透明度、文本样式和动画参数。

### ColorTokens

```dart
ColorTokens.primary    // 主色 Teal
ColorTokens.secondary  // 次色
ColorTokens.error      // 错误色
ColorTokens.surface    // 背景色
// ...
```

### TextTokens

```dart
TextTokens.headline    // 标题样式
TextTokens.body        // 正文样式
TextTokens.caption     // 说明文字
// ...
```

### OpacityTokens

```dart
OpacityTokens.disabled // 禁用状态透明度
OpacityTokens.hint     // 提示文字透明度
// ...
```

### AnimationTokens

```dart
AnimationTokens.fast     // 快速动画时长
AnimationTokens.normal   // 普通动画时长
AnimationTokens.slow     // 慢速动画时长
// ...
```

## 主题

- 主色调：Teal (#14b8a6)
- 圆角：12px (rounded-xl)
- 暗色模式：支持

## 参考

详见项目根目录 `DESIGN.md`。
