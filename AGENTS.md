# Agent Instructions

本仓同时支持 Claude Code 和 Codex 等通用 Agent。

- **Claude Code 入口**: `CLAUDE.md`
- **Codex/通用 Agent 入口**: `AGENTS.md`
- **规则主源**: `CLAUDE.md`
- **同步规则**: 修改架构、测试、脚本或安全约定时，必须同步检查本文件是否需要更新

请优先阅读 `CLAUDE.md`，并遵守其中的技术栈、测试、目录和提交约定。

## Flutter 专属 Skill

修改 Flutter 客户端时优先使用 `work-order-flutter-patterns`，并结合 `flutter-patterns` / `flutter-architecture`。重点遵守 Token、CrudFieldConfig、AppDioInterceptors、ApiClient.requestRaw、Feature-first 目录和精确 patch 约定。
