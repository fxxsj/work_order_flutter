import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/data/generic_repository.dart';
import 'package:work_order_app/src/core/models/generic_record.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/dialogs.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/generic_resource_list_page.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/core/viewmodels/generic_list_view_model.dart';
import 'package:work_order_app/src/features/finance_costs/domain/cost_center_form_options.dart';
import 'package:work_order_app/src/features/finance_costs/domain/cost_center_options_repository.dart';

class CostCenterListPage extends StatelessWidget {
  const CostCenterListPage({super.key});

  static const String _listRoute = '/finance/cost-centers';

  @override
  Widget build(BuildContext context) {
    return GenericResourceListEntry(
      config: GenericResourceConfig(
        id: 'cost_centers',
        title: '成本中心',
        endpoint: '/cost-centers/',
        searchHintText: '搜索成本中心名称/编码',
        emptyText: '暂无成本中心',
        emptyIcon: Icons.account_tree_outlined,
        openDetailsOnPrimaryTap: true,
        columns: const [
          GenericColumn(label: '编码', value: _code),
          GenericColumn(label: '名称', value: _name),
          GenericColumn(label: '类型', value: _type),
          GenericColumn(label: '负责人', value: _manager),
          GenericColumn(label: '上级', value: _parent),
          GenericColumn(label: '启用', value: _active),
        ],
        summaryFields: const [
          GenericSummaryField(label: '类型', value: _type),
          GenericSummaryField(label: '负责人', value: _manager),
          GenericSummaryField(label: '上级', value: _parent),
          GenericSummaryField(label: '启用', value: _active),
        ],
        titleBuilder: _name,
        extraParamsBuilder: _extraParamsBuilder,
        headerActionsBuilder: _buildHeaderActions,
        rowActionsBuilder: (context, record, openDetails) => [
          RowAction(label: '查看', onPressed: openDetails),
          RowAction(
            label: '编辑',
            icon: Icons.edit_outlined,
            onPressed: () => _openForm(context, record: record),
          ),
          if ((record.getNumber('children_count') ?? 0) == 0)
            RowAction(
              label: '删除',
              icon: Icons.delete_outline,
              onPressed: () => _deleteCostCenter(context, record),
            ),
        ],
      ),
    );
  }

  static String _code(GenericRecord record) {
    return AppValueFormatter.text(record.getString('code'));
  }

  static String _name(GenericRecord record) {
    return AppValueFormatter.text(record.getString('name'));
  }

  static String _type(GenericRecord record) {
    return AppValueFormatter.text(
      record.getString('type_display') ?? _typeLabel(record.getString('type')),
    );
  }

  static String _manager(GenericRecord record) {
    return AppValueFormatter.text(record.getString('manager_name'));
  }

  static String _parent(GenericRecord record) {
    return AppValueFormatter.text(record.getString('parent_name'));
  }

  static String _active(GenericRecord record) {
    return AppValueFormatter.boolText(record.getBool('is_active'));
  }

  static Map<String, dynamic> _extraParamsBuilder(Uri uri) {
    final extraParams = <String, dynamic>{};
    final type = uri.queryParameters['type']?.trim() ?? '';
    if (type.isNotEmpty) {
      extraParams['type'] = type;
    }
    final isActive = uri.queryParameters['is_active']?.trim() ?? '';
    if (isActive.isNotEmpty) {
      extraParams['is_active'] = isActive;
    }
    final ordering = uri.queryParameters['ordering']?.trim() ?? '';
    extraParams['ordering'] = ordering.isEmpty ? 'code' : ordering;
    return extraParams;
  }

  static List<Widget> _buildHeaderActions(
    BuildContext context,
    GenericListViewModel viewModel,
  ) {
    return [
      if (_hasActiveFilter(viewModel))
        OutlinedButton.icon(
          onPressed: () => context.go(_listRoute),
          icon: const Icon(Icons.filter_alt_off_outlined, size: 16),
          label: const Text('清除筛选'),
        ),
      SizedBox(
        width: 150,
        child: AppSelect<String>(
          key: ValueKey<String>(_currentType(viewModel)),
          value: _currentType(viewModel).isEmpty
              ? null
              : _currentType(viewModel),
          selectHintText: '类型',
          options: const [
            AppDropdownOption<String>(value: '', label: '全部类型'),
            AppDropdownOption<String>(value: 'production', label: '生产部门'),
            AppDropdownOption<String>(value: 'auxiliary', label: '辅助部门'),
            AppDropdownOption<String>(value: 'management', label: '管理部门'),
            AppDropdownOption<String>(value: 'sales', label: '销售部门'),
          ],
          onChanged: (value) =>
              _openFilter(context, viewModel, type: value ?? ''),
        ),
      ),
      SizedBox(
        width: 140,
        child: AppSelect<String>(
          key: ValueKey<String>(_currentActive(viewModel)),
          value: _currentActive(viewModel).isEmpty
              ? null
              : _currentActive(viewModel),
          selectHintText: '状态',
          options: const [
            AppDropdownOption<String>(value: '', label: '全部状态'),
            AppDropdownOption<String>(value: 'true', label: '启用'),
            AppDropdownOption<String>(value: 'false', label: '禁用'),
          ],
          onChanged: (value) =>
              _openFilter(context, viewModel, isActive: value ?? ''),
        ),
      ),
      SizedBox(
        width: 160,
        child: AppSelect<String>(
          key: ValueKey<String>(_currentOrdering(viewModel)),
          value: _currentOrdering(viewModel),
          selectHintText: '排序',
          options: const [
            AppDropdownOption<String>(value: 'code', label: '编码升序'),
            AppDropdownOption<String>(value: '-code', label: '编码降序'),
            AppDropdownOption<String>(value: 'name', label: '名称升序'),
            AppDropdownOption<String>(value: '-name', label: '名称降序'),
            AppDropdownOption<String>(value: 'type', label: '类型升序'),
            AppDropdownOption<String>(value: '-type', label: '类型降序'),
            AppDropdownOption<String>(value: 'parent__name', label: '上级升序'),
            AppDropdownOption<String>(value: '-parent__name', label: '上级降序'),
            AppDropdownOption<String>(
              value: 'manager__username',
              label: '负责人升序',
            ),
            AppDropdownOption<String>(
              value: '-manager__username',
              label: '负责人降序',
            ),
          ],
          onChanged: (value) =>
              _openFilter(context, viewModel, ordering: value ?? 'code'),
        ),
      ),
      PageActionButton.filled(
        onPressed: () => _openForm(context),
        icon: const Icon(Icons.add),
        label: '新建成本中心',
      ),
    ];
  }

  static String _currentType(GenericListViewModel viewModel) {
    return viewModel.extraParams['type']?.toString().trim() ?? '';
  }

  static String _currentActive(GenericListViewModel viewModel) {
    return viewModel.extraParams['is_active']?.toString().trim() ?? '';
  }

  static String _currentOrdering(GenericListViewModel viewModel) {
    final value = viewModel.extraParams['ordering']?.toString().trim() ?? '';
    return value.isEmpty ? 'code' : value;
  }

  static bool _hasActiveFilter(GenericListViewModel viewModel) {
    return _currentType(viewModel).isNotEmpty ||
        _currentActive(viewModel).isNotEmpty ||
        _currentOrdering(viewModel) != 'code';
  }

  static void _openFilter(
    BuildContext context,
    GenericListViewModel viewModel, {
    String? type,
    String? isActive,
    String? ordering,
  }) {
    final query = <String, String>{};
    final search = viewModel.searchText.trim();
    if (search.isNotEmpty) {
      query['search'] = search;
    }
    final nextType = type ?? _currentType(viewModel);
    if (nextType.trim().isNotEmpty) {
      query['type'] = nextType.trim();
    }
    final nextActive = isActive ?? _currentActive(viewModel);
    if (nextActive.trim().isNotEmpty) {
      query['is_active'] = nextActive.trim();
    }
    final nextOrdering = ordering ?? _currentOrdering(viewModel);
    if (nextOrdering.trim().isNotEmpty && nextOrdering != 'code') {
      query['ordering'] = nextOrdering.trim();
    }
    context.go(Uri(path: _listRoute, queryParameters: query).toString());
  }

  static Future<void> _openForm(
    BuildContext context, {
    GenericRecord? record,
  }) async {
    final formKey = GlobalKey<FormState>();
    final repository = context.read<GenericRepository>();
    final codeController = TextEditingController(
      text: record?.getString('code') ?? '',
    );
    final nameController = TextEditingController(
      text: record?.getString('name') ?? '',
    );
    final descriptionController = TextEditingController(
      text: record?.getString('description') ?? '',
    );
    final options = await _loadFormOptions(context, record);
    var parentId = record?.getNumber('parent')?.toInt();
    var managerId = record?.getNumber('manager')?.toInt();
    var type = record?.getString('type') ?? 'production';
    var isActive = record?.getBool('is_active') ?? true;
    var submitting = false;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AppFormDialog(
          title: record == null ? '新建成本中心' : '编辑成本中心',
          formKey: formKey,
          submitting: submitting,
          submitText: '保存',
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: codeController,
                decoration: const InputDecoration(labelText: '编码'),
                validator: _codeValidator,
              ),
              SpacingTokens.vMd,
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: '名称'),
                validator: _nameValidator,
              ),
              SpacingTokens.vMd,
              AppSelect<String>(
                key: ValueKey<String>(type),
                value: type,
                decoration: const InputDecoration(labelText: '类型'),
                options: const [
                  AppDropdownOption(value: 'production', label: '生产部门'),
                  AppDropdownOption(value: 'auxiliary', label: '辅助部门'),
                  AppDropdownOption(value: 'management', label: '管理部门'),
                  AppDropdownOption(value: 'sales', label: '销售部门'),
                ],
                onChanged: submitting
                    ? null
                    : (value) =>
                          setDialogState(() => type = value ?? 'production'),
              ),
              SpacingTokens.vMd,
              AppSelect<int?>(
                key: ValueKey<int?>(parentId),
                value: parentId,
                decoration: const InputDecoration(labelText: '上级成本中心'),
                options: options.parents
                    .map(
                      (item) => AppDropdownOption<int?>(
                        value: item.id,
                        label: item.label,
                      ),
                    )
                    .toList(),
                onChanged: submitting
                    ? null
                    : (value) => setDialogState(() => parentId = value),
              ),
              SpacingTokens.vMd,
              AppSelect<int?>(
                key: ValueKey<int?>(managerId),
                value: managerId,
                decoration: const InputDecoration(labelText: '负责人'),
                options: options.managers
                    .map(
                      (item) => AppDropdownOption<int?>(
                        value: item.id,
                        label: item.label,
                      ),
                    )
                    .toList(),
                onChanged: submitting
                    ? null
                    : (value) => setDialogState(() => managerId = value),
              ),
              SpacingTokens.vMd,
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('启用'),
                value: isActive,
                onChanged: submitting
                    ? null
                    : (value) => setDialogState(() => isActive = value),
              ),
              SpacingTokens.vMd,
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: '描述'),
                minLines: 2,
                maxLines: 4,
              ),
            ],
          ),
          onSubmit: () async {
            if (!(formKey.currentState?.validate() ?? false)) return;
            setDialogState(() => submitting = true);
            try {
              final payload = {
                'code': codeController.text.trim(),
                'name': nameController.text.trim(),
                'type': type,
                'parent': parentId,
                'manager': managerId,
                'is_active': isActive,
                'description': descriptionController.text.trim(),
              };
              if (record == null) {
                await repository.createRecord(payload);
              } else {
                await repository.updateRecord(record.id, payload);
              }
              if (!context.mounted) return;
              context.read<GenericListViewModel>().reload(resetPage: true);
              Navigator.of(dialogContext).pop();
              ToastUtil.showSuccess(record == null ? '已创建' : '已更新');
            } catch (err) {
              ToastUtil.showError('保存失败: $err');
            } finally {
              if (dialogContext.mounted) {
                setDialogState(() => submitting = false);
              }
            }
          },
        ),
      ),
    );

    codeController.dispose();
    nameController.dispose();
    descriptionController.dispose();
  }

  static Future<CostCenterFormOptions> _loadFormOptions(
    BuildContext context,
    GenericRecord? record,
  ) {
    return context.read<CostCenterOptionsRepository>().loadOptions(
          currentRecord: record,
        );
  }

  static Future<void> _deleteCostCenter(
    BuildContext context,
    GenericRecord record,
  ) async {
    final repository = context.read<GenericRepository>();
    try {
      await repository.deleteRecord(record.id);
      if (!context.mounted) return;
      context.read<GenericListViewModel>().reload(resetPage: true);
      ToastUtil.showSuccess('已删除');
    } catch (err) {
      ToastUtil.showError('删除失败: $err');
    }
  }

  static String? _codeValidator(String? value) {
    final text = value?.trim() ?? '';
    if (text.length < 2 || text.length > 50) {
      return '编码长度必须为 2-50';
    }
    return null;
  }

  static String? _nameValidator(String? value) {
    final text = value?.trim() ?? '';
    if (text.length < 2 || text.length > 100) {
      return '名称长度必须为 2-100';
    }
    return null;
  }

  static String _typeLabel(String? value) {
    switch (value) {
      case 'production':
        return '生产部门';
      case 'auxiliary':
        return '辅助部门';
      case 'management':
        return '管理部门';
      case 'sales':
        return '销售部门';
      default:
        return value ?? '';
    }
  }
}
