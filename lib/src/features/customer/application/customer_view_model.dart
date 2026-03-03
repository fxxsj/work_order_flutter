import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/customer/domain/customer.dart';
import 'package:work_order_app/src/features/customer/domain/customer_repository.dart';
import 'package:work_order_app/src/features/customer/domain/salesperson.dart';

/// 客户管理 ViewModel，负责加载与维护客户列表状态。
///
/// 继承 [PaginatedViewModel] 复用分页、搜索、loading/error 逻辑，
/// 仅保留客户特有的业务方法。
class CustomerViewModel extends PaginatedViewModel<Customer> {
  CustomerViewModel(this._repository);

  final CustomerRepository _repository;

  List<Salesperson> _salespersons = [];
  bool _loadingSalespersons = false;
  String? _salespersonsError;

  /// 当前客户列表（[items] 的别名，兼容现有 UI）。
  List<Customer> get customers => items;

  /// 当前业务员列表。
  List<Salesperson> get salespersons => _salespersons;

  /// 是否正在加载业务员列表。
  bool get loadingSalespersons => _loadingSalespersons;

  /// 业务员列表错误信息（不影响客户列表加载）。
  String? get salespersonsError => _salespersonsError;

  /// 初始化加载数据。
  Future<void> initialize() async {
    await Future.wait([
      loadSalespersons(),
      loadItems(resetPage: true),
    ]);
  }

  /// 加载客户列表（[loadItems] 的别名，兼容现有调用点）。
  Future<void> loadCustomers({bool resetPage = false}) =>
      loadItems(resetPage: resetPage);

  @override
  Future<PageData<Customer>> fetchPage({
    required int page,
    required int pageSize,
    String? search,
  }) async {
    final result = await _repository.getCustomers(
      page: page,
      pageSize: pageSize,
      search: search,
    );
    return PageData(
      items: result.items,
      total: result.total,
      page: result.page,
      pageSize: result.pageSize,
    );
  }

  /// 加载业务员列表。
  Future<void> loadSalespersons() async {
    _loadingSalespersons = true;
    _salespersonsError = null;
    safeNotify();
    try {
      _salespersons = await _repository.getSalespersons();
    } catch (err) {
      _salespersonsError = err.toString().replaceFirst('Exception: ', '');
    } finally {
      _loadingSalespersons = false;
      safeNotify();
    }
  }

  /// 创建客户并刷新列表。
  Future<void> createCustomer(Customer customer) async {
    await _repository.createCustomer(customer);
    await loadItems(resetPage: true);
  }

  /// 更新客户并刷新列表。
  Future<void> updateCustomer(Customer customer) async {
    await _repository.updateCustomer(customer);
    await loadItems();
  }

  /// 删除客户并刷新列表。
  Future<void> deleteCustomer(int id) async {
    await deleteAndReload(() => _repository.deleteCustomer(id));
  }
}
