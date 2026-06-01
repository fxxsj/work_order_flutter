import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/detail_section_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/responsive_layout.dart';
import 'package:work_order_app/src/features/processes/data/process_api_service.dart';
import 'package:work_order_app/src/features/processes/domain/process.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  List<Process> _processes = [];
  bool _loadingProcesses = false;

  @override
  void initState() {
    super.initState();
    if (widget.product.defaultProcessIds.isNotEmpty) {
      _loadProcesses();
    }
  }

  Future<void> _loadProcesses() async {
    setState(() => _loadingProcesses = true);
    try {
      final apiClient = context.read<ApiClient>();
      final service = ProcessApiService(apiClient);
      final page = await service.fetchProcesses(page: 1, pageSize: 50);
      if (!mounted) return;
      setState(() {
        _processes = page.items.map((dto) => dto.toEntity()).toList();
      });
    } catch (_) {
      // 工序名称加载失败不影响整体展示
    } finally {
      if (mounted) setState(() => _loadingProcesses = false);
    }
  }

  List<String> _resolveProcessNames(List<int> ids) {
    final names = <String>[];
    for (final id in ids) {
      final match = _processes.where((p) => p.id == id);
      if (match.isNotEmpty) {
        names.add(match.first.name);
      } else {
        names.add('工序 #$id');
      }
    }
    return names;
  }

  static const String _empty = '-';

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final isMobile = ResponsiveLayout.isMobile(context);
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    final columnSpacing = LayoutTokens.formColumnSpacing(context);
    final itemSpacing = LayoutTokens.sectionSpacing(context);
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final labelStyle = theme.textTheme.bodySmall?.copyWith(
      color: colors?.subtleText ?? theme.hintColor,
    );

    return ListPageScaffold(
      spacing: sectionSpacing,
      header: PageHeaderBar(
        breadcrumb: null,
        useSurface: false,
        showDivider: false,
        padding: EdgeInsets.zero,
        actions: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            PageActionButton.outlined(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back, size: 16),
              label: '返回',
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          // --- 左右双列 ---
          if (!isMobile)
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        _buildBasicInfoCard(
                          context,
                          product,
                          itemSpacing,
                          labelStyle,
                        ),
                        SizedBox(height: sectionSpacing),
                        _buildStockPriceCard(
                          context,
                          product,
                          itemSpacing,
                          labelStyle,
                        ),
                        if (product.productType == 'group_main') ...[
                          SizedBox(height: sectionSpacing),
                          _buildGroupCard(
                            context,
                            product,
                            itemSpacing,
                            labelStyle,
                          ),
                        ],
                        if (product.defaultMaterials.isNotEmpty) ...[
                          SizedBox(height: sectionSpacing),
                          _buildMaterialsCard(
                            context,
                            product,
                            itemSpacing,
                            labelStyle,
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(width: columnSpacing),
                  Expanded(
                    child: Column(
                      children: [
                        if (product.defaultProcessIds.isNotEmpty ||
                            _loadingProcesses) ...[
                          _buildProcessCard(context, product),
                          SizedBox(height: sectionSpacing),
                        ],
                        _buildExtraInfoCard(
                          context,
                          product,
                          itemSpacing,
                          labelStyle,
                        ),
                        if (product.images.isNotEmpty) ...[
                          SizedBox(height: sectionSpacing),
                          _buildImageCard(context, product),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          // --- 移动端单列 ---
          if (isMobile) ...[
            _buildBasicInfoCard(context, product, itemSpacing, labelStyle),
            SizedBox(height: sectionSpacing),
            _buildStockPriceCard(context, product, itemSpacing, labelStyle),
            if (product.productType == 'group_main') ...[
              SizedBox(height: sectionSpacing),
              _buildGroupCard(context, product, itemSpacing, labelStyle),
            ],
            if (product.defaultProcessIds.isNotEmpty || _loadingProcesses) ...[
              SizedBox(height: sectionSpacing),
              _buildProcessCard(context, product),
            ],
            SizedBox(height: sectionSpacing),
            _buildExtraInfoCard(context, product, itemSpacing, labelStyle),
            if (product.images.isNotEmpty) ...[
              SizedBox(height: sectionSpacing),
              _buildImageCard(context, product),
            ],
            if (product.defaultMaterials.isNotEmpty) ...[
              SizedBox(height: sectionSpacing),
              _buildMaterialsCard(context, product, itemSpacing, labelStyle),
            ],
          ],
        ],
      ),
    );
  }

  // ---- 卡片构建 ----

  Widget _buildBasicInfoCard(
    BuildContext context,
    Product item,
    double spacing,
    TextStyle? labelStyle,
  ) {
    return DetailSectionCard(
      title: '基本信息',
      child: Column(
        children: [
          _row(context, '产品名称', item.name, spacing, labelStyle),
          _row(context, '产品编码', item.code, spacing, labelStyle),
          _row(context, '产品类型', _productTypeText(item), spacing, labelStyle),
          _row(
            context,
            '所属产品组',
            item.productGroupName ?? _empty,
            spacing,
            labelStyle,
            last: true,
          ),
          _row(
            context,
            '规格',
            item.specification ?? _empty,
            spacing,
            labelStyle,
            last: true,
          ),
        ],
      ),
    );
  }

  Widget _buildStockPriceCard(
    BuildContext context,
    Product item,
    double spacing,
    TextStyle? labelStyle,
  ) {
    final isLowStock =
        item.stockQuantity != null &&
        item.minStockQuantity != null &&
        item.stockQuantity! < item.minStockQuantity!;
    return DetailSectionCard(
      title: '库存与价格',
      child: Column(
        children: [
          _row(context, '单位', item.unit ?? _empty, spacing, labelStyle),
          _row(
            context,
            '单价',
            item.unitPrice?.toStringAsFixed(2) ?? _empty,
            spacing,
            labelStyle,
          ),
          _row(
            context,
            '库存数量',
            item.stockQuantity?.toString() ?? _empty,
            spacing,
            labelStyle,
            valueColor: isLowStock ? Colors.red : null,
          ),
          _row(
            context,
            '最小库存',
            item.minStockQuantity?.toString() ?? _empty,
            spacing,
            labelStyle,
          ),
          _row(
            context,
            '状态',
            _statusText(item),
            spacing,
            labelStyle,
            last: true,
          ),
        ],
      ),
    );
  }

  Widget _buildGroupCard(
    BuildContext context,
    Product item,
    double spacing,
    TextStyle? labelStyle,
  ) {
    if (item.productType != 'group_main') return const SizedBox.shrink();
    return DetailSectionCard(
      title: '套装信息',
      child: Column(
        children: [
          if (item.availableGroupStock != null)
            _row(
              context,
              '可用库存',
              item.availableGroupStock.toString(),
              spacing,
              labelStyle,
            ),
          if (item.groupItems.isNotEmpty) ...[
            SizedBox(height: spacing),
            ...item.groupItems.asMap().entries.map((entry) {
              final groupItem = entry.value;
              final isLast = entry.key == item.groupItems.length - 1;
              return _row(
                context,
                '${groupItem.code}',
                '${groupItem.name} · 库存 ${groupItem.stockQuantity}',
                spacing,
                labelStyle,
                last: isLast,
              );
            }).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildExtraInfoCard(
    BuildContext context,
    Product item,
    double spacing,
    TextStyle? labelStyle,
  ) {
    return DetailSectionCard(
      title: '补充信息',
      child: _row(
        context,
        '描述',
        item.description ?? _empty,
        spacing,
        labelStyle,
        last: true,
      ),
    );
  }

  Widget _buildProcessCard(BuildContext context, Product item) {
    return DetailSectionCard(title: '默认工序', child: _buildProcessTags(item));
  }

  Widget _buildImageCard(BuildContext context, Product item) {
    return DetailSectionCard(
      title: '产品图片',
      child: _buildImageGallery(context, item.images),
    );
  }

  Widget _buildMaterialsCard(
    BuildContext context,
    Product item,
    double spacing,
    TextStyle? labelStyle,
  ) {
    return DetailSectionCard(
      title: '默认物料',
      child: Column(
        children: [
          for (int i = 0; i < item.defaultMaterials.length; i++)
            _row(
              context,
              _materialLabel(item.defaultMaterials[i]),
              _materialSummary(item.defaultMaterials[i]),
              spacing,
              labelStyle,
              last: i == item.defaultMaterials.length - 1,
            ),
        ],
      ),
    );
  }

  // ---- 通用行 ----

  Widget _row(
    BuildContext context,
    String label,
    String value,
    double spacing,
    TextStyle? labelStyle, {
    bool last = false,
    Color? valueColor,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : spacing),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Text(label, style: labelStyle)),
          Expanded(
            child: Text(
              value.isEmpty ? _empty : value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: valueColor,
                fontWeight: valueColor != null ? FontWeight.bold : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---- 工序标签 ----

  Widget _buildProcessTags(Product item) {
    if (_loadingProcesses) {
      return const SizedBox(
        height: 32,
        child: Center(
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }
    final names = _resolveProcessNames(item.defaultProcessIds);
    final theme = Theme.of(context);
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final name in names)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(
                alpha: OpacityTokens.distinctStrong,
              ),
              borderRadius: RadiusTokens.bXs,
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withValues(
                  alpha: OpacityTokens.borderMedium,
                ),
              ),
            ),
            child: Text(
              name,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
      ],
    );
  }

  // ---- 静态工具方法 ----

  static String _productTypeText(Product product) {
    final display = product.productTypeDisplay;
    if (display != null && display.isNotEmpty) return display;
    switch (product.productType) {
      case 'group_main':
        return '套装主产品';
      case 'group_item':
        return '套装子产品';
      case 'single':
        return '单品';
      default:
        return _empty;
    }
  }

  static String _statusText(Product product) {
    final isActive = product.isActive;
    if (isActive == null) return _empty;
    return isActive ? '启用' : '停用';
  }

  static String _materialLabel(ProductMaterialItem material) {
    final name = material.materialName;
    if (name != null && name.isNotEmpty) {
      final code = material.materialCode;
      if (code != null && code.isNotEmpty) return '$name ($code)';
      return name;
    }
    return '物料 #${material.materialId}';
  }

  static String _materialSummary(ProductMaterialItem material) {
    final parts = <String>[];
    if (material.materialSize != null && material.materialSize!.isNotEmpty) {
      parts.add('尺寸: ${material.materialSize}');
    }
    if (material.materialUsage != null && material.materialUsage!.isNotEmpty) {
      parts.add('用量: ${material.materialUsage}');
    }
    if (material.needCutting == true) parts.add('需开料');
    if (material.notes != null && material.notes!.isNotEmpty) {
      parts.add('备注: ${material.notes}');
    }
    return parts.isEmpty ? _empty : parts.join(' · ');
  }

  // ---- 图片画廊 ----

  Widget _buildImageGallery(BuildContext context, List<ProductImage> images) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final image in images)
          GestureDetector(
            onTap: () =>
                _showImageViewer(context, images, images.indexOf(image)),
            child: ClipRRect(
              borderRadius: RadiusTokens.bSm,
              child: Stack(
                children: [
                  Image.network(
                    image.imageUrl,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 120,
                      height: 120,
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      child: const Icon(Icons.broken_image_outlined),
                    ),
                  ),
                  Positioned(
                    right: 4,
                    bottom: 4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(
                          alpha: OpacityTokens.borderMedium,
                        ),
                        borderRadius: RadiusTokens.bXs,
                      ),
                      child: const Icon(
                        Icons.zoom_in,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  void _showImageViewer(
    BuildContext context,
    List<ProductImage> images,
    int initialIndex,
  ) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) =>
          _ImageViewerDialog(images: images, initialIndex: initialIndex),
    );
  }
}

// ---- 图片全屏查看器 ----

class _ImageViewerDialog extends StatefulWidget {
  const _ImageViewerDialog({required this.images, this.initialIndex = 0});

  final List<ProductImage> images;
  final int initialIndex;

  @override
  State<_ImageViewerDialog> createState() => _ImageViewerDialogState();
}

class _ImageViewerDialogState extends State<_ImageViewerDialog> {
  late PageController _pageController;
  late int _currentIndex;
  late TransformationController _transformController;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    _transformController = TransformationController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _transformController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            GestureDetector(
              onTap: () => setState(() => _showControls = !_showControls),
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.images.length,
                onPageChanged: (index) {
                  _transformController.value = Matrix4.identity();
                  setState(() => _currentIndex = index);
                },
                itemBuilder: (context, index) {
                  return InteractiveViewer(
                    transformationController: _transformController,
                    minScale: 0.5,
                    maxScale: 4.0,
                    child: Center(
                      child: Image.network(
                        widget.images[index].imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.broken_image_outlined,
                              color: Colors.white54,
                              size: 64,
                            ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_showControls) ...[
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, color: Colors.white),
                        tooltip: '关闭',
                      ),
                      const Spacer(),
                      Text(
                        '${_currentIndex + 1} / ${widget.images.length}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      SpacingTokens.hLg,
                    ],
                  ),
                ),
              ),
              if (widget.images.length > 1) ...[
                if (_currentIndex > 0)
                  Positioned(
                    left: 8,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: IconButton(
                        onPressed: () {
                          _transformController.value = Matrix4.identity();
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(
                              alpha: OpacityTokens.borderMedium,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                          ),
                        ),
                        tooltip: '上一张',
                      ),
                    ),
                  ),
                if (_currentIndex < widget.images.length - 1)
                  Positioned(
                    right: 8,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: IconButton(
                        onPressed: () {
                          _transformController.value = Matrix4.identity();
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(
                              alpha: OpacityTokens.borderMedium,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                          ),
                        ),
                        tooltip: '下一张',
                      ),
                    ),
                  ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
