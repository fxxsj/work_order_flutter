import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/data/generic_api_service.dart';
import 'package:work_order_app/src/core/data/generic_repository_impl.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/viewmodels/generic_list_view_model.dart';
import 'package:work_order_app/src/features/stock_in/data/stock_in_api_service.dart';
import 'package:work_order_app/src/features/stock_in/data/stock_in_repository_impl.dart';
import 'package:work_order_app/src/features/stock_in/domain/stock_in_repository.dart';
import 'package:work_order_app/src/features/stock_in/presentation/stock_in_list_page.dart';

class StockInListEntry extends StatelessWidget {
  const StockInListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<StockInRepository>(
          create: (context) => StockInRepositoryImpl(
            StockInApiService(context.read<ApiClient>()),
          ),
        ),
        ChangeNotifierProvider<GenericListViewModel>(
          create: (context) => GenericListViewModel(
            GenericRepositoryImpl(
              GenericApiService(
                context.read<ApiClient>(),
                resourcePath: '/stock-ins/',
              ),
            ),
            enableSummary: false,
          )..initialize(),
        ),
      ],
      child: const StockInListPage(),
    );
  }
}
