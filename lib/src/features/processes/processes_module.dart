import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/data/generic_api_service.dart';
import 'package:work_order_app/src/core/data/generic_repository_impl.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/core/viewmodels/generic_list_view_model.dart';
import 'package:work_order_app/src/features/processes/application/process_view_model.dart';
import 'package:work_order_app/src/features/processes/data/process_api_service.dart';
import 'package:work_order_app/src/features/processes/data/process_repository_impl.dart';
import 'package:work_order_app/src/features/processes/domain/process_repository.dart';
import 'package:work_order_app/src/features/processes/presentation/process_list_page.dart';
import 'package:work_order_app/src/features/processes/presentation/process_log_list_page.dart';

class ProcessListEntry extends StatelessWidget {
  const ProcessListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureEntry<ProcessApiService, ProcessRepository, ProcessViewModel>(
      createService: (context) => ProcessApiService(context.read<ApiClient>()),
      createRepository: (context) =>
          ProcessRepositoryImpl(context.read<ProcessApiService>()),
      createViewModel: (context) =>
          ProcessViewModel(context.read<ProcessRepository>()),
      initialize: (viewModel) => viewModel.initialize(),
      child: const ProcessListPage(),
    );
  }
}

class ProcessLogListEntry extends StatelessWidget {
  const ProcessLogListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GenericListViewModel>(
      create: (context) => GenericListViewModel(
        GenericRepositoryImpl(
          GenericApiService(
            context.read<ApiClient>(),
            resourcePath: '/process-logs/',
          ),
        ),
        enableSummary: false,
      )..initialize(),
      child: const ProcessLogListPage(),
    );
  }
}
