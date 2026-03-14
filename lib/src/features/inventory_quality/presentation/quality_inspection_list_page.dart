import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_data_table.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/expandable_summary_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_toolbar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/summary_widgets.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/searchable_dropdown.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/inventory_quality/application/quality_inspection_view_model.dart';
import 'package:work_order_app/src/features/inventory_quality/data/quality_inspection_api_service.dart';
import 'package:work_order_app/src/features/inventory_quality/data/quality_inspection_repository_impl.dart';
import 'package:work_order_app/src/features/inventory_quality/domain/quality_inspection.dart';
import 'package:work_order_app/src/features/inventory_quality/domain/quality_inspection_repository.dart';

/// 质检列表入口，负责创建并缓存依赖，避免页面重建时重复初始化。
class QualityInspectionListEntry extends StatefulWidget {
  const QualityInspectionListEntry({super.key});

  @override
  State<QualityInspectionListEntry> createState() =>
      _QualityInspectionListEntryState();
}

class _QualityInspectionListEntryState
    extends State<QualityInspectionListEntry> {
  QualityInspectionApiService? _apiService;
  QualityInspectionRepositoryImpl? _repository;
  QualityInspectionViewModel? _viewModel;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_viewModel != null) return;
    final apiClient = context.read<ApiClient>();
    _apiService = QualityInspectionApiService(apiClient);
    _repository = QualityInspectionRepositoryImpl(_apiService!);
    _viewModel = QualityInspectionViewModel(_repository!);
    if (!_initialized) {
      _initialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _viewModel?.initialize();
      });
    }
  }

  @override
  void dispose() {
    _viewModel?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final apiService = _apiService;
    final repository = _repository;
    final viewModel = _viewModel;
    if (apiService == null || repository == null || viewModel == null) {
      return const SizedBox.shrink();
    }
    return MultiProvider(
      providers: [
        Provider<QualityInspectionApiService>.value(value: apiService),
        Provider<QualityInspectionRepository>.value(value: repository),
        ChangeNotifierProvider<QualityInspectionViewModel>.value(
            value: viewModel),
      ],
      child: const QualityInspectionListPage(),
    );
  }
}

/// 质检列表页视图，只负责渲染。
class QualityInspectionListPage extends StatelessWidget {
  const QualityInspectionListPage({super.key});

  @override
  Widget build(BuildContext context) => const _QualityInspectionListView();
}

class _QualityInspectionListView extends StatefulWidget {
  const _QualityInspectionListView();

  @override
  State<_QualityInspectionListView> createState() =>
      _QualityInspectionListViewState();
}

class _QualityInspectionListViewState
    extends State<_QualityInspectionListView> {
  static const _searchDebounceDuration = Duration(milliseconds: 450);
  static const double _searchWidth = 320;
  static const double _spacingSm = LayoutTokens.gapSm;
  static const double _controlHeight = PageActionStyle.height;
  static const String _emptyCellText = '-';

  static const String _searchHintText = '搜索检验单号/施工单号';
  static const String _refreshButtonText = '刷新';
  static const String _emptyText = '暂无质检数据';
  static const String _errorFallbackText = '加载失败';
  static const String _retryText = '重新加载';
  static const String _completeTitle = '完成检验';
  static const String _completeSuccessText = '检验完成';
  static const String _completeErrorText = '检验提交失败: ';
  static const String _submitText = '提交';
  static const String _cancelText = '取消';
  static const String _detailTitle = '质检详情';
  static const String _resultFilterLabel = '检验结果';
  static const String _typeFilterLabel = '检验类型';
  static const String _resetButtonText = '重置筛选';
  static const String _pageInfoTemplate = '第 {page} / {total} 页，共 {count} 条';
  static const String _pageSizeLabel = '每页 {size}';

  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  Map<String, dynamic> _summary = {};
  bool _summaryLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadSummary());
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _scheduleSearch(QualityInspectionViewModel viewModel,
      {bool immediate = false}) {
    _searchDebounce?.cancel();
    if (immediate) {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadInspections(resetPage: true);
      return;
    }
    _searchDebounce = Timer(_searchDebounceDuration, () {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadInspections(resetPage: true);
    });
  }

  Future<void> _loadSummary() async {
    final apiService = context.read<QualityInspectionApiService>();
    setState(() => _summaryLoading = true);
    try {
      final data = await apiService.fetchSummary();
      if (!mounted) return;
      setState(() => _summary = data);
    } catch (_) {
      if (!mounted) return;
      setState(() => _summary = {});
    } finally {
      if (!mounted) return;
      setState(() => _summaryLoading = false);
    }
  }

  Future<void> _openDetailDialog(QualityInspection inspection) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(_detailTitle),
          content: SizedBox(
            width: 640,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetailRow(label: '质检单号', value: inspection.inspectionNumber),
                  _DetailRow(
                    label: '检验类型',
                    value: _displayText(inspection.inspectionTypeDisplay ??
                        inspection.inspectionType),
                  ),
                  _DetailRow(
                    label: '产品',
                    value: _displayText(inspection.productName),
                  ),
                  _DetailRow(
                    label: '批次号',
                    value: _displayText(inspection.batchNo),
                  ),
                  _DetailRow(
                    label: '施工单号',
                    value: _displayText(inspection.workOrderNumber),
                  ),
                  _DetailRow(
                    label: '检验员',
                    value: _displayText(inspection.inspectorName),
                  ),
                  _DetailRow(
                    label: '检验日期',
                    value: _formatDate(inspection.inspectionDate),
                  ),
                  _DetailRow(
                    label: '检验数量',
                    value: _formatAmount(inspection.inspectionQuantity),
                  ),
                  _DetailRow(
                    label: '合格数量',
                    value: _formatAmount(inspection.passedQuantity),
                  ),
                  _DetailRow(
                    label: '不合格数量',
                    value: _formatAmount(inspection.failedQuantity),
                  ),
                  _DetailRow(
                    label: '检验结果',
                    value: _displayText(
                        inspection.resultDisplay ?? inspection.result),
                  ),
                  if ((inspection.inspectionStandard ?? '').trim().isNotEmpty)
                    _DetailRow(
                      label: '检验标准',
                      value: inspection.inspectionStandard ?? '',
                    ),
                  if (inspection.inspectionItems.isNotEmpty)
                    _DetailRow(
                      label: '检验项目',
                      value: inspection.inspectionItems.join('、'),
                    ),
                  if (inspection.defects.isNotEmpty)
                    _DetailRow(
                      label: '缺陷',
                      value: inspection.defects.join('、'),
                    ),
                  if ((inspection.defectDescription ?? '').trim().isNotEmpty)
                    _DetailRow(
                      label: '缺陷描述',
                      value: inspection.defectDescription ?? '',
                    ),
                  if ((inspection.disposition ?? '').trim().isNotEmpty)
                    _DetailRow(
                      label: '处理意见',
                      value: inspection.disposition ?? '',
                    ),
                  if ((inspection.dispositionNotes ?? '').trim().isNotEmpty)
                    _DetailRow(
                      label: '处理备注',
                      value: inspection.dispositionNotes ?? '',
                    ),
                  if ((inspection.notes ?? '').trim().isNotEmpty)
                    _DetailRow(label: '备注', value: inspection.notes ?? ''),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(_cancelText),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openCompleteDialog(
    BuildContext context,
    QualityInspectionViewModel viewModel,
    QualityInspection inspection,
  ) async {
    final apiService = context.read<QualityInspectionApiService>();
    final formKey = GlobalKey<FormState>();
    final passedController = TextEditingController(
      text: inspection.passedQuantity?.toStringAsFixed(0) ?? '',
    );
    final failedController = TextEditingController(
      text: inspection.failedQuantity?.toStringAsFixed(0) ?? '',
    );
    String result = inspection.result == null || inspection.result == 'pending'
        ? 'passed'
        : inspection.result!;
    bool submitting = false;

    Future<void> submit(StateSetter setState) async {
      if (!(formKey.currentState?.validate() ?? false)) return;
      final passedText = passedController.text.trim();
      final failedText = failedController.text.trim();
      final passed = int.tryParse(passedText);
      final failed = int.tryParse(failedText);
      if (passed == null || failed == null) {
        ToastUtil.showError('请输入有效数量');
        return;
      }
      setState(() => submitting = true);
      try {
        await apiService.complete(inspection.id, {
          'result': result,
          'passed_quantity': passed,
          'failed_quantity': failed,
        });
        if (!mounted) return;
        Navigator.of(context).pop();
        ToastUtil.showSuccess(_completeSuccessText);
        await viewModel.loadInspections(resetPage: false);
        _loadSummary();
      } catch (err) {
        if (!mounted) return;
        setState(() => submitting = false);
        ToastUtil.showError('$_completeErrorText$err');
      }
    }

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text(_completeTitle),
              content: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SearchableDropdownFormField<String>(
                          key: ValueKey<String>(result),
                          initialValue: result,
                          decoration: const InputDecoration(labelText: '检验结果'),
                          items: const [
                            DropdownMenuItem(
                                value: 'passed', child: Text('合格')),
                            DropdownMenuItem(
                                value: 'failed', child: Text('不合格')),
                            DropdownMenuItem(
                                value: 'conditional', child: Text('条件接收')),
                          ],
                          onChanged: submitting
                              ? null
                              : (value) {
                                  if (value == null) return;
                                  setState(() => result = value);
                                },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: passedController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: '合格数量'),
                          validator: (value) {
                            final text = value?.trim() ?? '';
                            final parsed = int.tryParse(text);
                            if (parsed == null || parsed < 0) {
                              return '请输入有效数量';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: failedController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: '不合格数量'),
                          validator: (value) {
                            final text = value?.trim() ?? '';
                            final parsed = int.tryParse(text);
                            if (parsed == null || parsed < 0) {
                              return '请输入有效数量';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: submitting
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: const Text(_cancelText),
                ),
                FilledButton(
                  onPressed: submitting ? null : () => submit(setState),
                  child: Text(submitting ? '提交中...' : _submitText),
                ),
              ],
            );
          },
        );
      },
    );

    passedController.dispose();
    failedController.dispose();
  }

  static String _pageInfoText(QualityInspectionViewModel viewModel) {
    return _pageInfoTemplate
        .replaceFirst('{page}', viewModel.page.toString())
        .replaceFirst('{total}', viewModel.totalPages.toString())
        .replaceFirst('{count}', viewModel.total.toString());
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = BreakpointsUtil.isMobile(context);

    return Consumer<QualityInspectionViewModel>(
      builder: (context, viewModel, _) {
        final inspections = viewModel.inspections;
        return ListPageScaffold(
          spacing: _spacingSm,
          header: _buildPageHeader(context, viewModel, isMobile),
          body: _buildListBody(context, viewModel, inspections, isMobile),
          footer: viewModel.totalPages > 1
              ? ResponsivePaginationBar(
                  infoText: _pageInfoText(viewModel),
                  page: viewModel.page,
                  pageSize: viewModel.pageSize,
                  pageSizeOptions: viewModel.pageSizeOptions,
                  onPageSizeChanged: viewModel.setPageSize,
                  onPrev: () => viewModel.setPage(viewModel.page - 1),
                  onNext: () => viewModel.setPage(viewModel.page + 1),
                  hasPrev: viewModel.hasPrev,
                  hasNext: viewModel.hasNext,
                  pageSizeLabelBuilder: (size) =>
                      _pageSizeLabel.replaceFirst('{size}', size.toString()),
                )
              : null,
        );
      },
    );
  }

  Widget _buildListBody(
    BuildContext context,
    QualityInspectionViewModel viewModel,
    List<QualityInspection> inspections,
    bool isMobile,
  ) {
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    Widget listContent;
    if (viewModel.loading && inspections.isEmpty) {
      listContent = const Center(child: CircularProgressIndicator());
    } else if (viewModel.errorMessage != null && !viewModel.loading) {
      listContent = ErrorStateCard(
        message: viewModel.errorMessage ?? _errorFallbackText,
        retryLabel: _retryText,
        onRetry: () => viewModel.loadInspections(resetPage: true),
      );
    } else if (!viewModel.loading && inspections.isEmpty) {
      listContent = const EmptyStateCard(
        icon: Icons.verified_outlined,
        text: _emptyText,
      );
    } else {
      if (!isMobile) {
        listContent = _buildDesktopTable(context, viewModel, inspections);
      } else {
        listContent = ListView.separated(
          itemCount: inspections.length,
          separatorBuilder: (_, __) => SizedBox(height: sectionSpacing),
          itemBuilder: (context, index) {
            final inspection = inspections[index];
            return _buildSummaryCard(context, viewModel, inspection, isMobile);
          },
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSummarySection(context),
        SizedBox(height: sectionSpacing),
        Expanded(child: listContent),
      ],
    );
  }

  Widget _buildDesktopTable(
    BuildContext context,
    QualityInspectionViewModel viewModel,
    List<QualityInspection> inspections,
  ) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodySmall;
    return AppDataTable(
      columns: const [
        DataColumn(label: Text('质检单号')),
        DataColumn(label: Text('施工单号')),
        DataColumn(label: Text('产品')),
        DataColumn(label: Text('检验员')),
        DataColumn(label: Text('检验日期')),
        DataColumn(label: Text('结果')),
        DataColumn(label: Text('不良率')),
        DataColumn(label: Text('操作')),
      ],
      rows: inspections.map(
        (inspection) {
          final canComplete = (inspection.result ?? 'pending') == 'pending';
          return DataRow(
            cells: [
              DataCell(Text(
                _displayText(inspection.inspectionNumber),
                style: theme.textTheme.bodyMedium,
              )),
              DataCell(Text(_displayText(inspection.workOrderNumber),
                  style: textStyle)),
              DataCell(
                  Text(_displayText(inspection.productName), style: textStyle)),
              DataCell(Text(_displayText(inspection.inspectorName),
                  style: textStyle)),
              DataCell(Text(_formatDate(inspection.inspectionDate),
                  style: textStyle)),
              DataCell(Text(
                inspection.resultDisplay ?? inspection.result ?? _emptyCellText,
                style: textStyle,
              )),
              DataCell(Text(inspection.defectiveRateFormatted ?? _emptyCellText,
                  style: textStyle)),
              DataCell(RowActionGroup(
                actions: [
                  RowAction(
                    label: '查看',
                    onPressed: () => _openDetailDialog(inspection),
                  ),
                  if (canComplete)
                    RowAction(
                      label: _completeTitle,
                      onPressed: () =>
                          _openCompleteDialog(context, viewModel, inspection),
                    ),
                ],
              )),
            ],
          );
        },
      ).toList(),
    );
  }

  Widget _buildPageHeader(
    BuildContext context,
    QualityInspectionViewModel viewModel,
    bool isMobile,
  ) {
    void openFilterDrawer() {
      if (isMobile) {
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          showDragHandle: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          builder: (sheetContext) {
            return _FilterDrawerContent(
              title: '筛选',
              child: _buildFilterPanel(
                sheetContext,
                viewModel,
                bottomSpacing: 16,
              ),
            );
          },
        );
        return;
      }

      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: '筛选',
        barrierColor: Colors.black.withValues(alpha: 0.3),
        transitionDuration: const Duration(milliseconds: 220),
        pageBuilder: (dialogContext, animation, secondaryAnimation) {
          return Align(
            alignment: Alignment.centerRight,
            child: Material(
              color: Theme.of(dialogContext).colorScheme.surface,
              shape:
                  const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              child: SizedBox(
                width: 360,
                height: double.infinity,
                child: SafeArea(
                  child: _FilterDrawerContent(
                    title: '筛选',
                    child: _buildFilterPanel(
                      dialogContext,
                      viewModel,
                      bottomSpacing: 20,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          final offsetTween =
              Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero);
          return SlideTransition(
            position: animation
                .drive(
                  CurveTween(curve: Curves.easeOutCubic),
                )
                .drive(offsetTween),
            child: child,
          );
        },
      );
    }

    return PageHeaderBar(
      breadcrumb: null,
      useSurface: false,
      showDivider: false,
      padding: EdgeInsets.zero,
      actions: LayoutBuilder(
        builder: (context, constraints) {
          final activeFilters = _activeFilterCount(viewModel);
          final searchField = ListSearchField(
            controller: _searchController,
            hintText: _searchHintText,
            height: _controlHeight,
            width: isMobile ? constraints.maxWidth : _searchWidth,
            onChanged: (_) => _scheduleSearch(viewModel),
            onSubmitted: (_) => _scheduleSearch(viewModel, immediate: true),
            onClear: () {
              _searchController.clear();
              _scheduleSearch(viewModel, immediate: true);
            },
          );

          final actions = <Widget>[
            PageActionButton.outlined(
              onPressed: () => viewModel.loadInspections(resetPage: true),
              icon: const Icon(Icons.refresh, size: 16),
              label: _refreshButtonText,
            ),
            PageActionButton.outlined(
              onPressed: openFilterDrawer,
              icon: const Icon(Icons.filter_alt_outlined, size: 16),
              label: activeFilters > 0 ? '筛选 $activeFilters' : '筛选',
            ),
          ];

          return ListToolbar(
            isMobile: isMobile,
            searchField: searchField,
            actions: actions,
            spacing: _spacingSm,
          );
        },
      ),
    );
  }

  Widget _buildFilterPanel(
    BuildContext context,
    QualityInspectionViewModel viewModel, {
    required double bottomSpacing,
  }) {
    final resultValue =
        viewModel.resultFilter.isEmpty ? '' : viewModel.resultFilter;
    final typeValue = viewModel.typeFilter.isEmpty ? '' : viewModel.typeFilter;
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SearchableDropdownFormField<String>(
          key: ValueKey<String>(typeValue),
          initialValue: typeValue,
          isExpanded: true,
          decoration: const InputDecoration(labelText: _typeFilterLabel),
          items: const [
            DropdownMenuItem(value: '', child: Text('全部类型')),
            DropdownMenuItem(value: 'incoming', child: Text('来料检验')),
            DropdownMenuItem(value: 'process', child: Text('过程检验')),
            DropdownMenuItem(value: 'final', child: Text('成品检验')),
            DropdownMenuItem(value: 'customer', child: Text('客诉检验')),
          ],
          onChanged: (value) => viewModel.setTypeFilter(value ?? ''),
        ),
        const SizedBox(height: _spacingSm),
        SearchableDropdownFormField<String>(
          key: ValueKey<String>(resultValue),
          initialValue: resultValue,
          isExpanded: true,
          decoration: const InputDecoration(labelText: _resultFilterLabel),
          items: const [
            DropdownMenuItem(value: '', child: Text('全部结果')),
            DropdownMenuItem(value: 'pending', child: Text('待检验')),
            DropdownMenuItem(value: 'passed', child: Text('合格')),
            DropdownMenuItem(value: 'failed', child: Text('不合格')),
            DropdownMenuItem(value: 'conditional', child: Text('条件接收')),
          ],
          onChanged: (value) => viewModel.setResultFilter(value ?? ''),
        ),
        SizedBox(height: bottomSpacing),
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: () => _resetFilters(viewModel),
              icon: const Icon(Icons.restart_alt),
              label: const Text(_resetButtonText),
            ),
            const SizedBox(width: 12),
            FilledButton(
              onPressed: () => Navigator.of(context).maybePop(),
              child: const Text('完成'),
            ),
          ],
        ),
      ],
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      children: [content],
    );
  }

  int _activeFilterCount(QualityInspectionViewModel viewModel) {
    var count = 0;
    if (_searchController.text.trim().isNotEmpty) count += 1;
    if (viewModel.typeFilter.isNotEmpty) count += 1;
    if (viewModel.resultFilter.isNotEmpty) count += 1;
    return count;
  }

  void _resetFilters(QualityInspectionViewModel viewModel) {
    _searchController.clear();
    viewModel.setSearchText('');
    var needsReload = false;
    if (viewModel.typeFilter.isNotEmpty) {
      needsReload = true;
      viewModel.setTypeFilter('');
    }
    if (viewModel.resultFilter.isNotEmpty) {
      needsReload = true;
      viewModel.setResultFilter('');
    }
    if (!needsReload) {
      viewModel.loadInspections(resetPage: true);
    }
  }

  static String _displayText(String? value) {
    final text = value?.trim() ?? '';
    return text.isEmpty ? _emptyCellText : text;
  }

  String _formatDate(DateTime? value) {
    if (value == null) return _emptyCellText;
    final local = value.toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  String _formatAmount(double? value) {
    if (value == null) return _emptyCellText;
    if (value % 1 == 0) return value.toInt().toString();
    return value.toStringAsFixed(2);
  }

  Widget _buildSummaryCard(
    BuildContext context,
    QualityInspectionViewModel viewModel,
    QualityInspection inspection,
    bool isMobile,
  ) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    final number = inspection.inspectionNumber.isEmpty
        ? '质检 #${inspection.id}'
        : inspection.inspectionNumber;
    final workOrder = _displayText(inspection.workOrderNumber);
    final product = _displayText(inspection.productName);
    final inspector = _displayText(inspection.inspectorName);
    final result =
        inspection.resultDisplay ?? inspection.result ?? _emptyCellText;
    final defectiveRate = inspection.defectiveRateFormatted ?? _emptyCellText;
    final inspectionDate = _formatDate(inspection.inspectionDate);
    final canComplete = (inspection.result ?? 'pending') == 'pending';

    return ExpandableSummaryCard(
      headerBuilder: (context, expanded) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    number,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colors?.sidebarText,
                    ),
                  ),
                  SizedBox(height: sectionSpacing),
                  Text(
                    '$workOrder · $product',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors?.subtleText ?? theme.hintColor,
                    ),
                  ),
                  SizedBox(height: sectionSpacing),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _SummaryChip(label: '结果', value: result),
                      _SummaryChip(label: '不良率', value: defectiveRate),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: sectionSpacing),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  inspectionDate,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors?.subtleText ?? theme.hintColor,
                  ),
                ),
                SizedBox(height: sectionSpacing),
                AnimatedRotation(
                  turns: expanded ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.expand_more,
                    size: 20,
                    color: colors?.subtleText ?? theme.hintColor,
                  ),
                ),
              ],
            ),
          ],
        );
      },
      expandedChild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SummaryFieldWrap(
            isMobile: isMobile,
            children: [
              _SummaryField(label: '质检单号', value: number),
              _SummaryField(label: '施工单号', value: workOrder),
              _SummaryField(label: '产品', value: product),
              _SummaryField(label: '检验员', value: inspector),
              _SummaryField(label: '检验日期', value: inspectionDate),
              _SummaryField(label: '结果', value: result),
              _SummaryField(label: '不良率', value: defectiveRate),
            ],
          ),
          SizedBox(height: sectionSpacing),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () => _openDetailDialog(inspection),
                icon: const Icon(Icons.visibility_outlined, size: 16),
                label: const Text('查看'),
              ),
              if (canComplete)
                OutlinedButton.icon(
                  onPressed: () =>
                      _openCompleteDialog(context, viewModel, inspection),
                  icon: const Icon(Icons.verified_outlined, size: 16),
                  label: const Text(_completeTitle),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(BuildContext context) {
    final spacing = LayoutTokens.sectionSpacing(context);
    if (_summaryLoading && _summary.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    final summary = _summary['summary'] is Map
        ? Map<String, dynamic>.from(_summary['summary'] as Map)
        : <String, dynamic>{};

    String formatValue(dynamic value) {
      if (value == null) return _emptyCellText;
      if (value is num) {
        if (value % 1 == 0) return value.toInt().toString();
        return value.toStringAsFixed(2);
      }
      return value.toString();
    }

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: [
        _StatTile(
          label: '检验总数',
          value: formatValue(summary['total_count']),
          icon: Icons.verified_outlined,
        ),
        _StatTile(
          label: '检验数量',
          value: formatValue(summary['total_quantity']),
          icon: Icons.fact_check_outlined,
        ),
        _StatTile(
          label: '合格数量',
          value: formatValue(summary['total_passed']),
          icon: Icons.check_circle_outline,
        ),
        _StatTile(
          label: '不合格数量',
          value: formatValue(summary['total_failed']),
          icon: Icons.cancel_outlined,
        ),
      ],
    );
  }
}

typedef _SummaryField = SummaryField;
typedef _SummaryChip = SummaryChip;

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    return Container(
      width: 170,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors?.surface ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(LayoutTokens.radiusLg),
        border: Border.all(color: colors?.borderColor ?? theme.dividerColor),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.bodySmall),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterDrawerContent extends StatelessWidget {
  const _FilterDrawerContent({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                tooltip: '关闭',
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(child: child),
      ],
    );
  }
}
