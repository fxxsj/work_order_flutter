# Flutter 组件复用接入指南

## 目标

统一表单、详情、弹窗和附件上传的实现方式，减少新页面重复拼装。

当前优先复用的组件：

- `CrudListPage`
- `CrudEditPage`
- `CrudDetailPage`
- `CrudFormField`
- `FormDialog`
- `showFileUploadDialog`

## 1. 编辑页

适合标准新增 / 编辑页面。

```dart
return CrudEditPage<Customer, CustomerViewModel>(
  item: customer,
  config: CrudEditConfig<Customer, CustomerViewModel>(
    submitText: '保存',
    sectionsBuilder: (context, isMobile) => [
      CrudFormSection(
        title: '基本信息',
        fields: [
          CrudFormField.text(
            label: '客户名称',
            controller: nameController,
            validator: FormValidators.required,
          ),
          CrudFormField.phone(
            label: '联系电话',
            controller: phoneController,
            validator: FormValidators.phone,
          ),
          CrudFormField.tags(
            label: '标签',
            values: tags,
            onChanged: (values) => setState(() => tags = values),
          ),
        ],
      ),
    ],
    onSave: (context, viewModel, item) async {
      await viewModel.saveCustomer(...);
    },
  ),
);
```

## 2. 复杂字段

`CrudFormField` 已支持以下高频场景：

- `text`
- `number`
- `email`
- `phone`
- `date`
- `dateRange`
- `textarea`
- `toggle`
- `dropdown`
- `multiSelect`
- `checkboxGroup`
- `radioGroup`
- `tags`
- `fileUpload`
- `color`

### 多选复选框

```dart
CrudFormField.checkboxGroup(
  label: 'CMYK',
  options: const [
    CrudFieldOption(value: 'C', label: 'C'),
    CrudFieldOption(value: 'M', label: 'M'),
    CrudFieldOption(value: 'Y', label: 'Y'),
    CrudFieldOption(value: 'K', label: 'K'),
  ],
  values: selectedColors,
  onChanged: (values) => setState(() => selectedColors = values.cast<String>()),
)
```

### 单选组

```dart
CrudFormField.radioGroup(
  label: '对账单类型',
  value: statementType,
  options: const [
    CrudFieldOption(value: 'customer', label: '客户对账单'),
    CrudFieldOption(value: 'supplier', label: '供应商对账单'),
  ],
  onChanged: (value) => setState(() => statementType = value as String),
)
```

### 标签输入

```dart
CrudFormField.tags(
  label: '其他颜色',
  values: otherColors,
  hintText: '输入后按回车、逗号或换行添加',
  onChanged: (values) => setState(() => otherColors = values),
)
```

### 文件上传字段

```dart
CrudFormField.fileUpload(
  label: '附件',
  value: pickedFile,
  allowedExtensions: const ['pdf', 'png', 'jpg'],
  fallbackFilename: 'attachment',
  onChanged: (value) => setState(() => pickedFile = value),
  validator: (value) => value == null ? '请选择文件' : null,
)
```

## 3. 表单弹窗

适合列表页上的创建、生成、登记、审核备注等弹窗。

```dart
return FormDialog(
  title: '新建收款',
  formKey: formKey,
  submitText: '创建',
  onSubmit: submit,
  content: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      CrudFormField.radioGroup(...).build(context),
      const SizedBox(height: 12),
      TextFormField(...),
    ],
  ),
);
```

如果只是展示信息，不需要表单校验，优先使用 `BaseDialog`。

## 4. 通用上传弹窗

列表动作、详情动作里的“上传附件”优先复用：

```dart
final pickedFile = await showFileUploadDialog(
  context,
  title: '上传发票附件',
  label: '发票附件',
  allowedExtensions: const ['pdf', 'png', 'jpg'],
  fallbackFilename: 'invoice-attachment',
  helperText: '支持 PDF、图片等票据资料',
);

if (pickedFile != null) {
  await viewModel.uploadAttachment(id, pickedFile.file);
}
```

## 5. 详情页

统一只读展示优先走 `CrudDetailPage`：

```dart
return CrudDetailPage<Customer>(
  config: CrudDetailConfig<Customer>(
    title: '客户详情',
    item: customer,
    sections: [
      CrudDetailSection(
        title: '基本信息',
        fields: [
          CrudDetailField(label: '客户名称', value: customer.name),
          CrudDetailField(label: '联系电话', value: customer.phone),
        ],
      ),
    ],
  ),
);
```

## 6. 接入约束

- 新增标准表单页，优先尝试 `CrudEditPage`，不要先写裸 `Scaffold + Form`。
- 列表上的标准创建 / 编辑 / 生成弹窗，优先尝试 `FormDialog`。
- 文件上传动作，优先尝试 `showFileUploadDialog`。
- 多个离散布尔选项优先用 `checkboxGroup`，不要再手拼 `Wrap + CheckboxListTile`。
- 单一枚举选项优先用 `radioGroup`，不要继续堆 `Dropdown`。
