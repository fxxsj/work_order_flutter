import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/features/audit_logs/application/audit_log_view_model.dart';
import 'package:work_order_app/src/features/audit_logs/data/audit_log_api_service.dart';
import 'package:work_order_app/src/features/audit_logs/data/audit_log_repository_impl.dart';
import 'package:work_order_app/src/features/audit_logs/domain/audit_log_repository.dart';
import 'package:work_order_app/src/features/audit_logs/presentation/audit_log_list_page.dart';

class AuditLogListEntry extends StatelessWidget {
  const AuditLogListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureEntry<
      AuditLogApiService,
      AuditLogRepository,
      AuditLogViewModel
    >(
      createService: (context) => AuditLogApiService(context.read<ApiClient>()),
      createRepository: (context) =>
          AuditLogRepositoryImpl(context.read<AuditLogApiService>()),
      createViewModel: (context) =>
          AuditLogViewModel(context.read<AuditLogRepository>()),
      initialize: (viewModel) => viewModel.initialize(),
      child: const AuditLogListPage(),
    );
  }
}
