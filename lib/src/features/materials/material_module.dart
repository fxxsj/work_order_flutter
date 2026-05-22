import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/features/materials/application/material_view_model.dart';
import 'package:work_order_app/src/features/materials/data/material_api_service.dart';
import 'package:work_order_app/src/features/materials/data/material_repository_impl.dart';
import 'package:work_order_app/src/features/materials/domain/material_repository.dart';
import 'package:work_order_app/src/features/materials/presentation/material_list_page.dart';

class MaterialListEntry extends StatelessWidget {
  const MaterialListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureEntry<MaterialApiService, MaterialRepository,
        MaterialViewModel>(
      createService: (context) => MaterialApiService(context.read<ApiClient>()),
      createRepository: (context) =>
          MaterialRepositoryImpl(context.read<MaterialApiService>()),
      createViewModel: (context) =>
          MaterialViewModel(context.read<MaterialRepository>()),
      initialize: (viewModel) => viewModel.initialize(),
      child: const MaterialListPage(),
    );
  }
}
