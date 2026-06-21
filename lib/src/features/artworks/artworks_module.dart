import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/features/artworks/application/artwork_view_model.dart';
import 'package:work_order_app/src/features/artworks/data/artwork_api_service.dart';
import 'package:work_order_app/src/features/artworks/data/artwork_repository_impl.dart';
import 'package:work_order_app/src/features/artworks/domain/artwork_repository.dart';
import 'package:work_order_app/src/features/artworks/presentation/artwork_list_page.dart';

class ArtworkListEntry extends StatelessWidget {
  const ArtworkListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureEntry<
      ArtworkApiService,
      ArtworkRepository,
      ArtworkViewModel
    >(
      createService: (context) => ArtworkApiService(context.read<ApiClient>()),
      createRepository: (context) =>
          ArtworkRepositoryImpl(context.read<ArtworkApiService>()),
      createViewModel: (context) =>
          ArtworkViewModel(context.read<ArtworkRepository>()),
      initialize: (viewModel) => viewModel.initialize(),
      child: const ArtworkListPage(),
    );
  }
}
