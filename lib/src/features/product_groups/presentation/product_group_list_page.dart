import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_list_page.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/product_groups/application/product_group_view_model.dart';
import 'package:work_order_app/src/features/product_groups/domain/product_group.dart';
import 'package:work_order_app/src/features/product_groups/presentation/product_group_edit_page.dart';

/// 产品组列表页视图，只负责渲染。
class ProductGroupListPage extends StatelessWidget {
  const ProductGroupListPage({super.key});

  static const CrudDeleteConfig<ProductGroup> _deleteConfig = CrudDeleteConfig(
    title: '确认删除',
    summaryBuilder: _buildDeleteSummary,
    impactsBuilder: _buildDeleteImpacts,
    auditHintBuilder: _buildDeleteAuditHint,
    confirmText: '确认删除',
    errorMessagePrefix: '删除失败: ',
  );

  static const CrudListConfig<ProductGroup, ProductGroupViewModel> _config =
      CrudListConfig(
        searchHintText: '搜索产品组名称/编码',
        emptyText: '暂无产品组数据',
        emptyIcon: Icons.group_work_outlined,
        loadItems: _loadProductGroups,
        titleBuilder: _titleText,
        subtitleBuilder: _subtitleText,
        summaryChipsBuilder: _summaryChips,
        summaryFieldsBuilder: _summaryFields,
        headerActionsBuilder: _headerActions,
        rowActionsBuilder: _rowActions,
        columns: [
          CrudTableColumn(label: '产品组', cellBuilder: _buildNameCell),
          CrudTableColumn(label: '编码', cellBuilder: _buildCodeCell),
          CrudTableColumn(label: '状态', cellBuilder: _buildStatusCell),
          CrudTableColumn(label: '明细数', cellBuilder: _buildItemsCountCell),
          CrudTableColumn(label: '描述', cellBuilder: _buildDescriptionCell),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return const CrudListPage<ProductGroup, ProductGroupViewModel>(
      config: _config,
    );
  }

  static Future<void> _loadProductGroups(
    ProductGroupViewModel viewModel, {
    bool resetPage = false,
  }) {
    return viewModel.loadProductGroups(resetPage: resetPage);
  }

  static Future<void> _openEditPage(
    BuildContext context,
    ProductGroupViewModel viewModel,
    ProductGroup? group,
  ) async {
    final result = await showProductGroupEditDrawer(
      context,
      viewModel: viewModel,
      group: group,
    );
    if (result) {
      ToastUtil.showSuccess(group == null ? '创建成功' : '更新成功');
    }
  }

  static Future<void> _confirmDelete(
    BuildContext context,
    ProductGroupViewModel viewModel,
    ProductGroup group,
  ) {
    return confirmCrudDeletion(
      context,
      item: group,
      onDelete: (item) => viewModel.deleteProductGroup(item.id),
      config: _deleteConfig,
    );
  }

  static List<Widget> _headerActions(
    BuildContext context,
    ProductGroupViewModel viewModel,
  ) {
    return [
      SizedBox(
        width: 112,
        child: AppSelect<String>(
          options: const [
            AppDropdownOption(value: '', label: '全部状态'),
            AppDropdownOption(value: 'true', label: '启用'),
            AppDropdownOption(value: 'false', label: '停用'),
          ],
          value: viewModel.isActive == null
              ? ''
              : viewModel.isActive == true
              ? 'true'
              : 'false',
          onChanged: (value) {
            if (value == null || value.isEmpty) {
              viewModel.setIsActive(null);
            } else {
              viewModel.setIsActive(value == 'true');
            }
          },
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(),
          ),
        ),
      ),
      const SizedBox(width: 8),
      SizedBox(
        width: 132,
        child: AppSelect<String>(
          options: const [
            AppDropdownOption(value: 'code', label: '编码升序'),
            AppDropdownOption(value: '-code', label: '编码降序'),
            AppDropdownOption(value: 'name', label: '名称升序'),
            AppDropdownOption(value: '-name', label: '名称降序'),
            AppDropdownOption(value: '-created_at', label: '最新创建'),
            AppDropdownOption(value: 'created_at', label: '最早创建'),
            AppDropdownOption(value: 'is_active', label: '状态升序'),
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
      PageActionButton.filled(
        onPressed: () => _openEditPage(context, viewModel, null),
        icon: const Icon(Icons.add),
        label: '新建产品组',
      ),
    ];
  }

  static List<RowAction> _rowActions(
    BuildContext context,
    ProductGroupViewModel viewModel,
    ProductGroup group,
  ) {
    return [
      RowAction(
        label: '编辑',
        onPressed: () => _openEditPage(context, viewModel, group),
      ),
      RowAction(
        label: '删除',
        onPressed: () => _confirmDelete(context, viewModel, group),
        destructive: true,
      ),
    ];
  }

  static Widget _buildNameCell(BuildContext context, ProductGroup group) {
    return Text(
      _titleText(group),
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  static Widget _buildCodeCell(BuildContext context, ProductGroup group) {
    return _buildBodyText(context, AppValueFormatter.text(group.code));
  }

  static Widget _buildStatusCell(BuildContext context, ProductGroup group) {
    return _buildBodyText(context, _statusText(group));
  }

  static Widget _buildItemsCountCell(BuildContext context, ProductGroup group) {
    return _buildBodyText(context, AppValueFormatter.number(group.itemsCount));
  }

  static Widget _buildDescriptionCell(
    BuildContext context,
    ProductGroup group,
  ) {
    return _buildBodyText(context, AppValueFormatter.text(group.description));
  }

  static Widget _buildBodyText(BuildContext context, String value) {
    return Text(value, style: Theme.of(context).textTheme.bodySmall);
  }

  static String _titleText(ProductGroup group) {
    return AppValueFormatter.text(group.name);
  }

  static String _subtitleText(ProductGroup group) {
    return AppValueFormatter.text(group.code);
  }

  static String _statusText(ProductGroup group) {
    final isActive = group.isActive;
    if (isActive == null) {
      return AppValueFormatter.empty;
    }
    return isActive ? '启用' : '停用';
  }

  static List<CrudSummaryChipData> _summaryChips(ProductGroup group) {
    return [
      CrudSummaryChipData(label: '状态', value: _statusText(group)),
      CrudSummaryChipData(
        label: '明细数',
        value: AppValueFormatter.number(group.itemsCount),
      ),
    ];
  }

  static List<CrudSummaryFieldData> _summaryFields(ProductGroup group) {
    return [
      CrudSummaryFieldData(
        label: '编码',
        value: AppValueFormatter.text(group.code),
      ),
      CrudSummaryFieldData(label: '状态', value: _statusText(group)),
      CrudSummaryFieldData(
        label: '明细数',
        value: AppValueFormatter.number(group.itemsCount),
      ),
      CrudSummaryFieldData(
        label: '描述',
        value: AppValueFormatter.text(group.description),
      ),
      CrudSummaryFieldData(
        label: '创建时间',
        value: AppValueFormatter.dateTime(group.createdAt),
      ),
      CrudSummaryFieldData(
        label: '更新时间',
        value: AppValueFormatter.dateTime(group.updatedAt),
      ),
    ];
  }

  static String _buildDeleteSummary(ProductGroup group) {
    return '即将删除产品组 ${_titleText(group)}。删除后，关联产品的分组信息可能需要重新整理。';
  }

  static List<String> _buildDeleteImpacts(ProductGroup group) {
    return [
      '产品组编码：${AppValueFormatter.text(group.code)}',
      if ((group.itemsCount ?? 0) > 0)
        '当前组内有 ${group.itemsCount} 个产品明细，删除前建议先处理归类关系',
    ];
  }

  static String _buildDeleteAuditHint(ProductGroup group) {
    return '如果只是临时停用该分组，优先考虑停用状态，而不是直接删除。';
  }
}
