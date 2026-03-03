import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/features/customer/application/customer_view_model.dart';
import 'package:work_order_app/src/features/customer/data/customer_api_service.dart';
import 'package:work_order_app/src/features/customer/data/customer_repository_impl.dart';
import 'package:work_order_app/src/features/customer/domain/customer_repository.dart';

List<SingleChildWidget> buildCustomerProviders() {
  return [
    Provider<CustomerApiService>(
      create: (context) => CustomerApiService(
        context.read<ApiClient>(),
      ),
    ),
    Provider<CustomerRepository>(
      create: (context) => CustomerRepositoryImpl(
        context.read<CustomerApiService>(),
      ),
    ),
    ChangeNotifierProvider<CustomerViewModel>(
      create: (context) => CustomerViewModel(
        context.read<CustomerRepository>(),
      )..initialize(),
    ),
  ];
}
