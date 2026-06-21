import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/features/inventory_quality/application/quality_inspection_view_model.dart';
import 'package:work_order_app/src/features/inventory_quality/data/quality_inspection_api_service.dart';
import 'package:work_order_app/src/features/inventory_quality/data/quality_inspection_repository_impl.dart';
import 'package:work_order_app/src/features/inventory_quality/domain/quality_inspection_repository.dart';
import 'package:work_order_app/src/features/inventory_quality/presentation/quality_inspection_list_page.dart';

/// 质检模块组合根：负责注入仓库与 ViewModel，presentation 层只依赖抽象。
class QualityInspectionListEntry extends StatelessWidget {
  const QualityInspectionListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<QualityInspectionRepository>(
          create: (context) => QualityInspectionRepositoryImpl(
            QualityInspectionApiService(context.read<ApiClient>()),
          ),
        ),
        ChangeNotifierProvider<QualityInspectionViewModel>(
          create: (context) => QualityInspectionViewModel(
            context.read<QualityInspectionRepository>(),
          )..initialize(),
        ),
      ],
      child: const QualityInspectionListPage(),
    );
  }
}
