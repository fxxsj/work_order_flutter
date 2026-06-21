import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/features/artworks/application/artwork_view_model.dart';
import 'package:work_order_app/src/features/artworks/data/artwork_api_service.dart';
import 'package:work_order_app/src/features/artworks/data/artwork_repository_impl.dart';
import 'package:work_order_app/src/features/artworks/domain/artwork_repository.dart';
import 'package:work_order_app/src/features/artworks/presentation/artwork_list_page.dart';
import 'package:work_order_app/src/features/dies/data/die_api_service.dart';
import 'package:work_order_app/src/features/dies/data/die_repository_impl.dart';
import 'package:work_order_app/src/features/dies/domain/die_repository.dart';
import 'package:work_order_app/src/features/embossing_plates/data/embossing_plate_api_service.dart';
import 'package:work_order_app/src/features/embossing_plates/data/embossing_plate_repository_impl.dart';
import 'package:work_order_app/src/features/embossing_plates/domain/embossing_plate_repository.dart';
import 'package:work_order_app/src/features/foiling_plates/data/foiling_plate_api_service.dart';
import 'package:work_order_app/src/features/foiling_plates/data/foiling_plate_repository_impl.dart';
import 'package:work_order_app/src/features/foiling_plates/domain/foiling_plate_repository.dart';
import 'package:work_order_app/src/features/products/data/product_api_service.dart';
import 'package:work_order_app/src/features/products/data/product_repository_impl.dart';
import 'package:work_order_app/src/features/products/domain/product_repository.dart';

class ArtworkListEntry extends StatelessWidget {
  const ArtworkListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ProductRepository>(
          create: (context) => ProductRepositoryImpl(
            ProductApiService(context.read<ApiClient>()),
          ),
        ),
        Provider<DieRepository>(
          create: (context) => DieRepositoryImpl(
            DieApiService(context.read<ApiClient>()),
          ),
        ),
        Provider<FoilingPlateRepository>(
          create: (context) => FoilingPlateRepositoryImpl(
            FoilingPlateApiService(context.read<ApiClient>()),
          ),
        ),
        Provider<EmbossingPlateRepository>(
          create: (context) => EmbossingPlateRepositoryImpl(
            EmbossingPlateApiService(context.read<ApiClient>()),
          ),
        ),
      ],
      child: FeatureEntry<
        ArtworkApiService,
        ArtworkRepository,
        ArtworkViewModel
      >(
        createService: (context) =>
            ArtworkApiService(context.read<ApiClient>()),
        createRepository: (context) =>
            ArtworkRepositoryImpl(context.read<ArtworkApiService>()),
        createViewModel: (context) =>
            ArtworkViewModel(context.read<ArtworkRepository>()),
        initialize: (viewModel) => viewModel.initialize(),
        child: const ArtworkListPage(),
      ),
    );
  }
}
