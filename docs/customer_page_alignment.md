# 客户管理对齐规范记录

版本: 1.0
更新时间: 2026-03-05
适用范围: Flutter CRUD 列表与表单页面

## 目标

将新模块（供应商、部门等）的列表与表单样式对齐到客户管理页面，统一布局、交互和视觉基线，降低维护成本。

## 对齐原则

- 结构一致: 列表页使用 `ListPageScaffold + PageHeaderBar + DataTable/移动端列表 + Pagination` 的固定骨架。
- 控件一致: 搜索、刷新、列管理、密度切换、分页与空/错态呈现完全一致。
- 表单一致: 表单区域按“左列主信息 + 右列补充信息”的结构组织，底部使用统一操作栏。

## 列表页对齐规范

1. 页头区域
- 组件: `PageHeaderBar`
- 桌面端: 搜索框 + 刷新 + 列管理 + 密度切换 + 新建按钮
- 移动端: 搜索框独占一行，操作按钮另起一行
- 参考: `lib/src/features/customer/presentation/customer_list_page.dart`

2. 搜索
- 行为: 输入后 450ms 防抖，回车立即搜索
- 入口: `_scheduleSearch`
- UI: `TextField` + `prefixIcon` 搜索图标 + `suffixIcon` 清空按钮

3. 表格
- 组件: `DataTable`
- 结构: `columns` 可选，`rows` 根据可见列渲染
- 密度: `ToggleButtons` 控制 `headingRowHeight` / `dataRowMinHeight` / `dataRowMaxHeight`
- 列管理: `CheckedPopupMenuItem`

4. 移动端列表
- 组件: `ListTile` + `CircleAvatar`
- 操作: 编辑按钮 + 右侧“更多”菜单（删除）
- 展示: 标题 + 二级信息用 `subtitle` 拼接
- 对齐参考: `lib/src/features/customer/presentation/widgets/customer_list_tile.dart`

5. 空/错态
- 空态: 统一背景色与图标大小
- 错态: 统一错误色与重试按钮
- 参考: `_EmptyState` / `_ErrorState`

6. 分页
- 组件: `_PaginationBar`
- 展示: “第 x / y 页，共 z 条” + pageSize 下拉 + 翻页按钮

## 表单页对齐规范

1. 页面骨架
- 顶部: `PageHeaderBar` + 返回按钮
- 中部: `Form + SingleChildScrollView`
- 底部: 固定操作栏（`PageActionButton`）

2. 表单布局
- 移动端: 单列垂直堆叠，按“基本信息 -> 联系信息 -> 补充信息”顺序
- 桌面端: 两列布局
  - 左列: 基本信息 + 联系信息
  - 右列: 补充信息（地址、备注、状态等）

3. 表单控件样式
- 所有输入控件统一 `OutlineInputBorder`
- 状态/多选类控件（如部门的工序与启用）需使用 `InputDecorator` 包裹，保持 label 和 border 一致

4. 底部操作栏
- 结构: `PageActionButton.outlined` + `PageActionButton.filled`
- 样式: 底部容器带 `surface` 背景 + 顶部分割线
- 参考: `lib/src/features/customer/presentation/customer_edit_page.dart`

## 关键实现文件

- 客户列表页: `lib/src/features/customer/presentation/customer_list_page.dart`
- 客户表单页: `lib/src/features/customer/presentation/customer_edit_page.dart`
- 客户移动端列表: `lib/src/features/customer/presentation/widgets/customer_list_tile.dart`

## 对齐检查清单

- 列表页
  - [ ] `PageHeaderBar` 控件顺序与客户一致
  - [ ] 搜索防抖与清空按钮存在
  - [ ] 列管理与密度切换存在
  - [ ] DataTable 行高与客户一致
  - [ ] 移动端列表使用 `ListTile + Avatar + 更多菜单`
  - [ ] 空态/错态视觉一致

- 表单页
  - [ ] 移动端单列顺序一致
  - [ ] 桌面端两列结构一致
  - [ ] 所有控件为 `OutlineInputBorder`
  - [ ] 状态/多选控件有 `InputDecorator`
  - [ ] 底部操作栏样式一致

