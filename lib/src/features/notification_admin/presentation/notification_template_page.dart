import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_data_table.dart';

class NotificationTemplatePage extends StatefulWidget {
  const NotificationTemplatePage({super.key});

  @override
  State<NotificationTemplatePage> createState() =>
      _NotificationTemplatePageState();
}

class _NotificationTemplatePageState extends State<NotificationTemplatePage> {
  ApiClient? _apiClient;
  bool _loading = false;
  String? _error;
  final List<_TemplateItem> _templates = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _apiClient ??= context.read<ApiClient>();
    if (_templates.isEmpty && !_loading) {
      _loadTemplates();
    }
  }

  Future<void> _loadTemplates() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final response =
          await _apiClient!.get('/notification-templates/get_templates/');
      final data = response.data;
      final templates = <_TemplateItem>[];
      if (data is Map) {
        final map = Map<String, dynamic>.from(data);
        map.forEach((key, value) {
          if (value is Map) {
            final item = Map<String, dynamic>.from(value);
            templates.add(_TemplateItem(
              key: key,
              title: item['title']?.toString() ?? '-',
              message: item['message']?.toString() ?? '-',
              variables: _parseVariables(item['variables']),
            ));
          }
        });
      }
      setState(() {
        _templates
          ..clear()
          ..addAll(templates);
      });
    } catch (err) {
      setState(() => _error = err.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<String> _parseVariables(dynamic value) {
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return const [];
  }

  @override
  Widget build(BuildContext context) {
    final spacing = LayoutTokens.sectionSpacing(context);
    return SingleChildScrollView(
      padding: LayoutTokens.pagePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('通知模板', style: Theme.of(context).textTheme.titleSmall),
                OutlinedButton.icon(
                  onPressed: _loading ? null : _loadTemplates,
                  icon: _loading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh, size: 18),
                  label: Text(_loading ? '刷新中' : '刷新'),
                ),
              ],
            ),
          ),
          SizedBox(height: spacing),
          if (_error != null)
            AppCard(
              child: Text('加载失败: $_error'),
            )
          else if (_loading && _templates.isEmpty)
            const Center(child: CircularProgressIndicator())
          else if (_templates.isEmpty)
            AppCard(
              child: const Text('暂无模板数据'),
            )
          else
            AppDataTable(
              columns: const [
                DataColumn(label: Text('模板键')),
                DataColumn(label: Text('标题')),
                DataColumn(label: Text('内容')),
                DataColumn(label: Text('变量')),
              ],
              rows: _templates
                  .map(
                    (item) => DataRow(
                      cells: [
                        DataCell(Text(item.key)),
                        DataCell(Text(item.title)),
                        DataCell(Text(item.message)),
                        DataCell(Text(item.variables.join(', '))),
                      ],
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }
}

class _TemplateItem {
  const _TemplateItem({
    required this.key,
    required this.title,
    required this.message,
    required this.variables,
  });

  final String key;
  final String title;
  final String message;
  final List<String> variables;
}
