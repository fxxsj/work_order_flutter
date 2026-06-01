import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/features/customer/application/customer_view_model.dart';
import 'package:work_order_app/src/features/customer/data/customer_api_service.dart';
import 'package:work_order_app/src/features/customer/data/customer_repository_impl.dart';
import 'package:work_order_app/src/features/customer/domain/customer_repository.dart';
import 'package:work_order_app/src/features/customer/presentation/customer_list_page.dart';

class CustomerListEntry extends StatelessWidget {
  const CustomerListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureEntry<
      CustomerApiService,
      CustomerRepository,
      CustomerViewModel
    >(
      createService: (context) => CustomerApiService(context.read<ApiClient>()),
      createRepository: (context) =>
          CustomerRepositoryImpl(context.read<CustomerApiService>()),
      createViewModel: (context) =>
          CustomerViewModel(context.read<CustomerRepository>()),
      initialize: (viewModel) => viewModel.initialize(),
      child: const CustomerListPage(),
    );
  }
}
