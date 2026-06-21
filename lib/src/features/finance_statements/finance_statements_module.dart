import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/features/customer/data/customer_api_service.dart';
import 'package:work_order_app/src/features/customer/data/customer_repository_impl.dart';
import 'package:work_order_app/src/features/customer/domain/customer_repository.dart';
import 'package:work_order_app/src/features/finance_statements/application/statement_view_model.dart';
import 'package:work_order_app/src/features/finance_statements/data/statement_api_service.dart';
import 'package:work_order_app/src/features/finance_statements/data/statement_repository_impl.dart';
import 'package:work_order_app/src/features/finance_statements/data/statement_support_service.dart';
import 'package:work_order_app/src/features/finance_statements/domain/statement_repository.dart';
import 'package:work_order_app/src/features/finance_statements/presentation/statement_list_page.dart';
import 'package:work_order_app/src/features/suppliers/data/supplier_api_service.dart';
import 'package:work_order_app/src/features/suppliers/data/supplier_repository_impl.dart';
import 'package:work_order_app/src/features/suppliers/domain/supplier_repository.dart';

class StatementListEntry extends StatelessWidget {
  const StatementListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<StatementApiService>(
          create: (context) => StatementApiService(context.read<ApiClient>()),
        ),
        Provider<StatementSupportService>(
          create: (context) => StatementSupportService(context.read<ApiClient>()),
        ),
        Provider<StatementRepository>(
          create: (context) => StatementRepositoryImpl(
            context.read<StatementApiService>(),
            context.read<StatementSupportService>(),
          ),
        ),
        ChangeNotifierProvider<StatementViewModel>(
          create: (context) => StatementViewModel(
            context.read<StatementRepository>(),
          )..initialize(),
        ),
        Provider<CustomerRepository>(
          create: (context) => CustomerRepositoryImpl(
            CustomerApiService(context.read<ApiClient>()),
          ),
        ),
        Provider<SupplierRepository>(
          create: (context) => SupplierRepositoryImpl(
            SupplierApiService(context.read<ApiClient>()),
          ),
        ),
      ],
      child: const StatementListPage(),
    );
  }
}
