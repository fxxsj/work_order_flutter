import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/features/materials/data/material_api_service.dart';
import 'package:work_order_app/src/features/materials/data/material_repository_impl.dart';
import 'package:work_order_app/src/features/materials/domain/material_repository.dart';
import 'package:work_order_app/src/features/purchase_orders/application/purchase_order_view_model.dart';
import 'package:work_order_app/src/features/purchase_orders/data/purchase_order_api_service.dart';
import 'package:work_order_app/src/features/purchase_orders/data/purchase_order_repository_impl.dart';
import 'package:work_order_app/src/features/purchase_orders/domain/purchase_order_repository.dart';
import 'package:work_order_app/src/features/purchase_orders/presentation/purchase_order_list_page.dart';
import 'package:work_order_app/src/features/suppliers/data/supplier_api_service.dart';
import 'package:work_order_app/src/features/suppliers/data/supplier_repository_impl.dart';
import 'package:work_order_app/src/features/suppliers/domain/supplier_repository.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_api_service.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_repository_impl.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_repository.dart';

class PurchaseOrderListEntry extends StatelessWidget {
  const PurchaseOrderListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SupplierRepository>(
          create: (context) => SupplierRepositoryImpl(
            SupplierApiService(context.read<ApiClient>()),
          ),
        ),
        Provider<MaterialRepository>(
          create: (context) => MaterialRepositoryImpl(
            MaterialApiService(context.read<ApiClient>()),
          ),
        ),
        Provider<WorkOrderRepository>(
          create: (context) => WorkOrderRepositoryImpl(
            WorkOrderApiService(context.read<ApiClient>()),
          ),
        ),
      ],
      child: FeatureEntry<
        PurchaseOrderApiService,
        PurchaseOrderRepository,
        PurchaseOrderViewModel
      >(
        createService: (context) =>
            PurchaseOrderApiService(context.read<ApiClient>()),
        createRepository: (context) => PurchaseOrderRepositoryImpl(
          context.read<PurchaseOrderApiService>(),
        ),
        createViewModel: (context) =>
            PurchaseOrderViewModel(context.read<PurchaseOrderRepository>()),
        initialize: (viewModel) => viewModel.initialize(),
        child: const PurchaseOrderListPage(),
      ),
    );
  }
}
