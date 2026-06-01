import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/features/product_groups/application/product_group_view_model.dart';
import 'package:work_order_app/src/features/product_groups/data/product_group_api_service.dart';
import 'package:work_order_app/src/features/product_groups/data/product_group_repository_impl.dart';
import 'package:work_order_app/src/features/product_groups/domain/product_group_repository.dart';
import 'package:work_order_app/src/features/product_groups/presentation/product_group_list_page.dart';

class ProductGroupListEntry extends StatelessWidget {
  const ProductGroupListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureEntry<
      ProductGroupApiService,
      ProductGroupRepository,
      ProductGroupViewModel
    >(
      createService: (context) =>
          ProductGroupApiService(context.read<ApiClient>()),
      createRepository: (context) =>
          ProductGroupRepositoryImpl(context.read<ProductGroupApiService>()),
      createViewModel: (context) =>
          ProductGroupViewModel(context.read<ProductGroupRepository>()),
      initialize: (viewModel) => viewModel.initialize(),
      child: const ProductGroupListPage(),
    );
  }
}
