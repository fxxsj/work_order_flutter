import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/features/customer/data/customer_api_service.dart';
import 'package:work_order_app/src/features/customer/data/customer_repository_impl.dart';
import 'package:work_order_app/src/features/customer/domain/customer_repository.dart';
import 'package:work_order_app/src/features/materials/data/material_api_service.dart';
import 'package:work_order_app/src/features/materials/data/material_repository_impl.dart';
import 'package:work_order_app/src/features/materials/domain/material_repository.dart';
import 'package:work_order_app/src/features/products/data/product_api_service.dart';
import 'package:work_order_app/src/features/products/data/product_repository_impl.dart';
import 'package:work_order_app/src/features/products/domain/product_repository.dart';
import 'package:work_order_app/src/features/purchase_orders/data/purchase_order_api_service.dart';
import 'package:work_order_app/src/features/purchase_orders/data/purchase_order_repository_impl.dart';
import 'package:work_order_app/src/features/purchase_orders/domain/purchase_order_repository.dart';
import 'package:work_order_app/src/features/tasks/data/task_api_service.dart';
import 'package:work_order_app/src/features/tasks/data/task_list_support_service.dart';
import 'package:work_order_app/src/features/tasks/data/task_supervisor_support_service.dart';
import 'package:work_order_app/src/features/tasks/domain/task_repository.dart';
import 'package:work_order_app/src/features/tasks/data/task_repository_impl.dart';
import 'package:work_order_app/src/features/workorders/application/work_order_view_model.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_api_service.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_flow_api_service.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_flow_repository_impl.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_repository_impl.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_flow_repository.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_repository.dart';
import 'package:work_order_app/src/features/workorders/presentation/work_order_detail_page.dart';
import 'package:work_order_app/src/features/workorders/presentation/work_order_form_page.dart';
import 'package:work_order_app/src/features/workorders/presentation/work_order_list_page.dart';

export 'presentation/work_order_form_page.dart' show WorkOrderFormMode;

/// 施工单模块，负责注入该特性所需的全部依赖。
class WorkOrderListEntry extends StatelessWidget {
  const WorkOrderListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: _crossFeatureProviders,
      child: FeatureEntry<
        WorkOrderApiService,
        WorkOrderRepository,
        WorkOrderViewModel
      >(
        createService: (context) =>
            WorkOrderApiService(context.read<ApiClient>()),
        createRepository: (context) => WorkOrderRepositoryImpl(
          context.read<WorkOrderApiService>(),
        ),
        createViewModel: (context) =>
            WorkOrderViewModel(context.read<WorkOrderRepository>()),
        initialize: (viewModel) => viewModel.initialize(),
        child: const WorkOrderListPage(),
      ),
    );
  }
}

class WorkOrderDetailEntry extends StatelessWidget {
  const WorkOrderDetailEntry({super.key, required this.workOrderId});

  final int workOrderId;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: _crossFeatureProviders,
      child: FeatureEntry<
        WorkOrderApiService,
        WorkOrderRepository,
        WorkOrderViewModel
      >(
        createService: (context) =>
            WorkOrderApiService(context.read<ApiClient>()),
        createRepository: (context) => WorkOrderRepositoryImpl(
          context.read<WorkOrderApiService>(),
        ),
        createViewModel: (context) =>
            WorkOrderViewModel(context.read<WorkOrderRepository>()),
        initialize: (viewModel) => viewModel.initialize(),
        child: WorkOrderDetailPage(workOrderId: workOrderId),
      ),
    );
  }
}

class WorkOrderFormEntry extends StatelessWidget {
  const WorkOrderFormEntry({
    super.key,
    required this.mode,
    this.workOrderId,
    this.initialSalesOrderId,
  });

  final WorkOrderFormMode mode;
  final int? workOrderId;
  final int? initialSalesOrderId;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: _crossFeatureProviders,
      child: FeatureEntry<
        WorkOrderApiService,
        WorkOrderRepository,
        WorkOrderViewModel
      >(
        createService: (context) =>
            WorkOrderApiService(context.read<ApiClient>()),
        createRepository: (context) => WorkOrderRepositoryImpl(
          context.read<WorkOrderApiService>(),
        ),
        createViewModel: (context) =>
            WorkOrderViewModel(context.read<WorkOrderRepository>()),
        initialize: (viewModel) => viewModel.initialize(),
        child: WorkOrderFormPage(
          mode: mode,
          workOrderId: workOrderId,
          initialSalesOrderId: initialSalesOrderId,
        ),
      ),
    );
  }
}

List<Provider> get _crossFeatureProviders => [
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
  Provider<MaterialRepository>(
    create: (context) => MaterialRepositoryImpl(
      MaterialApiService(context.read<ApiClient>()),
    ),
  ),
  Provider<TaskRepository>(
    create: (context) => TaskRepositoryImpl(
      TaskApiService(context.read<ApiClient>()),
      TaskListSupportService(context.read<ApiClient>()),
      TaskSupervisorSupportService(context.read<ApiClient>()),
    ),
  ),
  Provider<PurchaseOrderRepository>(
    create: (context) => PurchaseOrderRepositoryImpl(
      PurchaseOrderApiService(context.read<ApiClient>()),
    ),
  ),
  Provider<WorkOrderFlowRepository>(
    create: (context) => WorkOrderFlowRepositoryImpl(
      WorkOrderFlowApiService(context.read<ApiClient>()),
    ),
  ),
];
