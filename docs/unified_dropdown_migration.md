# UnifiedDropdown 组件文档

## 概述

`UnifiedDropdown` 是一个新的统一下拉选择框组件，整合了单选和多选功能，提供了一致的 API 和用户体验。

## 主要特性

| 特性 | 说明 |
|------|------|
| **统一 API** | 单选和多选使用相同的组件，只需切换 `isMultiSelect` 参数 |
| **自适应弹出** | 桌面端使用 Popover，移动端使用 BottomSheet |
| **内置搜索** | 选项超过 7 个时自动显示搜索框 |
| **分组支持** | 支持 `DropdownDivider` 和 `DropdownGroupHeader` |
| **副标题和图标** | 选项可以显示图标和副标题 |
| **无障碍支持** | 内置 Semantics 和 FocusNode 支持 |
| **键盘导航** | 支持键盘操作 |

## 基础用法

### 单选下拉框

```dart
UnifiedDropdown<String>(
  value: _selectedValue,
  options: const [
    DropdownOption(value: 'apple', label: '苹果'),
    DropdownOption(value: 'banana', label: '香蕉'),
    DropdownOption(value: 'orange', label: '橙子'),
  ],
  decoration: const InputDecoration(
    labelText: '选择水果',
    border: OutlineInputBorder(),
  ),
  onChanged: (value) {
    setState(() => _selectedValue = value);
  },
)
```

### 多选下拉框

```dart
UnifiedDropdown<int>(
  value: _selectedValues,  // Set<int>
  options: const [
    DropdownOption(value: 1, label: '选项 1'),
    DropdownOption(value: 2, label: '选项 2'),
    DropdownOption(value: 3, label: '选项 3'),
  ],
  decoration: const InputDecoration(
    labelText: '选择多个选项',
    border: OutlineInputBorder(),
  ),
  onChanged: (value) {
    setState(() => _selectedValues = value as Set<int>);
  },
  isMultiSelect: true,
)
```

### 带图标和副标题

```dart
UnifiedDropdown<String>(
  value: _selectedValue,
  options: const [
    DropdownOption(
      value: 'settings',
      label: '设置',
      icon: Icons.settings,
      secondaryLabel: '系统设置选项',
    ),
    DropdownOption(
      value: 'profile',
      label: '个人资料',
      icon: Icons.person,
      secondaryLabel: '管理您的个人信息',
    ),
  ],
  decoration: const InputDecoration(labelText: '选择设置项'),
  onChanged: (value) => setState(() => _selectedValue = value),
)
```

### 自定义搜索

```dart
UnifiedDropdown<String>(
  value: _selectedValue,
  options: _options,
  decoration: const InputDecoration(labelText: '搜索用户'),
  onChanged: (value) => setState(() => _selectedValue = value),
  searchConfig: DropdownSearchConfig(
    enabled: true,
    hintText: '输入姓名或邮箱搜索',
    matcher: (query, option) {
      // 自定义匹配逻辑
      return option.label.toLowerCase().contains(query) ||
          option.secondaryLabel?.toLowerCase().contains(query) == true;
    },
  ),
  minOptionsForSearch: 1,  // 始终显示搜索框
)
```

## API 参考

### UnifiedDropdown

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `options` | `List<dynamic>` | 必填 | 选项列表 |
| `value` | `dynamic` | - | 当前值（单选）或已选值集合（多选） |
| `onChanged` | `ValueChanged<dynamic>?` | - | 值变化回调 |
| `decoration` | `InputDecoration` | - | 输入装饰 |
| `enabled` | `bool` | true | 是否启用 |
| `isMultiSelect` | `bool` | false | 是否多选 |
| `searchConfig` | `DropdownSearchConfig` | - | 搜索配置 |
| `emptyText` | `String` | '暂无可选项' | 无选项时的提示 |
| `noResultsText` | `String` | '无匹配结果' | 无搜索结果时的提示 |
| `selectHintText` | `String` | '请选择' | 选择提示 |
| `confirmText` | `String` | '确定' | 确定按钮文本 |
| `cancelText` | `String` | '取消' | 取消按钮文本 |
| `clearText` | `String` | '清空' | 清空按钮文本 |
| `selectAllText` | `String` | '全选' | 全选按钮文本 |
| `minOptionsForSearch` | `int` | 7 | 显示搜索框的最小选项数 |

### DropdownOption

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `value` | `T` | 必填 | 选项值 |
| `label` | `String` | 必填 | 显示文本 |
| `enabled` | `bool` | true | 是否启用 |
| `icon` | `IconData?` | - | 图标 |
| `secondaryLabel` | `String?` | - | 副标题 |
| `groupLabel` | `String?` | - | 分组标签（预留） |

### DropdownSearchConfig

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `enabled` | `bool` | true | 是否启用搜索 |
| `hintText` | `String?` | - | 搜索提示文本 |
| `matcher` | `bool Function(String, DropdownOption)?` | - | 自定义匹配器 |
| `highlightMatches` | `bool` | false | 是否高亮匹配（预留） |

## 迁移指南

### 从 SearchableDropdownFormField 迁移

**之前：**
```dart
SearchableDropdownFormField<int>(
  initialValue: selectedId,
  decoration: const InputDecoration(labelText: '客户'),
  items: customers.map((c) => DropdownMenuItem<int>(
    value: c.id,
    child: Text(c.name),
  )).toList(),
  onChanged: (value) => setState(() => selectedId = value),
)
```

**之后：**
```dart
UnifiedDropdown<int>(
  value: selectedId,
  options: customers.map((c) => DropdownOption(
    value: c.id,
    label: c.name,
  )).toList(),
  decoration: const InputDecoration(labelText: '客户'),
  onChanged: (value) => setState(() => selectedId = value),
)
```

### 从 CrudFormField.dropdown 迁移

`CrudFormField.dropdown` 已经内部使用 `UnifiedDropdown`，无需修改代码。

### 从 CrudFormField.multiSelect 迁移

`CrudFormField.multiSelect` 已经内部使用 `UnifiedDropdown`，无需修改代码。

## 注意事项

1. **类型安全**：单选时 `value` 是 `T?` 类型，多选时是 `Set<T>` 类型
2. **状态同步**：使用 `onChanged` 回调来更新状态
3. **表单验证**：通过 `validator` 参数添加验证逻辑
4. **性能优化**：大数据量时考虑分页或虚拟滚动
