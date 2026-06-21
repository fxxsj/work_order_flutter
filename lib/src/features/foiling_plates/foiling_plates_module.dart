import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/features/foiling_plates/application/foiling_plate_view_model.dart';
import 'package:work_order_app/src/features/foiling_plates/data/foiling_plate_api_service.dart';
import 'package:work_order_app/src/features/foiling_plates/data/foiling_plate_repository_impl.dart';
import 'package:work_order_app/src/features/foiling_plates/domain/foiling_plate_repository.dart';
import 'package:work_order_app/src/features/foiling_plates/presentation/foiling_plate_list_page.dart';
import 'package:work_order_app/src/features/products/data/product_api_service.dart';
import 'package:work_order_app/src/features/products/data/product_repository_impl.dart';
import 'package:work_order_app/src/features/products/domain/product_repository.dart';

class FoilingPlateListEntry extends StatelessWidget {
  const FoilingPlateListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<ProductRepository>(
      create: (context) => ProductRepositoryImpl(
        ProductApiService(context.read<ApiClient>()),
      ),
      child: FeatureEntry<
        FoilingPlateApiService,
        FoilingPlateRepository,
        FoilingPlateViewModel
      >(
        createService: (context) =>
            FoilingPlateApiService(context.read<ApiClient>()),
        createRepository: (context) =>
            FoilingPlateRepositoryImpl(context.read<FoilingPlateApiService>()),
        createViewModel: (context) =>
            FoilingPlateViewModel(context.read<FoilingPlateRepository>()),
        initialize: (viewModel) => viewModel.initialize(),
        child: const FoilingPlateListPage(),
      ),
    );
  }
}
