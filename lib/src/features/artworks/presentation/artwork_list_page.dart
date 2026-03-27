import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_list_page.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/artworks/application/artwork_view_model.dart';
import 'package:work_order_app/src/features/artworks/data/artwork_api_service.dart';
import 'package:work_order_app/src/features/artworks/data/artwork_repository_impl.dart';
import 'package:work_order_app/src/features/artworks/domain/artwork.dart';
import 'package:work_order_app/src/features/artworks/domain/artwork_repository.dart';
import 'package:work_order_app/src/features/artworks/presentation/artwork_edit_page.dart';

class ArtworkListEntry extends StatelessWidget {
  const ArtworkListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureEntry<ArtworkApiService, ArtworkRepository, ArtworkViewModel>(
      createService: (context) => ArtworkApiService(context.read<ApiClient>()),
      createRepository: (context) =>
          ArtworkRepositoryImpl(context.read<ArtworkApiService>()),
      createViewModel: (context) =>
          ArtworkViewModel(context.read<ArtworkRepository>()),
      initialize: (viewModel) => viewModel.initialize(),
      child: const ArtworkListPage(),
    );
  }
}

class ArtworkListPage extends StatelessWidget {
  const ArtworkListPage({super.key});

  static const CrudDeleteConfig<Artwork> _deleteConfig = CrudDeleteConfig(
    title: '确认删除',
    summaryBuilder: _buildDeleteSummary,
    impactsBuilder: _buildDeleteImpacts,
    auditHintBuilder: _buildDeleteAuditHint,
    confirmText: '确认删除',
    errorMessagePrefix: '删除失败: ',
  );

  static const CrudActionConfig<Artwork> _confirmConfig = CrudActionConfig(
    title: '确认图稿',
    summaryBuilder: _buildConfirmSummary,
    impactsBuilder: _buildConfirmImpacts,
    auditHintBuilder: _buildConfirmAuditHint,
    confirmText: '确认图稿',
    successMessageBuilder: _buildConfirmSuccessMessage,
    errorMessagePrefix: '确认失败: ',
  );

  static const CrudActionConfig<Artwork> _versionConfig = CrudActionConfig(
    title: '创建新版本',
    summaryBuilder: _buildVersionSummary,
    impactsBuilder: _buildVersionImpacts,
    auditHintBuilder: _buildVersionAuditHint,
    confirmText: '创建版本',
    successMessageBuilder: _buildVersionSuccessMessage,
    errorMessagePrefix: '创建新版本失败: ',
  );

  static const CrudListConfig<Artwork, ArtworkViewModel> _config =
      CrudListConfig(
    searchHintText: '搜索图稿编码、名称、拼版尺寸',
    emptyText: '暂无图稿数据',
    emptyIcon: Icons.image_outlined,
    loadItems: _loadArtworks,
    titleBuilder: _titleText,
    subtitleBuilder: _subtitleText,
    summaryChipsBuilder: _summaryChips,
    summaryFieldsBuilder: _summaryFields,
    headerActionsBuilder: _headerActions,
    rowActionsBuilder: _rowActions,
    columns: [
      CrudTableColumn(label: '稿件', cellBuilder: _buildNameCell),
      CrudTableColumn(label: '编码', cellBuilder: _buildCodeCell),
      CrudTableColumn(label: '色数', cellBuilder: _buildColorCell),
      CrudTableColumn(label: '拼版尺寸', cellBuilder: _buildSizeCell),
      CrudTableColumn(label: '状态', cellBuilder: _buildStatusCell),
      CrudTableColumn(label: '关联刀模', cellBuilder: _buildDiesCell),
      CrudTableColumn(label: '烫金版', cellBuilder: _buildFoilingCell),
      CrudTableColumn(label: '压凸版', cellBuilder: _buildEmbossingCell),
      CrudTableColumn(label: '包含产品', cellBuilder: _buildProductsCell),
      CrudTableColumn(label: '创建时间', cellBuilder: _buildCreatedAtCell),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const CrudListPage<Artwork, ArtworkViewModel>(config: _config);
  }

  static Future<void> _loadArtworks(
    ArtworkViewModel viewModel, {
    bool resetPage = false,
  }) {
    return viewModel.loadArtworks(resetPage: resetPage);
  }

  static Future<void> _openEditPage(
    BuildContext context,
    ArtworkViewModel viewModel,
    Artwork? artwork,
  ) async {
    Artwork? target = artwork;
    if (artwork != null) {
      try {
        final apiService = context.read<ArtworkApiService>();
        final detail = await apiService.fetchArtwork(artwork.id);
        if (!context.mounted) {
          return;
        }
        target = detail.toEntity();
      } catch (err) {
        if (!context.mounted) {
          return;
        }
        ToastUtil.showError('加载图稿详情失败: $err');
        return;
      }
    }
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: viewModel,
          child: ArtworkEditPage(artwork: target),
        ),
      ),
    );
    if (result == true) {
      ToastUtil.showSuccess(artwork == null ? '创建成功' : '更新成功');
    }
  }

  static Future<void> _confirmDelete(
    BuildContext context,
    ArtworkViewModel viewModel,
    Artwork artwork,
  ) {
    return confirmCrudDeletion(
      context,
      item: artwork,
      onDelete: (item) => viewModel.deleteArtwork(item.id),
      config: _deleteConfig,
    );
  }

  static Future<void> _confirmArtwork(
    BuildContext context,
    ArtworkViewModel viewModel,
    Artwork artwork,
  ) {
    return confirmCrudAction(
      context,
      item: artwork,
      onConfirm: (item) => viewModel.confirmArtwork(item.id),
      config: _confirmConfig,
    );
  }

  static Future<void> _createVersion(
    BuildContext context,
    ArtworkViewModel viewModel,
    Artwork artwork,
  ) {
    return confirmCrudAction(
      context,
      item: artwork,
      onConfirm: (item) => viewModel.createVersion(item.id),
      config: _versionConfig,
    );
  }

  static List<Widget> _headerActions(
    BuildContext context,
    ArtworkViewModel viewModel,
  ) {
    return [
      PageActionButton.filled(
        onPressed: () => _openEditPage(context, viewModel, null),
        icon: const Icon(Icons.add),
        label: '新建图稿',
      ),
    ];
  }

  static List<RowAction> _rowActions(
    BuildContext context,
    ArtworkViewModel viewModel,
    Artwork artwork,
  ) {
    return [
      RowAction(
        label: '编辑',
        onPressed: () => _openEditPage(context, viewModel, artwork),
      ),
      RowAction(
        label: '新版本',
        onPressed: () => _createVersion(context, viewModel, artwork),
      ),
      if (!artwork.confirmed)
        RowAction(
          label: '确认',
          onPressed: () => _confirmArtwork(context, viewModel, artwork),
        ),
      RowAction(
        label: '删除',
        onPressed: () => _confirmDelete(context, viewModel, artwork),
        destructive: true,
      ),
    ];
  }

  static Widget _buildNameCell(BuildContext context, Artwork artwork) {
    return Text(
      _titleText(artwork),
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  static Widget _buildCodeCell(BuildContext context, Artwork artwork) {
    return _buildBodyText(context, _codeText(artwork));
  }

  static Widget _buildColorCell(BuildContext context, Artwork artwork) {
    return _buildBodyText(
      context,
      CrudValueFormatter.text(artwork.colorDisplay),
    );
  }

  static Widget _buildSizeCell(BuildContext context, Artwork artwork) {
    return _buildBodyText(
      context,
      CrudValueFormatter.text(artwork.impositionSize),
    );
  }

  static Widget _buildStatusCell(BuildContext context, Artwork artwork) {
    return _buildBodyText(context, _statusText(artwork));
  }

  static Widget _buildDiesCell(BuildContext context, Artwork artwork) {
    return _buildBodyText(
      context,
      _compactListText(artwork.dieCodes, artwork.dieNames),
    );
  }

  static Widget _buildFoilingCell(BuildContext context, Artwork artwork) {
    return _buildBodyText(
      context,
      _compactListText(artwork.foilingPlateCodes, artwork.foilingPlateNames),
    );
  }

  static Widget _buildEmbossingCell(BuildContext context, Artwork artwork) {
    return _buildBodyText(
      context,
      _compactListText(
        artwork.embossingPlateCodes,
        artwork.embossingPlateNames,
      ),
    );
  }

  static Widget _buildProductsCell(BuildContext context, Artwork artwork) {
    return _buildBodyText(context, _productSummary(artwork.products));
  }

  static Widget _buildCreatedAtCell(BuildContext context, Artwork artwork) {
    return _buildBodyText(
        context, CrudValueFormatter.dateTime(artwork.createdAt));
  }

  static Widget _buildBodyText(BuildContext context, String value) {
    return Text(
      value,
      style: Theme.of(context).textTheme.bodySmall,
    );
  }

  static String _titleText(Artwork artwork) {
    return CrudValueFormatter.text(artwork.name);
  }

  static String _codeText(Artwork artwork) {
    return CrudValueFormatter.text(
      artwork.fullCode.isNotEmpty ? artwork.fullCode : artwork.code,
    );
  }

  static String _subtitleText(Artwork artwork) {
    return '${_codeText(artwork)} · '
        '${CrudValueFormatter.text(artwork.colorDisplay)}';
  }

  static String _statusText(Artwork artwork) {
    return artwork.confirmed ? '已确认' : '未确认';
  }

  static String _compactListText(List<String> codes, List<String> names) {
    if (codes.isEmpty) {
      return CrudValueFormatter.empty;
    }
    final display = <String>[];
    for (var i = 0; i < codes.length; i++) {
      final code = codes[i];
      final name = i < names.length ? names[i] : '';
      display.add(name.isNotEmpty ? '$code - $name' : code);
    }
    return display.join('、');
  }

  static String _productSummary(List<ArtworkProduct> products) {
    if (products.isEmpty) {
      return CrudValueFormatter.empty;
    }
    return products
        .map((item) => '${item.productName}(${item.impositionQuantity ?? 1}拼)')
        .join('、');
  }

  static List<CrudSummaryChipData> _summaryChips(Artwork artwork) {
    return [
      CrudSummaryChipData(label: '状态', value: _statusText(artwork)),
      CrudSummaryChipData(
        label: '拼版',
        value: CrudValueFormatter.text(artwork.impositionSize),
      ),
    ];
  }

  static List<CrudSummaryFieldData> _summaryFields(Artwork artwork) {
    return [
      CrudSummaryFieldData(label: '编码', value: _codeText(artwork)),
      CrudSummaryFieldData(
        label: '色数',
        value: CrudValueFormatter.text(artwork.colorDisplay),
      ),
      CrudSummaryFieldData(
        label: '拼版尺寸',
        value: CrudValueFormatter.text(artwork.impositionSize),
      ),
      CrudSummaryFieldData(label: '确认状态', value: _statusText(artwork)),
      CrudSummaryFieldData(
        label: '关联刀模',
        value: _compactListText(artwork.dieCodes, artwork.dieNames),
      ),
      CrudSummaryFieldData(
        label: '关联烫金版',
        value: _compactListText(
          artwork.foilingPlateCodes,
          artwork.foilingPlateNames,
        ),
      ),
      CrudSummaryFieldData(
        label: '关联压凸版',
        value: _compactListText(
          artwork.embossingPlateCodes,
          artwork.embossingPlateNames,
        ),
      ),
      CrudSummaryFieldData(
        label: '包含产品',
        value: _productSummary(artwork.products),
      ),
      CrudSummaryFieldData(
        label: '备注',
        value: CrudValueFormatter.text(artwork.notes),
      ),
      CrudSummaryFieldData(
        label: '创建时间',
        value: CrudValueFormatter.dateTime(artwork.createdAt),
      ),
    ];
  }

  static String _buildDeleteSummary(Artwork artwork) {
    return '即将删除图稿 ${_titleText(artwork)}。删除后，相关产品、刀模和版材追溯可能受影响。';
  }

  static List<String> _buildDeleteImpacts(Artwork artwork) {
    return [
      '图稿编码：${_codeText(artwork)}',
      if (artwork.dieCodes.isNotEmpty)
        '关联刀模：${_compactListText(artwork.dieCodes, artwork.dieNames)}',
      if (artwork.foilingPlateCodes.isNotEmpty)
        '关联烫金版：${_compactListText(artwork.foilingPlateCodes, artwork.foilingPlateNames)}',
      if (artwork.embossingPlateCodes.isNotEmpty)
        '关联压凸版：${_compactListText(artwork.embossingPlateCodes, artwork.embossingPlateNames)}',
      if (artwork.products.isNotEmpty)
        '包含产品：${_productSummary(artwork.products)}',
    ];
  }

  static String _buildDeleteAuditHint(Artwork artwork) {
    return '如果图稿已用于历史业务，优先保留档案并停止引用，而不是直接删除。';
  }

  static String _buildConfirmSummary(Artwork artwork) {
    return '即将确认图稿 ${_titleText(artwork)}。确认后当前版本将不再允许直接修改。';
  }

  static List<String> _buildConfirmImpacts(Artwork artwork) {
    return [
      '确认后如需调整内容，应基于当前版本创建新版本',
      '当前编码：${_codeText(artwork)}',
    ];
  }

  static String _buildConfirmAuditHint(Artwork artwork) {
    return '请确认色数、拼版尺寸和关联版材信息已校对无误。';
  }

  static String _buildConfirmSuccessMessage(Artwork artwork) {
    return '图稿已确认';
  }

  static String _buildVersionSummary(Artwork artwork) {
    return '即将基于图稿 ${_codeText(artwork)} 创建新版本，新版本会继承当前版本的主要配置。';
  }

  static List<String> _buildVersionImpacts(Artwork artwork) {
    return [
      '新版本适合用于后续修改，不影响当前版本历史记录',
      '当前名称：${_titleText(artwork)}',
    ];
  }

  static String _buildVersionAuditHint(Artwork artwork) {
    return '若当前版本已经确认，建议通过新版本承接后续改动。';
  }

  static String _buildVersionSuccessMessage(Artwork artwork) {
    return '新版本创建成功';
  }
}
