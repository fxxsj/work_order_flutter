import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/features/embossing_plates/application/embossing_plate_view_model.dart';
import 'package:work_order_app/src/features/embossing_plates/data/embossing_plate_api_service.dart';
import 'package:work_order_app/src/features/embossing_plates/data/embossing_plate_repository_impl.dart';
import 'package:work_order_app/src/features/embossing_plates/domain/embossing_plate_repository.dart';
import 'package:work_order_app/src/features/embossing_plates/presentation/embossing_plate_list_page.dart';

class EmbossingPlateListEntry extends StatelessWidget {
  const EmbossingPlateListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureEntry<
      EmbossingPlateApiService,
      EmbossingPlateRepository,
      EmbossingPlateViewModel
    >(
      createService: (context) =>
          EmbossingPlateApiService(context.read<ApiClient>()),
      createRepository: (context) => EmbossingPlateRepositoryImpl(
        context.read<EmbossingPlateApiService>(),
      ),
      createViewModel: (context) =>
          EmbossingPlateViewModel(context.read<EmbossingPlateRepository>()),
      initialize: (viewModel) => viewModel.initialize(),
      child: const EmbossingPlateListPage(),
    );
  }
}
