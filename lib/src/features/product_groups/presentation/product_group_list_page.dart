import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_list_page.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/product_groups/application/product_group_view_model.dart';
import 'package:work_order_app/src/features/product_groups/data/product_group_api_service.dart';
import 'package:work_order_app/src/features/product_groups/data/product_group_repository_impl.dart';
import 'package:work_order_app/src/features/product_groups/domain/product_group.dart';
import 'package:work_order_app/src/features/product_groups/domain/product_group_repository.dart';
import 'package:work_order_app/src/features/product_groups/presentation/product_group_edit_page.dart';

/// 产品组列表入口，负责创建并缓存依赖，避免页面重建时重复初始化。
class ProductGroupListEntry extends StatelessWidget {
  const ProductGroupListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureEntry<ProductGroupApiService, ProductGroupRepository,
        ProductGroupViewModel>(
      createService: (context) =>
          ProductGroupApiService(context.read<ApiClient>()),
      createRepository: (context) =>
          ProductGroupRepositoryImpl(context.read<ProductGroupApiService>()),
      createViewModel: (context) =>
          ProductGroupViewModel(context.read<ProductGroupRepository>()),
      initialize: (viewModel) => viewModel.initialize(),
      child: const ProductGroupListPage(),
    );
  }
}

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
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: viewModel,
          child: ProductGroupEditPage(group: group),
        ),
      ),
    );
    if (result == true) {
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
    return _buildBodyText(context, CrudValueFormatter.text(group.code));
  }

  static Widget _buildStatusCell(BuildContext context, ProductGroup group) {
    return _buildBodyText(context, _statusText(group));
  }

  static Widget _buildItemsCountCell(BuildContext context, ProductGroup group) {
    return _buildBodyText(context, CrudValueFormatter.number(group.itemsCount));
  }

  static Widget _buildDescriptionCell(
    BuildContext context,
    ProductGroup group,
  ) {
    return _buildBodyText(context, CrudValueFormatter.text(group.description));
  }

  static Widget _buildBodyText(BuildContext context, String value) {
    return Text(
      value,
      style: Theme.of(context).textTheme.bodySmall,
    );
  }

  static String _titleText(ProductGroup group) {
    return CrudValueFormatter.text(group.name);
  }

  static String _subtitleText(ProductGroup group) {
    return CrudValueFormatter.text(group.code);
  }

  static String _statusText(ProductGroup group) {
    final isActive = group.isActive;
    if (isActive == null) {
      return CrudValueFormatter.empty;
    }
    return isActive ? '启用' : '停用';
  }

  static List<CrudSummaryChipData> _summaryChips(ProductGroup group) {
    return [
      CrudSummaryChipData(label: '状态', value: _statusText(group)),
      CrudSummaryChipData(
        label: '明细数',
        value: CrudValueFormatter.number(group.itemsCount),
      ),
    ];
  }

  static List<CrudSummaryFieldData> _summaryFields(ProductGroup group) {
    return [
      CrudSummaryFieldData(
        label: '编码',
        value: CrudValueFormatter.text(group.code),
      ),
      CrudSummaryFieldData(
        label: '状态',
        value: _statusText(group),
      ),
      CrudSummaryFieldData(
        label: '明细数',
        value: CrudValueFormatter.number(group.itemsCount),
      ),
      CrudSummaryFieldData(
        label: '描述',
        value: CrudValueFormatter.text(group.description),
      ),
    ];
  }

  static String _buildDeleteSummary(ProductGroup group) {
    return '即将删除产品组 ${_titleText(group)}。删除后，关联产品的分组信息可能需要重新整理。';
  }

  static List<String> _buildDeleteImpacts(ProductGroup group) {
    return [
      '产品组编码：${CrudValueFormatter.text(group.code)}',
      if ((group.itemsCount ?? 0) > 0)
        '当前组内有 ${group.itemsCount} 个产品明细，删除前建议先处理归类关系',
    ];
  }

  static String _buildDeleteAuditHint(ProductGroup group) {
    return '如果只是临时停用该分组，优先考虑停用状态，而不是直接删除。';
  }
}
