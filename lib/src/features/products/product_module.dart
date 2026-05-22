import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/features/products/application/product_view_model.dart';
import 'package:work_order_app/src/features/products/data/product_api_service.dart';
import 'package:work_order_app/src/features/products/data/product_repository_impl.dart';
import 'package:work_order_app/src/features/products/domain/product_repository.dart';
import 'package:work_order_app/src/features/products/presentation/product_list_page.dart';

class ProductListEntry extends StatelessWidget {
  const ProductListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureEntry<ProductApiService, ProductRepository, ProductViewModel>(
      createService: (context) => ProductApiService(context.read<ApiClient>()),
      createRepository: (context) =>
          ProductRepositoryImpl(context.read<ProductApiService>()),
      createViewModel: (context) =>
          ProductViewModel(context.read<ProductRepository>()),
      initialize: (viewModel) => viewModel.initialize(),
      child: const ProductListPage(),
    );
  }
}
