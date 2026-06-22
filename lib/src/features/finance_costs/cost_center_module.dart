import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/data/generic_api_service.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/features/auth/data/auth_api.dart';
import 'package:work_order_app/src/features/finance_costs/data/cost_center_options_repository_impl.dart';
import 'package:work_order_app/src/features/finance_costs/data/cost_center_repository_impl.dart';
import 'package:work_order_app/src/features/finance_costs/domain/cost_center_options_repository.dart';
import 'package:work_order_app/src/features/finance_costs/domain/cost_center_repository.dart';
import 'package:work_order_app/src/features/finance_costs/presentation/cost_center_list_page.dart';

class CostCenterListEntry extends StatelessWidget {
  const CostCenterListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<CostCenterRepository>(
          create: (context) => CostCenterRepositoryImpl(context.read<ApiClient>()),
        ),
        Provider<CostCenterOptionsRepository>(
          create: (context) => CostCenterOptionsRepositoryImpl(
            GenericApiService(
              context.read<ApiClient>(),
              resourcePath: '/cost-centers/',
            ),
            AuthApi(context.read<ApiClient>()),
          ),
        ),
      ],
      child: const CostCenterListPage(),
    );
  }
}
