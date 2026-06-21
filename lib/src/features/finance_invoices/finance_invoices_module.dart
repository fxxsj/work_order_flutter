import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/features/finance_invoices/application/invoice_view_model.dart';
import 'package:work_order_app/src/features/finance_invoices/data/invoice_api_service.dart';
import 'package:work_order_app/src/features/finance_invoices/data/invoice_form_options_loader.dart';
import 'package:work_order_app/src/features/finance_invoices/data/invoice_repository_impl.dart';
import 'package:work_order_app/src/features/finance_invoices/domain/invoice_repository.dart';
import 'package:work_order_app/src/features/finance_invoices/presentation/invoice_detail_page.dart';
import 'package:work_order_app/src/features/finance_invoices/presentation/invoice_list_page.dart';

/// 发票模块组合根：注入仓库与 ViewModel，presentation 层只依赖抽象。
class InvoiceListEntry extends StatelessWidget {
  const InvoiceListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<InvoiceRepository>(
          create: (context) {
            final apiService = InvoiceApiService(context.read<ApiClient>());
            return InvoiceRepositoryImpl(
              apiService,
              InvoiceFormOptionsLoader(context.read<ApiClient>()),
            );
          },
        ),
        ChangeNotifierProvider<InvoiceViewModel>(
          create: (context) => InvoiceViewModel(
            context.read<InvoiceRepository>(),
          )..initialize(),
        ),
      ],
      child: const InvoiceListPage(),
    );
  }
}

/// 发票详情模块入口，负责为详情页注入仓库。
class InvoiceDetailEntry extends StatelessWidget {
  const InvoiceDetailEntry({super.key, required this.invoiceId});

  final int invoiceId;

  @override
  Widget build(BuildContext context) {
    return Provider<InvoiceRepository>(
      create: (context) => InvoiceRepositoryImpl(
        InvoiceApiService(context.read<ApiClient>()),
        InvoiceFormOptionsLoader(context.read<ApiClient>()),
      ),
      child: InvoiceDetailPage(invoiceId: invoiceId),
    );
  }
}
