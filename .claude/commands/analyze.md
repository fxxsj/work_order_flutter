---
description: 运行 Flutter 静态分析
allowed-tools: Bash(flutter:*,cd:*)
---

# Analyze 命令

运行 Flutter 静态分析工具。

## 步骤

1. **运行分析**
   ```bash
   bash scripts/analyze.sh
   ```

2. **失败分析**
   - 识别 analyze 错误和警告
   - 提供修复建议

## 输出格式

```markdown
## Flutter Analyze 报告

- ✅ 无问题 / ⚠️ N warnings / ❌ N errors

### 发现的问题
- 列出需要修复的问题
```
