import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/departments/data/department_api_service.dart';
import 'package:work_order_app/src/features/departments/data/department_dto.dart';
import 'package:work_order_app/src/features/departments/domain/department.dart';
import 'package:work_order_app/src/features/departments/domain/department_repository.dart';

class DepartmentRepositoryImpl implements DepartmentRepository {
  DepartmentRepositoryImpl(this._api);

  final DepartmentApiService _api;

  @override
  Future<PageData<Department>> getDepartments({
    required int page,
    required int pageSize,
    String? search,
  }) async {
    final response = await _api.fetchDepartments(
      page: page,
      pageSize: pageSize,
      search: search,
    );
    return PageData(
      items: response.items.map((item) => item.toEntity()).toList(),
      total: response.total,
      page: response.page,
      pageSize: response.pageSize,
    );
  }

  @override
  Future<List<Department>> getAllDepartments() async {
    const pageSize = 200;
    var page = 1;
    final items = <Department>[];

    while (true) {
      final response = await _api.fetchDepartments(page: page, pageSize: pageSize);
      items.addAll(response.items.map((item) => item.toEntity()));
      if (items.length >= response.total || response.items.isEmpty) {
        break;
      }
      page += 1;
    }

    return items;
  }

  @override
  Future<List<ProcessOption>> getProcessOptions() async {
    final list = await _api.fetchProcesses();
    return list.map((item) => item.toEntity()).toList();
  }

  @override
  Future<void> createDepartment(Department department) async {
    await _api.createDepartment(DepartmentDto.fromEntity(department));
  }

  @override
  Future<void> updateDepartment(Department department) async {
    await _api.updateDepartment(DepartmentDto.fromEntity(department));
  }

  @override
  Future<void> deleteDepartment(int id) async {
    await _api.deleteDepartment(id);
  }
}
