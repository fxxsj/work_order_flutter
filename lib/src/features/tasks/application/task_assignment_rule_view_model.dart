import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/tasks/data/task_assignment_rule_dto.dart';
import 'package:work_order_app/src/features/tasks/domain/task_assignment_rule.dart';
import 'package:work_order_app/src/features/tasks/domain/task_assignment_rule_repository.dart';

class TaskAssignmentRuleViewModel
    extends PaginatedViewModel<TaskAssignmentRule> {
  TaskAssignmentRuleViewModel(this._repository);

  final TaskAssignmentRuleRepository _repository;
  int? _processId;
  int? _departmentId;
  bool? _isActive;

  List<TaskAssignmentRule> get rules => items;

  int? get processId => _processId;
  int? get departmentId => _departmentId;
  bool? get isActive => _isActive;

  Future<void> initialize() => loadItems(resetPage: true);

  Future<void> loadRules({bool resetPage = false}) =>
      loadItems(resetPage: resetPage);

  void setProcessId(int? value) {
    _processId = value;
  }

  void setDepartmentId(int? value) {
    _departmentId = value;
  }

  void setIsActive(bool? value) {
    _isActive = value;
  }

  Future<TaskAssignmentRule> createRule(TaskAssignmentRuleDto dto) async {
    final created = await _repository.createRule(dto);
    await loadItems(resetPage: true);
    return created.toEntity();
  }

  Future<TaskAssignmentRule> updateRule(
    int id,
    Map<String, dynamic> payload, {
    bool reload = true,
  }) async {
    final updated = await _repository.updateRule(id, payload);
    if (reload) {
      await loadItems(resetPage: false);
    }
    return updated.toEntity();
  }

  Future<void> updateRuleSilently(int id, Map<String, dynamic> payload) async {
    await _repository.updateRule(id, payload);
  }

  Future<void> deleteRule(int id) async {
    await deleteAndReload(() => _repository.deleteRule(id));
  }

  @override
  Future<PageData<TaskAssignmentRule>> fetchPage({
    required int page,
    required int pageSize,
    String? search,
  }) async {
    final result = await _repository.getRules(
      page: page,
      pageSize: pageSize,
      search: search,
      processId: _processId,
      departmentId: _departmentId,
      isActive: _isActive,
      ordering: '-priority',
    );
    return PageData(
      items: result.items.map((dto) => dto.toEntity()).toList(),
      total: result.total,
      page: result.page,
      pageSize: result.pageSize,
    );
  }
}
