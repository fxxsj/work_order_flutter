import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/features/suppliers/application/supplier_view_model.dart';
import 'package:work_order_app/src/features/suppliers/data/supplier_api_service.dart';
import 'package:work_order_app/src/features/suppliers/data/supplier_repository_impl.dart';
import 'package:work_order_app/src/features/suppliers/domain/supplier_repository.dart';
import 'package:work_order_app/src/features/suppliers/presentation/supplier_list_page.dart';

class SupplierListEntry extends StatelessWidget {
  const SupplierListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureEntry<
      SupplierApiService,
      SupplierRepository,
      SupplierViewModel
    >(
      createService: (context) => SupplierApiService(context.read<ApiClient>()),
      createRepository: (context) =>
          SupplierRepositoryImpl(context.read<SupplierApiService>()),
      createViewModel: (context) =>
          SupplierViewModel(context.read<SupplierRepository>()),
      initialize: (viewModel) => viewModel.initialize(),
      child: const SupplierListPage(),
    );
  }
}
