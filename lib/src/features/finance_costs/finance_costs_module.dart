import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/features/finance_costs/application/production_cost_view_model.dart';
import 'package:work_order_app/src/features/finance_costs/data/production_cost_api_service.dart';
import 'package:work_order_app/src/features/finance_costs/data/production_cost_repository_impl.dart';
import 'package:work_order_app/src/features/finance_costs/domain/production_cost_repository.dart';
import 'package:work_order_app/src/features/finance_costs/presentation/production_cost_list_page.dart';

class ProductionCostListEntry extends StatelessWidget {
  const ProductionCostListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureEntry<
      ProductionCostApiService,
      ProductionCostRepository,
      ProductionCostViewModel
    >(
      createService: (context) =>
          ProductionCostApiService(context.read<ApiClient>()),
      createRepository: (context) => ProductionCostRepositoryImpl(
        context.read<ProductionCostApiService>(),
      ),
      createViewModel: (context) =>
          ProductionCostViewModel(context.read<ProductionCostRepository>()),
      initialize: (viewModel) => viewModel.initialize(),
      child: const ProductionCostListPage(),
    );
  }
}
