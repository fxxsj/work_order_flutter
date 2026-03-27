import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_list_page.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/products/application/product_view_model.dart';
import 'package:work_order_app/src/features/products/data/product_api_service.dart';
import 'package:work_order_app/src/features/products/data/product_repository_impl.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';
import 'package:work_order_app/src/features/products/domain/product_repository.dart';
import 'package:work_order_app/src/features/products/presentation/product_edit_page.dart';

/// 产品列表入口，负责创建并缓存依赖，避免页面重建时重复初始化。
class ProductListEntry extends StatelessWidget {
  const ProductListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureEntry<ProductApiService, ProductRepository, ProductViewModel>(
      createService: (context) => ProductApiService(context.read<ApiClient>()),
      createRepository: (context) =>
          ProductRepositoryImpl(context.read<ProductApiService>()),
      createViewModel: (context) =>
          ProductViewModel(context.read<ProductRepository>()),
      initialize: (viewModel) => viewModel.initialize(),
      child: const ProductListPage(),
    );
  }
}

/// 产品列表页视图，只负责渲染。
class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  static const CrudDeleteConfig<Product> _deleteConfig = CrudDeleteConfig(
    title: '确认删除',
    summaryBuilder: _buildDeleteSummary,
    impactsBuilder: _buildDeleteImpacts,
    auditHintBuilder: _buildDeleteAuditHint,
    confirmText: '确认删除',
    errorMessagePrefix: '删除失败: ',
  );

  static const CrudListConfig<Product, ProductViewModel> _config =
      CrudListConfig(
    searchHintText: '搜索产品名称/编码',
    emptyText: '暂无产品数据',
    emptyIcon: Icons.inventory_2_outlined,
    loadItems: _loadProducts,
    titleBuilder: _titleText,
    subtitleBuilder: _subtitleText,
    summaryChipsBuilder: _summaryChips,
    summaryFieldsBuilder: _summaryFields,
    headerActionsBuilder: _headerActions,
    rowActionsBuilder: _rowActions,
    columns: [
      CrudTableColumn(label: '产品', cellBuilder: _buildNameCell),
      CrudTableColumn(label: '编码', cellBuilder: _buildCodeCell),
      CrudTableColumn(label: '类型', cellBuilder: _buildTypeCell),
      CrudTableColumn(label: '产品组', cellBuilder: _buildGroupCell),
      CrudTableColumn(label: '规格', cellBuilder: _buildSpecificationCell),
      CrudTableColumn(label: '单位', cellBuilder: _buildUnitCell),
      CrudTableColumn(label: '单价', cellBuilder: _buildPriceCell),
      CrudTableColumn(label: '库存', cellBuilder: _buildStockCell),
      CrudTableColumn(label: '最小库存', cellBuilder: _buildMinStockCell),
      CrudTableColumn(label: '状态', cellBuilder: _buildStatusCell),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const CrudListPage<Product, ProductViewModel>(config: _config);
  }

  static Future<void> _loadProducts(
    ProductViewModel viewModel, {
    bool resetPage = false,
  }) {
    return viewModel.loadProducts(resetPage: resetPage);
  }

  static Future<void> _openEditPage(
    BuildContext context,
    ProductViewModel viewModel,
    Product? product,
  ) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: viewModel,
          child: ProductEditPage(product: product),
        ),
      ),
    );
    if (result == true) {
      ToastUtil.showSuccess(product == null ? '创建成功' : '更新成功');
    }
  }

  static Future<void> _confirmDelete(
    BuildContext context,
    ProductViewModel viewModel,
    Product product,
  ) {
    return confirmCrudDeletion(
      context,
      item: product,
      onDelete: (item) => viewModel.deleteProduct(item.id),
      config: _deleteConfig,
    );
  }

  static List<Widget> _headerActions(
    BuildContext context,
    ProductViewModel viewModel,
  ) {
    return [
      PageActionButton.filled(
        onPressed: () => _openEditPage(context, viewModel, null),
        icon: const Icon(Icons.add),
        label: '新建产品',
      ),
    ];
  }

  static List<RowAction> _rowActions(
    BuildContext context,
    ProductViewModel viewModel,
    Product product,
  ) {
    return [
      RowAction(
        label: '编辑',
        onPressed: () => _openEditPage(context, viewModel, product),
      ),
      RowAction(
        label: '删除',
        onPressed: () => _confirmDelete(context, viewModel, product),
        destructive: true,
      ),
    ];
  }

  static Widget _buildNameCell(BuildContext context, Product product) {
    return Text(
      _titleText(product),
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  static Widget _buildCodeCell(BuildContext context, Product product) {
    return _buildBodyText(context, CrudValueFormatter.text(product.code));
  }

  static Widget _buildTypeCell(BuildContext context, Product product) {
    return _buildBodyText(context, _productTypeText(product));
  }

  static Widget _buildGroupCell(BuildContext context, Product product) {
    return _buildBodyText(
      context,
      CrudValueFormatter.text(product.productGroupName),
    );
  }

  static Widget _buildSpecificationCell(BuildContext context, Product product) {
    return _buildBodyText(
      context,
      CrudValueFormatter.text(product.specification),
    );
  }

  static Widget _buildUnitCell(BuildContext context, Product product) {
    return _buildBodyText(context, CrudValueFormatter.text(product.unit));
  }

  static Widget _buildPriceCell(BuildContext context, Product product) {
    return _buildBodyText(
        context, CrudValueFormatter.amount(product.unitPrice));
  }

  static Widget _buildStockCell(BuildContext context, Product product) {
    return _buildBodyText(
      context,
      CrudValueFormatter.amount(product.stockQuantity),
    );
  }

  static Widget _buildMinStockCell(BuildContext context, Product product) {
    return _buildBodyText(
      context,
      CrudValueFormatter.amount(product.minStockQuantity),
    );
  }

  static Widget _buildStatusCell(BuildContext context, Product product) {
    return _buildBodyText(context, _statusText(product));
  }

  static Widget _buildBodyText(BuildContext context, String value) {
    return Text(
      value,
      style: Theme.of(context).textTheme.bodySmall,
    );
  }

  static String _titleText(Product product) {
    return CrudValueFormatter.text(product.name);
  }

  static String _subtitleText(Product product) {
    return '${CrudValueFormatter.text(product.code)} · ${_productTypeText(product)}';
  }

  static String _productTypeText(Product product) {
    final display = product.productTypeDisplay;
    if (display != null && display.isNotEmpty) {
      return display;
    }
    switch (product.productType) {
      case 'group_main':
        return '套装主产品';
      case 'group_item':
        return '套装子产品';
      case 'single':
        return '单品';
      default:
        return CrudValueFormatter.empty;
    }
  }

  static String _statusText(Product product) {
    final isActive = product.isActive;
    if (isActive == null) {
      return CrudValueFormatter.empty;
    }
    return isActive ? '启用' : '停用';
  }

  static List<CrudSummaryChipData> _summaryChips(Product product) {
    return [
      CrudSummaryChipData(label: '状态', value: _statusText(product)),
      CrudSummaryChipData(
        label: '单价',
        value: CrudValueFormatter.amount(product.unitPrice),
      ),
      CrudSummaryChipData(
        label: '库存',
        value: CrudValueFormatter.amount(product.stockQuantity),
      ),
      CrudSummaryChipData(
        label: '最小库存',
        value: CrudValueFormatter.amount(product.minStockQuantity),
      ),
    ];
  }

  static List<CrudSummaryFieldData> _summaryFields(Product product) {
    return [
      CrudSummaryFieldData(
        label: '产品编码',
        value: CrudValueFormatter.text(product.code),
      ),
      CrudSummaryFieldData(
        label: '产品类型',
        value: _productTypeText(product),
      ),
      CrudSummaryFieldData(
        label: '产品组',
        value: CrudValueFormatter.text(product.productGroupName),
      ),
      CrudSummaryFieldData(
        label: '规格',
        value: CrudValueFormatter.text(product.specification),
      ),
      CrudSummaryFieldData(
        label: '单位',
        value: CrudValueFormatter.text(product.unit),
      ),
      CrudSummaryFieldData(
        label: '单价',
        value: CrudValueFormatter.amount(product.unitPrice),
      ),
      CrudSummaryFieldData(
        label: '库存',
        value: CrudValueFormatter.amount(product.stockQuantity),
      ),
      CrudSummaryFieldData(
        label: '最小库存',
        value: CrudValueFormatter.amount(product.minStockQuantity),
      ),
      CrudSummaryFieldData(
        label: '状态',
        value: _statusText(product),
      ),
      CrudSummaryFieldData(
        label: '描述',
        value: CrudValueFormatter.text(product.description),
      ),
    ];
  }

  static String _buildDeleteSummary(Product product) {
    return '即将删除产品 ${_titleText(product)}。删除后，施工单、订单和库存追溯可能受到影响。';
  }

  static List<String> _buildDeleteImpacts(Product product) {
    return [
      '产品编码：${CrudValueFormatter.text(product.code)}',
      '产品类型：${_productTypeText(product)}',
      if ((product.productGroupName ?? '').trim().isNotEmpty)
        '所属产品组：${product.productGroupName!.trim()}',
      '若已有订单、库存或刀模关联，删除可能失败或需要先解除引用',
    ];
  }

  static String _buildDeleteAuditHint(Product product) {
    return '如果只是暂停销售或生产，优先考虑停用状态，而不是直接删除。';
  }
}
