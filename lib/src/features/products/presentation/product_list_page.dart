import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_list_page.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/core/utils/permission_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/products/application/product_view_model.dart';
import 'package:work_order_app/src/features/products/data/product_api_service.dart';
import 'package:work_order_app/src/features/products/data/product_repository_impl.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';
import 'package:work_order_app/src/features/products/domain/product_repository.dart';
import 'package:work_order_app/src/features/products/presentation/product_detail_page.dart';
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
    onItemTap: _onItemTap,
    mobileFieldsBuilder: _buildMobileFields,
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
    final result = await showProductEditDrawer(
      context,
      viewModel: viewModel,
      product: product,
    );
    if (result) {
      ToastUtil.showSuccess(product == null ? '创建成功' : '更新成功');
    }
  }

  static Future<void> _openDetailPage(
    BuildContext context,
    Product product,
  ) {
    return context.pushNamed<void>(
      'products_detail',
      pathParameters: {'id': product.id.toString()},
      extra: ProductDetailPage(product: product),
    );
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
    final permissions = PermissionUtil.snapshot(context);
    final canChangeProduct = permissions.has('workorder.change_product');

    return [
      if (canChangeProduct)
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
      if (canChangeProduct)
        PageActionButton.filled(
          onPressed: () => _openEditPage(context, viewModel, null),
          icon: const Icon(Icons.add),
          label: '新建产品',
        ),
    ];
  }

  static Future<void> _handleExport(
    BuildContext context,
    ProductViewModel viewModel,
  ) async {
    try {
      await viewModel.exportProducts();
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
    ProductViewModel viewModel,
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
      final importResult = await viewModel.importProducts(file);
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

  static void _onItemTap(BuildContext context, Product product) {
    _openDetailPage(context, product);
  }

  static Widget _buildMobileFields(BuildContext context, Product product) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final labelStyle = theme.textTheme.bodySmall?.copyWith(
      color: colors?.subtleText ?? theme.hintColor,
    );
    const fields = [
      ('产品编码', _productCode),
      ('产品类型', _productType),
      ('产品组', _productGroup),
      ('规格', _productSpec),
      ('单位', _productUnit),
      ('单价', _productPrice),
      ('库存', _productStock),
      ('最小库存', _productMinStock),
      ('状态', _productStatus),
      ('描述', _productDesc),
    ];
    return Column(
      children: [
        for (int i = 0; i < fields.length; i++)
          _mobileRow(
            context,
            labelStyle,
            fields[i].$1,
            fields[i].$2(product),
            last: i == fields.length - 1,
          ),
      ],
    );
  }

  static Widget _mobileRow(
    BuildContext context,
    TextStyle? labelStyle,
    String label,
    String value, {
    bool last = false,
  }) {
    final theme = Theme.of(context);
    final spacing = LayoutTokens.sectionSpacing(context) * 0.6;
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : spacing),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            child: Text(label, style: labelStyle),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? CrudValueFormatter.empty : value,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  static String _productCode(Product p) => CrudValueFormatter.text(p.code);
  static String _productType(Product p) => _productTypeText(p);
  static String _productGroup(Product p) =>
      CrudValueFormatter.text(p.productGroupName);
  static String _productSpec(Product p) =>
      CrudValueFormatter.text(p.specification);
  static String _productUnit(Product p) => CrudValueFormatter.text(p.unit);
  static String _productPrice(Product p) =>
      CrudValueFormatter.amount(p.unitPrice);
  static String _productStock(Product p) =>
      CrudValueFormatter.amount(p.stockQuantity);
  static String _productMinStock(Product p) =>
      CrudValueFormatter.amount(p.minStockQuantity);
  static String _productStatus(Product p) => _statusText(p);
  static String _productDesc(Product p) =>
      CrudValueFormatter.text(p.description);

  static Widget _buildNameCell(BuildContext context, Product product) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => _openDetailPage(context, product),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(
          _titleText(product),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
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
