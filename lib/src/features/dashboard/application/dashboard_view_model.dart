import 'package:work_order_app/src/core/viewmodels/base_view_model.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_repository.dart';

class DashboardViewModel extends BaseViewModel {
  DashboardViewModel(this._workOrderRepository);

  final WorkOrderRepository _workOrderRepository;

  Map<String, dynamic>? _stats;

  Map<String, dynamic>? get stats => _stats;

  Future<void> loadStats() async {
    setLoading(true);
    clearError();
    try {
      _stats = await _workOrderRepository.getStatistics();
      safeNotify();
    } catch (err) {
      setError('获取统计失败: $err');
    } finally {
      setLoading(false);
    }
  }
}
