import 'package:work_order_app/src/core/data/generic_api_service.dart';
import 'package:work_order_app/src/core/models/generic_record.dart';
import 'package:work_order_app/src/features/auth/data/auth_api.dart';
import 'package:work_order_app/src/features/finance_costs/domain/cost_center_form_options.dart';
import 'package:work_order_app/src/features/finance_costs/domain/cost_center_options_repository.dart';

class CostCenterOptionsRepositoryImpl implements CostCenterOptionsRepository {
  CostCenterOptionsRepositoryImpl(this._apiService, this._authApi);

  final GenericApiService _apiService;
  final AuthApi _authApi;

  @override
  Future<CostCenterFormOptions> loadOptions({GenericRecord? currentRecord}) async {
    final parents = await _loadParentOptions(currentRecord);
    final managers = await _loadManagerOptions();
    return CostCenterFormOptions(parents: parents, managers: managers);
  }

  Future<List<CostCenterOption>> _loadParentOptions(
    GenericRecord? currentRecord,
  ) async {
    final options = <CostCenterOption>[
      const CostCenterOption(id: null, label: '无上级'),
    ];
    try {
      final page = await _apiService.fetchPage(
        pageSize: 200,
        extraParams: const {'ordering': 'code'},
      );
      for (final center in page.items) {
        if (currentRecord != null && center.id == currentRecord.id) continue;
        final code = center.getString('code') ?? '';
        final name = center.getString('name') ?? '成本中心 #${center.id}';
        options.add(
          CostCenterOption(
            id: center.id,
            label: code.isEmpty ? name : '$code · $name',
          ),
        );
      }
    } catch (_) {
      // Keep the form usable even if optional lookup data fails to load.
    }
    return options;
  }

  Future<List<CostCenterOption>> _loadManagerOptions() async {
    final options = <CostCenterOption>[
      const CostCenterOption(id: null, label: '未指定'),
    ];
    try {
      final usersResult = await _authApi.getUsersByDepartment();
      for (final user in usersResult.data ?? const <Map<String, dynamic>>[]) {
        final id = _intFrom(user['id']);
        if (id == null) continue;
        final label =
            user['username']?.toString() ??
            user['name']?.toString() ??
            '用户 #$id';
        options.add(CostCenterOption(id: id, label: label));
      }
    } catch (_) {
      // Manager is optional; an unavailable user lookup should not block edits.
    }
    return options;
  }

  int? _intFrom(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
