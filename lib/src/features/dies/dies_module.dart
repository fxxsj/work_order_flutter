import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/features/dies/application/die_view_model.dart';
import 'package:work_order_app/src/features/dies/data/die_api_service.dart';
import 'package:work_order_app/src/features/dies/data/die_repository_impl.dart';
import 'package:work_order_app/src/features/dies/domain/die_repository.dart';
import 'package:work_order_app/src/features/dies/presentation/die_list_page.dart';

class DieListEntry extends StatelessWidget {
  const DieListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureEntry<DieApiService, DieRepository, DieViewModel>(
      createService: (context) => DieApiService(context.read<ApiClient>()),
      createRepository: (context) =>
          DieRepositoryImpl(context.read<DieApiService>()),
      createViewModel: (context) =>
          DieViewModel(context.read<DieRepository>()),
      initialize: (viewModel) => viewModel.initialize(),
      child: const DieListPage(),
    );
  }
}
