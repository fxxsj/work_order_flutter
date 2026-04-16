import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_list_page.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/suppliers/application/supplier_view_model.dart';
import 'package:work_order_app/src/features/suppliers/data/supplier_api_service.dart';
import 'package:work_order_app/src/features/suppliers/data/supplier_repository_impl.dart';
import 'package:work_order_app/src/features/suppliers/domain/supplier.dart';
import 'package:work_order_app/src/features/suppliers/domain/supplier_repository.dart';
import 'package:work_order_app/src/features/suppliers/presentation/supplier_detail_page.dart';
import 'package:work_order_app/src/features/suppliers/presentation/supplier_edit_page.dart';

/// 供应商列表入口，负责创建并缓存依赖，避免页面重建时重复初始化。
class SupplierListEntry extends StatelessWidget {
  const SupplierListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureEntry<SupplierApiService, SupplierRepository,
        SupplierViewModel>(
      createService: (context) => SupplierApiService(context.read<ApiClient>()),
      createRepository: (context) =>
          SupplierRepositoryImpl(context.read<SupplierApiService>()),
      createViewModel: (context) =>
          SupplierViewModel(context.read<SupplierRepository>()),
      initialize: (viewModel) => viewModel.initialize(),
      child: const SupplierListPage(),
    );
  }
}

/// 供应商列表页视图，只负责渲染。
class SupplierListPage extends StatelessWidget {
  const SupplierListPage({super.key});

  static const CrudDeleteConfig<Supplier> _deleteConfig = CrudDeleteConfig(
    title: '确认删除',
    summaryBuilder: _buildDeleteSummary,
    impactsBuilder: _buildDeleteImpacts,
    auditHintBuilder: _buildDeleteAuditHint,
    confirmText: '确认删除',
    errorMessagePrefix: '删除失败: ',
  );

  static const CrudListConfig<Supplier, SupplierViewModel> _config =
      CrudListConfig(
    searchHintText: '搜索供应商名称/编码',
    emptyText: '暂无供应商数据',
    emptyIcon: Icons.storefront_outlined,
    loadItems: _loadSuppliers,
    titleBuilder: _titleText,
    subtitleBuilder: _subtitleText,
    summaryChipsBuilder: _summaryChips,
    summaryFieldsBuilder: _summaryFields,
    headerActionsBuilder: _headerActions,
    rowActionsBuilder: _rowActions,
    columns: [
      CrudTableColumn(label: '供应商', cellBuilder: _buildNameCell),
      CrudTableColumn(label: '编码', cellBuilder: _buildCodeCell),
      CrudTableColumn(label: '联系人', cellBuilder: _buildContactCell),
      CrudTableColumn(label: '电话', cellBuilder: _buildPhoneCell),
      CrudTableColumn(label: '状态', cellBuilder: _buildStatusCell),
      CrudTableColumn(label: '物料数', cellBuilder: _buildMaterialCountCell),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const CrudListPage<Supplier, SupplierViewModel>(config: _config);
  }

  static Future<void> _loadSuppliers(
    SupplierViewModel viewModel, {
    bool resetPage = false,
  }) {
    return viewModel.loadSuppliers(resetPage: resetPage);
  }

  static Future<void> _openEditPage(
    BuildContext context,
    SupplierViewModel viewModel,
    Supplier? supplier,
  ) async {
    final result = await showSupplierEditDrawer(
      context,
      viewModel: viewModel,
      supplier: supplier,
    );
    if (result) {
      ToastUtil.showSuccess(supplier == null ? '创建成功' : '更新成功');
    }
  }

  static Future<void> _confirmDelete(
    BuildContext context,
    SupplierViewModel viewModel,
    Supplier supplier,
  ) {
    return confirmCrudDeletion(
      context,
      item: supplier,
      onDelete: (item) => viewModel.deleteSupplier(item.id),
      config: _deleteConfig,
    );
  }

  static Future<void> _openDetailPage(
    BuildContext context,
    Supplier supplier,
  ) {
    return context.pushNamed<void>(
      'suppliers_detail',
      pathParameters: {'id': supplier.id.toString()},
      extra: SupplierDetailPage(supplier: supplier),
    );
  }

  static List<Widget> _headerActions(
    BuildContext context,
    SupplierViewModel viewModel,
  ) {
    return [
      PageActionButton.filled(
        onPressed: () => _openEditPage(context, viewModel, null),
        icon: const Icon(Icons.add),
        label: '新建供应商',
      ),
    ];
  }

  static List<RowAction> _rowActions(
    BuildContext context,
    SupplierViewModel viewModel,
    Supplier supplier,
  ) {
    return [
      RowAction(
        label: '详情',
        onPressed: () => _openDetailPage(context, supplier),
      ),
      RowAction(
        label: '编辑',
        onPressed: () => _openEditPage(context, viewModel, supplier),
      ),
      RowAction(
        label: '删除',
        onPressed: () => _confirmDelete(context, viewModel, supplier),
        destructive: true,
      ),
    ];
  }

  static Widget _buildNameCell(BuildContext context, Supplier supplier) {
    return Text(
      _titleText(supplier),
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  static Widget _buildCodeCell(BuildContext context, Supplier supplier) {
    return _buildBodyText(context, CrudValueFormatter.text(supplier.code));
  }

  static Widget _buildContactCell(BuildContext context, Supplier supplier) {
    return _buildBodyText(
      context,
      CrudValueFormatter.text(supplier.contactPerson),
    );
  }

  static Widget _buildPhoneCell(BuildContext context, Supplier supplier) {
    return _buildBodyText(context, CrudValueFormatter.text(supplier.phone));
  }

  static Widget _buildStatusCell(BuildContext context, Supplier supplier) {
    return _buildBodyText(context, _statusText(supplier));
  }

  static Widget _buildMaterialCountCell(
      BuildContext context, Supplier supplier) {
    return _buildBodyText(
      context,
      CrudValueFormatter.number(supplier.materialCount),
    );
  }

  static Widget _buildBodyText(BuildContext context, String value) {
    return Text(
      value,
      style: Theme.of(context).textTheme.bodySmall,
    );
  }

  static String _titleText(Supplier supplier) {
    return CrudValueFormatter.text(supplier.name);
  }

  static String _subtitleText(Supplier supplier) {
    return '${CrudValueFormatter.text(supplier.code)} · '
        '${CrudValueFormatter.text(supplier.contactPerson)}';
  }

  static List<CrudSummaryChipData> _summaryChips(Supplier supplier) {
    return [
      CrudSummaryChipData(label: '状态', value: _statusText(supplier)),
      CrudSummaryChipData(
        label: '物料数',
        value: CrudValueFormatter.number(supplier.materialCount),
      ),
    ];
  }

  static List<CrudSummaryFieldData> _summaryFields(Supplier supplier) {
    return [
      CrudSummaryFieldData(
        label: '编码',
        value: CrudValueFormatter.text(supplier.code),
      ),
      CrudSummaryFieldData(
        label: '联系人',
        value: CrudValueFormatter.text(supplier.contactPerson),
      ),
      CrudSummaryFieldData(
        label: '电话',
        value: CrudValueFormatter.text(supplier.phone),
      ),
      CrudSummaryFieldData(
        label: '邮箱',
        value: CrudValueFormatter.text(supplier.email),
      ),
      CrudSummaryFieldData(
        label: '状态',
        value: _statusText(supplier),
      ),
      CrudSummaryFieldData(
        label: '供应物料数',
        value: CrudValueFormatter.number(supplier.materialCount),
      ),
      CrudSummaryFieldData(
        label: '备注',
        value: CrudValueFormatter.text(supplier.notes),
      ),
    ];
  }

  static String _statusText(Supplier supplier) {
    return CrudValueFormatter.text(supplier.statusDisplay ?? supplier.status);
  }

  static String _buildDeleteSummary(Supplier supplier) {
    return '即将删除供应商 ${_titleText(supplier)}。删除后，相关采购、物料绑定和历史记录可能无法完整追溯。';
  }

  static List<String> _buildDeleteImpacts(Supplier supplier) {
    return [
      '供应商编码：${CrudValueFormatter.text(supplier.code)}',
      '如已有采购单、送货单或物料引用，删除可能失败或需要先解除关联',
      '删除后不能直接恢复，建议先确认该供应商已停止使用且不再参与历史追溯',
    ];
  }

  static String _buildDeleteAuditHint(Supplier supplier) {
    return '如果只是暂停合作，优先考虑保留供应商资料并停用，而不是直接删除。';
  }
}
