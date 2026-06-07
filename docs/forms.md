# 表单规范

## CrudFieldConfig

Flutter 端表单组件统一使用 `CrudFieldConfig`（非已废弃的 `CrudFormField`）。

## 使用示例

```dart
CrudFieldConfig(
  name: 'quantity',
  label: '数量',
  type: FieldType.number,
  required: true,
  validators: [Validators.required, Validators.min(0)],
)
```

## 字段类型

| 类型 | 说明 |
|------|------|
| `FieldType.text` | 文本输入 |
| `FieldType.number` | 数字输入 |
| `FieldType.date` | 日期选择 |
| `FieldType.dropdown` | 下拉选择 |
| `FieldType.file` | 文件上传 |

## 编辑页逻辑

- 编辑页业务逻辑在对应 `*_edit_page.dart` 中实现
- 表单验证在 `CrudFieldConfig.validators` 中定义
- 提交前统一调用 `formKey.currentState!.validate()`
