import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/departments/domain/department.dart';

abstract class DepartmentRepository {
  Future<PageData<Department>> getDepartments({
    required int page,
    required int pageSize,
    String? search,
  });

  Future<List<Department>> getAllDepartments({bool? isActive});

  Future<List<Department>> getDepartmentTree();

  Future<List<ProcessOption>> getProcessOptions();

  Future<void> createDepartment(Department department);

  Future<void> updateDepartment(Department department);

  Future<void> deleteDepartment(int id);
}
