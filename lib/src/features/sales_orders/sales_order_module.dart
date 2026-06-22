import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/features/customer/data/customer_api_service.dart';
import 'package:work_order_app/src/features/customer/data/customer_repository_impl.dart';
import 'package:work_order_app/src/features/customer/domain/customer_repository.dart';
import 'package:work_order_app/src/features/products/data/product_api_service.dart';
import 'package:work_order_app/src/features/products/data/product_repository_impl.dart';
import 'package:work_order_app/src/features/products/domain/product_repository.dart';
import 'package:work_order_app/src/features/sales_orders/application/sales_order_view_model.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_api_service.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_repository_impl.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order_repository.dart';
import 'package:work_order_app/src/features/sales_orders/presentation/sales_order_detail_page.dart';
import 'package:work_order_app/src/features/sales_orders/presentation/sales_order_form_page.dart';
import 'package:work_order_app/src/features/sales_orders/presentation/sales_order_list_page.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_flow_api_service.dart';

export 'presentation/sales_order_form_page.dart' show SalesOrderFormMode;

/// 客户订单模块，负责注入该特性所需的全部依赖。
class SalesOrderListEntry extends StatelessWidget {
  const SalesOrderListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<CustomerRepository>(
          create: (context) => CustomerRepositoryImpl(
            CustomerApiService(context.read<ApiClient>()),
          ),
        ),
        Provider<ProductRepository>(
          create: (context) => ProductRepositoryImpl(
            ProductApiService(context.read<ApiClient>()),
          ),
        ),
      ],
      child: FeatureEntry<
        SalesOrderApiService,
        SalesOrderRepository,
        SalesOrderViewModel
      >(
        createService: (context) =>
            SalesOrderApiService(context.read<ApiClient>()),
        createRepository: (context) => SalesOrderRepositoryImpl(
          context.read<SalesOrderApiService>(),
          WorkOrderFlowApiService(context.read<ApiClient>()),
        ),
        createViewModel: (context) =>
            SalesOrderViewModel(context.read<SalesOrderRepository>()),
        initialize: (viewModel) => viewModel.initialize(),
        child: const SalesOrderListPage(),
      ),
    );
  }
}

class SalesOrderDetailEntry extends StatelessWidget {
  const SalesOrderDetailEntry({super.key, required this.orderId});

  final int orderId;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<CustomerRepository>(
          create: (context) => CustomerRepositoryImpl(
            CustomerApiService(context.read<ApiClient>()),
          ),
        ),
        Provider<ProductRepository>(
          create: (context) => ProductRepositoryImpl(
            ProductApiService(context.read<ApiClient>()),
          ),
        ),
      ],
      child: FeatureEntry<
        SalesOrderApiService,
        SalesOrderRepository,
        SalesOrderViewModel
      >(
        createService: (context) =>
            SalesOrderApiService(context.read<ApiClient>()),
        createRepository: (context) => SalesOrderRepositoryImpl(
          context.read<SalesOrderApiService>(),
          WorkOrderFlowApiService(context.read<ApiClient>()),
        ),
        createViewModel: (context) =>
            SalesOrderViewModel(context.read<SalesOrderRepository>()),
        initialize: (viewModel) => viewModel.initialize(),
        child: SalesOrderDetailPage(orderId: orderId),
      ),
    );
  }
}

class SalesOrderFormEntry extends StatelessWidget {
  const SalesOrderFormEntry({super.key, required this.mode, this.orderId});

  final SalesOrderFormMode mode;
  final int? orderId;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<CustomerRepository>(
          create: (context) => CustomerRepositoryImpl(
            CustomerApiService(context.read<ApiClient>()),
          ),
        ),
        Provider<ProductRepository>(
          create: (context) => ProductRepositoryImpl(
            ProductApiService(context.read<ApiClient>()),
          ),
        ),
      ],
      child: FeatureEntry<
        SalesOrderApiService,
        SalesOrderRepository,
        SalesOrderViewModel
      >(
        createService: (context) =>
            SalesOrderApiService(context.read<ApiClient>()),
        createRepository: (context) => SalesOrderRepositoryImpl(
          context.read<SalesOrderApiService>(),
          WorkOrderFlowApiService(context.read<ApiClient>()),
        ),
        createViewModel: (context) =>
            SalesOrderViewModel(context.read<SalesOrderRepository>()),
        initialize: (viewModel) => viewModel.initialize(),
        child: SalesOrderFormPage(mode: mode, orderId: orderId),
      ),
    );
  }
}
