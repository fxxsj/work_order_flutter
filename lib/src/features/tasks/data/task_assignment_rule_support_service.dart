import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/features/departments/data/department_api_service.dart';
import 'package:work_order_app/src/features/processes/data/process_api_service.dart';
import 'package:work_order_app/src/features/tasks/data/task_assignment_rule_api_service.dart';
import 'package:work_order_app/src/features/tasks/domain/task_assignment_rule_lookup_data.dart';
import 'package:work_order_app/src/features/tasks/presentation/task_department_option.dart';

class TaskAssignmentRuleSupportService {
  TaskAssignmentRuleSupportService(this._client);

  final ApiClient _client;

  Future<TaskAssignmentRuleLookupData> loadLookup() async {
    final processPage = await ProcessApiService(
      _client,
    ).fetchProcesses(page: 1, pageSize: 50);
    final departmentPage = await DepartmentApiService(
      _client,
    ).fetchDepartments(page: 1, pageSize: 50);
    return TaskAssignmentRuleLookupData(
      processes: processPage.items.map((dto) => dto.toEntity()).toList(),
      departments: departmentPage.items
          .map((dto) => TaskDepartmentOption(id: dto.id, name: dto.name))
          .toList(),
    );
  }

  Future<TaskAssignmentRulePreviewData> loadPreview() async {
    final payload = await TaskAssignmentRuleApiService(_client).preview();
    final preview = payload['preview'];
    return TaskAssignmentRulePreviewData(
      previewItems: preview is List
          ? preview
                .whereType<Map>()
                .map((item) => Map<String, dynamic>.from(item))
                .toList()
          : const [],
      globalEnabled: payload['global_enabled'] is bool
          ? payload['global_enabled'] as bool
          : null,
    );
  }

  Future<bool> getGlobalState() async {
    final payload = await TaskAssignmentRuleApiService(
      _client,
    ).getGlobalState();
    return payload['enabled'] == true;
  }

  Future<bool> setGlobalState(bool enabled) async {
    final payload = await TaskAssignmentRuleApiService(
      _client,
    ).setGlobalState(enabled);
    return payload['enabled'] == true;
  }
}
