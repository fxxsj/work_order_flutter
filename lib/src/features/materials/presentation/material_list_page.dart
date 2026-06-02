import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_list_page.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/utils/permission_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/materials/application/material_view_model.dart';
import 'package:work_order_app/src/features/materials/domain/material.dart';
import 'package:work_order_app/src/features/materials/presentation/material_edit_page.dart';

/// 物料列表页视图，只负责渲染。
class MaterialListPage extends StatelessWidget {
  const MaterialListPage({super.key});

  static const CrudDeleteConfig<MaterialItem> _deleteConfig = CrudDeleteConfig(
    title: '确认删除',
    summaryBuilder: _buildDeleteSummary,
    impactsBuilder: _buildDeleteImpacts,
    auditHintBuilder: _buildDeleteAuditHint,
    confirmText: '确认删除',
    errorMessagePrefix: '删除失败: ',
  );

  static const CrudListConfig<MaterialItem, MaterialViewModel> _config =
      CrudListConfig(
        searchHintText: '搜索物料名称/编码',
        emptyText: '暂无物料数据',
        emptyIcon: Icons.category_outlined,
        loadItems: _loadMaterials,
        titleBuilder: _titleText,
        subtitleBuilder: _subtitleText,
        summaryChipsBuilder: _summaryChips,
        summaryFieldsBuilder: _summaryFields,
        headerActionsBuilder: _headerActions,
        rowActionsBuilder: _rowActions,
        columns: [
          CrudTableColumn(label: '物料', cellBuilder: _buildNameCell),
          CrudTableColumn(label: '编码', cellBuilder: _buildCodeCell),
          CrudTableColumn(label: '单位', cellBuilder: _buildUnitCell),
          CrudTableColumn(label: '单价', cellBuilder: _buildPriceCell),
          CrudTableColumn(label: '库存', cellBuilder: _buildStockCell),
          CrudTableColumn(label: '安全库存', cellBuilder: _buildMinStockCell),
          CrudTableColumn(label: '状态', cellBuilder: _buildStatusCell),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return const CrudListPage<MaterialItem, MaterialViewModel>(config: _config);
  }

  static Future<void> _loadMaterials(
    MaterialViewModel viewModel, {
    bool resetPage = false,
  }) {
    return viewModel.loadMaterials(resetPage: resetPage);
  }

  static Future<void> _openEditPage(
    BuildContext context,
    MaterialViewModel viewModel,
    MaterialItem? material,
  ) async {
    final result = await showMaterialEditDrawer(
      context,
      viewModel: viewModel,
      material: material,
    );
    if (result) {
      ToastUtil.showSuccess(material == null ? '创建成功' : '更新成功');
    }
  }

  static Future<void> _confirmDelete(
    BuildContext context,
    MaterialViewModel viewModel,
    MaterialItem material,
  ) {
    return confirmCrudDeletion(
      context,
      item: material,
      onDelete: (item) => viewModel.deleteMaterial(item.id),
      config: _deleteConfig,
    );
  }

  static List<Widget> _headerActions(
    BuildContext context,
    MaterialViewModel viewModel,
  ) {
    final permissions = PermissionUtil.snapshot(context);
    final canChangeMaterial = permissions.has('workorder.change_material');

    return [
      SizedBox(
        width: 120,
        child: AppSelect<bool?>(
          options: const [
            AppDropdownOption(value: null, label: '全部状态'),
            AppDropdownOption(value: true, label: '启用'),
            AppDropdownOption(value: false, label: '停用'),
          ],
          value: viewModel.isActiveFilter,
          onChanged: (value) => viewModel.setIsActiveFilter(value),
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(),
          ),
        ),
      ),
      const SizedBox(width: 8),
      SizedBox(
        width: 120,
        child: AppSelect<String>(
          options: const [
            AppDropdownOption(value: 'code', label: '编码升序'),
            AppDropdownOption(value: '-code', label: '编码降序'),
            AppDropdownOption(value: 'name', label: '名称升序'),
            AppDropdownOption(value: '-name', label: '名称降序'),
            AppDropdownOption(value: 'stock_quantity', label: '库存升序'),
            AppDropdownOption(value: '-stock_quantity', label: '库存降序'),
          ],
          value: viewModel.ordering ?? 'code',
          onChanged: (value) {
            if (value != null) viewModel.setOrdering(value);
          },
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(),
          ),
        ),
      ),
      const SizedBox(width: 8),
      if (canChangeMaterial)
        PageActionButton.outlined(
          onPressed: () => _handleExport(context, viewModel),
          icon: const Icon(Icons.download),
          label: '导出',
        ),
      PageActionButton.outlined(
        onPressed: () => _handleImport(context, viewModel),
        icon: const Icon(Icons.upload),
        label: '导入',
      ),
      if (canChangeMaterial)
        PageActionButton.filled(
          onPressed: () => _openEditPage(context, viewModel, null),
          icon: const Icon(Icons.add),
          label: '新建物料',
        ),
    ];
  }

  static Future<void> _handleExport(
    BuildContext context,
    MaterialViewModel viewModel,
  ) async {
    try {
      await viewModel.exportMaterials();
      if (context.mounted) {
        ToastUtil.showSuccess('导出成功');
      }
    } catch (err) {
      if (context.mounted) {
        ToastUtil.showError('导出失败: $err');
      }
    }
  }

  static Future<void> _handleImport(
    BuildContext context,
    MaterialViewModel viewModel,
  ) async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );
    if (result == null || result.files.isEmpty) {
      return;
    }
    final file = result.files.first;
    if (file.bytes == null) {
      if (context.mounted) {
        ToastUtil.showError('无法读取文件');
      }
      return;
    }
    try {
      final importResult = await viewModel.importMaterials(file);
      if (context.mounted) {
        final created = importResult.createdCount ?? 0;
        final updated = importResult.updatedCount ?? 0;
        if (importResult.errorCount == 0) {
          ToastUtil.showSuccess('导入成功: 新增 $created 条, 更新 $updated 条');
        } else {
          ToastUtil.showError(
            '导入完成: 新增 $created 条, 更新 $updated 条, 失败 ${importResult.errorCount} 条',
          );
        }
      }
    } catch (err) {
      if (context.mounted) {
        ToastUtil.showError('导入失败: $err');
      }
    }
  }

  static List<RowAction> _rowActions(
    BuildContext context,
    MaterialViewModel viewModel,
    MaterialItem material,
  ) {
    final permissions = PermissionUtil.snapshot(context);
    final canChangeMaterial = permissions.has('workorder.change_material');
    final canDeleteMaterial = permissions.has('workorder.delete_material');

    return [
      if (canChangeMaterial)
        RowAction(
          label: '编辑',
          onPressed: () => _openEditPage(context, viewModel, material),
        ),
      if (canDeleteMaterial)
        RowAction(
          label: '删除',
          onPressed: () => _confirmDelete(context, viewModel, material),
          destructive: true,
        ),
    ];
  }

  static Widget _buildNameCell(BuildContext context, MaterialItem material) {
    return Text(
      _titleText(material),
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  static Widget _buildCodeCell(BuildContext context, MaterialItem material) {
    return _buildBodyText(context, AppValueFormatter.text(material.code));
  }

  static Widget _buildUnitCell(BuildContext context, MaterialItem material) {
    return _buildBodyText(context, AppValueFormatter.text(material.unit));
  }

  static Widget _buildPriceCell(BuildContext context, MaterialItem material) {
    return _buildBodyText(
      context,
      AppValueFormatter.amount(material.unitPrice),
    );
  }

  static Widget _buildStockCell(BuildContext context, MaterialItem material) {
    return _buildBodyText(
      context,
      AppValueFormatter.amount(material.stockQuantity),
    );
  }

  static Widget _buildMinStockCell(
    BuildContext context,
    MaterialItem material,
  ) {
    return _buildBodyText(
      context,
      AppValueFormatter.amount(material.minStockQuantity),
    );
  }

  static Widget _buildStatusCell(BuildContext context, MaterialItem material) {
    return _buildBodyText(context, _statusText(material));
  }

  static Widget _buildBodyText(BuildContext context, String value) {
    return Text(value, style: Theme.of(context).textTheme.bodySmall);
  }

  static String _titleText(MaterialItem material) {
    return AppValueFormatter.text(material.name);
  }

  static String _subtitleText(MaterialItem material) {
    return '${AppValueFormatter.text(material.code)} · '
        '${AppValueFormatter.text(material.unit)}';
  }

  static String _statusText(MaterialItem material) {
    final isActive = material.isActive;
    if (isActive == null) {
      return AppValueFormatter.empty;
    }
    return isActive ? '启用' : '停用';
  }

  static List<CrudSummaryChipData> _summaryChips(MaterialItem material) {
    return [
      CrudSummaryChipData(label: '状态', value: _statusText(material)),
      CrudSummaryChipData(
        label: '库存',
        value: AppValueFormatter.amount(material.stockQuantity),
      ),
      CrudSummaryChipData(
        label: '安全库存',
        value: AppValueFormatter.amount(material.minStockQuantity),
      ),
    ];
  }

  static List<CrudSummaryFieldData> _summaryFields(MaterialItem material) {
    return [
      CrudSummaryFieldData(
        label: '物料编码',
        value: AppValueFormatter.text(material.code),
      ),
      CrudSummaryFieldData(
        label: '单位',
        value: AppValueFormatter.text(material.unit),
      ),
      CrudSummaryFieldData(
        label: '单价',
        value: AppValueFormatter.amount(material.unitPrice),
      ),
      CrudSummaryFieldData(
        label: '库存',
        value: AppValueFormatter.amount(material.stockQuantity),
      ),
      CrudSummaryFieldData(
        label: '安全库存',
        value: AppValueFormatter.amount(material.minStockQuantity),
      ),
      CrudSummaryFieldData(label: '状态', value: _statusText(material)),
    ];
  }

  static String _buildDeleteSummary(MaterialItem material) {
    return '即将删除物料 ${_titleText(material)}。删除后，采购、库存和产品用料关联可能受到影响。';
  }

  static List<String> _buildDeleteImpacts(MaterialItem material) {
    return [
      '物料编码：${AppValueFormatter.text(material.code)}',
      '单位：${AppValueFormatter.text(material.unit)}',
      '当前库存：${AppValueFormatter.amount(material.stockQuantity)}',
      '若已有采购记录、库存流水或产品用料引用，删除可能失败或需要先解除关联',
    ];
  }

  static String _buildDeleteAuditHint(MaterialItem material) {
    return '如果只是停止使用该物料，优先考虑停用或清理库存后保留档案，而不是直接删除。';
  }
}
