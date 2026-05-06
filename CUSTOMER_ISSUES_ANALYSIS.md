# Customer Management Feature - 问题分析

> 检查时间：2026-03-02 20:54
> Feature: Customer Management
> 状态：✅ 可运行，⚠️ 功能未完成

---

## ✅ 已正常工作的部分

### 1. 编译状态
```
✅ 0 个 error
⚠️  2 个 warning（unused import）
```

### 2. 基础架构
- ✅ 完整的 Feature 结构
- ✅ Model + API + Controller + Widget
- ✅ GetX 状态管理
- ✅ 集成到路由系统

### 3. 已实现功能
- ✅ 客户列表显示（UI）
- ✅ 搜索框
- ✅ 过滤（仅显示启用）
- ✅ 删除确认对话框
- ✅ Toast 错误提示
- ✅ 下拉刷新
- ✅ 加载更多（分页）

---

## ⚠️ 存在的问题

### 1. 功能未完成（高优先级）

#### 问题 1.1：新建/编辑客户表单未实现
```dart
// customer_list.dart:191-198
void _showCustomerForm(BuildContext context, [Customer? customer]) {
  // TODO: Implement form dialog
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(customer == null ? '新建客户' : '编辑客户: ${customer.name}'),
      action: SnackBarAction(
        label: 'TODO',
        onPressed: () {},
      ),
    ),
  );
}
```

**影响**：
- ❌ 无法新建客户
- ❌ 无法编辑客户
- ✅ 删除功能可用

**建议**：
- 创建 `CustomerFormDialog` Widget
- 实现表单验证
- 集成到 `_showCustomerForm`

---

#### 问题 1.2：客户详情页未实现
```dart
// customer_list.dart:191-195
void _showCustomerDetail(BuildContext context, Customer customer) {
  // TODO: Implement detail page
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('查看客户详情: ${customer.name}')),
  );
}
```

**影响**：
- ❌ 无法查看客户详细信息
- ⚠️ 只能在列表中看到基本信息

**建议**：
- 创建 `CustomerDetailPage`
- 显示完整客户信息
- 提供编辑入口

---

### 2. 后端集成问题（中优先级）

#### 问题 2.1：API 端点可能不匹配

**前端实现**：
```dart
static const String _basePath = '/customers/';
static Future<CustomerListResponse> fetchCustomers({
  int page = 1,
  int pageSize = 20,
  String? search,
  bool? isActive,
}) async {
  final response = await HttpClient.get(_basePath, queryParameters: {
    'page': page,
    'page_size': pageSize,
    if (search != null && search.isNotEmpty) 'search': search,
    if (isActive != null) 'is_active': isActive,
  });
}
```

**需要验证**：
- ✅ 后端有 `/customers/` 端点
- ❓ 后端是否支持 `page`, `page_size`, `search`, `is_active` 参数？
- ❓ 后端返回格式是否与 `CustomerListResponse` 一致？

**潜在问题**：
```dart
// CustomerListResponse 期望的格式
{
  "results": [...],
  "count": 100,
  "next": "...或 null"
}

// 如果后端返回不同格式，会解析失败
```

**建议验证步骤**：
1. 运行 App，点击"客户管理"
2. 查看网络请求（Dio 拦截器）
3. 确认返回的 JSON 格式
4. 如果不匹配，调整 Model 或 Adapter

---

#### 问题 2.2：PATCH 方法问题

**当前实现**：
```dart
static Future<Customer> toggleActive(String id, bool isActive) async {
  final response = await HttpClient.post(  // ← 用 POST 代替 PATCH
    '$_basePath$id/',
    data: {'is_active': isActive},
  );
}
```

**问题**：
- 原本应该用 `PATCH` 方法
- 但 `HttpClient` 没有 `patch` 方法
- 临时用 `POST` 代替

**影响**：
- ⚠️ 不符合 RESTful 规范
- ⚠️ 可能与后端不匹配（如果后端只接受 PATCH）

**建议**：
1. 确认后端是否支持 POST
2. 或者在 `HttpClient` 添加 `patch` 方法
3. 或者使用 `put` 代替

---

### 3. 代码质量问题（低优先级）

#### 问题 3.1：未使用的导入
```dart
// customer_controller.dart:4
import '../models/customer_list_response.dart';  // ← 未使用

// customer_api.dart:1
import 'package:work_order_app/models/api_response.dart';  // ← 未使用
```

**建议**：删除这些导入

---

#### 问题 3.2：硬编码常量
```dart
// customer_controller.dart:18
final int _pageSize = 20;

// customer_api.dart:14
int pageSize = 20,
```

**建议**：统一到 `AppConstants`
```dart
class AppConstants {
  static const int defaultPageSize = 20;
}
```

---

### 4. 用户体验问题

#### 问题 4.1：错误提示不友好
```dart
ToastUtil.showError('加载客户列表失败: $e');
```

**问题**：
- 显示原始错误信息（技术性）
- 用户看不懂

**建议**：
```dart
ApiErrorHandler.handle(e, context: context);
// 统一处理，显示友好提示
```

---

#### 问题 4.2：没有加载状态指示
```dart
// 列表加载时只有 CircularProgressIndicator
// 但单个操作（删除、切换状态）没有状态反馈
```

**建议**：
- 添加操作中状态（loading overlay）
- 禁用操作按钮
- 显示操作进度

---

## 🔍 需要验证的关键点

### 1. 后端 API 格式
**发送实际请求**：
```
GET /customers/?page=1&page_size=20&search=测试
```

**期望返回**：
```json
{
  "results": [
    {
      "id": "1",
      "name": "测试客户",
      "code": "C001",
      ...
    }
  ],
  "count": 100,
  "next": null
}
```

**如果返回格式不同**，需要：
- 调整 `CustomerListResponse.fromJson()`
- 或添加适配层（Adapter）

---

### 2. 权限验证
**需要确认**：
- ❓ 当前用户是否有权限访问 `/customers/`？
- ❓ 未登录时是否正确跳转？
- ❓ 无权限时是否显示错误？

**测试步骤**：
1. 未登录访问 → 应跳转到 `/login`
2. 登录后访问 → 应显示列表或空状态
3. 无权限访问 → 应显示 403 或 404

---

### 3. 数据验证
**需要测试**：
- 空列表显示
- 大量数据（100+）分页
- 搜索结果为空
- 网络错误处理

---

## 📊 问题优先级

| 优先级 | 问题 | 影响 | 修复时间 |
|--------|------|------|---------|
| 🔴 高 | 表单未实现 | 无法新建/编辑 | 30分钟 |
| 🔴 高 | API 格式验证 | 可能无法加载数据 | 10分钟 |
| 🟡 中 | 详情页未实现 | 用户体验 | 20分钟 |
| 🟡 中 | PATCH 方法 | RESTful 不规范 | 5分钟 |
| 🟢 低 | 未使用导入 | 代码质量 | 1分钟 |
| 🟢 低 | 硬编码常量 | 可维护性 | 5分钟 |

---

## 🎯 立即行动建议

### Step 1: 验证 API（5分钟）
```bash
# 运行 App
flutter run

# 点击"客户管理"
# 查看控制台输出，确认：
# 1. 是否发送了 API 请求
# 2. 返回了什么数据
# 3. 是否有错误
```

### Step 2: 实现表单（30分钟）
创建 `CustomerFormDialog`：
```dart
class CustomerFormDialog extends StatefulWidget {
  final Customer? customer;
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(customer == null ? '新建客户' : '编辑客户'),
      content: Form(
        child: Column(
          children: [
            TextFormField(name: 'name'),
            TextFormField(name: 'code'),
            ...
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: onCancel, child: Text('取消')),
        ElevatedButton(onPressed: onSubmit, child: Text('保存')),
      ],
    );
  }
}
```

### Step 3: 测试流程（10分钟）
1. ✅ 列表加载
2. ✅ 搜索
3. ✅ 删除
4. ⚠️ 新建（需实现）
5. ⚠️ 编辑（需实现）

---

## 📝 总结

### 当前状态
- ✅ 架构完整
- ✅ 编译通过
- ⚠️ 功能未完成（70%）
- ❓ 后端集成未验证

### 主要风险
1. **后端 API 格式不匹配** → 可能无法加载数据
2. **缺少表单** → 无法新建/编辑客户
3. **未测试** → 可能有运行时错误

### 建议
1. **立即验证**：运行 App，测试 API 调用
2. **优先修复**：实现表单功能
3. **后续优化**：详情页、错误处理等

---

**要不要现在验证一下 API 是否正常工作？**
