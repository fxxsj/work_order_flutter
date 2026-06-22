import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/data/generic_api_service.dart';
import 'package:work_order_app/src/core/data/generic_repository_impl.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/viewmodels/generic_list_view_model.dart';
import 'package:work_order_app/src/features/finance_payments/application/payment_view_model.dart';
import 'package:work_order_app/src/features/finance_payments/data/payment_api_service.dart';
import 'package:work_order_app/src/features/finance_payments/data/payment_plan_repository_impl.dart';
import 'package:work_order_app/src/features/finance_payments/data/payment_repository_impl.dart';
import 'package:work_order_app/src/features/finance_payments/data/payment_support_service.dart';
import 'package:work_order_app/src/features/finance_payments/domain/payment_plan_repository.dart';
import 'package:work_order_app/src/features/finance_payments/domain/payment_repository.dart';
import 'package:work_order_app/src/features/finance_payments/presentation/payment_list_page.dart';
import 'package:work_order_app/src/features/finance_payments/presentation/payment_plan_list_page.dart';

/// 收款模块组合根：注入仓库与 ViewModel，presentation 层只依赖抽象。
class PaymentListEntry extends StatelessWidget {
  const PaymentListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<PaymentRepository>(
          create: (context) {
            final apiService = PaymentApiService(context.read<ApiClient>());
            return PaymentRepositoryImpl(
              apiService,
              PaymentSupportService(context.read<ApiClient>()),
            );
          },
        ),
        ChangeNotifierProvider<PaymentViewModel>(
          create: (context) => PaymentViewModel(
            context.read<PaymentRepository>(),
          )..initialize(),
        ),
      ],
      child: const PaymentListPage(),
    );
  }
}

/// 收款计划模块组合根。
class PaymentPlanListEntry extends StatelessWidget {
  const PaymentPlanListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<PaymentPlanRepository>(
          create: (context) => PaymentPlanRepositoryImpl(context.read<ApiClient>()),
        ),
        ChangeNotifierProvider<GenericListViewModel>(
          create: (context) => GenericListViewModel(
            GenericRepositoryImpl(
              GenericApiService(
                context.read<ApiClient>(),
                resourcePath: '/payment-plans/',
              ),
            ),
            enableSummary: false,
          )..initialize(),
        ),
      ],
      child: const PaymentPlanListPage(),
    );
  }
}
