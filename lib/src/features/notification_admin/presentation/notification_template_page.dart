import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/api_exception.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_data_table.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/auth/application/auth_controller.dart';

class NotificationTemplatePage extends StatefulWidget {
  const NotificationTemplatePage({super.key});

  @override
  State<NotificationTemplatePage> createState() =>
      _NotificationTemplatePageState();
}

class _NotificationTemplatePageState extends State<NotificationTemplatePage> {
  ApiClient? _apiClient;
  AuthController? _authController;
  bool _loading = false;
  bool _saving = false;
  bool _previewing = false;
  String? _error;
  final List<_TemplateItem> _templates = [];
  _TemplateItem? _selectedTemplate;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _variablesController = TextEditingController();
  final TextEditingController _previewController = TextEditingController();
  bool _isActive = true;
  String? _previewResult;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _apiClient ??= context.read<ApiClient>();
    _authController ??= context.read<AuthController>();
    if (_templates.isEmpty && !_loading) {
      _loadTemplates();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    _variablesController.dispose();
    _previewController.dispose();
    super.dispose();
  }

  Future<void> _loadTemplates() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final response = await _runAuthorized(
        () => _apiClient!.get('/notification-templates/get_templates/'),
      );
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
              isActive: item['is_active'] != false,
            ));
          }
        });
      }
      setState(() {
        _templates
          ..clear()
          ..addAll(templates);
        if (_templates.isNotEmpty) {
          final currentKey = _selectedTemplate?.key;
          _TemplateItem? matched;
          if (currentKey != null) {
            for (final item in _templates) {
              if (item.key == currentKey) {
                matched = item;
                break;
              }
            }
          }
          _selectTemplate(matched ?? _templates.first);
        }
      });
    } catch (err) {
      if (err is ApiException && err.statusCode == 401) {
        setState(() => _error = '登录状态已失效，请重新登录');
      } else {
        setState(() => _error = err.toString());
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _selectTemplate(_TemplateItem item) {
    setState(() {
      _selectedTemplate = item;
      _titleController.text = item.title;
      _messageController.text = item.message;
      _variablesController.text = item.variables.join(', ');
      _previewController.text = _buildDefaultPreviewJson(item.variables);
      _isActive = item.isActive;
      _previewResult = null;
    });
  }

  String _buildDefaultPreviewJson(List<String> variables) {
    final pairs = variables
        .map((item) => '"$item": "$item-demo"')
        .join(', ');
    return '{${pairs.isEmpty ? '' : pairs}}';
  }

  Future<void> _saveTemplate() async {
    final selected = _selectedTemplate;
    if (selected == null) {
      return;
    }
    setState(() => _saving = true);
    try {
      final variables = _variablesController.text
          .split(',')
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .toList();
      await _runAuthorized(
        () => _apiClient!.post(
          '/notification-templates/update_template/',
          data: {
            'template_name': selected.key,
            'title': _titleController.text.trim(),
            'message': _messageController.text.trim(),
            'variables': variables,
            'is_active': _isActive,
          },
        ),
      );
      await _loadTemplates();
      ToastUtil.showSuccess('模板已保存');
    } catch (err) {
      _showRequestError('保存失败', err);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _previewTemplate() async {
    final selected = _selectedTemplate;
    if (selected == null) {
      return;
    }
    setState(() => _previewing = true);
    try {
      final variables = _parsePreviewVariables(_previewController.text.trim());
      final response = await _runAuthorized(
        () => _apiClient!.post(
          '/notification-templates/preview_template/',
          data: {
            'template_name': selected.key,
            'variables': variables,
          },
        ),
      );
      final data = response.data;
      if (!mounted) {
        return;
      }
      setState(() {
        _previewResult =
            '标题：${data['title'] ?? '-'}\n\n内容：${data['message'] ?? '-'}';
      });
    } catch (err) {
      _showRequestError('预览失败', err);
    } finally {
      if (mounted) setState(() => _previewing = false);
    }
  }

  Future<T> _runAuthorized<T>(Future<T> Function() action) async {
    final auth = _authController;
    if (auth != null) {
      final valid = await auth.ensureValidSession();
      if (!valid) {
        throw const ApiException(message: '登录状态已失效，请重新登录', statusCode: 401);
      }
    }
    try {
      return await action();
    } on ApiException catch (err) {
      if (err.statusCode == 401 && await (_apiClient?.refreshAccessToken() ?? Future.value(false))) {
        return action();
      }
      rethrow;
    }
  }

  Map<String, dynamic> _parsePreviewVariables(String raw) {
    final result = <String, dynamic>{};
    final trimmed = raw.replaceAll('{', '').replaceAll('}', '').trim();
    if (trimmed.isEmpty) {
      return result;
    }
    for (final entry in trimmed.split(',')) {
      final parts = entry.split(':');
      if (parts.length < 2) {
        continue;
      }
      final key = parts.first.replaceAll('"', '').trim();
      final value = parts.sublist(1).join(':').replaceAll('"', '').trim();
      if (key.isNotEmpty) {
        result[key] = value;
      }
    }
    return result;
  }

  List<String> _parseVariables(dynamic value) {
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return const [];
  }

  void _showRequestError(String prefix, Object err) {
    if (err is ApiException && err.statusCode == 401) {
      ToastUtil.showError('登录状态已失效，请重新登录');
      return;
    }
    ToastUtil.showError('$prefix: $err');
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
            Column(
              children: [
                AppDataTable(
                  columns: const [
                    DataColumn(label: Text('模板键')),
                    DataColumn(label: Text('标题')),
                    DataColumn(label: Text('内容')),
                    DataColumn(label: Text('变量')),
                    DataColumn(label: Text('状态')),
                  ],
                  rows: _templates
                      .map(
                        (item) => DataRow(
                          selected: _selectedTemplate?.key == item.key,
                          onSelectChanged: (_) => _selectTemplate(item),
                          cells: [
                            DataCell(Text(item.key)),
                            DataCell(Text(item.title)),
                            DataCell(Text(item.message)),
                            DataCell(Text(item.variables.join(', '))),
                            DataCell(Text(item.isActive ? '启用' : '停用')),
                          ],
                        ),
                      )
                      .toList(),
                ),
                SizedBox(height: spacing),
                if (_selectedTemplate != null)
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '编辑模板: ${_selectedTemplate!.key}',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: LayoutTokens.gapSm),
                        TextField(
                          controller: _titleController,
                          decoration: const InputDecoration(labelText: '标题模板'),
                        ),
                        const SizedBox(height: LayoutTokens.gapSm),
                        TextField(
                          controller: _messageController,
                          maxLines: 4,
                          decoration: const InputDecoration(labelText: '内容模板'),
                        ),
                        const SizedBox(height: LayoutTokens.gapSm),
                        TextField(
                          controller: _variablesController,
                          decoration: const InputDecoration(
                            labelText: '变量列表',
                            hintText: 'task_name, workorder_number',
                          ),
                        ),
                        const SizedBox(height: LayoutTokens.gapSm),
                        SwitchListTile(
                          value: _isActive,
                          onChanged: (value) => setState(() => _isActive = value),
                          title: const Text('启用模板'),
                          contentPadding: EdgeInsets.zero,
                        ),
                        const SizedBox(height: LayoutTokens.gapSm),
                        TextField(
                          controller: _previewController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: '预览变量',
                            hintText: '{"task_name":"打样","assigned_by":"主管"}',
                          ),
                        ),
                        const SizedBox(height: LayoutTokens.gapSm),
                        Wrap(
                          spacing: LayoutTokens.gapSm,
                          runSpacing: LayoutTokens.gapSm,
                          children: [
                            FilledButton.icon(
                              onPressed: _saving ? null : _saveTemplate,
                              icon: _saving
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Icon(Icons.save_outlined, size: 18),
                              label: Text(_saving ? '保存中' : '保存'),
                            ),
                            OutlinedButton.icon(
                              onPressed: _previewing ? null : _previewTemplate,
                              icon: _previewing
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Icon(Icons.visibility_outlined, size: 18),
                              label: Text(_previewing ? '预览中' : '预览'),
                            ),
                          ],
                        ),
                        if (_previewResult != null) ...[
                          const SizedBox(height: LayoutTokens.gapSm),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(LayoutTokens.gapSm),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(_previewResult!),
                          ),
                        ],
                      ],
                    ),
                  ),
              ],
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
    required this.isActive,
  });

  final String key;
  final String title;
  final String message;
  final List<String> variables;
  final bool isActive;
}
