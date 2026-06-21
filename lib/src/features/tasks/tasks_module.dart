import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/features/tasks/application/task_view_model.dart';
import 'package:work_order_app/src/features/tasks/data/task_api_service.dart';
import 'package:work_order_app/src/features/tasks/data/task_list_support_service.dart';
import 'package:work_order_app/src/features/tasks/data/task_repository_impl.dart';
import 'package:work_order_app/src/features/tasks/domain/task_repository.dart';
import 'package:work_order_app/src/features/tasks/presentation/task_list_page.dart';

class TaskListEntry extends StatelessWidget {
  const TaskListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<TaskApiService>(
          create: (context) => TaskApiService(context.read<ApiClient>()),
        ),
        Provider<TaskListSupportService>(
          create: (context) => TaskListSupportService(context.read<ApiClient>()),
        ),
        Provider<TaskRepository>(
          create: (context) => TaskRepositoryImpl(
            context.read<TaskApiService>(),
            context.read<TaskListSupportService>(),
          ),
        ),
        ChangeNotifierProvider<TaskViewModel>(
          create: (context) => TaskViewModel(
            context.read<TaskRepository>(),
          )..initialize(),
        ),
      ],
      child: const TaskListPage(),
    );
  }
}
