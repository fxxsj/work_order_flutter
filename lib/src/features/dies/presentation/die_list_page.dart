import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_list_page.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/dies/application/die_view_model.dart';
import 'package:work_order_app/src/features/dies/data/die_api_service.dart';
import 'package:work_order_app/src/features/dies/data/die_repository_impl.dart';
import 'package:work_order_app/src/features/dies/domain/die.dart';
import 'package:work_order_app/src/features/dies/domain/die_repository.dart';
import 'package:work_order_app/src/features/dies/presentation/die_edit_page.dart';

class DieListEntry extends StatelessWidget {
  const DieListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureEntry<DieApiService, DieRepository, DieViewModel>(
      createService: (context) => DieApiService(context.read<ApiClient>()),
      createRepository: (context) =>
          DieRepositoryImpl(context.read<DieApiService>()),
      createViewModel: (context) => DieViewModel(context.read<DieRepository>()),
      initialize: (viewModel) => viewModel.initialize(),
      child: const DieListPage(),
    );
  }
}

class DieListPage extends StatelessWidget {
  const DieListPage({super.key});

  static const CrudDeleteConfig<Die> _deleteConfig = CrudDeleteConfig(
    title: '确认删除',
    summaryBuilder: _buildDeleteSummary,
    impactsBuilder: _buildDeleteImpacts,
    auditHintBuilder: _buildDeleteAuditHint,
    confirmText: '确认删除',
    errorMessagePrefix: '删除失败: ',
  );

  static const CrudListConfig<Die, DieViewModel> _config = CrudListConfig(
    searchHintText: '搜索刀模编码、名称、尺寸、材质',
    emptyText: '暂无刀模数据',
    emptyIcon: Icons.cut_outlined,
    loadItems: _loadDies,
    titleBuilder: _titleText,
    subtitleBuilder: _subtitleText,
    summaryChipsBuilder: _summaryChips,
    summaryFieldsBuilder: _summaryFields,
    headerActionsBuilder: _headerActions,
    rowActionsBuilder: _rowActions,
    columns: [
      CrudTableColumn(label: '刀模', cellBuilder: _buildNameCell),
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
    return const CrudListPage<Die, DieViewModel>(config: _config);
  }

  static Future<void> _loadDies(
    DieViewModel viewModel, {
    bool resetPage = false,
  }) {
    return viewModel.loadDies(resetPage: resetPage);
  }

  static Future<void> _openEditPage(
    BuildContext context,
    DieViewModel viewModel,
    Die? die,
  ) async {
    Die? target = die;
    if (die != null) {
      try {
        final apiService = context.read<DieApiService>();
        final detail = await apiService.fetchDie(die.id);
        if (!context.mounted) {
          return;
        }
        target = detail.toEntity();
      } catch (err) {
        if (!context.mounted) {
          return;
        }
        ToastUtil.showError('加载刀模详情失败: $err');
        return;
      }
    }
    final result = await showDieEditDrawer(
      context,
      viewModel: viewModel,
      die: target,
    );
    if (result) {
      ToastUtil.showSuccess(die == null ? '创建成功' : '更新成功');
    }
  }

  static Future<void> _confirmDelete(
    BuildContext context,
    DieViewModel viewModel,
    Die die,
  ) {
    return confirmCrudDeletion(
      context,
      item: die,
      onDelete: (item) => viewModel.deleteDie(item.id),
      config: _deleteConfig,
    );
  }

  static List<Widget> _headerActions(
    BuildContext context,
    DieViewModel viewModel,
  ) {
    return [
      SizedBox(
        width: 112,
        child: AppSelect<String>(
          options: const [
            AppDropdownOption(value: '', label: '全部状态'),
            AppDropdownOption(value: 'true', label: '已确认'),
            AppDropdownOption(value: 'false', label: '待确认'),
          ],
          value: viewModel.confirmed == null
              ? ''
              : viewModel.confirmed == true
              ? 'true'
              : 'false',
          onChanged: (value) {
            if (value == null || value.isEmpty) {
              viewModel.setConfirmed(null);
            } else {
              viewModel.setConfirmed(value == 'true');
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
            AppDropdownOption(value: '', label: '全部类型'),
            AppDropdownOption(value: 'combined', label: '拼版刀模'),
            AppDropdownOption(value: 'dedicated', label: '专用刀模'),
            AppDropdownOption(value: 'universal', label: '通用刀模'),
          ],
          value: viewModel.dieType ?? '',
          onChanged: (value) => viewModel.setDieType(
            value == null || value.isEmpty ? null : value,
          ),
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
            AppDropdownOption(value: '-created_at', label: '最新创建'),
            AppDropdownOption(value: 'created_at', label: '最早创建'),
            AppDropdownOption(value: 'code', label: '编码升序'),
            AppDropdownOption(value: '-code', label: '编码降序'),
            AppDropdownOption(value: 'name', label: '名称升序'),
            AppDropdownOption(value: '-name', label: '名称降序'),
            AppDropdownOption(value: 'die_type', label: '类型升序'),
            AppDropdownOption(value: 'confirmed', label: '状态升序'),
          ],
          value: viewModel.ordering ?? '-created_at',
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
        label: '新建刀模',
      ),
    ];
  }

  static List<RowAction> _rowActions(
    BuildContext context,
    DieViewModel viewModel,
    Die die,
  ) {
    return [
      RowAction(
        label: '编辑',
        onPressed: () => _openEditPage(context, viewModel, die),
      ),
      RowAction(
        label: '删除',
        onPressed: () => _confirmDelete(context, viewModel, die),
        destructive: true,
      ),
    ];
  }

  static Widget _buildNameCell(BuildContext context, Die die) {
    return Text(_titleText(die), style: Theme.of(context).textTheme.bodyMedium);
  }

  static Widget _buildCodeCell(BuildContext context, Die die) {
    return _buildBodyText(context, AppValueFormatter.text(die.code));
  }

  static Widget _buildTypeCell(BuildContext context, Die die) {
    return _buildBodyText(context, _dieTypeText(die));
  }

  static Widget _buildSizeCell(BuildContext context, Die die) {
    return _buildBodyText(context, AppValueFormatter.text(die.size));
  }

  static Widget _buildMaterialCell(BuildContext context, Die die) {
    return _buildBodyText(context, AppValueFormatter.text(die.material));
  }

  static Widget _buildThicknessCell(BuildContext context, Die die) {
    return _buildBodyText(context, AppValueFormatter.text(die.thickness));
  }

  static Widget _buildConfirmedCell(BuildContext context, Die die) {
    return _buildBodyText(context, _confirmedText(die));
  }

  static Widget _buildProductsCell(BuildContext context, Die die) {
    return _buildBodyText(context, _productSummary(die.products));
  }

  static Widget _buildCreatedAtCell(BuildContext context, Die die) {
    return _buildBodyText(context, AppValueFormatter.dateTime(die.createdAt));
  }

  static Widget _buildBodyText(BuildContext context, String value) {
    return Text(value, style: Theme.of(context).textTheme.bodySmall);
  }

  static String _titleText(Die die) {
    return AppValueFormatter.text(die.name);
  }

  static String _subtitleText(Die die) {
    return '${AppValueFormatter.text(die.code)} · ${_dieTypeText(die)}';
  }

  static String _dieTypeText(Die die) {
    final display = die.dieTypeDisplay;
    if (display != null && display.isNotEmpty) {
      return display;
    }
    switch (die.dieType) {
      case 'combined':
        return '拼版刀模';
      case 'dedicated':
        return '专用刀模';
      case 'universal':
        return '通用刀模';
      default:
        return AppValueFormatter.empty;
    }
  }

  static String _confirmedText(Die die) {
    return die.confirmed ? '已确认' : '待确认';
  }

  static String _productSummary(List<DieProduct> products) {
    if (products.isEmpty) {
      return AppValueFormatter.empty;
    }
    return products
        .map((item) => '${item.productName}(${item.quantity ?? 1}拼)')
        .join('、');
  }

  static List<CrudSummaryChipData> _summaryChips(Die die) {
    return [
      CrudSummaryChipData(label: '状态', value: _confirmedText(die)),
      CrudSummaryChipData(label: '尺寸', value: AppValueFormatter.text(die.size)),
    ];
  }

  static List<CrudSummaryFieldData> _summaryFields(Die die) {
    return [
      CrudSummaryFieldData(
        label: '编码',
        value: AppValueFormatter.text(die.code),
      ),
      CrudSummaryFieldData(label: '类型', value: _dieTypeText(die)),
      CrudSummaryFieldData(
        label: '尺寸',
        value: AppValueFormatter.text(die.size),
      ),
      CrudSummaryFieldData(
        label: '材质',
        value: AppValueFormatter.text(die.material),
      ),
      CrudSummaryFieldData(
        label: '厚度',
        value: AppValueFormatter.text(die.thickness),
      ),
      CrudSummaryFieldData(label: '确认状态', value: _confirmedText(die)),
      CrudSummaryFieldData(
        label: '确认人',
        value: AppValueFormatter.text(die.confirmedByName),
      ),
      CrudSummaryFieldData(
        label: '确认时间',
        value: AppValueFormatter.dateTime(die.confirmedAt),
      ),
      CrudSummaryFieldData(label: '包含产品', value: _productSummary(die.products)),
      CrudSummaryFieldData(
        label: '备注',
        value: AppValueFormatter.text(die.notes),
      ),
      CrudSummaryFieldData(
        label: '创建时间',
        value: AppValueFormatter.dateTime(die.createdAt),
      ),
      CrudSummaryFieldData(
        label: '更新时间',
        value: AppValueFormatter.dateTime(die.updatedAt),
      ),
    ];
  }

  static String _buildDeleteSummary(Die die) {
    return '即将删除刀模 ${_titleText(die)}。删除后，相关产品拼版和历史工单追溯可能受到影响。';
  }

  static List<String> _buildDeleteImpacts(Die die) {
    return [
      '刀模编码：${AppValueFormatter.text(die.code)}',
      '刀模类型：${_dieTypeText(die)}',
      if (die.products.isNotEmpty) '包含产品：${_productSummary(die.products)}',
      '若已有施工单或产品绑定使用该刀模，删除可能失败或需要先解除关联',
    ];
  }

  static String _buildDeleteAuditHint(Die die) {
    return '如果只是暂不使用该刀模，优先考虑保留档案并停止引用，而不是直接删除。';
  }
}
