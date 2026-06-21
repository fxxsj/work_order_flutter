import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/features/inventory_stocks/application/product_stock_view_model.dart';
import 'package:work_order_app/src/features/inventory_stocks/data/product_stock_api_service.dart';
import 'package:work_order_app/src/features/inventory_stocks/data/product_stock_repository_impl.dart';
import 'package:work_order_app/src/features/inventory_stocks/data/product_stock_support_service.dart';
import 'package:work_order_app/src/features/inventory_stocks/domain/product_stock_repository.dart';
import 'package:work_order_app/src/features/inventory_stocks/presentation/product_stock_list_page.dart';

/// 成品库存模块组合根：注入仓库与 ViewModel，presentation 层只依赖抽象。
class ProductStockListEntry extends StatelessWidget {
  const ProductStockListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ProductStockRepository>(
          create: (context) {
            final apiService = ProductStockApiService(
              context.read<ApiClient>(),
            );
            return ProductStockRepositoryImpl(
              apiService,
              ProductStockSupportService(context.read<ApiClient>()),
            );
          },
        ),
        ChangeNotifierProvider<ProductStockViewModel>(
          create: (context) => ProductStockViewModel(
            context.read<ProductStockRepository>(),
          )..initialize(),
        ),
      ],
      child: const ProductStockListPage(),
    );
  }
}
