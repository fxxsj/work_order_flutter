import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_list_page.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/embossing_plates/application/embossing_plate_view_model.dart';
import 'package:work_order_app/src/features/embossing_plates/data/embossing_plate_api_service.dart';
import 'package:work_order_app/src/features/embossing_plates/data/embossing_plate_repository_impl.dart';
import 'package:work_order_app/src/features/embossing_plates/domain/embossing_plate.dart';
import 'package:work_order_app/src/features/embossing_plates/domain/embossing_plate_repository.dart';
import 'package:work_order_app/src/features/embossing_plates/presentation/embossing_plate_edit_page.dart';

class EmbossingPlateListEntry extends StatelessWidget {
  const EmbossingPlateListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureEntry<EmbossingPlateApiService, EmbossingPlateRepository,
        EmbossingPlateViewModel>(
      createService: (context) =>
          EmbossingPlateApiService(context.read<ApiClient>()),
      createRepository: (context) => EmbossingPlateRepositoryImpl(
          context.read<EmbossingPlateApiService>()),
      createViewModel: (context) =>
          EmbossingPlateViewModel(context.read<EmbossingPlateRepository>()),
      initialize: (viewModel) => viewModel.initialize(),
      child: const EmbossingPlateListPage(),
    );
  }
}

class EmbossingPlateListPage extends StatelessWidget {
  const EmbossingPlateListPage({super.key});

  static const CrudDeleteConfig<EmbossingPlate> _deleteConfig =
      CrudDeleteConfig(
    title: '确认删除',
    summaryBuilder: _buildDeleteSummary,
    impactsBuilder: _buildDeleteImpacts,
    auditHintBuilder: _buildDeleteAuditHint,
    confirmText: '确认删除',
    errorMessagePrefix: '删除失败: ',
  );

  static const CrudActionConfig<EmbossingPlate> _confirmConfig =
      CrudActionConfig(
    title: '确认压凸版',
    summaryBuilder: _buildConfirmSummary,
    impactsBuilder: _buildConfirmImpacts,
    auditHintBuilder: _buildConfirmAuditHint,
    confirmText: '确认压凸版',
    successMessageBuilder: _buildConfirmSuccessMessage,
    errorMessagePrefix: '确认失败: ',
  );

  static const CrudListConfig<EmbossingPlate, EmbossingPlateViewModel> _config =
      CrudListConfig(
    searchHintText: '搜索压凸版编码、名称、尺寸、材质',
    emptyText: '暂无压凸版数据',
    emptyIcon: Icons.dashboard_customize_outlined,
    loadItems: _loadEmbossingPlates,
    titleBuilder: _titleText,
    subtitleBuilder: _subtitleText,
    summaryChipsBuilder: _summaryChips,
    summaryFieldsBuilder: _summaryFields,
    headerActionsBuilder: _headerActions,
    rowActionsBuilder: _rowActions,
    columns: [
      CrudTableColumn(label: '压凸版', cellBuilder: _buildNameCell),
      CrudTableColumn(label: '编码', cellBuilder: _buildCodeCell),
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
    return const CrudListPage<EmbossingPlate, EmbossingPlateViewModel>(
      config: _config,
    );
  }

  static Future<void> _loadEmbossingPlates(
    EmbossingPlateViewModel viewModel, {
    bool resetPage = false,
  }) {
    return viewModel.loadEmbossingPlates(resetPage: resetPage);
  }

  static Future<void> _openEditPage(
    BuildContext context,
    EmbossingPlateViewModel viewModel,
    EmbossingPlate? plate,
  ) async {
    EmbossingPlate? target = plate;
    if (plate != null) {
      try {
        final apiService = context.read<EmbossingPlateApiService>();
        final detail = await apiService.fetchEmbossingPlate(plate.id);
        if (!context.mounted) {
          return;
        }
        target = detail.toEntity();
      } catch (err) {
        if (!context.mounted) {
          return;
        }
        ToastUtil.showError('加载压凸版详情失败: $err');
        return;
      }
    }
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: viewModel,
          child: EmbossingPlateEditPage(plate: target),
        ),
      ),
    );
    if (result == true) {
      ToastUtil.showSuccess(plate == null ? '创建成功' : '更新成功');
    }
  }

  static Future<void> _confirmDelete(
    BuildContext context,
    EmbossingPlateViewModel viewModel,
    EmbossingPlate plate,
  ) {
    return confirmCrudDeletion(
      context,
      item: plate,
      onDelete: (item) => viewModel.deleteEmbossingPlate(item.id),
      config: _deleteConfig,
    );
  }

  static Future<void> _confirmPlate(
    BuildContext context,
    EmbossingPlateViewModel viewModel,
    EmbossingPlate plate,
  ) {
    return confirmCrudAction(
      context,
      item: plate,
      onConfirm: (item) => viewModel.confirmEmbossingPlate(item.id),
      config: _confirmConfig,
    );
  }

  static List<Widget> _headerActions(
    BuildContext context,
    EmbossingPlateViewModel viewModel,
  ) {
    return [
      PageActionButton.filled(
        onPressed: () => _openEditPage(context, viewModel, null),
        icon: const Icon(Icons.add),
        label: '新建压凸版',
      ),
    ];
  }

  static List<RowAction> _rowActions(
    BuildContext context,
    EmbossingPlateViewModel viewModel,
    EmbossingPlate plate,
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

  static Widget _buildNameCell(BuildContext context, EmbossingPlate plate) {
    return Text(
      _titleText(plate),
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  static Widget _buildCodeCell(BuildContext context, EmbossingPlate plate) {
    return _buildBodyText(context, CrudValueFormatter.text(plate.code));
  }

  static Widget _buildSizeCell(BuildContext context, EmbossingPlate plate) {
    return _buildBodyText(context, CrudValueFormatter.text(plate.size));
  }

  static Widget _buildMaterialCell(BuildContext context, EmbossingPlate plate) {
    return _buildBodyText(context, CrudValueFormatter.text(plate.material));
  }

  static Widget _buildThicknessCell(
    BuildContext context,
    EmbossingPlate plate,
  ) {
    return _buildBodyText(context, CrudValueFormatter.text(plate.thickness));
  }

  static Widget _buildConfirmedCell(
    BuildContext context,
    EmbossingPlate plate,
  ) {
    return _buildBodyText(context, _confirmedText(plate));
  }

  static Widget _buildProductsCell(
    BuildContext context,
    EmbossingPlate plate,
  ) {
    return _buildBodyText(context, _productSummary(plate.products));
  }

  static Widget _buildCreatedAtCell(
    BuildContext context,
    EmbossingPlate plate,
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

  static String _titleText(EmbossingPlate plate) {
    return CrudValueFormatter.text(plate.name);
  }

  static String _subtitleText(EmbossingPlate plate) {
    return '${CrudValueFormatter.text(plate.code)} · '
        '${CrudValueFormatter.text(plate.size)}';
  }

  static String _confirmedText(EmbossingPlate plate) {
    return plate.confirmed ? '已确认' : '待确认';
  }

  static String _productSummary(List<EmbossingPlateProduct> products) {
    if (products.isEmpty) {
      return CrudValueFormatter.empty;
    }
    return products
        .map((item) => '${item.productName}(${item.quantity ?? 1}个)')
        .join('、');
  }

  static List<CrudSummaryChipData> _summaryChips(EmbossingPlate plate) {
    return [
      CrudSummaryChipData(label: '状态', value: _confirmedText(plate)),
      CrudSummaryChipData(
        label: '材质',
        value: CrudValueFormatter.text(plate.material),
      ),
    ];
  }

  static List<CrudSummaryFieldData> _summaryFields(EmbossingPlate plate) {
    return [
      CrudSummaryFieldData(
        label: '编码',
        value: CrudValueFormatter.text(plate.code),
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

  static String _buildDeleteSummary(EmbossingPlate plate) {
    return '即将删除压凸版 ${_titleText(plate)}。删除后，关联图稿和产品的版材追溯可能受影响。';
  }

  static List<String> _buildDeleteImpacts(EmbossingPlate plate) {
    return [
      '版材编码：${CrudValueFormatter.text(plate.code)}',
      '尺寸：${CrudValueFormatter.text(plate.size)}',
      if (plate.products.isNotEmpty) '包含产品：${_productSummary(plate.products)}',
    ];
  }

  static String _buildDeleteAuditHint(EmbossingPlate plate) {
    return '如果该压凸版已用于历史订单或图稿，优先保留档案并停止引用。';
  }

  static String _buildConfirmSummary(EmbossingPlate plate) {
    return '即将确认压凸版 ${_titleText(plate)}。确认后当前版材将不再允许直接修改。';
  }

  static List<String> _buildConfirmImpacts(EmbossingPlate plate) {
    return [
      '确认后如需改动，建议新建或复制新的版材记录',
      '当前编码：${CrudValueFormatter.text(plate.code)}',
    ];
  }

  static String _buildConfirmAuditHint(EmbossingPlate plate) {
    return '请确认尺寸、材质、厚度和产品关联信息均已核对。';
  }

  static String _buildConfirmSuccessMessage(EmbossingPlate plate) {
    return '确认成功';
  }
}
