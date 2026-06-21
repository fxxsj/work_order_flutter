import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/features/inventory_delivery/application/delivery_order_view_model.dart';
import 'package:work_order_app/src/features/inventory_delivery/data/delivery_order_api_service.dart';
import 'package:work_order_app/src/features/inventory_delivery/data/delivery_order_repository_impl.dart';
import 'package:work_order_app/src/features/inventory_delivery/data/delivery_order_support_service.dart';
import 'package:work_order_app/src/features/inventory_delivery/domain/delivery_order_repository.dart';
import 'package:work_order_app/src/features/inventory_delivery/presentation/delivery_order_detail_page.dart';
import 'package:work_order_app/src/features/inventory_delivery/presentation/delivery_order_list_page.dart';

class DeliveryOrderListEntry extends StatelessWidget {
  const DeliveryOrderListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DeliveryOrderApiService>(
          create: (context) => DeliveryOrderApiService(context.read<ApiClient>()),
        ),
        Provider<DeliveryOrderSupportService>(
          create: (context) => DeliveryOrderSupportService(context.read<ApiClient>()),
        ),
        Provider<DeliveryOrderRepository>(
          create: (context) => DeliveryOrderRepositoryImpl(
            context.read<DeliveryOrderApiService>(),
            context.read<DeliveryOrderSupportService>(),
          ),
        ),
        ChangeNotifierProvider<DeliveryOrderViewModel>(
          create: (context) => DeliveryOrderViewModel(
            context.read<DeliveryOrderRepository>(),
          )..initialize(),
        ),
      ],
      child: const DeliveryOrderListPage(),
    );
  }
}

class DeliveryOrderDetailEntry extends StatelessWidget {
  const DeliveryOrderDetailEntry({super.key, required this.deliveryOrderId});

  final int deliveryOrderId;

  @override
  Widget build(BuildContext context) {
    return Provider<DeliveryOrderRepository>(
      create: (context) => DeliveryOrderRepositoryImpl(
        DeliveryOrderApiService(context.read<ApiClient>()),
        DeliveryOrderSupportService(context.read<ApiClient>()),
      ),
      child: DeliveryOrderDetailPage(deliveryOrderId: deliveryOrderId),
    );
  }
}
