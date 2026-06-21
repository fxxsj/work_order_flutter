import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/features/materials/data/material_api_service.dart';
import 'package:work_order_app/src/features/materials/data/material_repository_impl.dart';
import 'package:work_order_app/src/features/materials/domain/material_repository.dart';
import 'package:work_order_app/src/features/processes/data/process_api_service.dart';
import 'package:work_order_app/src/features/processes/data/process_repository_impl.dart';
import 'package:work_order_app/src/features/processes/domain/process_repository.dart';
import 'package:work_order_app/src/features/product_groups/data/product_group_api_service.dart';
import 'package:work_order_app/src/features/product_groups/data/product_group_repository_impl.dart';
import 'package:work_order_app/src/features/product_groups/domain/product_group_repository.dart';
import 'package:work_order_app/src/features/product_materials/data/product_material_api_service.dart';
import 'package:work_order_app/src/features/product_materials/data/product_material_repository_impl.dart';
import 'package:work_order_app/src/features/product_materials/domain/product_material_repository.dart';
import 'package:work_order_app/src/features/products/application/product_view_model.dart';
import 'package:work_order_app/src/features/products/data/product_api_service.dart';
import 'package:work_order_app/src/features/products/data/product_repository_impl.dart';
import 'package:work_order_app/src/features/products/domain/product_repository.dart';
import 'package:work_order_app/src/features/products/presentation/product_list_page.dart';

class ProductListEntry extends StatelessWidget {
  const ProductListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ProcessRepository>(
          create: (context) => ProcessRepositoryImpl(
            ProcessApiService(context.read<ApiClient>()),
          ),
        ),
        Provider<ProductGroupRepository>(
          create: (context) => ProductGroupRepositoryImpl(
            ProductGroupApiService(context.read<ApiClient>()),
          ),
        ),
        Provider<MaterialRepository>(
          create: (context) => MaterialRepositoryImpl(
            MaterialApiService(context.read<ApiClient>()),
          ),
        ),
        Provider<ProductMaterialRepository>(
          create: (context) => ProductMaterialRepositoryImpl(
            ProductMaterialApiService(context.read<ApiClient>()),
          ),
        ),
      ],
      child: FeatureEntry<
        ProductApiService,
        ProductRepository,
        ProductViewModel
      >(
        createService: (context) => ProductApiService(context.read<ApiClient>()),
        createRepository: (context) =>
            ProductRepositoryImpl(context.read<ProductApiService>()),
        createViewModel: (context) =>
            ProductViewModel(context.read<ProductRepository>()),
        initialize: (viewModel) => viewModel.initialize(),
        child: const ProductListPage(),
      ),
    );
  }
}
