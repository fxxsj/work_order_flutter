import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_list_page.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/foiling_plates/application/foiling_plate_view_model.dart';
import 'package:work_order_app/src/features/foiling_plates/data/foiling_plate_api_service.dart';
import 'package:work_order_app/src/features/foiling_plates/data/foiling_plate_repository_impl.dart';
import 'package:work_order_app/src/features/foiling_plates/domain/foiling_plate.dart';
import 'package:work_order_app/src/features/foiling_plates/domain/foiling_plate_repository.dart';
import 'package:work_order_app/src/features/foiling_plates/presentation/foiling_plate_edit_page.dart';

class FoilingPlateListEntry extends StatelessWidget {
  const FoilingPlateListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureEntry<FoilingPlateApiService, FoilingPlateRepository,
        FoilingPlateViewModel>(
      createService: (context) =>
          FoilingPlateApiService(context.read<ApiClient>()),
      createRepository: (context) =>
          FoilingPlateRepositoryImpl(context.read<FoilingPlateApiService>()),
      createViewModel: (context) =>
          FoilingPlateViewModel(context.read<FoilingPlateRepository>()),
      initialize: (viewModel) => viewModel.initialize(),
      child: const FoilingPlateListPage(),
    );
  }
}

class FoilingPlateListPage extends StatelessWidget {
  const FoilingPlateListPage({super.key});

  static const CrudDeleteConfig<FoilingPlate> _deleteConfig = CrudDeleteConfig(
    title: '确认删除',
    summaryBuilder: _buildDeleteSummary,
    impactsBuilder: _buildDeleteImpacts,
    auditHintBuilder: _buildDeleteAuditHint,
    confirmText: '确认删除',
    errorMessagePrefix: '删除失败: ',
  );

  static const CrudActionConfig<FoilingPlate> _confirmConfig = CrudActionConfig(
    title: '确认烫金版',
    summaryBuilder: _buildConfirmSummary,
    impactsBuilder: _buildConfirmImpacts,
    auditHintBuilder: _buildConfirmAuditHint,
    confirmText: '确认烫金版',
    successMessageBuilder: _buildConfirmSuccessMessage,
    errorMessagePrefix: '确认失败: ',
  );

  static const CrudListConfig<FoilingPlate, FoilingPlateViewModel> _config =
      CrudListConfig(
    searchHintText: '搜索烫金版编码、名称、尺寸、材质',
    emptyText: '暂无烫金版数据',
    emptyIcon: Icons.auto_fix_high_outlined,
    loadItems: _loadFoilingPlates,
    titleBuilder: _titleText,
    subtitleBuilder: _subtitleText,
    summaryChipsBuilder: _summaryChips,
    summaryFieldsBuilder: _summaryFields,
    headerActionsBuilder: _headerActions,
    rowActionsBuilder: _rowActions,
    columns: [
      CrudTableColumn(label: '烫金版', cellBuilder: _buildNameCell),
      CrudTableColumn(label: '编码', cellBuilder: _buildCodeCell),
      CrudTableColumn(label: '类型', cellBuilder: _buildTypeCell),
      CrudTableColumn(label: '尺寸', cellBuilder: _buildSizeCell),
      CrudTableColumn(label: '材质', cellBuilder: _buildMaterialCell),
      CrudTableColumn(label: '厚度', cellBuilder: _buildThicknessCell),
      CrudTableColumn(label: '确认状态', cellBuilder: _buildConfirmedCell),
      CrudTableColumn(label: '包含产品', cellBuilder: _buildProductsCell),
      CrudTableColumn(label: '创建时间', cellBuilder: _buildCreatedAtCell),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const CrudListPage<FoilingPlate, FoilingPlateViewModel>(
      config: _config,
    );
  }

  static Future<void> _loadFoilingPlates(
    FoilingPlateViewModel viewModel, {
    bool resetPage = false,
  }) {
    return viewModel.loadFoilingPlates(resetPage: resetPage);
  }

  static Future<void> _openEditPage(
    BuildContext context,
    FoilingPlateViewModel viewModel,
    FoilingPlate? plate,
  ) async {
    FoilingPlate? target = plate;
    if (plate != null) {
      try {
        final apiService = context.read<FoilingPlateApiService>();
        final detail = await apiService.fetchFoilingPlate(plate.id);
        if (!context.mounted) {
          return;
        }
        target = detail.toEntity();
      } catch (err) {
        if (!context.mounted) {
          return;
        }
        ToastUtil.showError('加载烫金版详情失败: $err');
        return;
      }
    }
    final result = await showFoilingPlateEditDrawer(
      context,
      viewModel: viewModel,
      plate: target,
    );
    if (result) {
      ToastUtil.showSuccess(plate == null ? '创建成功' : '更新成功');
    }
  }

  static Future<void> _confirmDelete(
    BuildContext context,
    FoilingPlateViewModel viewModel,
    FoilingPlate plate,
  ) {
    return confirmCrudDeletion(
      context,
      item: plate,
      onDelete: (item) => viewModel.deleteFoilingPlate(item.id),
      config: _deleteConfig,
    );
  }

  static Future<void> _confirmPlate(
    BuildContext context,
    FoilingPlateViewModel viewModel,
    FoilingPlate plate,
  ) {
    return confirmCrudAction(
      context,
      item: plate,
      onConfirm: (item) => viewModel.confirmFoilingPlate(item.id),
      config: _confirmConfig,
    );
  }

  static List<Widget> _headerActions(
    BuildContext context,
    FoilingPlateViewModel viewModel,
  ) {
    return [
      PageActionButton.filled(
        onPressed: () => _openEditPage(context, viewModel, null),
        icon: const Icon(Icons.add),
        label: '新建烫金版',
      ),
    ];
  }

  static List<RowAction> _rowActions(
    BuildContext context,
    FoilingPlateViewModel viewModel,
    FoilingPlate plate,
  ) {
    return [
      RowAction(
        label: '编辑',
        onPressed: () => _openEditPage(context, viewModel, plate),
      ),
      if (!plate.confirmed)
        RowAction(
          label: '确认',
          onPressed: () => _confirmPlate(context, viewModel, plate),
        ),
      RowAction(
        label: '删除',
        onPressed: () => _confirmDelete(context, viewModel, plate),
        destructive: true,
      ),
    ];
  }

  static Widget _buildNameCell(BuildContext context, FoilingPlate plate) {
    return Text(
      _titleText(plate),
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  static Widget _buildCodeCell(BuildContext context, FoilingPlate plate) {
    return _buildBodyText(context, CrudValueFormatter.text(plate.code));
  }

  static Widget _buildTypeCell(BuildContext context, FoilingPlate plate) {
    return _buildBodyText(context, _typeText(plate));
  }

  static Widget _buildSizeCell(BuildContext context, FoilingPlate plate) {
    return _buildBodyText(context, CrudValueFormatter.text(plate.size));
  }

  static Widget _buildMaterialCell(BuildContext context, FoilingPlate plate) {
    return _buildBodyText(context, CrudValueFormatter.text(plate.material));
  }

  static Widget _buildThicknessCell(
    BuildContext context,
    FoilingPlate plate,
  ) {
    return _buildBodyText(context, CrudValueFormatter.text(plate.thickness));
  }

  static Widget _buildConfirmedCell(
    BuildContext context,
    FoilingPlate plate,
  ) {
    return _buildBodyText(context, _confirmedText(plate));
  }

  static Widget _buildProductsCell(
    BuildContext context,
    FoilingPlate plate,
  ) {
    return _buildBodyText(context, _productSummary(plate.products));
  }

  static Widget _buildCreatedAtCell(
    BuildContext context,
    FoilingPlate plate,
  ) {
    return _buildBodyText(
        context, CrudValueFormatter.dateTime(plate.createdAt));
  }

  static Widget _buildBodyText(BuildContext context, String value) {
    return Text(
      value,
      style: Theme.of(context).textTheme.bodySmall,
    );
  }

  static String _titleText(FoilingPlate plate) {
    return CrudValueFormatter.text(plate.name);
  }

  static String _subtitleText(FoilingPlate plate) {
    return '${CrudValueFormatter.text(plate.code)} · ${_typeText(plate)}';
  }

  static String _typeText(FoilingPlate plate) {
    switch (plate.foilingType) {
      case 'gold':
        return '烫金';
      case 'silver':
        return '烫银';
      default:
        return CrudValueFormatter.empty;
    }
  }

  static String _confirmedText(FoilingPlate plate) {
    return plate.confirmed ? '已确认' : '待确认';
  }

  static String _productSummary(List<FoilingPlateProduct> products) {
    if (products.isEmpty) {
      return CrudValueFormatter.empty;
    }
    return products
        .map((item) => '${item.productName}(${item.quantity ?? 1}个)')
        .join('、');
  }

  static List<CrudSummaryChipData> _summaryChips(FoilingPlate plate) {
    return [
      CrudSummaryChipData(label: '状态', value: _confirmedText(plate)),
      CrudSummaryChipData(
        label: '尺寸',
        value: CrudValueFormatter.text(plate.size),
      ),
    ];
  }

  static List<CrudSummaryFieldData> _summaryFields(FoilingPlate plate) {
    return [
      CrudSummaryFieldData(
        label: '编码',
        value: CrudValueFormatter.text(plate.code),
      ),
      CrudSummaryFieldData(
        label: '类型',
        value: _typeText(plate),
      ),
      CrudSummaryFieldData(
        label: '尺寸',
        value: CrudValueFormatter.text(plate.size),
      ),
      CrudSummaryFieldData(
        label: '材质',
        value: CrudValueFormatter.text(plate.material),
      ),
      CrudSummaryFieldData(
        label: '厚度',
        value: CrudValueFormatter.text(plate.thickness),
      ),
      CrudSummaryFieldData(
        label: '确认状态',
        value: _confirmedText(plate),
      ),
      CrudSummaryFieldData(
        label: '包含产品',
        value: _productSummary(plate.products),
      ),
      CrudSummaryFieldData(
        label: '备注',
        value: CrudValueFormatter.text(plate.notes),
      ),
      CrudSummaryFieldData(
        label: '创建时间',
        value: CrudValueFormatter.dateTime(plate.createdAt),
      ),
    ];
  }

  static String _buildDeleteSummary(FoilingPlate plate) {
    return '即将删除烫金版 ${_titleText(plate)}。删除后，关联图稿和产品的版材追溯可能受影响。';
  }

  static List<String> _buildDeleteImpacts(FoilingPlate plate) {
    return [
      '版材编码：${CrudValueFormatter.text(plate.code)}',
      '版材类型：${_typeText(plate)}',
      if (plate.products.isNotEmpty) '包含产品：${_productSummary(plate.products)}',
    ];
  }

  static String _buildDeleteAuditHint(FoilingPlate plate) {
    return '如果该烫金版已用于历史图稿或订单，优先保留档案并停止引用。';
  }

  static String _buildConfirmSummary(FoilingPlate plate) {
    return '即将确认烫金版 ${_titleText(plate)}。确认后当前版材将不再允许直接修改。';
  }

  static List<String> _buildConfirmImpacts(FoilingPlate plate) {
    return [
      '确认后如需改动，建议新建或复制新的版材记录',
      '当前编码：${CrudValueFormatter.text(plate.code)}',
    ];
  }

  static String _buildConfirmAuditHint(FoilingPlate plate) {
    return '请确认类型、尺寸、材质、厚度和产品关联信息均已核对。';
  }

  static String _buildConfirmSuccessMessage(FoilingPlate plate) {
    return '确认成功';
  }
}
