import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/data/generic_api_service.dart';
import 'package:work_order_app/src/core/data/generic_repository_impl.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/viewmodels/generic_list_view_model.dart';
import 'package:work_order_app/src/features/finance_costs/data/cost_item_repository_impl.dart';
import 'package:work_order_app/src/features/finance_costs/domain/cost_item_repository.dart';
import 'package:work_order_app/src/features/finance_costs/presentation/cost_item_list_page.dart';

class CostItemListEntry extends StatelessWidget {
  const CostItemListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GenericListViewModel>(
          create: (context) => GenericListViewModel(
            GenericRepositoryImpl(
              GenericApiService(
                context.read<ApiClient>(),
                resourcePath: '/cost-items/',
              ),
            ),
            enableSummary: false,
          )..initialize(),
        ),
        Provider<CostItemRepository>(
          create: (context) => CostItemRepositoryImpl(context.read<ApiClient>()),
        ),
      ],
      child: const CostItemListPage(),
    );
  }
}
