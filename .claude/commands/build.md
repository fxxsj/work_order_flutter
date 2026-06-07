---
description: 构建 Flutter 生产包
allowed-tools: Bash(flutter:*,cd:*)
---

# Build 命令

构建 Flutter 生产包。

## 步骤

1. **构建 Web 包**
   ```bash
   bash scripts/build.sh web
   ```

2. **构建 APK**
   ```bash
   bash scripts/build.sh apk
   ```

## 输出格式

```markdown
## 构建报告

- ✅ 构建成功
- 📦 输出: build/xxx/
- ⏱️ 耗时: Xs
```
