Flutter CRUD 列表页开发规范
版本: 1.0
更新日期: 2026-03-02
适用范围: 团队所有 Flutter 项目中涉及列表增删改查的功能模块

1. 概述
本规范定义了在 Flutter 项目中实现列表数据增删改查（CRUD）功能的标准化开发流程、架构模式、代码组织和最佳实践。目标是确保代码的可维护性、可扩展性和团队协作效率。[1][2]
1.1 适用场景
    • 客户管理列表
    • 订单管理列表
    • 商品管理列表
    • 员工管理列表
    • 任何需要展示数据列表并支持增删改查的业务模块
1.2 核心原则
    • 关注点分离: UI 层、业务逻辑层、数据层清晰分离[2][3]
    • 单一职责: 每个类、方法只负责一个明确的功能
    • 可测试性: 业务逻辑与 UI 解耦，便于单元测试
    • 一致性: 团队所有 CRUD 模块遵循相同的架构和命名规范

2. 架构设计
2.1 分层架构
采用四层架构模式，确保代码职责清晰：[2][3][4]
层级
职责
示例组件
Presentation (UI 层)
展示界面、处理用户交互
Widget、Page、Screen
Application (应用层)
状态管理、业务流程协调
ViewModel、StateNotifier、Bloc
Domain (领域层)
业务模型、业务规则
Model、Entity、UseCase
Data (数据层)
数据获取、持久化
Repository、DataSource、API Service

Table 1: 四层架构职责划分
2.2 数据流向
用户操作 → UI Widget → ViewModel/Notifier → Repository → API/Database
↓ ↓
UI 更新 ← 状态变更 ← 数据返回
关键要求:
    • UI 层不直接调用 Repository 或 API
    • 所有数据操作必须通过状态管理层
    • Repository 对上层提供统一接口，屏蔽数据源细节[2][3]
2.3 目录结构规范
采用 Feature-first（功能优先） 结构组织代码：[4][5]
lib/
├── src/
│ ├── features/
│ │ ├── customer/ # 客户管理功能
│ │ │ ├── presentation/
│ │ │ │ ├── customer_list_page.dart
│ │ │ │ ├── customer_edit_page.dart
│ │ │ │ └── widgets/
│ │ │ │ └── customer_list_tile.dart
│ │ │ ├── application/
│ │ │ │ └── customer_view_model.dart
│ │ │ ├── domain/
│ │ │ │ ├── customer.dart
│ │ │ │ └── customer_repository.dart (接口)
│ │ │ └── data/
│ │ │ ├── customer_repository_impl.dart
│ │ │ ├── customer_api_service.dart
│ │ │ └── customer_dto.dart
│ │ └── order/ # 订单管理功能
│ │ └── ...
│ ├── common_widgets/ # 全局共用组件
│ ├── constants/ # 常量定义
│ └── utils/ # 工具函数
└── main.dart
规范要求:
    • 每个功能模块独立成 feature 文件夹
    • 每个 feature 内部按四层分包
    • 文件命名使用 snake_case（小写下划线）[6][7]
    • 类名使用 PascalCase（大驼峰）
    • 变量和方法名使用 camelCase（小驼峰）[7][8]

3. CRUD 功能实现规范
3.1 数据模型层（Domain）
    • 定义纯粹的数据类，包含业务字段和必要的业务方法
    • 使用 freezed 或手动实现 copyWith、toJson、fromJson
    • 模型类放在 domain/ 目录
示例代码:
// domain/customer.dart
class Customer {
final String id;
final String name;
final String phone;
final String email;
final bool isActive;
final DateTime createdAt;
const Customer({
required this.id,
required this.name,
required this.phone,
required this.email,
this.isActive = true,
required this.createdAt,
});
Customer copyWith({
String? id,
String? name,
String? phone,
String? email,
bool? isActive,
DateTime? createdAt,
}) {
return Customer(
id: id ?? this.id,
name: name ?? this.name,
phone: phone ?? this.phone,
email: email ?? this.email,
isActive: isActive ?? this.isActive,
createdAt: createdAt ?? this.createdAt,
);
}
Map<String, dynamic> toJson() => {
'id': id,
'name': name,
'phone': phone,
'email': email,
'isActive': isActive,
'createdAt': createdAt.toIso8601String(),
};
factory Customer.fromJson(Map<String, dynamic> json) => Customer(
id: json['id'],
name: json['name'],
phone: json['phone'],
email: json['email'],
isActive: json['isActive'] ?? true,
createdAt: DateTime.parse(json['createdAt']),
);
}
3.2 数据层（Data）
3.2.1 Repository 接口（Domain 层）
定义抽象接口，不依赖具体实现：
// domain/customer_repository.dart
abstract class CustomerRepository {
Future<List<Customer>> getCustomers();
Future<Customer> getCustomerById(String id);
Future<void> createCustomer(Customer customer);
Future<void> updateCustomer(Customer customer);
Future<void> deleteCustomer(String id);
}
3.2.2 Repository 实现（Data 层）
具体实现数据获取逻辑，调用 API 或本地数据库：[9][10]
// data/customer_repository_impl.dart
class CustomerRepositoryImpl implements CustomerRepository {
final CustomerApiService _apiService;
CustomerRepositoryImpl(this._apiService);
@override
Future<List<Customer>> getCustomers() async {
try {
final dtoList = await _apiService.fetchCustomers();
return dtoList.map((dto) => dto.toEntity()).toList();
} catch (e) {
throw Exception('获取客户列表失败: $e');
}
}
@override
Future<void> createCustomer(Customer customer) async {
try {
await _apiService.createCustomer(CustomerDto.fromEntity(customer));
} catch (e) {
throw Exception('创建客户失败: $e');
}
}
@override
Future<void> updateCustomer(Customer customer) async {
try {
await _apiService.updateCustomer(customer.id, CustomerDto.fromEntity(customer));
} catch (e) {
throw Exception('更新客户失败: $e');
}
}
@override
Future<void> deleteCustomer(String id) async {
try {
await _apiService.deleteCustomer(id);
} catch (e) {
throw Exception('删除客户失败: $e');
}
}
}
规范要求:
    • Repository 实现必须依赖抽象接口，便于测试和替换数据源
    • 异常处理统一在 Repository 层完成，向上抛出业务友好的错误信息
    • 使用 DTO（Data Transfer Object）进行网络数据转换，与 Domain Model 分离[3][4]
3.3 状态管理层（Application）
推荐使用 Riverpod 或 Provider 进行状态管理。[11][12]
3.3.1 使用 Riverpod 的示例
// application/customer_view_model.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
class CustomerViewModel extends StateNotifier<AsyncValue<List<Customer>>> {
final CustomerRepository _repository;
CustomerViewModel(this._repository) : super(const AsyncValue.loading()) {
loadAll();
}
Future<void> loadAll() async {
state = const AsyncValue.loading();
try {
final customers = await _repository.getCustomers();
state = AsyncValue.data(customers);
} catch (e, stack) {
state = AsyncValue.error(e, stack);
}
}
Future<void> addCustomer(Customer customer) async {
try {
await _repository.createCustomer(customer);
await loadAll(); // 刷新列表
} catch (e) {
// 错误处理，可以通过单独的 error state 传递给 UI
rethrow;
}
}
Future<void> updateCustomer(Customer customer) async {
try {
await _repository.updateCustomer(customer);
await loadAll();
} catch (e) {
rethrow;
}
}
Future<void> deleteCustomer(String id) async {
try {
await _repository.deleteCustomer(id);
await loadAll();
} catch (e) {
rethrow;
}
}
}
// Provider 定义
final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
return CustomerRepositoryImpl(CustomerApiService());
});
final customerViewModelProvider = StateNotifierProvider<CustomerViewModel, AsyncValue<List<Customer>>>((ref) {
return CustomerViewModel(ref.watch(customerRepositoryProvider));
});
规范要求:
    • ViewModel 不包含任何 UI 逻辑（如 BuildContext、Navigator）
    • 所有异步操作使用 Future 明确返回类型
    • 状态变更后自动触发 UI 刷新，UI 层无需手动调用 setState[11][12]
3.4 UI 层（Presentation）
3.4.1 列表页规范
职责:
    • 展示客户列表
    • 提供搜索、筛选入口
    • 处理新增、编辑、删除的导航
代码结构:
// presentation/customer_list_page.dart
class CustomerListPage extends ConsumerWidget {
const CustomerListPage({Key? key}) : super(key: key);
@override
Widget build(BuildContext context, WidgetRef ref) {
final customersAsync = ref.watch(customerViewModelProvider);
return Scaffold(
  appBar: AppBar(
    title: const Text('客户管理'),
    actions: [
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: () => _showSearch(context),
      ),
    ],
  ),
  body: customersAsync.when(
    data: (customers) => _buildCustomerList(context, ref, customers),
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (error, stack) => Center(
      child: Text('加载失败: $error'),
    ),
  ),
  floatingActionButton: FloatingActionButton(
    onPressed: () => _navigateToEdit(context, null),
    child: const Icon(Icons.add),
  ),
);

}
Widget _buildCustomerList(BuildContext context, WidgetRef ref, List<Customer> customers) {
if (customers.isEmpty) {
return const Center(child: Text('暂无客户'));
}
return ListView.builder(
  itemCount: customers.length,
  itemBuilder: (context, index) {
    final customer = customers[index];
    return CustomerListTile(
      customer: customer,
      onTap: () => _navigateToEdit(context, customer),
      onDelete: () => _confirmDelete(context, ref, customer),
    );
  },
);

}
void _navigateToEdit(BuildContext context, Customer? customer) {
Navigator.push(
context,
MaterialPageRoute(
builder: (context) => CustomerEditPage(customer: customer),
),
);
}
Future<void> _confirmDelete(BuildContext context, WidgetRef ref, Customer customer) async {
final confirmed = await showDialog<bool>(
context: context,
builder: (context) => AlertDialog(
title: const Text('确认删除'),
content: Text('确定要删除客户 "${customer.name}" 吗？此操作不可恢复。'),
actions: [
TextButton(
onPressed: () => Navigator.pop(context, false),
child: const Text('取消'),
),
TextButton(
onPressed: () => Navigator.pop(context, true),
child: const Text('删除'),
),
],
),
);
if (confirmed == true) {
  try {
    await ref.read(customerViewModelProvider.notifier).deleteCustomer(customer.id);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('删除成功')),
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('删除失败: $e')),
      );
    }
  }
}

}
void _showSearch(BuildContext context) {
// 实现搜索功能
}
}
UI 层规范要求:
    • 使用 ListView.builder 而非 Column + SingleChildScrollView，保证大列表性能[13]
    • 列表项抽取为独立 Widget（如 CustomerListTile），减少重建范围[13][14]
    • 删除操作必须二次确认（AlertDialog），避免误操作
    • 异步操作完成后检查 context.mounted，避免内存泄漏[15]
    • 错误提示使用 SnackBar，成功提示可选
3.4.1.1 列表页布局规范（固定工具条/分页）
说明: 列表页采用“顶部工具条固定 + 内容区滚动 + 底部分页固定”的三段式结构，确保高频操作位置稳定。
规范要求:
    • 顶部工具条固定在页面内，不随列表滚动
    • 内容区作为唯一滚动区域，列表滚动不影响工具条和分页
    • 底部分页固定在页面内，单行显示
    • 搜索采用输入即搜（支持回车立即触发）
    • 移动端隐藏列管理与密度切换
    • 按钮统一高度 36px、圆角 4px，文字按钮宽度自适应
3.4.2 列表项组件规范
// presentation/widgets/customer_list_tile.dart
class CustomerListTile extends StatelessWidget {
final Customer customer;
final VoidCallback onTap;
final VoidCallback onDelete;
const CustomerListTile({
Key? key,
required this.customer,
required this.onTap,
required this.onDelete,
}) : super(key: key);
@override
Widget build(BuildContext context) {
return Card(
margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
child: ListTile(
leading: CircleAvatar(
child: Text(customer.name[0].toUpperCase()),
),
title: Text(customer.name),
subtitle: Text('{customer.email}'),
isThreeLine: true,
trailing: Row(
mainAxisSize: MainAxisSize.min,
children: [
IconButton(
icon: const Icon(Icons.edit, color: Colors.blue),
onPressed: onTap,
),
IconButton(
icon: const Icon(Icons.delete, color: Colors.red),
onPressed: onDelete,
),
],
),
onTap: onTap,
),
);
}
}
组件规范:
    • 尽量使用 StatelessWidget，数据从外部传入
    • 回调函数使用 VoidCallback 或 ValueChanged<T> 类型
    • 颜色、间距等使用常量或主题中的值，避免硬编码[8]
3.4.3 编辑页规范
职责:
    • 新增或编辑客户信息
    • 表单校验
    • 提交数据到状态管理层
代码结构:
// presentation/customer_edit_page.dart
class CustomerEditPage extends ConsumerStatefulWidget {
final Customer? customer; // null 表示新增，非 null 表示编辑
const CustomerEditPage({Key? key, this.customer}) : super(key: key);
@override
ConsumerState<CustomerEditPage> createState() => _CustomerEditPageState();
}
class _CustomerEditPageState extends ConsumerState<CustomerEditPage> {
final _formKey = GlobalKey<FormState>();
late TextEditingController _nameController;
late TextEditingController _phoneController;
late TextEditingController _emailController;
bool _isActive = true;
bool _isSubmitting = false;
@override
void initState() {
super.initState();
final customer = widget.customer;
_nameController = TextEditingController(text: customer?.name);
_phoneController = TextEditingController(text: customer?.phone);
_emailController = TextEditingController(text: customer?.email);
_isActive = customer?.isActive ?? true;
}
@override
void dispose() {
_nameController.dispose();
_phoneController.dispose();
_emailController.dispose();
super.dispose();
}
@override
Widget build(BuildContext context) {
final isEditing = widget.customer != null;
return Scaffold(
  appBar: AppBar(
    title: Text(isEditing ? '编辑客户' : '新增客户'),
  ),
  body: SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: '客户名称',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return '请输入客户名称';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: '手机号',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return '请输入手机号';
              }
              final phoneRegex = RegExp(r'^1[3-9]\d{9}$');
              if (!phoneRegex.hasMatch(value.trim())) {
                return '请输入正确的手机号';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: '邮箱',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value != null && value.trim().isNotEmpty) {
                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!emailRegex.hasMatch(value.trim())) {
                  return '请输入正确的邮箱地址';
                }
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('是否启用'),
            value: _isActive,
            onChanged: (value) => setState(() => _isActive = value),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _isSubmitting ? null : _handleSubmit,
            child: _isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(isEditing ? '保存修改' : '创建客户'),
          ),
        ],
      ),
    ),
  ),
);

}
Future<void> _handleSubmit() async {
if (!_formKey.currentState!.validate()) {
return;
}
setState(() => _isSubmitting = true);

try {
  final customer = Customer(
    id: widget.customer?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
    name: _nameController.text.trim(),
    phone: _phoneController.text.trim(),
    email: _emailController.text.trim(),
    isActive: _isActive,
    createdAt: widget.customer?.createdAt ?? DateTime.now(),
  );

  if (widget.customer == null) {
    await ref.read(customerViewModelProvider.notifier).addCustomer(customer);
  } else {
    await ref.read(customerViewModelProvider.notifier).updateCustomer(customer);
  }

  if (mounted) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(widget.customer == null ? '创建成功' : '更新成功')),
    );
  }
} catch (e) {
  if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('操作失败: $e')),
    );
  }
} finally {
  if (mounted) {
    setState(() => _isSubmitting = false);
  }
}

}
}
编辑页规范要求:
    • 使用 Form + GlobalKey<FormState> 进行表单管理[9][10]
    • 每个输入框必须有 validator 进行校验
    • TextEditingController 必须在 dispose 中释放，避免内存泄漏
    • 提交过程中禁用按钮，显示 loading 状态
    • 异步操作前后检查 mounted，防止页面销毁后调用 setState
    • 新增和编辑共用一个页面，通过传入参数区分[9][10]

4. 交互与导航规范
4.1 导航方式
操作
导航方式
说明
新增
Navigator.push
跳转到编辑页，不传参数
编辑
Navigator.push
跳转到编辑页，传入对象
删除
无导航
列表页弹出确认对话框
保存成功
Navigator.pop
返回列表页

Table 2: CRUD 操作导航规则
规范要求:
    • 不使用 Dialog 进行表单编辑，使用独立完整页面[16]
    • 编辑完成后使用 Navigator.pop(context) 返回，依赖状态自动刷新列表
    • 避免使用 pushReplacement，保持导航栈清晰
4.2 用户反馈
    • 加载状态: 使用 CircularProgressIndicator 在列表中心显示
    • 空状态: 列表为空时显示友好提示（"暂无数据"）
    • 成功提示: 使用 SnackBar 短暂提示
    • 错误提示: 使用 SnackBar 或 AlertDialog 显示具体错误信息
    • 确认操作: 删除等危险操作必须使用 AlertDialog 二次确认
4.3 性能优化
    • 使用 ListView.builder 实现懒加载，避免一次性渲染所有项[13][14]
    • 列表项使用 const 构造函数（如果数据不变）
    • 避免在 build 方法中执行重逻辑或网络请求
    • 使用 AutomaticKeepAliveClientMixin 保持列表滚动位置（如需要）
    • 大列表考虑分页加载，避免一次加载所有数据

5. 代码质量与测试
5.1 命名规范
类型
命名规则
示例
文件名
snake_case
customer_list_page.dart
类名
PascalCase
CustomerListPage
变量、方法
camelCase
loadCustomers(), isActive
常量
lowerCamelCase
defaultTimeout
私有变量
_camelCase
_controller, _repository

Table 3: 命名规范对照表
通用规则:[6][7][8]
    • 使用描述性命名，避免缩写（除非是公认的如 id、dto）
    • 布尔变量使用 is、has、can 开头
    • 方法名使用动词开头（load、create、update、delete）
    • 避免使用 data、info、manager 等模糊词汇
5.2 注释规范
    • 公共 API（public class、method）必须添加文档注释（///）
    • 复杂业务逻辑添加说明性注释
    • 避免自解释代码添加冗余注释
    • 使用英文或中文统一，团队内保持一致
示例:
/// 客户管理状态管理类
///
/// 提供客户列表的增删改查功能，自动处理加载状态和错误状态
class CustomerViewModel extends StateNotifier<AsyncValue<List<Customer>>> {
// ...
}
5.3 错误处理
    • Repository 层捕获底层异常，转换为业务友好的错误信息
    • ViewModel 层传递错误给 UI 层，不吞没异常
    • UI 层向用户展示可理解的错误提示
    • 记录关键错误日志，便于生产环境排查
5.4 单元测试要求
    • Repository 层必须编写单元测试，覆盖所有 CRUD 方法
    • ViewModel 层测试业务逻辑，使用 Mock Repository
    • UI 层编写 Widget 测试，验证关键交互流程
    • 测试覆盖率目标：Repository > 80%, ViewModel > 70%
测试示例:
// test/features/customer/application/customer_view_model_test.dart
void main() {
late MockCustomerRepository mockRepository;
late CustomerViewModel viewModel;
setUp(() {
mockRepository = MockCustomerRepository();
viewModel = CustomerViewModel(mockRepository);
});
test('loadAll 成功时应更新状态为 data', () async {
final customers = [
Customer(id: '1', name: 'Test', phone: '13800138000', email: 'test@example.com', createdAt: DateTime.now()),
];
when(mockRepository.getCustomers()).thenAnswer((_) async => customers);
await viewModel.loadAll();

expect(viewModel.state, isA<AsyncData<List<Customer>>>());
expect(viewModel.state.value, customers);

});
test('addCustomer 成功后应刷新列表', () async {
// 实现测试逻辑
});
}

6. 安全与权限
6.1 数据校验
    • 前端必须进行格式校验（手机号、邮箱等）
    • 后端必须再次校验，前端校验仅为用户体验
    • 敏感数据（如身份证号）不在日志中输出
6.2 权限控制
    • 删除、批量操作等危险功能需要二次确认
    • 根据用户角色显示/隐藏操作按钮
    • 接口层必须进行权限验证

7. 检查清单
开发完成后，使用此清单进行自检：
7.1 架构与代码组织
    • [ ] 代码按四层架构组织（Presentation、Application、Domain、Data）
    • [ ] 使用 Feature-first 目录结构
    • [ ] UI 层不直接调用 Repository 或 API
    • [ ] 模型类实现了 copyWith、toJson、fromJson
7.2 UI 层
    • [ ] 列表使用 ListView.builder 而非 Column
    • [ ] 列表项抽取为独立 Widget
    • [ ] 删除操作有二次确认
    • [ ] 异步操作检查 context.mounted
    • [ ] 加载、空状态、错误状态都有处理
    • [ ] 使用 FAB 或 AppBar 按钮进行新增
7.3 编辑页
    • [ ] 使用 Form + GlobalKey<FormState>
    • [ ] 所有必填字段有 validator
    • [ ] TextEditingController 在 dispose 中释放
    • [ ] 提交时显示 loading 状态并禁用按钮
    • [ ] 新增和编辑复用同一个页面
7.4 状态管理
    • [ ] ViewModel 不包含 UI 逻辑
    • [ ] 所有异步操作有错误处理
    • [ ] 状态变更自动触发 UI 刷新
7.5 代码质量
    • [ ] 遵循命名规范（文件名 snake_case，类名 PascalCase）
    • [ ] 公共 API 有文档注释
    • [ ] 无硬编码字符串、颜色、魔法数字
    • [ ] 通过 flutter analyze 无警告
    • [ ] 关键业务逻辑有单元测试

8. 参考资源
8.1 官方文档
    • Flutter 官方架构指南: https://docs.flutter.dev/app-architecture/guide
    • Flutter 性能最佳实践: https://docs.flutter.dev/perf/best-practices
    • Dart 语言规范: https://dart.dev/guides/language/effective-dart
8.2 推荐库
    • 状态管理: Riverpod (https://riverpod.dev/)
    • 网络请求: Dio (https://pub.dev/packages/dio)
    • JSON 序列化: json_serializable, freezed
    • 本地存储: sqflite (SQLite), hive, shared_preferences
    • 测试: mockito, mocktail
8.3 学习资源
    • Code with Andrea - Flutter 架构系列: https://codewithandrea.com/articles/flutter-app-architecture-riverpod-introduction/
    • Flutter CRUD 教程合集: https://fluttertalk.com/flutter-crud-tutorial/

9. 版本历史
版本
日期
变更说明
1.0
2026-03-02
初始版本，定义 CRUD 开发规范

Table 4: 版本历史记录

10. 附录：完整示例项目结构
customer_management_feature/
├── presentation/
│ ├── customer_list_page.dart # 列表页
│ ├── customer_edit_page.dart # 编辑页（新增/修改复用）
│ └── widgets/
│ ├── customer_list_tile.dart # 列表项组件
│ └── customer_search_delegate.dart # 搜索功能（可选）
├── application/
│ └── customer_view_model.dart # 状态管理
├── domain/
│ ├── customer.dart # 领域模型
│ └── customer_repository.dart # Repository 接口
└── data/
├── customer_repository_impl.dart # Repository 实现
├── customer_api_service.dart # API 调用
└── customer_dto.dart # 数据传输对象

文档维护: 本规范由开发团队共同维护，如有改进建议请提交团队评审。
References
[1] Auth0. (2021). Build a Flutter Wishlist App, Part 2: Adding CRUD Functionality. https://auth0.com/blog/build-flutter-wishlist-app-with-secure-api-part-2/
[2] Flutter. (2026). Guide to app architecture - Flutter documentation. https://docs.flutter.dev/app-architecture/guide
[3] Flutter. (2025). Common architecture concepts - Flutter documentation. https://docs.flutter.dev/app-architecture/concepts
[4] Codewithandrea. (2022). Flutter Project Structure: Feature-first or Layer-first? https://codewithandrea.com/articles/flutter-project-structure/
[5] Codewithandrea. Flutter App Architecture with Riverpod: An Introduction. https://codewithandrea.com/articles/flutter-app-architecture-riverpod-introduction/
[6] Flutter. (2024). Style guide for Flutter repo. https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo
[7] Gürkan Fikret Günak. (2023). Flutter Naming Conventions Guidance. https://www.gurkanfikretgunak.com/guidances/flutter-naming-conventions-guidance
[8] FlutterFlow. (2025). Naming Variables & Functions - Style Guide. https://docs.flutterflow.io/resources/style-guide/
[9] Strapi. (2023). How to Build a CRUD Application Using Flutter and Strapi. https://strapi.io/blog/how-to-build-a-simple-crud-application-using-flutter-and-strapi
[10] FlutterTalk. Complete Flutter CRUD Example with SQLite. https://fluttertalk.com/flutter-crud-tutorial/
[11] Reddit r/FlutterDev. (2024). Proper state management in 2024 for beginners. https://www.reddit.com/r/FlutterDev/comments/1boqpb1/proper_state_management_in_2024_for_beginners/
[12] Stack Overflow. (2024). Using Riverpod CRUD API DATA. https://stackoverflow.com/questions/77855955/using-riverpod-crud-api-data
[13] Flutter. (2025). Minimizing Calls To... - Performance best practices. https://docs.flutter.dev/perf/best-practices
[14] ITNEXT. (2024). Write best performance ListView with Riverpod in Flutter. https://itnext.io/write-best-performance-listviews-with-riverpod-in-flutter-8bf6590ed8b8
[15] Flutter. (2026). Stack-based navigation - Flutter documentation. https://docs.flutter.dev/learn/pathway/tutorial/navigation
[16] Stack Overflow. (2014). Edit in place vs. separate edit page / modal? https://stackoverflow.com/questions/3326451/edit-in-place-vs-separate-edit-page-modal
