import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/features/departments/application/department_view_model.dart';
import 'package:work_order_app/src/features/departments/data/department_api_service.dart';
import 'package:work_order_app/src/features/departments/data/department_repository_impl.dart';
import 'package:work_order_app/src/features/departments/domain/department_repository.dart';
import 'package:work_order_app/src/features/departments/presentation/department_list_page.dart';

class DepartmentListEntry extends StatelessWidget {
  const DepartmentListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureEntry<
      DepartmentApiService,
      DepartmentRepository,
      DepartmentViewModel
    >(
      createService: (context) =>
          DepartmentApiService(context.read<ApiClient>()),
      createRepository: (context) =>
          DepartmentRepositoryImpl(context.read<DepartmentApiService>()),
      createViewModel: (context) =>
          DepartmentViewModel(context.read<DepartmentRepository>()),
      initialize: (viewModel) => viewModel.initialize(),
      child: const DepartmentListPage(),
    );
  }
}
