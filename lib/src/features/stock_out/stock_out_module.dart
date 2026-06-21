import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/features/inventory_delivery/data/delivery_order_api_service.dart';
import 'package:work_order_app/src/features/inventory_delivery/data/delivery_order_repository_impl.dart';
import 'package:work_order_app/src/features/inventory_delivery/data/delivery_order_support_service.dart';
import 'package:work_order_app/src/features/inventory_delivery/domain/delivery_order_repository.dart';
import 'package:work_order_app/src/features/stock_out/data/stock_out_api_service.dart';
import 'package:work_order_app/src/features/stock_out/data/stock_out_repository_impl.dart';
import 'package:work_order_app/src/features/stock_out/domain/stock_out_repository.dart';
import 'package:work_order_app/src/features/stock_out/presentation/stock_out_list_page.dart';

class StockOutListEntry extends StatelessWidget {
  const StockOutListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<StockOutRepository>(
          create: (context) => StockOutRepositoryImpl(
            StockOutApiService(context.read<ApiClient>()),
          ),
        ),
        Provider<DeliveryOrderRepository>(
          create: (context) => DeliveryOrderRepositoryImpl(
            DeliveryOrderApiService(context.read<ApiClient>()),
            DeliveryOrderSupportService(context.read<ApiClient>()),
          ),
        ),
      ],
      child: const StockOutListPage(),
    );
  }
}
