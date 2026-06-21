import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/api_exception.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/features/notification_admin/domain/notification_admin_repository.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_data_table.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/auth/application/auth_controller.dart';
import 'package:work_order_app/src/features/notification_admin/presentation/widgets/notification_admin_widgets.dart';

class NotificationTemplatePage extends StatefulWidget {
  const NotificationTemplatePage({super.key});

  @override
  State<NotificationTemplatePage> createState() =>
      _NotificationTemplatePageState();
}

class _NotificationTemplatePageState extends State<NotificationTemplatePage> {
  NotificationAdminRepository? _repository;
  AuthController? _authController;
  bool _loading = false;
  bool _saving = false;
  bool _previewing = false;
  String? _error;
  final List<_TemplateItem> _templates = [];
  _TemplateItem? _selectedTemplate;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _previewController = TextEditingController();
  bool _isActive = true;
  String? _previewResult;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _repository ??= context.read<NotificationAdminRepository>();
    _authController ??= context.read<AuthController>();
    if (_templates.isEmpty && !_loading) {
      _loadTemplates();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    _previewController.dispose();
    super.dispose();
  }

  Future<void> _loadTemplates() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await _runAuthorized(
        () => _repository!.getTemplates(),
      );
      final templates = <_TemplateItem>[];
      data.forEach((key, value) {
        if (value is Map) {
          final item = Map<String, dynamic>.from(value);
          templates.add(
            _TemplateItem(
              key: key,
              title: item['title']?.toString() ?? '-',
              message: item['message']?.toString() ?? '-',
              variables: _parseVariables(item['variables']),
              isActive: item['is_active'] != false,
            ),
          );
        }
      });
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
      _previewController.text = _buildDefaultPreviewJson(item.variables);
      _isActive = item.isActive;
      _previewResult = null;
    });
  }

  String _buildDefaultPreviewJson(List<String> variables) {
    final pairs = variables.map((item) => '"$item": "$item-demo"').join(', ');
    return '{${pairs.isEmpty ? '' : pairs}}';
  }

  Future<void> _saveTemplate() async {
    final selected = _selectedTemplate;
    if (selected == null) {
      return;
    }
    setState(() => _saving = true);
    try {
      await _runAuthorized(
        () => _repository!.updateTemplate(
          templateName: selected.key,
          title: _titleController.text.trim(),
          message: _messageController.text.trim(),
          variables: selected.variables,
          isActive: _isActive,
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
      final data = await _runAuthorized(
        () => _repository!.previewTemplate(
          templateName: selected.key,
          variables: variables,
        ),
      );
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
    return await action();
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
          NotificationAdminSection(
            title: '通知模板',
            trailing: OutlinedButton.icon(
              onPressed: _loading ? null : _loadTemplates,
              icon: NotificationLoadingIcon(
                loading: _loading,
                icon: Icons.refresh,
              ),
              label: Text(_loading ? '刷新中' : '刷新'),
            ),
            child: Text(
              '模板用于渲染任务分配、工序完成、交期预警和系统公告等自动通知。变量由系统事件提供，不建议手动修改变量名称。',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          SizedBox(height: spacing),
          if (_error != null)
            AppCard(child: Text('加载失败: $_error'))
          else if (_loading && _templates.isEmpty)
            const Center(child: CircularProgressIndicator())
          else if (_templates.isEmpty)
            AppCard(child: const Text('暂无模板数据'))
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
                  NotificationAdminSection(
                    title: '编辑模板: ${_selectedTemplate!.key}',
                    child: NotificationFieldList(
                      children: [
                        TextField(
                          controller: _titleController,
                          decoration: const InputDecoration(labelText: '标题模板'),
                        ),
                        TextField(
                          controller: _messageController,
                          maxLines: 4,
                          decoration: const InputDecoration(labelText: '内容模板'),
                        ),
                        _TemplateVariableChips(
                          variables: _selectedTemplate!.variables,
                        ),
                        SwitchListTile(
                          value: _isActive,
                          onChanged: (value) =>
                              setState(() => _isActive = value),
                          title: const Text('启用模板'),
                          contentPadding: EdgeInsets.zero,
                        ),
                        TextField(
                          controller: _previewController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: '预览变量',
                            hintText: '{"task_name":"打样","assigned_by":"主管"}',
                          ),
                        ),
                        Wrap(
                          spacing: SpacingTokens.sm,
                          runSpacing: SpacingTokens.sm,
                          children: [
                            FilledButton.icon(
                              onPressed: _saving ? null : _saveTemplate,
                              icon: NotificationLoadingIcon(
                                loading: _saving,
                                icon: Icons.save_outlined,
                              ),
                              label: Text(_saving ? '保存中' : '保存'),
                            ),
                            OutlinedButton.icon(
                              onPressed: _previewing ? null : _previewTemplate,
                              icon: NotificationLoadingIcon(
                                loading: _previewing,
                                icon: Icons.visibility_outlined,
                              ),
                              label: Text(_previewing ? '预览中' : '预览'),
                            ),
                          ],
                        ),
                        if (_previewResult != null) ...[
                          const SizedBox(height: SpacingTokens.sm),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(SpacingTokens.sm),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                              borderRadius: RadiusTokens.bMd,
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

class _TemplateVariableChips extends StatelessWidget {
  const _TemplateVariableChips({required this.variables});

  final List<String> variables;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '可用变量',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: SpacingTokens.sm),
        if (variables.isEmpty)
          Text('该模板暂无变量', style: theme.textTheme.bodySmall)
        else
          Wrap(
            spacing: SpacingTokens.sm,
            runSpacing: SpacingTokens.sm,
            children: [
              for (final variable in variables)
                Chip(label: Text('{$variable}')),
            ],
          ),
      ],
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
