import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/departments/domain/department.dart';
import 'package:work_order_app/src/features/departments/domain/department_repository.dart';

class DepartmentViewModel extends PaginatedViewModel<Department> {
  DepartmentViewModel(this._repository);

  final DepartmentRepository _repository;

  List<Department> _departmentOptions = [];
  List<ProcessOption> _processOptions = [];
  bool _loadingOptions = false;
  String? _optionsError;

  List<Department> get departments => items;

  List<Department> get departmentOptions => _departmentOptions;

  List<ProcessOption> get processOptions => _processOptions;

  bool get loadingOptions => _loadingOptions;

  String? get optionsError => _optionsError;

  Future<void> initialize() async {
    await Future.wait([
      loadItems(resetPage: true),
      loadOptions(),
    ]);
  }

  Future<void> loadDepartments({bool resetPage = false}) => loadItems(resetPage: resetPage);

  Future<void> loadOptions() async {
    _loadingOptions = true;
    _optionsError = null;
    safeNotify();
    try {
      final results = await Future.wait([
        _repository.getAllDepartments(),
        _repository.getProcessOptions(),
      ]);
      _departmentOptions = results[0] as List<Department>;
      _processOptions = results[1] as List<ProcessOption>;
    } catch (err) {
      _optionsError = err.toString().replaceFirst('Exception: ', '');
    } finally {
      _loadingOptions = false;
      safeNotify();
    }
  }

  @override
  Future<PageData<Department>> fetchPage({
    required int page,
    required int pageSize,
    String? search,
  }) async {
    return _repository.getDepartments(page: page, pageSize: pageSize, search: search);
  }

  Future<void> createDepartment(Department department) async {
    await _repository.createDepartment(department);
    await Future.wait([
      loadItems(resetPage: true),
      loadOptions(),
    ]);
  }

  Future<void> updateDepartment(Department department) async {
    await _repository.updateDepartment(department);
    await Future.wait([
      loadItems(),
      loadOptions(),
    ]);
  }

  Future<void> deleteDepartment(int id) async {
    await deleteAndReload(() => _repository.deleteDepartment(id));
    await loadOptions();
  }
}
